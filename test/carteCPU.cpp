#include <cmath>

#include "carteCPU.hpp"
#include "los/ppm.hpp"

using namespace std;


int DDA(int* data, float Cx, float Cy, float Px, float Py)
{
    float Dx, Dy, D;
    
    Dx = Px - Cx;
    Dy = Py - Cy;

    D = max(abs(Dx), abs(Dy));

    float incX = Dx / D;
    float incY = Dy / D;
    for (int i = 0; i < D - 1; i++)
    {
        Cx += incX;
        Cy += incY;
        data[i * 2] = (int)round(Cx);
        data[i * 2 + 1] = (int)round(Cy);
    } 
    return D;
}


void drawMap(int *data, Heightmap h_data, Heightmap h_out, float Cx, float Cy)
{
    for(int Py = 0; Py < h_data.getHeight(); Py++)
    {
        for(int Px = 0; Px < h_data.getWidth(); Px++)
        {
            int Dx, Dy, Dz;
            Dx = Px - Cx; 
            Dy = Py - Cy; 
            Dz = h_data.getPixel(Px, Py) - h_data.getPixel(Cx, Cy);
            double angle_ref = atan(Dz / sqrt((Dx * Dx) + (Dy * Dy)));
            double angle;
            int D = DDA(data, Cx, Cy, Px, Py);

            h_out.setPixel(Px, Py, 244);
            for (int i = 0; i < (D - 1); i++)
            {
                Dx = Px - data[i * 2];
                Dy = Py - data[i * 2 + 1];
                Dz = h_data.getPixel(Px, Py) - h_data.getPixel(data[i * 2], data[i * 2 + 1]);  
                angle = atan(Dz / sqrt((Dx * Dx) + (Dy * Dy)));

                if (angle_ref >= angle)
                {
                    h_out.setPixel(Px, Py, 0);
                    break;
                }  
            }        
        }
    }
    h_out.saveTo("img/Result/CPU/LimousinCPU.ppm");
}