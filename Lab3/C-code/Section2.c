// gcc -o Section2 Section2.c allocate.c randlib.c solve.c tiff.c mysubroutine2.c -g
// ./Section2 img22gd2.tif 2

#include <math.h>
#include "tiff.h"
#include "allocate.h"
#include "randlib.h"
#include "typeutil.h"
#include "mysubroutine2.h"

void error(char *name);

int main (int argc, char **argv)
{
  FILE *fp;
  struct TIFF_img input_img, seg_img, seg_original;
  struct pixel s;
  struct pixel c[4];
  double T;
  int ClassLabel = 255;
  int connect_num, neighbor_num, large_connect_num = 0;
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

  /* to allocate a image use type 'g' */
  get_TIFF ( &seg_img, input_img.height, input_img.width, 'g' );
  get_TIFF( &seg_original, input_img.height, input_img.width, 'g');

  /* Initialization of seg */
  for(i = 0; i<input_img.height; i++)
    for(j = 0; j<input_img.width; j++){
      seg_img.mono[i][j] = 0;
      seg_original.mono[i][j] = 0;
    }

    printf("T: %f\n", T);

  /* Get large connected sets number  */
    for (i = 0; i<input_img.height; i++) 
      for (j = 0; j<input_img.width; j++) {
        s.m = i;
        s.n = j;
        if (seg_original.mono[i][j] != ClassLabel) {
          ConnectedSet(s, T, input_img.mono, input_img.width, input_img.height,
            ClassLabel, seg_img.mono, seg_original.mono, &connect_num, &large_connect_num);
        }
      }
      printf("\n large connected sets number = %d \n", large_connect_num);

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

  /* open image file */ 
      if ((fp = fopen("seg_img_without_filter.tif", "wb")) == NULL) {
        fprintf(stderr, "cannot open file compare_img.tif\n");
        exit(1);
      }

  /* write image */
      if (write_TIFF(fp, &seg_original)) {
        fprintf(stderr, "error writing TIFF file %s\n", argv[2]);
        exit(1);
      }

  /* close image file */
      fclose(fp);

  /* de-allocate space which was used for the images */
      free_TIFF ( &(input_img) );
      free_TIFF ( &(seg_img) );
      free_TIFF(&(seg_original));

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