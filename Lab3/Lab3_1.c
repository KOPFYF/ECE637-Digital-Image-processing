#include <math.h>
#include <stdio.h>
#include <stdlib.h>

struct pixel {
       int m,n;        /* m=row, n=col */
}
     
void ConnectedNeighbors(
	struct pixel s,
  double T,
  unsigned char **img,
  int width,
  int height,
  int *M,
  struct pixel c[4])；

void ConnectedSet(
  struct pixel s,
  double T,
  unsigned char **img,
  int width,
  int height,
  int ClassLabel,
  unsigned int **seg,
  int *NumConPixels)；

int main (int argc, char **argv)
{
	// img = (double **)get_img(input_img.width+4,input_img.height+4,sizeof(double));
	double T = 1
	struct pixel s;
	s.m = 67;
	s.n = 45;

	return(0);
}


void ConnectedNeighbors(
	struct pixel s,
    double T,
    unsigned char **img,
    int width,
    int height,
    int *M,
    struct pixel c[4]){

	int Xr,Xs,k;
	Xr = (int32_t)img[s.m][s.n];
	for ( i = -1; i < 1; i++ )
    for ( j = -1; j < 1; j++ ) {
    	Xs = (int32_t)img[s.m+i][s.n+j];
    	c[i+j+2] = (int32_t)img[s.m+i][s.n+j];
		if (abs(Xs-Xr)<=T){
			k += 1;
		} 
		M = & k;
	}
}

void ConnectedSet(
  struct pixel s,
  double T,
  unsigned char **img,
  int width,
  int height,
  int ClassLabel,
  unsigned int **seg,
  int *NumConPixels){

  	// int Y = 0;
  	// int ClassLabel = 1;
  B = s0;
  int i = 0;
  int ClassLabel = 1;
  while (B){
  	s = B[i];
  	? B ← B − {s} pointer;
  	Y
  	seg[i][j] = ClassLabel;

  }



}