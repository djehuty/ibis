module math.abs;

double abs(double x) {
  ulong intRepresentation = *cast(ulong*)&x;
  intRepresentation &= 0x7fff_ffff_ffff_ffff;
  return *cast(double*)&intRepresentation;
}
