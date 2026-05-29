package flecs_wrapper.impl;

#if cpp
import cpp.Float32;
import cpp.Pointer;
import cpp.RawConstPointer;
import cpp.RawPointer;
import cpp.UInt32;
import haxe.ds.IntMap;
import flecs_wrapper.Component;
import flecs_wrapper.impl.FlecsWrapperImpl;
import flecs_wrapper.FlecsWrapper.ComponentId;
import flecs_wrapper.FlecsWrapper.EntityId;
import flecs_wrapper.FlecsWrapper.SystemId;
import flecs_wrapper.System.SystemIterCallback;
import flecs_wrapper.System.SystemIter;

private typedef SystemBridgeCallback = cpp.Callable<(
  entityIds:RawConstPointer<UInt32>,
  entityCount:UInt32,
  columns:RawPointer<RawPointer<cpp.Void>>,
  columnComponentIds:RawConstPointer<UInt32>,
  columnSizes:RawConstPointer<UInt32>,
  columnCount:UInt32,
  deltaTime:Float32,
  callbackId:UInt32
) -> Void>;

@:cppFileCode('
static void flecs_wrapper_hx_system_trampoline(
  const unsigned int* entityIds,
  unsigned int entityCount,
  void** columns,
  const unsigned int* columnComponentIds,
  const unsigned int* columnSizes,
  unsigned int columnCount,
  float deltaTime,
  unsigned int callbackId
) {
  ::Array< int > entityList = ::Array_obj< int >::__new();
  for (unsigned int i = 0; i < entityCount; ++i) {
    entityList->push((int)entityIds[i]);
  }

  ::Array< ::Dynamic > rawColumns = ::Array_obj< ::Dynamic >::__new();
  ::Array< int > colIds = ::Array_obj< int >::__new();
  ::Array< int > colSizes = ::Array_obj< int >::__new();
  for (unsigned int i = 0; i < columnCount; ++i) {
    void* raw = columns[i];
    rawColumns->push(raw ? ::cpp::Pointer_obj::fromRaw(raw) : null());
    colIds->push((int)columnComponentIds[i]);
    colSizes->push((int)columnSizes[i]);
  }

  ::flecs_wrapper::impl::SystemImpl_obj::dispatchSystem(
    entityList,
    rawColumns,
    colIds,
    colSizes,
    (Float)deltaTime,
    (int)callbackId
  );
}
')
private extern class SystemNativeBridge {
  @:native("::flecs_wrapper_hx_system_trampoline")
  static function systemTrampoline(
    entityIds:RawConstPointer<UInt32>,
    entityCount:UInt32,
    columns:RawPointer<RawPointer<cpp.Void>>,
    columnComponentIds:RawConstPointer<UInt32>,
    columnSizes:RawConstPointer<UInt32>,
    columnCount:UInt32,
    deltaTime:Float32,
    callbackId:UInt32
  ):Void;
}

@:cppFileCode('
static void flecs_wrapper_hx_system_trampoline(
  const unsigned int* entityIds,
  unsigned int entityCount,
  void** columns,
  const unsigned int* columnComponentIds,
  const unsigned int* columnSizes,
  unsigned int columnCount,
  float deltaTime,
  unsigned int callbackId
) {
  ::Array< int > entityList = ::Array_obj< int >::__new();
  for (unsigned int i = 0; i < entityCount; ++i) {
    entityList->push((int)entityIds[i]);
  }

  ::Array< ::Dynamic > rawColumns = ::Array_obj< ::Dynamic >::__new();
  ::Array< int > colIds = ::Array_obj< int >::__new();
  ::Array< int > colSizes = ::Array_obj< int >::__new();
  for (unsigned int i = 0; i < columnCount; ++i) {
    void* raw = columns[i];
    rawColumns->push(raw ? ::cpp::Pointer_obj::fromRaw(raw) : null());
    colIds->push((int)columnComponentIds[i]);
    colSizes->push((int)columnSizes[i]);
  }

  ::flecs_wrapper::impl::SystemImpl_obj::dispatchSystem(
    entityList,
    rawColumns,
    colIds,
    colSizes,
    (Float)deltaTime,
    (int)callbackId
  );
}
')
class SystemImpl {
  static var nextCallbackId:UInt32 = 1;
  static var callbackMap:IntMap<SystemIterCallback> = new IntMap();

  static function registerCallback(cb:SystemIterCallback, ?id:UInt32):UInt32 {
    if (cb == null) throw "System callback is null";
    var realId:UInt32 = id != null ? id : nextCallbackId++;
    if (callbackMap.exists(cast realId)) throw 'callback already registered for id ${realId}';
    callbackMap.set(cast realId, cb);
    return realId;
  }

  public static function removeSystem(id:SystemId):Void {
    if (callbackMap.exists(cast id)) callbackMap.remove(cast id);
  }

  public static function unregisterSystem(id:SystemId):Bool {
    removeSystem(id);
    return FlecsWrapperImpl.unregisterSystem(id);
  }

  private static function dispatchSystem(
    entityIds:Array<Int>,
    rawColumns:Array<Dynamic>,
    columnComponentIds:Array<Int>,
    columnSizes:Array<Int>,
    deltaTime:Float,
    callbackId:Int
  ):Void {
    var cb = callbackMap.get(cast callbackId);
    if (cb == null) return;
    cb(new SystemIter(entityIds, rawColumns, columnComponentIds, columnSizes, deltaTime, callbackId));
  }

  static function toComponentIds(components:Array<Component>):Array<UInt32> {
    var result = new Array<UInt32>();
    if (components != null) for (comp in components) result.push(cast comp.id);
    return result;
  }

  static function toComponentIdsFromNames(names:Array<String>):Array<UInt32> {
    var result = new Array<UInt32>();
    if (names != null) {
      for (name in names) {
        var id = FlecsWrapperImpl.componentId(name);
        if (id == 0) throw 'Unknown component name: ${name}';
        result.push(cast id);
      }
    }
    return result;
  }

  static function addSystemIdsInternal(name:String, componentIds:Array<UInt32>, callback:SystemIterCallback):SystemId {
    if (componentIds == null || componentIds.length == 0) throw "System must include at least one component";
    if (callback == null) throw "System callback is null";
    var cbid:UInt32 = registerCallback(callback);
    var compPtr = Pointer.ofArray(componentIds);
    var nativeCb:SystemBridgeCallback = untyped __cpp__("::cpp::Function< void (const unsigned int*,unsigned int,void**,const unsigned int*,const unsigned int*,unsigned int,float,unsigned int)>(&flecs_wrapper_hx_system_trampoline)");
    return FlecsWrapperImpl.registerSystem(name, compPtr, cast componentIds.length, cast nativeCb, cbid);
  }

  public static function addSystem(name:String, components:Array<Component>, callback:SystemIterCallback):SystemId {
    return addSystemIdsInternal(name, toComponentIds(components), callback);
  }

  public static function addSystemIds(name:String, componentIds:Array<ComponentId>, callback:SystemIterCallback):SystemId {
    return addSystemIdsInternal(name, [for (id in componentIds) cast id], callback);
  }

  public static function addSystemNames(name:String, componentNames:Array<String>, callback:SystemIterCallback):SystemId {
    return addSystemIdsInternal(name, toComponentIdsFromNames(componentNames), callback);
  }

  public static function addTask(name:String, callback:SystemIterCallback):SystemId {
    if (callback == null) throw "System callback is null";
    var cbid:UInt32 = registerCallback(callback);
    var nativeCb:SystemBridgeCallback = untyped __cpp__("::cpp::Function< void (const unsigned int*,unsigned int,void**,const unsigned int*,const unsigned int*,unsigned int,float,unsigned int)>(&flecs_wrapper_hx_system_trampoline)");
    return FlecsWrapperImpl.registerSystem(name, cast null, 0, cast nativeCb, cbid);
  }

  static function addSystemExIdsInternal(name:String, includeIds:Array<UInt32>, excludeIds:Array<UInt32>, callback:SystemIterCallback):SystemId {
    if (includeIds == null || includeIds.length == 0) throw "System must include at least one component";
    if (callback == null) throw "System callback is null";
    var cbid:UInt32 = registerCallback(callback);
    var includePtr = Pointer.ofArray(includeIds);
    var excludePtr = (excludeIds != null && excludeIds.length > 0) ? Pointer.ofArray(excludeIds) : null;
    var nativeCb:SystemBridgeCallback = untyped __cpp__("::cpp::Function< void (const unsigned int*,unsigned int,void**,const unsigned int*,const unsigned int*,unsigned int,float,unsigned int)>(&flecs_wrapper_hx_system_trampoline)");
    return FlecsWrapperImpl.registerSystemEx(
      name,
      includePtr,
      cast includeIds.length,
      excludePtr == null ? cast null : excludePtr,
      cast (excludeIds == null ? 0 : excludeIds.length),
      cast nativeCb,
      cbid
    );
  }

  public static function addSystemEx(name:String, includeComponents:Array<Component>, excludeComponents:Array<Component>, callback:SystemIterCallback):SystemId {
    return addSystemExIdsInternal(name, toComponentIds(includeComponents), toComponentIds(excludeComponents), callback);
  }

  public static function addSystemExIds(name:String, includeIds:Array<ComponentId>, excludeIds:Array<ComponentId>, callback:SystemIterCallback):SystemId {
    var nativeInclude = [for (id in includeIds) cast id];
    var nativeExclude = excludeIds == null ? null : [for (id in excludeIds) cast id];
    return addSystemExIdsInternal(name, nativeInclude, nativeExclude, callback);
  }

  public static function addSystemExNames(name:String, includeNames:Array<String>, excludeNames:Array<String>, callback:SystemIterCallback):SystemId {
    return addSystemExIdsInternal(name, toComponentIdsFromNames(includeNames), toComponentIdsFromNames(excludeNames), callback);
  }

  private static function rawColumnPtr(it:SystemIter, compId:ComponentId):Dynamic {
    var idx = it.colIndex(compId);
    if (idx < 0) return null;
    return it.rawColumns[idx];
  }

  private static function rawColumn(it:SystemIter, compId:ComponentId, i:Int):Dynamic {
    var ptrs:Pointer<Dynamic> = cast rawColumnPtr(it, compId);
    if (ptrs == null) return null;
    if (i < 0 || i >= it.count) throw "column index out of bounds";
    return cast ptrs.add(i);
  }

  public static function tryColumn(it:SystemIter, comp:Component, i:Int):Dynamic {
    var ptr:Pointer<cpp.Void> = cast rawColumn(it, comp.id, i);
    if (ptr == null) return null;
    return cast(cast ptr, Pointer<Dynamic>).ref;
  }

  public static function column(it:SystemIter, comp:Component, i:Int):Dynamic {
    var value = tryColumn(it, comp, i);
    if (value == null) throw 'Column value not found for component ${comp.name}';
    return value;
  }

  @:generic public static function each1<A>(it:SystemIter, a:Component, cb:(a:A)->Void):Void {
    var pa:Pointer<A> = cast rawColumnPtr(it, a.id);
    if (pa == null) return;
    for (i in 0...it.count) {
      var av = pa.add(i).ref;
      cb(cast av);
      pa.add(i).ref = av;
    }
  }

  @:generic public static function each2<A,B>(it:SystemIter, a:Component, b:Component, cb:(a:A,b:B)->Void):Void {
    var pa:Pointer<A> = cast rawColumnPtr(it, a.id);
    var pb:Pointer<B> = cast rawColumnPtr(it, b.id);
    if (pa == null || pb == null) return;
    for (i in 0...it.count) {
      var av = pa.add(i).ref;
      var bv = pb.add(i).ref;
      cb(cast av, cast bv);
      pa.add(i).ref = av;
      pb.add(i).ref = bv;
    }
  }

  @:generic public static function each3<A,B,C>(it:SystemIter, a:Component, b:Component, c:Component, cb:(a:A,b:B,c:C)->Void):Void {
    var pa:Pointer<A> = cast rawColumnPtr(it, a.id);
    var pb:Pointer<B> = cast rawColumnPtr(it, b.id);
    var pc:Pointer<C> = cast rawColumnPtr(it, c.id);
    if (pa == null || pb == null || pc == null) return;
    for (i in 0...it.count) {
      var av = pa.add(i).ref;
      var bv = pb.add(i).ref;
      var cv = pc.add(i).ref;
      cb(cast av, cast bv, cast cv);
      pa.add(i).ref = av;
      pb.add(i).ref = bv;
      pc.add(i).ref = cv;
    }
  }
}
#end
