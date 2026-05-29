package tests;

import cpp.Float32;
import cpp.Pointer;
import utest.Assert;
import utest.Test;
import flecs_wrapper.Component;
import flecs_wrapper.Entity;
import flecs_wrapper.Flecs;

@:component("SmokePosition")
class SmokePosition {
  public var x:Float32;
  public var y:Float32;

  public function new(x:Float32 = 0, y:Float32 = 0) {
    this.x = x;
    this.y = y;
  }
}

class SmokeTest extends Test {
  function testEntityTagLifecycle():Void {
    TestCommon.withFlecs(function() {
      var tag = Component.createTag("SmokeTag");
      var entity = Entity.create("SmokeEntity");

      Assert.isFalse(entity.has(tag));
      Assert.isTrue(entity.add(tag));
      Assert.isTrue(entity.has(tag));
      Assert.isTrue(entity.remove(tag));
      Assert.isFalse(entity.has(tag));
      Assert.isTrue(entity.destroy());
    });
  }

  function testComponentRoundTrip():Void {
    TestCommon.withFlecs(function() {
      var entity = Entity.create("SmokeVecEntity");
      var position = Component.of(SmokePosition);

      Assert.isFalse(entity.has(position));
      Assert.isTrue(entity.set(position, new SmokePosition(3, 4)));
      Assert.isTrue(entity.has(position));

      var value:Pointer<SmokePosition> = entity.rawGet(position);
      Assert.notNull(value);
      Assert.equals(3, value.ref.x);
      Assert.equals(4, value.ref.y);
      Assert.equals(position.id, Flecs.componentId("SmokePosition"));
      Assert.isTrue(entity.destroy());
    });
  }
}
