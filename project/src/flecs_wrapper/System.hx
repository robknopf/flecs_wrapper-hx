package flecs_wrapper;

import flecs_wrapper.FlecsWrapper.ComponentId;
import flecs_wrapper.FlecsWrapper.EntityId;
import flecs_wrapper.FlecsWrapper.SystemId;
import flecs_wrapper.impl.SystemImpl;

@:allow(flecs_wrapper.impl.SystemImpl)
class SystemIter {
  private var entityIds:Array<EntityId>;
  private var rawColumns:Array<Dynamic>;
  public var count:Int;
  public var columns:Array<Dynamic>;
  public var columnComponentIds:Array<ComponentId>;
  public var columnSizes:Array<Int>;
  public var dt:Float;
  public var callbackId:Int;

  private function new(
    entityIds:Array<EntityId>,
    rawColumns:Array<Dynamic>,
    columnComponentIds:Array<ComponentId>,
    columnSizes:Array<Int>,
    dt:Float,
    callbackId:Int
  ) {
    this.entityIds = entityIds;
    this.rawColumns = rawColumns;
    this.columns = rawColumns;
    this.columnComponentIds = columnComponentIds;
    this.columnSizes = columnSizes;
    this.count = entityIds.length;
    this.dt = dt;
    this.callbackId = callbackId;
  }

  public function entity(i:Int):EntityId {
    if (i < 0 || i >= count) throw "entity index out of bounds";
    return entityIds[i];
  }

  public function colIndex(compId:ComponentId):Int {
    for (i in 0...columnComponentIds.length) {
      if (columnComponentIds[i] == compId) return i;
    }
    return -1;
  }

  private inline function rawColumnPtrBase(compId:ComponentId):NativePtr<Dynamic> {
    var idx = colIndex(compId);
    if (idx < 0) return null;
    return cast rawColumns[idx];
  }

  private inline function rawColumnBase(compId:ComponentId, i:Int):NativePtr<Dynamic> {
    var ptrs:NativePtr<Dynamic> = rawColumnPtrBase(compId);
    if (ptrs == null) return null;
    if (i < 0 || i >= count) throw "column index out of bounds";
    return cast ptrs.add(i);
  }

  @:generic public inline function rawColumnPtr<T>(compId:ComponentId):NativePtr<T>
    return cast rawColumnPtrBase(compId);

  @:generic public inline function rawColumnPtrTyped<T>(compId:ComponentId):NativePtr<T>
    return cast rawColumnPtrBase(compId);

  @:generic public inline function rawColumn<T>(compId:ComponentId, i:Int):NativePtr<T>
    return cast rawColumnBase(compId, i);

  @:generic public inline function rawColumnTyped<T>(compId:ComponentId, i:Int):NativePtr<T>
    return cast rawColumnBase(compId, i);

  @:generic public inline function rawComponentColumn<T>(comp:Component, i:Int):NativePtr<T>
    return cast rawColumnBase(comp.id, i);

  @:generic public inline function rawComponentColumnTyped<T>(comp:Component, i:Int):NativePtr<T>
    return cast rawColumnBase(comp.id, i);

  public inline function tryColumn(comp:Component, i:Int):Dynamic {
    var ptr:NativePtr<Dynamic> = rawColumnBase(comp.id, i);
    if (ptr == null) return null;
    return ptr.ref;
  }

  public inline function column(comp:Component, i:Int):Dynamic {
    var value = tryColumn(comp, i);
    if (value == null) throw 'Column value not found for component ${comp.name}';
    return value;
  }

  @:generic public inline function each1<A>(a:Component, cb:(a:A) -> Void):Void
    SystemImpl.each1(this, a, cb);
  @:generic public inline function each2<A, B>(a:Component, b:Component, cb:(a:A, b:B) -> Void):Void
    SystemImpl.each2(this, a, b, cb);
  @:generic public inline function each3<A, B, C>(a:Component, b:Component, c:Component, cb:(a:A, b:B, c:C) -> Void):Void
    SystemImpl.each3(this, a, b, c, cb);

  #if display
  public inline function each(components:Array<Component>, cb:Dynamic):Void {
    if (components == null) return;
    switch (components.length) {
      case 0:
        for (_ in 0...count) cb();
      case 1:
        each1(components[0], cb);
      case 2:
        each2(components[0], components[1], cb);
      case 3:
        each3(components[0], components[1], components[2], cb);
      default:
        throw "it.each currently supports 0-3 components";
    }
  }
  #end
}

typedef SystemIterCallback = (it:SystemIter) -> Void;

class System {
  public static inline function removeSystem(id:SystemId):Void SystemImpl.removeSystem(id);
  public static inline function unregisterSystem(id:SystemId):Bool return SystemImpl.unregisterSystem(id);
  public static inline function addSystem(name:String, components:Array<Component>, callback:SystemIterCallback):SystemId return SystemImpl.addSystem(name, components, callback);
  public static inline function addSystemIds(name:String, componentIds:Array<ComponentId>, callback:SystemIterCallback):SystemId return SystemImpl.addSystemIds(name, componentIds, callback);
  public static inline function addSystemNames(name:String, componentNames:Array<String>, callback:SystemIterCallback):SystemId return SystemImpl.addSystemNames(name, componentNames, callback);
  public static inline function addTask(name:String, callback:SystemIterCallback):SystemId return SystemImpl.addTask(name, callback);
  public static inline function addSystemEx(name:String, includeComponents:Array<Component>, excludeComponents:Array<Component>, callback:SystemIterCallback):SystemId return SystemImpl.addSystemEx(name, includeComponents, excludeComponents, callback);
  public static inline function addSystemExIds(name:String, includeIds:Array<ComponentId>, excludeIds:Array<ComponentId>, callback:SystemIterCallback):SystemId return SystemImpl.addSystemExIds(name, includeIds, excludeIds, callback);
  public static inline function addSystemExNames(name:String, includeNames:Array<String>, excludeNames:Array<String>, callback:SystemIterCallback):SystemId return SystemImpl.addSystemExNames(name, includeNames, excludeNames, callback);
}
