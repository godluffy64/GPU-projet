#ifndef __CARTE_CPU__
#define __CARTE_CPU__

#include "los/ppm.hpp"

using namespace los;

int DDA( int *tabDda, float Cx, float Cy, float Px, float Py);
void drawMap(int *data, Heightmap h_data, Heightmap h_out, float Cx, float Cy);

#endif //__CARTE_CPU__