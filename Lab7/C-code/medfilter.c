/* gcc -o medfilter medfilter.c allocate.c randlib.c solve.c tiff.c */
/* ./medfilter img14gn.tif gn.tif */
/* ./medfilter img14sp.tif sp.tif */

#include <math.h>
#include "tiff.h"
#include "allocate.h"
#include "randlib.h"
#include "typeutil.h"
#include "medfilter.h"

int main (int argc, char **argv) 
{
  FILE *fp;
  struct TIFF_img input_img;
  unsigned int **filtered_img;
  int32_t i,j,pixel;

  if ( argc != 3 ) error( argv[0] );

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

  /* check the type of image output */
  if ( input_img.TIFF_type != 'g' ) {
    fprintf ( stderr, "error:  image must be grayscale\n" );
    exit ( 1 );
  }


  // call function median filter
  filtered_img = filter(input_img);

  /* copy green component to double array */
  for ( i = 0; i < input_img.height; i++ )
  for ( j = 0; j < input_img.width; j++ ) {
    input_img.mono[i][j] = filtered_img[i][j];
  }

  /* Free segment map */
  free_img((void *)filtered_img);
    
  /* open image file */
  if ( ( fp = fopen ( argv[2], "wb" ) ) == NULL ) {
      fprintf ( stderr, "cannot open file %s\n", argv[2]);
      exit ( 1 );
  }
    
  /* write color image */
  if ( write_TIFF ( fp, &input_img ) ) {
      fprintf ( stderr, "error writing TIFF file %s\n", argv[2]);
      exit ( 1 );
  }
    
  /* close color image file */
  fclose ( fp );

  /* de-allocate space which was used for the images */
  free_TIFF ( &(input_img) );

  return(0);
}


unsigned int filter_med(struct TIFF_img input, int i, int j) {
  int m, n, k = 0;
  unsigned int sum1, sum2;
  unsigned int temp1, temp2;
  unsigned int output[25];
  unsigned int weights[25] = {1, 1, 1, 1, 1,
                1, 2, 2, 2, 1,
                1, 2, 2, 2, 1,
                1, 2, 2, 2, 1,
                1, 1, 1, 1, 1};

  for (m = i - 2; m < i + 3; m++) {
    for (n = j - 2; n < j + 3; n++) {
      output[k] = input.mono[m][n];
      k++;
    }
  }

  // sorting the pixels in the window in descending order
  for (m = 0; m < 25; m++) {
    for (n = m + 1; n < 25; n++) {
      if (output[m] < output[n]) {
        temp1 = output[m];
        output[m] = output[n];
        output[n] = temp1;

        // corresponding pixel weights are placed 
        // in the same order as the sorted pixels
        temp2 = weights[m];
        weights[m] = weights[n];
        weights[n] = temp2;
      }
    }
  }

  sum1 = weights[0];
  sum2 = 34 - sum1;
  for (m = 0; m < 25; m++) {
    if (sum1 > sum2) {
      return output[m];
    }

    sum1 += weights[m+1];
    sum2 -= weights[m+1];
  }

  return output[m];
}


unsigned int** filter(struct TIFF_img input) {
  int i, j;
  unsigned int** filtered = (unsigned int**) get_img(input.width,input.height,sizeof(unsigned int));

  for (i = 2; i < input.height - 2; i++) {
    for (j = 2; j < input.width - 2; j++) {
      filtered[i][j] = filter_med(input, i, j);
    }
  }

  return filtered;
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

