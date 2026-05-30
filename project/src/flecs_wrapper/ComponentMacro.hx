package flecs_wrapper;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;

function computeComponentSize(classType:ClassType):Int {
  var size = 0;
  for (field in classType.fields.get()) {
    if (field.isPublic) {
      switch field.kind {
        case FVar(_, _):
          size += switch Context.follow(field.type) {
            case TAbstract(_.get() => a, _):
              switch a.pack.concat([a.name]).join(".") {
                case "Float":       8;
                case "Int":         4;
                case "Bool":        1;
                case "cpp.Float32": 4;
                case "cpp.UInt32":  4;
                case "cpp.Int32":   4;
                default: Context.error('Unsupported @:component field type: ${a.name}', field.pos); 0;
              }
            default: Context.error('Unsupported @:component field type', field.pos); 0;
          };
        default:
      }
    }
  }
  return size;
}
#end

class ComponentMacro {
	public static macro function ofType(typeExpr:Expr):Expr {
		// Resolve the class type from the expression (e.g. `Position` used as a type name)
		var typePath = switch (typeExpr.expr) {
			case EConst(CIdent(name)): name;
			case EField(_, name): name;
			default: null;
		};
		if (typePath == null) {
			Context.error("Component.ofType() requires a class type name", Context.currentPos());
		}

		// Look up the class type by name
		var classType = switch (Context.getType(typePath)) {
			case TInst(r, _): r.get();
			default: null;
		};
		if (classType == null) {
			Context.error('Component.ofType() requires a class type, got: ${typePath}', Context.currentPos());
		}

		var nativeName:String = null;
		for (meta in classType.meta.get()) {
			if (meta.name == ":component" && meta.params != null && meta.params.length > 0) {
				switch (meta.params[0].expr) {
					case EConst(CString(s)): nativeName = s;
					default:
				}
				break;
			}
		}
		if (nativeName == null) {
			Context.error('Component.ofType() requires a class annotated with @:component (got: ${typePath})', Context.currentPos());
		}
		var structCt = Context.toComplexType(Context.getType(typePath));
		var size = computeComponentSize(classType);
		return macro new flecs_wrapper.ComponentRef<$structCt>(
			flecs_wrapper.Component.create($v{nativeName}, $v{size})
		);
	}

	public static macro function register():Void {
		haxe.macro.Compiler.addGlobalMetadata(
			"",
			"@:build(flecs_wrapper.ComponentMacro.build())",
			true, true, false
		);
	}

	public static macro function build():Array<Field> {
		var localClass = Context.getLocalClass();
		if (localClass == null) return Context.getBuildFields();
		var cls = localClass.get();

		var nativeName:String = null;
		for (meta in cls.meta.get()) {
			if (meta.name == ":component") {
				if (meta.params != null && meta.params.length > 0) {
					switch (meta.params[0].expr) {
						case EConst(CString(s)):
							nativeName = s;
						default:
					}
				}
				break;
			}
		}

		// Not a @:component class — skip silently
		if (nativeName == null) {
			return Context.getBuildFields();
		}

		// Don't process classes in the runtime package itself
		var pkg = cls.pack.join(".");
		if (StringTools.startsWith(pkg, "flecs_wrapper")) {
			return Context.getBuildFields();
		}

		cls.meta.add(":structAccess", [], cls.pos);
		cls.meta.add(":structInit", [], cls.pos);
		cls.meta.add(":nativeGen", [], cls.pos);
		cls.meta.add(":keep", [], cls.pos);
		cls.meta.add(":native", [macro $v{nativeName}], cls.pos);
		// Emit a no-arg default constructor in the C++ header so that cpp::Struct<T>
		// and cpp::Pointer<T> (which call T()) can be instantiated.
		cls.meta.add(":headerClassCode", [macro $v{'${nativeName}() {}\n'}], cls.pos);

		return Context.getBuildFields();
	}
}
