package flecs_wrapper;

// Stable wrapper handle types. These are public Haxe-facing aliases, not raw flecs ids.
typedef EntityId = Int;
typedef ComponentId = Int;
typedef EventId = Int;
typedef ObserverId = Int;
typedef SystemId = Int;
typedef PairId = Int;

@:keep
@:expose
class FlecsWrapper {
  public static var EcsUnknownEvent(get, never):Int;
  static inline function get_EcsUnknownEvent():Int return flecs_wrapper.impl.FlecsWrapperImpl.EcsUnknownEvent;

  public static var EcsOnAdd(get, never):Int;
  static inline function get_EcsOnAdd():Int return flecs_wrapper.impl.FlecsWrapperImpl.EcsOnAdd;

  public static var EcsOnRemove(get, never):Int;
  static inline function get_EcsOnRemove():Int return flecs_wrapper.impl.FlecsWrapperImpl.EcsOnRemove;

  public static var EcsOnSet(get, never):Int;
  static inline function get_EcsOnSet():Int return flecs_wrapper.impl.FlecsWrapperImpl.EcsOnSet;

  public static var EcsOnDelete(get, never):Int;
  static inline function get_EcsOnDelete():Int return flecs_wrapper.impl.FlecsWrapperImpl.EcsOnDelete;

  public static var EcsOnDeleteTarget(get, never):Int;
  static inline function get_EcsOnDeleteTarget():Int return flecs_wrapper.impl.FlecsWrapperImpl.EcsOnDeleteTarget;

  public static var EcsOnTableCreate(get, never):Int;
  static inline function get_EcsOnTableCreate():Int return flecs_wrapper.impl.FlecsWrapperImpl.EcsOnTableCreate;

  public static var EcsOnTableDelete(get, never):Int;
  static inline function get_EcsOnTableDelete():Int return flecs_wrapper.impl.FlecsWrapperImpl.EcsOnTableDelete;

  public static function componentId(name:String):ComponentId {
    return flecs_wrapper.impl.FlecsWrapperImpl.componentId(name);
  }

  public static function componentIsTag(componentId:ComponentId):Bool {
    return flecs_wrapper.impl.FlecsWrapperImpl.componentIsTag(componentId);
  }

  public static function componentPrintRegistry():Void {
    flecs_wrapper.impl.FlecsWrapperImpl.componentPrintRegistry();
  }

  public static function componentCreate(name:String, size:Int):ComponentId {
    return flecs_wrapper.impl.FlecsWrapperImpl.componentCreate(name, size);
  }

  public static function componentCreateTag(name:String):ComponentId {
    return flecs_wrapper.impl.FlecsWrapperImpl.componentCreateTag(name);
  }

  public static function entityPrintComponents(entityId:EntityId):Void {
    flecs_wrapper.impl.FlecsWrapperImpl.entityPrintComponents(entityId);
  }

  public static function entityHasComponent(entityId:EntityId, componentId:ComponentId):Bool {
    return flecs_wrapper.impl.FlecsWrapperImpl.entityHasComponent(entityId, componentId);
  }

  public static function entityHasComponentByName(entityId:EntityId, name:String):Bool {
    return flecs_wrapper.impl.FlecsWrapperImpl.entityHasComponentByName(entityId, name);
  }

  public static function entityAddComponent(entityId:EntityId, componentId:ComponentId):Bool {
    return flecs_wrapper.impl.FlecsWrapperImpl.entityAddComponent(entityId, componentId);
  }

  public static function entityAddComponentByName(entityId:EntityId, name:String):Bool {
    return flecs_wrapper.impl.FlecsWrapperImpl.entityAddComponentByName(entityId, name);
  }

  public static function entityRemoveComponent(entityId:EntityId, componentId:ComponentId):Bool {
    return flecs_wrapper.impl.FlecsWrapperImpl.entityRemoveComponent(entityId, componentId);
  }

