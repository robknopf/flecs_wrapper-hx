package flecs_wrapper.impl;

import flecs_wrapper.Component;
import flecs_wrapper.FlecsWrapper.ComponentId;
import flecs_wrapper.FlecsWrapper.SystemId;
import flecs_wrapper.System.SystemIter;
import flecs_wrapper.System.SystemIterCallback;

class SystemImpl {
  public static function removeSystem(id:SystemId):Void {}
  public static function unregisterSystem(id:SystemId):Bool return false;
  public static function addSystem(name:String, components:Array<Component>, callback:SystemIterCallback):SystemId return 0;
  public static function addSystemIds(name:String, componentIds:Array<ComponentId>, callback:SystemIterCallback):SystemId return 0;
  public static function addSystemNames(name:String, componentNames:Array<String>, callback:SystemIterCallback):SystemId return 0;
  public static function addTask(name:String, callback:SystemIterCallback):SystemId return 0;
  public static function addSystemEx(name:String, includeComponents:Array<Component>, excludeComponents:Array<Component>, callback:SystemIterCallback):SystemId return 0;
  public static function addSystemExIds(name:String, includeIds:Array<ComponentId>, excludeIds:Array<ComponentId>, callback:SystemIterCallback):SystemId return 0;
  public static function addSystemExNames(name:String, includeNames:Array<String>, excludeNames:Array<String>, callback:SystemIterCallback):SystemId return 0;
  public static function rawColumnPtr(it:SystemIter, compId:ComponentId):Dynamic return null;
  public static function rawColumn(it:SystemIter, compId:ComponentId, i:Int):Dynamic return null;
  public static function tryColumn(it:SystemIter, comp:Component, i:Int):Dynamic return null;
  public static function column(it:SystemIter, comp:Component, i:Int):Dynamic return null;
  public static function each1<A>(it:SystemIter, a:Component, cb:(a:A)->Void):Void {}
  public static function each2<A, B>(it:SystemIter, a:Component, b:Component, cb:(a:A, b:B)->Void):Void {}
  public static function each3<A, B, C>(it:SystemIter, a:Component, b:Component, c:Component, cb:(a:A, b:B, c:C)->Void):Void {}
}
