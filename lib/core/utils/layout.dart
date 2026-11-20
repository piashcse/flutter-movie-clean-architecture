/// Number of grid columns for the available [width].
int gridColumnsForWidth(double width) {
  if (width >= 1200) {
    return 6;
  }
  if (width >= 900) {
    return 5;
  }
  if (width >= 600) {
    return 4;
  }
  return 2;
}
