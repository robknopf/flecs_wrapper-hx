package flecs_wrapper.impl;

#if cpp
import cpp.Pointer;
import cpp.RawConstPointer;
import cpp.RawPointer;
import cpp.UInt32;
import haxe.ds.IntMap;
import flecs_wrapper.Component;
import flecs_wrapper.impl.FlecsWrapperImpl;
import flecs_wrapper.FlecsWrapper.ComponentId;
import flecs_wrapper.FlecsWrapper.EventId;
import flecs_wrapper.FlecsWrapper.ObserverId;
import flecs_wrapper.Observer.ObserverIter;
import flecs_wrapper.Observer.ObserverIterCallback;

private typedef ObserverBridgeCallback = cpp.Callable<(
  entityIds:RawConstPointer<UInt32>,
  entityCount:UInt32,
  columns:RawPointer<RawPointer<cpp.Void>>,
  columnComponentIds:RawConstPointer<UInt32>,
  columnSizes:RawConstPointer<UInt32>,
  columnCount:UInt32,
  eventId:UInt32,
  componentId:UInt32,
  callbackId:UInt32
) -> Void>;

@:cppFileCode('
static void flecs_wrapper_hx_observer_trampoline(
  const unsigned int* entityIds,
  unsigned int entityCount,
  void** columns,
  const unsigned int* columnComponentIds,
  const unsigned int* columnSizes,
  unsigned int columnCount,
  unsigned int eventId,
  unsigned int componentId,
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

  ::flecs_wrapper::impl::ObserverImpl_obj::dispatchObserver(
    entityList,
    rawColumns,
    colIds,
    colSizes,
    (int)eventId,
    (int)componentId,
    (int)callbackId
  );
}
')
private extern class ObserverNativeBridge {
  @:native("::flecs_wrapper_hx_observer_trampoline")
  static function observerTrampoline(
    entityIds:RawConstPointer<UInt32>,
    entityCount:UInt32,
    columns:RawPointer<RawPointer<cpp.Void>>,
    columnComponentIds:RawConstPointer<UInt32>,
    columnSizes:RawConstPointer<UInt32>,
    columnCount:UInt32,
    eventId:UInt32,
    componentId:UInt32,
    callbackId:UInt32
  ):Void;
}

@:cppFileCode('
static void flecs_wrapper_hx_observer_trampoline(
  const unsigned int* entityIds,
  unsigned int entityCount,
  void** columns,
  const unsigned int* columnComponentIds,
  const unsigned int* columnSizes,
  unsigned int columnCount,
  unsigned int eventId,
  unsigned int componentId,
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

  ::flecs_wrapper::impl::ObserverImpl_obj::dispatchObserver(
    entityList,
    rawColumns,
    colIds,
    colSizes,
    (int)eventId,
    (int)componentId,
    (int)callbackId
  );
}
')
class ObserverImpl {
  static var nextCallbackId:UInt32 = 1;
  static var callbackMap:IntMap<ObserverIterCallback> = new IntMap();

  static function registerCallback(cb:ObserverIterCallback, ?id:UInt32):UInt32 {
    if (cb == null) throw "Observer callback is null";
    var realId:UInt32 = id != null ? id : nextCallbackId++;
    if (callbackMap.exists(cast realId)) throw 'callback already registered for id ${realId}';
    callbackMap.set(cast realId, cb);
    return realId;
  }

  public static function removeObserver(id:ObserverId):Void {
    if (callbackMap.exists(cast id)) callbackMap.remove(cast id);
  }

  public static function unregisterObserver(id:ObserverId):Bool {
    removeObserver(id);
    return FlecsWrapperImpl.unregisterObserver(id);
  }

  private static function dispatchObserver(
    entityIds:Array<Int>,
    rawColumns:Array<Dynamic>,
    columnComponentIds:Array<Int>,
    columnSizes:Array<Int>,
    eventId:Int,
    componentId:Int,
    callbackId:Int
  ):Void {
    var cb = callbackMap.get(cast callbackId);
    if (cb == null) return;
    cb(new ObserverIter(entityIds, rawColumns, columnComponentIds, columnSizes, eventId, componentId, callbackId));
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

  static function validateEventIds(events:Array<EventId>):Void {
    for (ev in events) if (ev < 1) throw 'Invalid event id: ${ev}';
  }

  static function toEventIds(events:Array<EventId>):Array<UInt32> {
    var result = new Array<UInt32>();
    if (events != null) for (eventId in events) result.push(cast eventId);
    return result;
  }

  static function addObserverIdsInternal(componentIds:Array<UInt32>, eventIds:Array<EventId>, callback:ObserverIterCallback):ObserverId {
    if (componentIds == null || componentIds.length == 0) throw "Observer must include at least one component";
    if (eventIds == null || eventIds.length == 0) throw "Observer must include at least one event";
    if (callback == null) throw "Observer callback is null";
    validateEventIds(eventIds);
    var cbid:UInt32 = registerCallback(callback);
    var compPtr = Pointer.ofArray(componentIds);
    var eventPtr = Pointer.ofArray(toEventIds(eventIds));
    var nativeCb:ObserverBridgeCallback = untyped __cpp__("::cpp::Function< void (const unsigned int*,unsigned int,void**,const unsigned int*,const unsigned int*,unsigned int,unsigned int,unsigned int,unsigned int)>(&flecs_wrapper_hx_observer_trampoline)");
    return FlecsWrapperImpl.registerObserver(compPtr, cast componentIds.length, eventPtr, cast eventIds.length, cast nativeCb, cbid);
  }

  public static function addObserver(components:Array<Component>, events:Array<EventId>, callback:ObserverIterCallback):ObserverId {
    return addObserverIdsInternal(toComponentIds(components), events, callback);
  }

  public static function addObserverIds(componentIds:Array<UInt32>, events:Array<EventId>, callback:ObserverIterCallback):ObserverId {
    return addObserverIdsInternal(componentIds, events, callback);
  }

  public static function addObserverIdsPublic(componentIds:Array<ComponentId>, events:Array<EventId>, callback:ObserverIterCallback):ObserverId {
    return addObserverIdsInternal([for (id in componentIds) cast id], events, callback);
  }

  public static function addObserverNames(componentNames:Array<String>, events:Array<EventId>, callback:ObserverIterCallback):ObserverId {
    return addObserverIdsInternal(toComponentIdsFromNames(componentNames), events, callback);
  }

  static function addObserverExIdsInternal(includeIds:Array<UInt32>, excludeIds:Array<UInt32>, events:Array<EventId>, callback:ObserverIterCallback):ObserverId {
    if (includeIds == null || includeIds.length == 0) throw "Observer must include at least one component";
    if (events == null || events.length == 0) throw "Observer must include at least one event";
    if (callback == null) throw "Observer callback is null";
    validateEventIds(events);
    var cbid:UInt32 = registerCallback(callback);
    var includePtr = Pointer.ofArray(includeIds);
    var excludePtr = (excludeIds != null && excludeIds.length > 0) ? Pointer.ofArray(excludeIds) : null;
    var eventPtr = Pointer.ofArray(toEventIds(events));
    var nativeCb:ObserverBridgeCallback = untyped __cpp__("::cpp::Function< void (const unsigned int*,unsigned int,void**,const unsigned int*,const unsigned int*,unsigned int,unsigned int,unsigned int,unsigned int)>(&flecs_wrapper_hx_observer_trampoline)");
    return FlecsWrapperImpl.registerObserverEx(
      includePtr,
      cast includeIds.length,
      excludePtr == null ? cast null : excludePtr,
      cast (excludeIds == null ? 0 : excludeIds.length),
      eventPtr,
      cast events.length,
      cast nativeCb,
      cbid
    );
  }

  public static function addObserverEx(includeComponents:Array<Component>, excludeComponents:Array<Component>, events:Array<EventId>, callback:ObserverIterCallback):ObserverId {
    return addObserverExIdsInternal(toComponentIds(includeComponents), toComponentIds(excludeComponents), events, callback);
  }

  public static function addObserverExIds(includeIds:Array<UInt32>, excludeIds:Array<UInt32>, events:Array<EventId>, callback:ObserverIterCallback):ObserverId {
    return addObserverExIdsInternal(includeIds, excludeIds, events, callback);
  }

  public static function addObserverExIdsPublic(includeIds:Array<ComponentId>, excludeIds:Array<ComponentId>, events:Array<EventId>, callback:ObserverIterCallback):ObserverId {
    var nativeInclude = [for (id in includeIds) cast id];
    var nativeExclude = excludeIds == null ? null : [for (id in excludeIds) cast id];
    return addObserverExIdsInternal(nativeInclude, nativeExclude, events, callback);
  }

  public static function addObserverExNames(includeNames:Array<String>, excludeNames:Array<String>, events:Array<EventId>, callback:ObserverIterCallback):ObserverId {
    return addObserverExIdsInternal(toComponentIdsFromNames(includeNames), toComponentIdsFromNames(excludeNames), events, callback);
  }
}
#end
