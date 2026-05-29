package flecs_wrapper.impl;

#if cpp
import cpp.Pointer;
import flecs_wrapper.Component;
import flecs_wrapper.Entity;
import flecs_wrapper.impl.FlecsWrapperImpl;
import flecs_wrapper.FlecsWrapper.EntityId;
import flecs_wrapper.FlecsWrapper.PairId;

class EntityImpl {
  public static function resolvePairId(relation:Dynamic, object:Dynamic):PairId {
    if (Std.isOfType(relation, Component)) {
      var relComp:Component = cast relation;
      if (Std.isOfType(object, Entity)) {
        return FlecsWrapperImpl.pairRegister(relComp.id, cast(object, Entity).id);
      }
      return FlecsWrapperImpl.pairRegister(relComp.id, cast object);
    }
    if (Std.isOfType(relation, Entity)) {
      var relEnt:Entity = cast relation;
      if (Std.isOfType(object, Entity)) {
        return FlecsWrapperImpl.pairRegisterEntity(relEnt.id, cast(object, Entity).id);
      }
      return FlecsWrapperImpl.pairRegisterEntity(relEnt.id, cast object);
    }
    if (Std.isOfType(relation, String) && Std.isOfType(object, String)) {
      return FlecsWrapperImpl.pairRegisterByName(cast relation, cast object);
    }
    throw 'Unsupported pair relation/object types';
  }

  @:generic public static function setValue<T>(id:EntityId, comp:Component, value:T):Bool {
    var tmp:T = value;
    var dataPtr:Pointer<cpp.Void> = untyped __cpp__("::cpp::Pointer<void>((void*)&{0})", tmp);
    return FlecsWrapperImpl.entitySetComponent(id, comp.id, dataPtr);
  }

  public static function rawSet(id:EntityId, comp:Component, value:Dynamic):Bool {
    return FlecsWrapperImpl.entitySetComponent(id, comp.id, cast value);
  }

  public static function rawGet(id:EntityId, comp:Component):Dynamic {
    return cast FlecsWrapperImpl.entityGetComponent(id, comp.id);
  }

  public static function get(id:EntityId, comp:Component):Dynamic {
    var ptr:Pointer<Dynamic> = cast FlecsWrapperImpl.entityGetComponent(id, comp.id);
    if (ptr == null) {
      throw 'Component not found for entity ${id} and component ${comp.id}';
    }
    return ptr.ref;
  }

  public static function tryGet(id:EntityId, comp:Component):Dynamic {
    return cast FlecsWrapperImpl.entityGetComponent(id, comp.id);
  }

  public static function rawSetPair(id:EntityId, relation:Dynamic, object:Dynamic, value:Dynamic):Bool {
    var pairId = resolvePairId(relation, object);
    return FlecsWrapperImpl.entitySetPair(id, pairId, cast value);
  }

  public static function rawGetPair(id:EntityId, relation:Dynamic, object:Dynamic):Dynamic {
    var pairId = resolvePairId(relation, object);
    return FlecsWrapperImpl.entityGetPair(id, pairId);
  }

  public static function rawGetPairTyped(id:EntityId, relation:Dynamic, object:Dynamic):Dynamic {
    return cast rawGetPair(id, relation, object);
  }
}
#end
