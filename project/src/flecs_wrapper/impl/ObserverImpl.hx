package flecs_wrapper.impl;

import flecs_wrapper.Component;
import flecs_wrapper.FlecsWrapper.ComponentId;
import flecs_wrapper.FlecsWrapper.EventId;
import flecs_wrapper.FlecsWrapper.ObserverId;
import flecs_wrapper.Observer.ObserverIter;
import flecs_wrapper.Observer.ObserverIterCallback;

class ObserverImpl {
  public static function removeObserver(id:ObserverId):Void {}
  public static function unregisterObserver(id:ObserverId):Bool return false;
  public static function addObserver(components:Array<Component>, events:Array<EventId>, callback:ObserverIterCallback):ObserverId return 0;
  public static function addObserverIds(componentIds:Array<ComponentId>, events:Array<EventId>, callback:ObserverIterCallback):ObserverId return 0;
  public static function addObserverIdsPublic(componentIds:Array<ComponentId>, events:Array<EventId>, callback:ObserverIterCallback):ObserverId return 0;
  public static function addObserverNames(componentNames:Array<String>, events:Array<EventId>, callback:ObserverIterCallback):ObserverId return 0;
  public static function addObserverEx(includeComponents:Array<Component>, excludeComponents:Array<Component>, events:Array<EventId>, callback:ObserverIterCallback):ObserverId return 0;
  public static function addObserverExIds(includeIds:Array<ComponentId>, excludeIds:Array<ComponentId>, events:Array<EventId>, callback:ObserverIterCallback):ObserverId return 0;
  public static function addObserverExIdsPublic(includeIds:Array<ComponentId>, excludeIds:Array<ComponentId>, events:Array<EventId>, callback:ObserverIterCallback):ObserverId return 0;
  public static function addObserverExNames(includeNames:Array<String>, excludeNames:Array<String>, events:Array<EventId>, callback:ObserverIterCallback):ObserverId return 0;
  public static function rawColumnPtr(it:ObserverIter, compId:ComponentId):Dynamic return null;
  public static function rawColumn(it:ObserverIter, compId:ComponentId, i:Int):Dynamic return null;
  public static function tryColumn(it:ObserverIter, comp:Component, i:Int):Dynamic return null;
  public static function column(it:ObserverIter, comp:Component, i:Int):Dynamic return null;
}
