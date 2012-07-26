module system.architecture;

import system.cpu;
import system.endian;

final class Architecture {
private:

public:
  static Cpu[] cpus() {
    return [new Cpu(Endian.Little)];
  }

  static Cpu currentCpu() {
    return new Cpu(Endian.Little);
  }
}
