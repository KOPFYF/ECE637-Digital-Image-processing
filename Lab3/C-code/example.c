#include <math.h>
#include "tiff.h"
#include "allocate.h"
#include "randlib.h"
#include "typeutil.h"
#include "subroutines.h"

void error(char *name);

int main (int argc, char **argv)
{
  FILE *fp;
  struct TIFF_img input_img, seg_img, checkvisit;
  struct pixel single_pixel;
  struct pixel c[4];
  double T;
  int connect_num;
  int ClassLabel = 0;
  int neighbor_num, large_conn_num = 0;
  int32_t i,j;

  if ( argc != 3 ) error( argv[0] );
/* input lamda*/
  T = atof(argv[2]);
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

  if ( input_img.TIFF_type != 'g' ) {
    fprintf ( stderr, "error:  image must be monochrome\n" );
    exit ( 1 );
  }


  /* set up structure for output achromatic image */
  /* to allocate a full color image use type 'c' */
  get_TIFF ( &seg_img, input_img.height, input_img.width, 'g' );
  get_TIFF( &checkvisit, input_img.height, input_img.width, 'g');

  for(i = 0; i<input_img.height; i++)
  for(j = 0; j<input_img.width; j++){
    seg_img.mono[i][j] = 255;
  checkvisit.mono[i][j] = 255;
  }

  printf("Threshold T is: %d\n", T);
/* code for prob1*/
  /*(col,row)*/
  /*
  single_pixel.n = 67;  
  single_pixel.m = 45;  
  ConnectedSet(single_pixel, T, input_img.mono, input_img.width, input_img.height,
    ClassLabel, seg_img.mono, checkvisit.mono, &connect_num, &large_conn_num);
  printf("Connected number = %d ", connect_num);  
 */
/* code for prob2*/

for (i = 0; i<input_img.height; i++) 
  for (j = 0; j<input_img.width; j++) {
    single_pixel.m = i;
    single_pixel.n = j;
    if (checkvisit.mono[i][j] != ClassLabel) {
      ConnectedSet(single_pixel, T, input_img.mono, input_img.width, input_img.height,
        ClassLabel, seg_img.mono, checkvisit.mono, &connect_num, &large_conn_num);
    }
  }
 printf("large connected sets number = %d ", large_conn_num);
 
  /* open image file */
  if ( ( fp = fopen ( "segmentation.tif", "wb" ) ) == NULL ) {
    fprintf ( stderr, "cannot open file seg_img.tif\n");
    exit ( 1 );
  }

  /* write image */
  if ( write_TIFF ( fp, &seg_img) ) {
    fprintf ( stderr, "error writing TIFF file %s\n", argv[2] );
    exit ( 1 );
  }

  /* close image file */
  fclose ( fp );

  if ((fp = fopen("seg_img_without_filter.tif", "wb")) == NULL) {
    fprintf(stderr, "cannot open file cmpare_img.tif\n");
    exit(1);
  }

  /* write image */
  if (write_TIFF(fp, &checkvisit)) {
    fprintf(stderr, "error writing TIFF file %s\n", argv[2]);
    exit(1);
  }

  /* close image file */
  fclose(fp);



  /* de-allocate space which was used for the images */
  free_TIFF ( &(input_img) );
  free_TIFF ( &(seg_img) );
  free_TIFF(&(checkvisit));

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