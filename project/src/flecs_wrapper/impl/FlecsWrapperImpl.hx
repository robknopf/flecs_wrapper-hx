package flecs_wrapper.impl;

import flecs_wrapper.NativePtr;
import flecs_wrapper.FlecsWrapper.ComponentId;
import flecs_wrapper.FlecsWrapper.EntityId;
import flecs_wrapper.FlecsWrapper.EventId;
import flecs_wrapper.FlecsWrapper.ObserverId;
import flecs_wrapper.FlecsWrapper.PairId;
import flecs_wrapper.FlecsWrapper.SystemId;

class FlecsWrapperImpl {
  public static final EcsUnknownEvent:Int = 0;
  public static final EcsOnAdd:Int = 1;
  public static final EcsOnRemove:Int = 2;
  public static final EcsOnSet:Int = 3;
  public static final EcsOnDelete:Int = 4;
  public static final EcsOnDeleteTarget:Int = 5;
  public static final EcsOnTableCreate:Int = 6;
  public static final EcsOnTableDelete:Int = 7;

  public static function componentId(name:String):ComponentId return 0;
  public static function componentIsTag(componentId:ComponentId):Bool return false;
  public static function componentPrintRegistry():Void {}
  public static function componentCreate(name:String, size:Int):ComponentId return 0;
  public static function componentCreateTag(name:String):ComponentId return 0;
  public static function entityPrintComponents(entityId:EntityId):Void {}
  public static function entityHasComponent(entityId:EntityId, componentId:ComponentId):Bool return false;
  public static function entityHasComponentByName(entityId:EntityId, name:String):Bool return false;
  public static function entityAddComponent(entityId:EntityId, componentId:ComponentId):Bool return false;
  public static function entityAddComponentByName(entityId:EntityId, name:String):Bool return false;
  public static function entityRemoveComponent(entityId:EntityId, componentId:ComponentId):Bool return false;
  public static function entityRemoveComponentByName(entityId:EntityId, name:String):Bool return false;
  public static function entitySetComponent(entityId:EntityId, componentId:ComponentId, componentPtr:NativePtr<Dynamic>):Bool return false;
  public static function entityGetComponent(entityId:EntityId, componentId:ComponentId):NativePtr<Dynamic> return null;
  public static function entityMarkComponent(entityId:EntityId, componentId:ComponentId):Void {}
  public static function pairRegister(relationComponentId:ComponentId, objectEntityId:EntityId):PairId return 0;
  public static function pairRegisterEntity(relationEntityId:EntityId, objectEntityId:EntityId):PairId return 0;
  public static function pairRegisterByName(relationName:String, objectName:String):PairId return 0;
  public static function pairUnregister(pairId:PairId):Bool return false;
  public static function entityAddPair(entityId:EntityId, pairId:PairId):Bool return false;
  public static function entityRemovePair(entityId:EntityId, pairId:PairId):Bool return false;
  public static function entityHasPair(entityId:EntityId, pairId:PairId):Bool return false;
  public static function entitySetPair(entityId:EntityId, pairId:PairId, pairPtr:NativePtr<Dynamic>):Bool return false;
  public static function entityGetPair(entityId:EntityId, pairId:PairId):NativePtr<Dynamic> return null;
  public static function entityCreate(name:String):EntityId return 0;
  public static function entityDestroy(entityId:EntityId):Bool return false;
  public static function registerObserver(componentIds:Dynamic, numComponents:Int, eventIds:Dynamic, numEvents:Int, callback:Dynamic, callbackId:Int):ObserverId return 0;
  public static function registerObserverEx(includeComponentIds:Dynamic, numIncludeComponents:Int, excludeComponentIds:Dynamic, numExcludeComponents:Int, eventIds:Dynamic, numEvents:Int, callback:Dynamic, callbackId:Int):ObserverId return 0;
  public static function unregisterObserver(observerId:ObserverId):Bool return false;
  public static function registerSystem(name:String, componentIds:Dynamic, numComponents:Int, callback:Dynamic, callbackId:Int):SystemId return 0;
  public static function registerSystemEx(name:String, includeComponentIds:Dynamic, numIncludeComponents:Int, excludeComponentIds:Dynamic, numExcludeComponents:Int, callback:Dynamic, callbackId:Int):SystemId return 0;
  public static function unregisterSystem(systemId:SystemId):Bool return false;
  public static function init():Void {}
  public static function progress(delta:Float):Void {}
  public static function fini():Void {}
  public static function setThreads(threads:Int):Void {}
  public static function version():String return "";
}