  public static function entityRemoveComponentByName(entityId:EntityId, name:String):Bool {
    return flecs_wrapper.impl.FlecsWrapperImpl.entityRemoveComponentByName(entityId, name);
  }

  public static function entitySetComponent(entityId:EntityId, componentId:ComponentId, componentPtr:NativePtr<Dynamic>):Bool {
    return flecs_wrapper.impl.FlecsWrapperImpl.entitySetComponent(entityId, componentId, componentPtr);
  }

  public static function entityGetComponent(entityId:EntityId, componentId:ComponentId):NativePtr<Dynamic> {
    return flecs_wrapper.impl.FlecsWrapperImpl.entityGetComponent(entityId, componentId);
  }

  public static function entityMarkComponent(entityId:EntityId, componentId:ComponentId):Void {
    flecs_wrapper.impl.FlecsWrapperImpl.entityMarkComponent(entityId, componentId);
  }

  public static function pairRegister(relationComponentId:ComponentId, objectEntityId:EntityId):PairId {
    return flecs_wrapper.impl.FlecsWrapperImpl.pairRegister(relationComponentId, objectEntityId);
  }

  public static function pairRegisterEntity(relationEntityId:EntityId, objectEntityId:EntityId):PairId {
    return flecs_wrapper.impl.FlecsWrapperImpl.pairRegisterEntity(relationEntityId, objectEntityId);
  }

  public static function pairRegisterByName(relationName:String, objectName:String):PairId {
    return flecs_wrapper.impl.FlecsWrapperImpl.pairRegisterByName(relationName, objectName);
  }

  public static function pairUnregister(pairId:PairId):Bool {
    return flecs_wrapper.impl.FlecsWrapperImpl.pairUnregister(pairId);
  }

  public static function entityAddPair(entityId:EntityId, pairId:PairId):Bool {
    return flecs_wrapper.impl.FlecsWrapperImpl.entityAddPair(entityId, pairId);
  }

  public static function entityRemovePair(entityId:EntityId, pairId:PairId):Bool {
    return flecs_wrapper.impl.FlecsWrapperImpl.entityRemovePair(entityId, pairId);
  }

  public static function entityHasPair(entityId:EntityId, pairId:PairId):Bool {
    return flecs_wrapper.impl.FlecsWrapperImpl.entityHasPair(entityId, pairId);
  }

  public static function entitySetPair(entityId:EntityId, pairId:PairId, pairPtr:NativePtr<Dynamic>):Bool {
    return flecs_wrapper.impl.FlecsWrapperImpl.entitySetPair(entityId, pairId, pairPtr);
  }

  public static function entityGetPair(entityId:EntityId, pairId:PairId):NativePtr<Dynamic> {
    return flecs_wrapper.impl.FlecsWrapperImpl.entityGetPair(entityId, pairId);
  }

  public static function entityCreate(name:String):EntityId {
    return flecs_wrapper.impl.FlecsWrapperImpl.entityCreate(name);
  }

  public static function entityDestroy(entityId:EntityId):Bool {
    return flecs_wrapper.impl.FlecsWrapperImpl.entityDestroy(entityId);
  }

  public static function init():Void {
    flecs_wrapper.impl.FlecsWrapperImpl.init();
  }

  public static function progress(delta:Float):Void {
    flecs_wrapper.impl.FlecsWrapperImpl.progress(delta);
  }

  public static function fini():Void {
    flecs_wrapper.impl.FlecsWrapperImpl.fini();
  }

  public static function setThreads(threads:Int):Void {
    flecs_wrapper.impl.FlecsWrapperImpl.setThreads(threads);
  }

  public static function version():String {
    return flecs_wrapper.impl.FlecsWrapperImpl.version();
  }
}

@:structAccess
@:structInit
@:nativeGen
@:keep
@:native("EntityId")
class EntityIdComponent {
  public var value:Int;
}
