package tests;

import flecs_wrapper.Flecs;

class TestCommon {
  public static function withFlecs(fn:Void->Void):Void {
    Flecs.init();
    Flecs.setThreads(1);
    var err:Dynamic = null;
    try {
      fn();
    } catch (e:Dynamic) {
      err = e;
    }
    Flecs.fini();
    if (err != null) {
      throw err;
    }
  }
}
