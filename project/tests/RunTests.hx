package tests;

import utest.Runner;
import utest.ui.Report;

class RunTests {
  static function main() {
    var runner = new Runner();
    runner.addCase(new SmokeTest());
    Report.create(runner);
    runner.run();
  }
}
