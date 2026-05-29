package flecs_wrapper.impl;

#if cpp
import cpp.Callable;
import cpp.ConstCharStar;
import cpp.Float32;
import cpp.Pointer;
import cpp.RawConstPointer;
import cpp.RawPointer;
import cpp.UInt32;
import flecs_wrapper.NativePtr;
import flecs_wrapper.FlecsWrapper.ComponentId;
import flecs_wrapper.FlecsWrapper.EntityId;
import flecs_wrapper.FlecsWrapper.EventId;
import flecs_wrapper.FlecsWrapper.ObserverId;
import flecs_wrapper.FlecsWrapper.PairId;
import flecs_wrapper.FlecsWrapper.SystemId;

private typedef SystemCallbackNative = Callable<(
  entityIds:RawConstPointer<UInt32>,
  entityCount:UInt32,
  columns:RawPointer<RawPointer<cpp.Void>>,
  columnComponentIds:RawConstPointer<UInt32>,
  columnSizes:RawConstPointer<UInt32>,
  columnCount:UInt32,
  deltaTime:Float32,
  callbackId:UInt32
) -> Void>;

private typedef ObserverCallbackNative = Callable<(
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

@:buildXml('
<echo value="Compiling Flecs (wrapper)..." />
<echo value="hxlib path: ${haxelib:flecs_wrapper-hx}" />
<files id="haxe">
  <compilerflag value="-I${haxelib:flecs_wrapper-hx}/project/lib/flecs_wrapper/include"/>
  <file name="${haxelib:flecs_wrapper-hx}/project/lib/flecs_wrapper/src/flecs.c" />
  <file name="${haxelib:flecs_wrapper-hx}/project/lib/flecs_wrapper/src/flecs_wrapper.c" />
  <file name="${haxelib:flecs_wrapper-hx}/project/lib/flecs_wrapper/src/flecs_wrapper_component.c" />
  <file name="${haxelib:flecs_wrapper-hx}/project/lib/flecs_wrapper/src/flecs_wrapper_components.c" />
  <file name="${haxelib:flecs_wrapper-hx}/project/lib/flecs_wrapper/src/flecs_wrapper_id.c" />
  <file name="${haxelib:flecs_wrapper-hx}/project/lib/flecs_wrapper/src/flecs_wrapper_pair.c" />
  <file name="${haxelib:flecs_wrapper-hx}/project/lib/flecs_wrapper/src/flecs_wrapper_world.c" />
  <file name="${haxelib:flecs_wrapper-hx}/project/lib/flecs_wrapper/src/flecs_wrapper_entity.c" />
  <file name="${haxelib:flecs_wrapper-hx}/project/lib/flecs_wrapper/src/flecs_wrapper_event.c" />
  <file name="${haxelib:flecs_wrapper-hx}/project/lib/flecs_wrapper/src/flecs_wrapper_system.c" />
  <file name="${haxelib:flecs_wrapper-hx}/project/lib/flecs_wrapper/src/systems/destination_system.c" />
  <file name="${haxelib:flecs_wrapper-hx}/project/lib/flecs_wrapper/src/systems/move_system.c" />
</files>
')
@:headerInclude('flecs_wrapper.h')
private extern class FlecsNative {
  @:native("flecs_component_get_id_by_name")
  static function componentId(name:String):ComponentId;
  @:native("flecs_component_is_tag")
  static function componentIsTag(componentId:ComponentId):Bool;
  @:native("flecs_component_print_registry")
  static function componentPrintRegistry():Void;
  @:native("flecs_component_create")
  static function componentCreate(name:String, size:UInt32):ComponentId;
  @:native("flecs_component_create_tag")
  static function componentCreateTag(name:String):ComponentId;

  @:native("flecs_entity_print_components")
  static function entityPrintComponents(entityId:EntityId):Void;
  @:native("flecs_entity_has_component")
  static function entityHasComponent(entityId:EntityId, componentId:ComponentId):Bool;
  @:native("flecs_entity_has_component_by_name")
  static function entityHasComponentByName(entityId:EntityId, name:String):Bool;
  @:native("flecs_entity_add_component")
  static function entityAddComponent(entityId:EntityId, componentId:ComponentId):Bool;
  @:native("flecs_entity_add_component_by_name")
  static function entityAddComponentByName(entityId:EntityId, name:String):Bool;
  @:native("flecs_entity_remove_component")
  static function entityRemoveComponent(entityId:EntityId, componentId:ComponentId):Bool;
  @:native("flecs_entity_remove_component_by_name")
  static function entityRemoveComponentByName(entityId:EntityId, name:String):Bool;
  @:native("flecs_entity_set_component")
  static function entitySetComponent(entityId:EntityId, componentId:ComponentId, componentPtr:Pointer<cpp.Void>):Bool;
  @:native("flecs_entity_get_component")
  static function entityGetComponent(entityId:EntityId, componentId:ComponentId):Pointer<cpp.Void>;
  @:native("flecs_entity_mark_component")
  static function entityMarkComponent(entityId:EntityId, componentId:ComponentId):Void;

  @:native("flecs_pair_register")
  static function pairRegister(relationComponentId:ComponentId, objectEntityId:EntityId):PairId;
  @:native("flecs_pair_register_entity")
  static function pairRegisterEntity(relationEntityId:EntityId, objectEntityId:EntityId):PairId;
  @:native("flecs_pair_register_by_name")
  static function pairRegisterByName(relationName:String, objectName:String):PairId;
  @:native("flecs_pair_unregister")
  static function pairUnregister(pairId:PairId):Bool;
  @:native("flecs_entity_add_pair")
  static function entityAddPair(entityId:EntityId, pairId:PairId):Bool;
  @:native("flecs_entity_remove_pair")
  static function entityRemovePair(entityId:EntityId, pairId:PairId):Bool;
  @:native("flecs_entity_has_pair")
  static function entityHasPair(entityId:EntityId, pairId:PairId):Bool;
  @:native("flecs_entity_set_pair")
  static function entitySetPair(entityId:EntityId, pairId:PairId, pairPtr:Pointer<cpp.Void>):Bool;
  @:native("flecs_entity_get_pair")
  static function entityGetPair(entityId:EntityId, pairId:PairId):Pointer<cpp.Void>;

  @:native("flecs_entity_create")
  static function entityCreate(name:String):EntityId;
  @:native("flecs_entity_destroy")
  static function entityDestroy(entityId:EntityId):Bool;

  @:native("flecs_register_observer")
  static function registerObserver(componentIds:RawPointer<UInt32>, numComponents:UInt32, eventIds:RawPointer<UInt32>, numEvents:UInt32, callback:ObserverCallbackNative, callbackId:UInt32):ObserverId;
  @:native("flecs_register_observer_ex")
  static function registerObserverEx(includeComponentIds:RawPointer<UInt32>, numIncludeComponents:UInt32, excludeComponentIds:RawPointer<UInt32>, numExcludeComponents:UInt32, eventIds:RawPointer<UInt32>, numEvents:UInt32, callback:ObserverCallbackNative, callbackId:UInt32):ObserverId;
  @:native("flecs_unregister_observer")
  static function unregisterObserver(observerId:ObserverId):Bool;

  @:native("flecs_register_system")
  static function registerSystem(name:String, componentIds:RawPointer<UInt32>, numComponents:UInt32, callback:SystemCallbackNative, callbackId:UInt32):SystemId;
  @:native("flecs_register_system_ex")
  static function registerSystemEx(name:String, includeComponentIds:RawPointer<UInt32>, numIncludeComponents:UInt32, excludeComponentIds:RawPointer<UInt32>, numExcludeComponents:UInt32, callback:SystemCallbackNative, callbackId:UInt32):SystemId;
  @:native("flecs_unregister_system")
  static function unregisterSystem(systemId:SystemId):Bool;

  @:native("flecs_init")
  static function init():Void;
  @:native("flecs_progress")
  static function progress(delta:Float32):Void;
  @:native("flecs_fini")
  static function fini():Void;
  @:native("flecs_set_threads")
  static function setThreads(threads:Int):Void;
  @:native("flecs_version")
  static function flecsVersion():ConstCharStar;
}

@:headerInclude('flecs_wrapper.h')
class FlecsWrapperImpl {
  public static final EcsUnknownEvent:Int = 0;
  public static final EcsOnAdd:Int = 1;
  public static final EcsOnRemove:Int = 2;
  public static final EcsOnSet:Int = 3;
  public static final EcsOnDelete:Int = 4;
  public static final EcsOnDeleteTarget:Int = 5;
  public static final EcsOnTableCreate:Int = 6;
  public static final EcsOnTableDelete:Int = 7;

  public static function componentId(name:String):ComponentId return FlecsNative.componentId(name);
  public static function componentIsTag(componentId:ComponentId):Bool return FlecsNative.componentIsTag(componentId);
  public static function componentPrintRegistry():Void FlecsNative.componentPrintRegistry();
  public static function componentCreate(name:String, size:Int):ComponentId return cast FlecsNative.componentCreate(name, cast size);
  public static function componentCreateTag(name:String):ComponentId return FlecsNative.componentCreateTag(name);

  public static function entityPrintComponents(entityId:EntityId):Void FlecsNative.entityPrintComponents(entityId);
  public static function entityHasComponent(entityId:EntityId, componentId:ComponentId):Bool return FlecsNative.entityHasComponent(entityId, componentId);
  public static function entityHasComponentByName(entityId:EntityId, name:String):Bool return FlecsNative.entityHasComponentByName(entityId, name);
  public static function entityAddComponent(entityId:EntityId, componentId:ComponentId):Bool return FlecsNative.entityAddComponent(entityId, componentId);
  public static function entityAddComponentByName(entityId:EntityId, name:String):Bool return FlecsNative.entityAddComponentByName(entityId, name);
  public static function entityRemoveComponent(entityId:EntityId, componentId:ComponentId):Bool return FlecsNative.entityRemoveComponent(entityId, componentId);
  public static function entityRemoveComponentByName(entityId:EntityId, name:String):Bool return FlecsNative.entityRemoveComponentByName(entityId, name);
  public static function entitySetComponent(entityId:EntityId, componentId:ComponentId, componentPtr:NativePtr<Dynamic>):Bool return FlecsNative.entitySetComponent(entityId, componentId, cast componentPtr);
  public static function entityGetComponent(entityId:EntityId, componentId:ComponentId):NativePtr<Dynamic> return cast FlecsNative.entityGetComponent(entityId, componentId);
  public static function entityMarkComponent(entityId:EntityId, componentId:ComponentId):Void FlecsNative.entityMarkComponent(entityId, componentId);

  public static function pairRegister(relationComponentId:ComponentId, objectEntityId:EntityId):PairId return FlecsNative.pairRegister(relationComponentId, objectEntityId);
  public static function pairRegisterEntity(relationEntityId:EntityId, objectEntityId:EntityId):PairId return FlecsNative.pairRegisterEntity(relationEntityId, objectEntityId);
  public static function pairRegisterByName(relationName:String, objectName:String):PairId return FlecsNative.pairRegisterByName(relationName, objectName);
  public static function pairUnregister(pairId:PairId):Bool return FlecsNative.pairUnregister(pairId);
  public static function entityAddPair(entityId:EntityId, pairId:PairId):Bool return FlecsNative.entityAddPair(entityId, pairId);
  public static function entityRemovePair(entityId:EntityId, pairId:PairId):Bool return FlecsNative.entityRemovePair(entityId, pairId);
  public static function entityHasPair(entityId:EntityId, pairId:PairId):Bool return FlecsNative.entityHasPair(entityId, pairId);
  public static function entitySetPair(entityId:EntityId, pairId:PairId, pairPtr:NativePtr<Dynamic>):Bool return FlecsNative.entitySetPair(entityId, pairId, cast pairPtr);
  public static function entityGetPair(entityId:EntityId, pairId:PairId):NativePtr<Dynamic> return cast FlecsNative.entityGetPair(entityId, pairId);

  public static function entityCreate(name:String):EntityId return FlecsNative.entityCreate(name);
  public static function entityDestroy(entityId:EntityId):Bool return FlecsNative.entityDestroy(entityId);

  public static function registerObserver(componentIds:Pointer<UInt32>, numComponents:Int, eventIds:Pointer<UInt32>, numEvents:Int, callback:ObserverCallbackNative, callbackId:Int):ObserverId {
    return cast FlecsNative.registerObserver(componentIds.raw, cast numComponents, eventIds.raw, cast numEvents, cast callback, cast callbackId);
  }

  public static function registerObserverEx(includeComponentIds:Pointer<UInt32>, numIncludeComponents:Int, excludeComponentIds:Pointer<UInt32>, numExcludeComponents:Int, eventIds:Pointer<UInt32>, numEvents:Int, callback:ObserverCallbackNative, callbackId:Int):ObserverId {
    return cast FlecsNative.registerObserverEx(includeComponentIds.raw, cast numIncludeComponents, excludeComponentIds.raw, cast numExcludeComponents, eventIds.raw, cast numEvents, cast callback, cast callbackId);
  }

  public static function unregisterObserver(observerId:ObserverId):Bool return FlecsNative.unregisterObserver(observerId);

  public static function registerSystem(name:String, componentIds:Pointer<UInt32>, numComponents:Int, callback:SystemCallbackNative, callbackId:Int):SystemId {
    return cast FlecsNative.registerSystem(name, componentIds.raw, cast numComponents, cast callback, cast callbackId);
  }

  public static function registerSystemEx(name:String, includeComponentIds:Pointer<UInt32>, numIncludeComponents:Int, excludeComponentIds:Pointer<UInt32>, numExcludeComponents:Int, callback:SystemCallbackNative, callbackId:Int):SystemId {
    return cast FlecsNative.registerSystemEx(name, includeComponentIds.raw, cast numIncludeComponents, excludeComponentIds.raw, cast numExcludeComponents, cast callback, cast callbackId);
  }

  public static function unregisterSystem(systemId:SystemId):Bool return FlecsNative.unregisterSystem(systemId);

  public static function init():Void FlecsNative.init();
  public static function progress(delta:Float):Void FlecsNative.progress(cast delta);
  public static function fini():Void FlecsNative.fini();
  public static function setThreads(threads:Int):Void FlecsNative.setThreads(threads);
  public static function version():String return cast FlecsNative.flecsVersion();
}
#end
