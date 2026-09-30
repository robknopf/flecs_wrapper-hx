# Plan: component storage and `it.each`

Status: not started. Written 2026-09-30 after switching hxcore's flecs examples to this
haxelib turned up the bugs below.

## The bugs

### 1. `entity.set` stores a pointer to a GC box, not the component bytes

`Entity.set` (via `EntityMacros.buildSet`) passes the value to `EntityImpl.setValue<T>` as
`Dynamic`, so the `@:generic` specialization that runs is `T = Dynamic`. Generated C++:

```cpp
SysPos value = SysPos(0.0, 0.0);
EntityImpl_obj::setValue_setValue_T(entity->id, position,
    (::Dynamic)((cpp::Struct<SysPos>)(value)));
```

`setValue` then takes `&tmp` of that `Dynamic` and flecs copies `size` bytes from it: the
8-byte pointer to a boxed struct on the Haxe heap (plus stack garbage when the component is
bigger than 8 bytes).

- `EntityImpl.get` reads the bytes back as a `Dynamic`, so it follows the pointer to the
  original box. That's why hxcore's `flecstest` *looks* right (`Position: (12, 34)`), and
  it only works until the GC moves or frees the box.
- `tryGet` and system columns see the raw pointer bits: `SysPos` read back as
  `(-3.1e-33, 4.1e-41)` right after `set`.

### 2. `it.each` callbacks get copies, so writes are lost

`@:component` classes become native structs (`@:structAccess`, `@:native`), so they're
passed by value. `SystemImpl.each1..3` read the column value, pass it to the callback, and
write the original back. `pos.x += ...` in the callback changes a copy. (The old in-repo
binding does the same; hxcore's `systemtest` printed `(0, 0)` where `(1.0, 1.5)` is right.)

### 3. `it.each` with struct components doesn't compile in native builds

Since the cppia refactor, `SystemIter.eachN` delegates to non-inline `SystemImpl.eachN`, so
the callback has to exist as a real closure. hxcpp's dynamic `__Run` wrapper can't convert
`Dynamic` back to a native struct: `cannot convert 'Dynamic' to 'SysPos'`.

### 4. `it.each` from cppia has probably never worked

`SystemImpl.eachN` are `@:generic`, and cppia can't call templated functions (the same
error `f58374f` fixed for `ComponentRef`). In scriptable builds `NativePtr<T>` is `Dynamic`,
so scripts can't touch native struct components at all.

Fixed already: `19d0c2d` keeps `dispatchObserver`/`dispatchSystem` under `--dce full`.

## Constraints (cppia + inline)

- Public API is `inline`; the implementation lives in private, non-inline `impl/*Impl`
  functions, so scripts never inline native code.
- No `@:generic` and no `cpp.Pointer`/`cpp.Reference` anywhere a script can reach.
- `*.hx` stubs in `impl/` exist for the macro and display contexts; `*.cpp.hx` are native.

So typed, zero-copy access has to be generated at the call site in native builds, and
cppia needs its own path.

## What the prototype showed

In a scratch copy of hxcore, `SystemIterMacro` expanded the 2-component case in place, with
the callback's arguments as `cpp.Reference<T>` locals into the columns:

```haxe
case 2:
  var ta = fn.args[0].type, tb = fn.args[1].type;
  var na = fn.args[0].name, nb = fn.args[1].name;
  var body = fn.expr;
  macro {
    var __sysIt = $e{itExpr};
    var __pa:cpp.Pointer<$ta> = @:privateAccess __sysIt.rawColumnPtrBase($e{components[0]}.id).reinterpret();
    var __pb:cpp.Pointer<$tb> = @:privateAccess __sysIt.rawColumnPtrBase($e{components[1]}.id).reinterpret();
    if (__pa != null && __pb != null) {
      for (__sysI in 0...__sysIt.count) {
        var $na:cpp.Reference<$ta> = __pa.add(__sysI).ref;
        var $nb:cpp.Reference<$tb> = __pb.add(__sysI).ref;
        $body;
      }
    }
  };
```

hxcpp keeps the reference: `SysPos & pos = _hx___pa1->add(_hx___sysI)->get_ref(); pos.x = ...`
writes straight into flecs's column. Use `.reinterpret()`, not `cast`: casting
`Pointer<Dynamic>` to `Pointer<SysPos>` is an ambiguous C++ constructor call. The values were
still garbage because of bug 1, but they changed every tick, so the write path works.

## Tasks (native)

1. **Typed `set`/`get`/`tryGet`** (~½ day). `buildSet` already resolves the struct type:
   generate `var tmp:T = value;` and pass `cpp.Pointer.addressOf(tmp)` reinterpreted to
   `void*` straight to `FlecsWrapperImpl.entitySetComponent`, never through `Dynamic`.
   Typed `get` returns a `T` copied from `Pointer<T>.ref`; `tryGet` returns `Pointer<T>`.
   Keep the untyped `setValue` for scripts, and make it fail loudly on a non-struct value.
2. **`it.each` in place** (~½–1 day). Move the prototype into this haxelib's own macro for
   0–3 components and have hxcore's `SystemIterMacro` defer to it. Rewrite `return` inside
   the callback body to `continue`. Check observers' iterators for the same copy problem.
3. **Tests** (~½ day). The current smoke tests never call `each` and never read a value
   back through `tryGet`. Add: set/get/tryGet round-trips for an 8-byte and a 12-byte
   component; a system that moves a position 10 ticks and asserts `(1.0, 1.5)`; builds with
   `--dce full` and `--debug` as well as the current `--dce no`.
4. **hxcore on this haxelib** (~1–2 h). hxcore's `src/hxcore/flecs/*.hx` aliases change from
   `hxcore.flecs.flecs_wrapper.bindings.haxe.*` to `flecs_wrapper.*` (7 files), and
   `extraParams.hxml` registers `flecs_wrapper.ComponentMacro`. Then drop hxcore's
   `flecs_wrapper` submodule. Both examples compiled against this API with no Haxe errors.

## cppia (separate design, 2–5 days, open questions)

Scripts can't use native structs, `@:generic` or pointers, so script-side components need
another model, probably Haxe objects in the script, with the host copying fields into the
struct bytes using the field layout `ComponentMacro.computeComponentSize` already walks.
Until then, `it.each` and typed `set`/`get` should fail at compile time in cppia with a
clear "not supported in scripts yet", instead of misbehaving at run time.
