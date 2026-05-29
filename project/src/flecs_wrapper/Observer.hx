package flecs_wrapper;

import flecs_wrapper.FlecsWrapper.ComponentId;
import flecs_wrapper.FlecsWrapper.EntityId;
import flecs_wrapper.FlecsWrapper.EventId;
import flecs_wrapper.FlecsWrapper.ObserverId;
import flecs_wrapper.impl.ObserverImpl;

@:allow(flecs_wrapper.impl.ObserverImpl)
class ObserverIter {
  private var entityIds:Array<EntityId>;
  private var rawColumns:Array<Dynamic>;
  public var count:Int;
  public var columns:Array<Dynamic>;
  public var columnComponentIds:Array<ComponentId>;
  public var columnSizes:Array<Int>;
  public var eventId:EventId;
  public var componentId:ComponentId;
  public var callbackId:Int;

  private function new(
    entityIds:Array<EntityId>,
    rawColumns:Array<Dynamic>,
    columnComponentIds:Array<ComponentId>,
    columnSizes:Array<Int>,
    eventId:EventId,
    componentId:ComponentId,
    callbackId:Int
  ) {
    this.entityIds = entityIds;
    this.rawColumns = rawColumns;
    this.columns = rawColumns;
    this.columnComponentIds = columnComponentIds;
    this.columnSizes = columnSizes;
    this.count = entityIds.length;
    this.eventId = eventId;
    this.componentId = componentId;
    this.callbackId = callbackId;
  }

  public function entity(i:Int):EntityId {
    if (i < 0 || i >= count) throw "entity index out of bounds";
    return entityIds[i];
  }

  public function colIndex(compId:ComponentId):Int {
    for (i in 0...columnComponentIds.length) if (columnComponentIds[i] == compId) return i;
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
}

typedef ObserverIterCallback = (it:ObserverIter) -> Void;

class Observer {
  public static inline function removeObserver(id:ObserverId):Void ObserverImpl.removeObserver(id);
  public static inline function unregisterObserver(id:ObserverId):Bool return ObserverImpl.unregisterObserver(id);
  public static inline function addObserver(components:Array<Component>, events:Array<EventId>, callback:ObserverIterCallback):ObserverId return ObserverImpl.addObserver(components, events, callback);
  public static inline function addObserverIds(componentIds:Array<ComponentId>, events:Array<EventId>, callback:ObserverIterCallback):ObserverId return ObserverImpl.addObserverIdsPublic(componentIds, events, callback);
  public static inline function addObserverNames(componentNames:Array<String>, events:Array<EventId>, callback:ObserverIterCallback):ObserverId return ObserverImpl.addObserverNames(componentNames, events, callback);
  public static inline function addObserverEx(includeComponents:Array<Component>, excludeComponents:Array<Component>, events:Array<EventId>, callback:ObserverIterCallback):ObserverId return ObserverImpl.addObserverEx(includeComponents, excludeComponents, events, callback);
  public static inline function addObserverExIds(includeIds:Array<ComponentId>, excludeIds:Array<ComponentId>, events:Array<EventId>, callback:ObserverIterCallback):ObserverId return ObserverImpl.addObserverExIdsPublic(includeIds, excludeIds, events, callback);
  public static inline function addObserverExNames(includeNames:Array<String>, excludeNames:Array<String>, events:Array<EventId>, callback:ObserverIterCallback):ObserverId return ObserverImpl.addObserverExNames(includeNames, excludeNames, events, callback);
}
