package flecs_wrapper;

import flecs_wrapper.FlecsWrapper;
import flecs_wrapper.FlecsWrapper.ComponentId;
import flecs_wrapper.FlecsWrapper.EntityId;
import flecs_wrapper.FlecsWrapper.PairId;
import flecs_wrapper.impl.EntityImpl;

class Entity {
  public var id:EntityId;

  public function new(id:EntityId) {
    this.id = id;
  }

  public static function create(name:String):Entity {
    var id = FlecsWrapper.entityCreate(name);
    if (id == 0) {
      throw 'entityCreate failed for ${name}';
    }
    return new Entity(id);
  }

  public static inline function wrap(id:EntityId):Entity {
    return new Entity(id);
  }

  public inline function destroy():Bool {
    return FlecsWrapper.entityDestroy(id);
  }

  public function add(comp:Dynamic):Bool {
    if (Std.isOfType(comp, Component)) {
      return FlecsWrapper.entityAddComponent(id, cast(comp, Component).id);
    }
    if (Std.isOfType(comp, String)) {
      return FlecsWrapper.entityAddComponentByName(id, cast comp);
    }
    return FlecsWrapper.entityAddComponent(id, cast comp);
  }

  public function remove(comp:Dynamic):Bool {
    if (Std.isOfType(comp, Component)) {
      return FlecsWrapper.entityRemoveComponent(id, cast(comp, Component).id);
    }
    if (Std.isOfType(comp, String)) {
      return FlecsWrapper.entityRemoveComponentByName(id, cast comp);
    }
    return FlecsWrapper.entityRemoveComponent(id, cast comp);
  }

  public function has(comp:Dynamic):Bool {
    if (Std.isOfType(comp, Component)) {
      return FlecsWrapper.entityHasComponent(id, cast(comp, Component).id);
    }
    if (Std.isOfType(comp, String)) {
      return FlecsWrapper.entityHasComponentByName(id, cast comp);
    }
    return FlecsWrapper.entityHasComponent(id, cast comp);
  }

  @:generic public inline function setValue<T>(comp:Component, value:T):Bool {
    return EntityImpl.setValue(id, comp, value);
  }

  @:generic public inline function rawSet<T>(comp:Component, value:NativePtr<T>):Bool {
    return EntityImpl.rawSet(id, comp, value);
  }

  @:generic public inline function rawGet<T>(comp:Component):NativePtr<T> {
    return cast EntityImpl.rawGet(id, comp);
  }

  @:generic public inline function get<T>(comp:Component):T {
    return cast EntityImpl.get(id, comp);
  }

  @:generic public inline function tryGet<T>(comp:Component):NativePtr<T> {
    return cast EntityImpl.tryGet(id, comp);
  }

  public function mark(comp:Dynamic):Void {
    if (Std.isOfType(comp, Component)) {
      FlecsWrapper.entityMarkComponent(id, cast(comp, Component).id);
      return;
    }
    if (Std.isOfType(comp, String)) {
      var compId:ComponentId = FlecsWrapper.componentId(cast comp);
      if (compId == 0) {
        throw 'Unknown component name: ${comp}';
      }
      FlecsWrapper.entityMarkComponent(id, compId);
      return;
    }
    FlecsWrapper.entityMarkComponent(id, cast comp);
  }

  private function resolvePairId(relation:Dynamic, object:Dynamic):PairId {
    return EntityImpl.resolvePairId(relation, object);
  }

  public function addPair(relation:Dynamic, object:Dynamic):Bool {
    var pairId = resolvePairId(relation, object);
    return FlecsWrapper.entityAddPair(id, pairId);
  }

  public function removePair(relation:Dynamic, object:Dynamic):Bool {
    var pairId = resolvePairId(relation, object);
    return FlecsWrapper.entityRemovePair(id, pairId);
  }

  public function hasPair(relation:Dynamic, object:Dynamic):Bool {
    var pairId = resolvePairId(relation, object);
    return FlecsWrapper.entityHasPair(id, pairId);
  }

  public inline function rawSetPair(relation:Dynamic, object:Dynamic, value:NativePtr<Dynamic>):Bool {
    return EntityImpl.rawSetPair(id, relation, object, value);
  }

  public inline function rawGetPair(relation:Dynamic, object:Dynamic):NativePtr<Dynamic> {
    return EntityImpl.rawGetPair(id, relation, object);
  }

  @:generic public inline function rawGetPairTyped<T>(relation:Dynamic, object:Dynamic):NativePtr<T> {
    return cast EntityImpl.rawGetPairTyped(id, relation, object);
  }

  @:overload(function(selfExpr:haxe.macro.Expr, compExpr:haxe.macro.Expr, valueExpr:haxe.macro.Expr):haxe.macro.Expr {})
  public macro function set(
    selfExpr:haxe.macro.Expr,
    compExpr:haxe.macro.Expr,
    valueExpr:haxe.macro.Expr,
    ?notifyExpr:haxe.macro.Expr
  ):haxe.macro.Expr {
    return EntityMacros.buildSet(selfExpr, compExpr, valueExpr, notifyExpr);
  }
}
