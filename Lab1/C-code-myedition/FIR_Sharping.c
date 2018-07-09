
#include <math.h>
#include "tiff.h"
#include "allocate.h"
#include "randlib.h"
#include "typeutil.h"

void error(char *name);

int main (int argc, char **argv) 
{
  FILE *fp;
  struct TIFF_img input_img, green_img, red_img, blue_img, color_img;
  double **img1,**img2,**img3,**img4,**img5,**img6;
  int32_t i,j,pixel,m,n;
  // double lamada = atof(argv[2]);
  // double lamada = atof('1.5');
  double lamada = 1.5;
  printf("lamada: %f", lamada);

  if ( argc != 2 ) error( argv[0] );

  /* open image file */
  if ( ( fp = fopen ( argv[1], "rb" ) ) == NULL ) {
    fprintf ( stderr, "cannot open file %s\n", argv[1] );
    exit ( 1 );
  }

  /* read image */
  if ( read_TIFF ( fp, &input_img ) ) {
    fprintf ( stderr, "error reading file %s\n", argv[1] );
    exit ( 1 );
  }

  /* close image file */
  fclose ( fp );

  /* check the type of image data */
  if ( input_img.TIFF_type != 'c' ) {
    fprintf ( stderr, "error:  image must be 24-bit color\n" );
    exit ( 1 );
  }

  /* Allocate image of double precision floats */
  img1 = (double **)get_img(input_img.width+4,input_img.height+4,sizeof(double));
  img2 = (double **)get_img(input_img.width+4,input_img.height+4,sizeof(double));
  img3 = (double **)get_img(input_img.width+4,input_img.height+4,sizeof(double));
  img4 = (double **)get_img(input_img.width+4,input_img.height+4,sizeof(double));
  img5 = (double **)get_img(input_img.width+4,input_img.height+4,sizeof(double));
  img6 = (double **)get_img(input_img.width+4,input_img.height+4,sizeof(double));

  // /* copy green component to double array */
  // for ( i = 0; i < input_img.height; i++ )
  // for ( j = 0; j < input_img.width; j++ ) {   

  // }


  for ( i = 0; i < input_img.height+4; i++ )
  for ( j = 0; j < input_img.width+4; j++ ) {
    img1[i][j] = 0;
    img3[i][j] = 0;
    img5[i][j] = 0;
    img2[i][j] = 0;
    img4[i][j] = 0;
    img6[i][j] = 0;
  }

  /* copy green component to double array */
  for ( i = 0; i < input_img.height; i++ )
  for ( j = 0; j < input_img.width; j++ ) {
    img1[i+2][j+2] = input_img.color[0][i][j];
    img3[i+2][j+2] = input_img.color[1][i][j];
    img5[i+2][j+2] = input_img.color[2][i][j];
  }


  /* Filter image along horizontal direction */
  for ( i = 0; i < input_img.height; i++ )
  for ( j = 0; j < input_img.width; j++ ) {   
    for ( m = -2; m <= 2; m++ )
    for ( n = -2; n <= 2; n++ ) {
        // img2[i+4][j+4] += 1/81*img1[i+4+m][j+4+n];
        img2[i+2][j+2] -= lamada*img1[i+2+m][j+2+n]/25;
        img4[i+2][j+2] -= lamada*img3[i+2+m][j+2+n]/25;
        img6[i+2][j+2] -= lamada*img5[i+2+m][j+2+n]/25;
    }
    img2[i+2][j+2] += img1[i+2][j+2]*(1+lamada);
    img4[i+2][j+2] += img3[i+2][j+2]*(1+lamada);
    img6[i+2][j+2] += img5[i+2][j+2]*(1+lamada);
  }

  /* set up structure for output achromatic image */
  /* to allocate a full color image use type 'c' */
  get_TIFF ( &green_img, input_img.height, input_img.width, 'g' );
  get_TIFF ( &red_img, input_img.height, input_img.width, 'g' );
  get_TIFF ( &blue_img, input_img.height, input_img.width, 'g' );
    
  /* set up structure for output color image */
  /* Note that the type is 'c' rather than 'g' */
  get_TIFF ( &color_img, input_img.height, input_img.width, 'c' );

  /* copy rgb component to new images */
  for ( i = 0; i < input_img.height; i++ )
  for ( j = 0; j < input_img.width; j++ ) {
    pixel = (int32_t)img2[i+2][j+2];
    if(pixel>255) {
      red_img.mono[i][j] = 255;
    }
    else {
      if(pixel<0) green_img.mono[i][j] = 0;
      else red_img.mono[i][j] = pixel;
    }

    pixel = (int32_t)img4[i+2][j+2];
    if(pixel>255) {
      green_img.mono[i][j] = 255;
    }
    else {
      if(pixel<0) green_img.mono[i][j] = 0;
      else green_img.mono[i][j] = pixel;
    }

    pixel = (int32_t)img6[i+2][j+2];
    if(pixel>255) {
      blue_img.mono[i][j] = 255;
    }
    else {
      if(pixel<0) blue_img.mono[i][j] = 0;
      else blue_img.mono[i][j] = pixel;
    }
    color_img.color[0][i][j] = red_img.mono[i][j];
    color_img.color[1][i][j] = green_img.mono[i][j];
    color_img.color[2][i][j] = blue_img.mono[i][j];
  }



  // /* Illustration: constructing a sample color image -- interchanging the red and green components from the input color image */
  // for ( i = 0; i < input_img.height; i++ )
  //     for ( j = 0; j < input_img.width; j++ ) {
  //         color_img.color[0][i][j] = input_img.color[1][i][j];
  //         color_img.color[1][i][j] = input_img.color[0][i][j];
  //         color_img.color[2][i][j] = input_img.color[2][i][j];
  //     }

  /* open green image file */
  if ( ( fp = fopen ( "green.tif", "wb" ) ) == NULL ) {
    fprintf ( stderr, "cannot open file green.tif\n");
    exit ( 1 );
  }

  /* write green image */
  if ( write_TIFF ( fp, &green_img ) ) {
    fprintf ( stderr, "error writing TIFF file %s\n", argv[2] );
    exit ( 1 );
  }

  /* close green image file */
  fclose ( fp );
    
    
  /* open color image file */
  if ( ( fp = fopen ( "color.tif", "wb" ) ) == NULL ) {
      fprintf ( stderr, "cannot open file color.tif\n");
      exit ( 1 );
  }
    
  /* write color image */
  if ( write_TIFF ( fp, &color_img ) ) {
      fprintf ( stderr, "error writing TIFF file %s\n", argv[2] );
      exit ( 1 );
  }
    
  /* close color image file */
  fclose ( fp );

  /* de-allocate space which was used for the images */
  free_TIFF ( &(input_img) );
  free_TIFF ( &(green_img) );
  free_TIFF ( &(red_img) );
  free_TIFF ( &(blue_img) );
  free_TIFF ( &(color_img) );
  
  free_img( (void**)img1 );
  free_img( (void**)img2 );  
  free_img( (void**)img3 );
  free_img( (void**)img4 );
  free_img( (void**)img5 );
  free_img( (void**)img6 ); 

  return(0);
}

void error(char *name)
{
    printf("usage:  %s  image.tiff \n\n",name);
    printf("this program reads in a 24-bit color TIFF image.\n");
    printf("It then horizontally filters the green component, adds noise,\n");
    printf("and writes out the result as an 8-bit image\n");
    printf("with the name 'green.tiff'.\n");
    printf("It also generates an 8-bit color image,\n");
    printf("that swaps red and green components from the input image");
    exit(1);
}

