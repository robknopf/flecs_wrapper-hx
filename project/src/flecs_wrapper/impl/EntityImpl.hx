package flecs_wrapper.impl;

import flecs_wrapper.Component;
import flecs_wrapper.FlecsWrapper.EntityId;
import flecs_wrapper.FlecsWrapper.PairId;

class EntityImpl {
  public static function resolvePairId(relation:Dynamic, object:Dynamic):PairId return 0;
  public static function setValue<T>(id:EntityId, comp:Component, value:T):Bool return false;
  public static function rawSet<T>(id:EntityId, comp:Component, value:Dynamic):Bool return false;
  public static function rawGet(id:EntityId, comp:Component):Dynamic return null;
  public static function get(id:EntityId, comp:Component):Dynamic return null;
  public static function tryGet(id:EntityId, comp:Component):Dynamic return null;
  public static function rawSetPair(id:EntityId, relation:Dynamic, object:Dynamic, value:Dynamic):Bool return false;
  public static function rawGetPair(id:EntityId, relation:Dynamic, object:Dynamic):Dynamic return null;
  public static function rawGetPairTyped(id:EntityId, relation:Dynamic, object:Dynamic):Dynamic return null;
}
