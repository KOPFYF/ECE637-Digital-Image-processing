#ifndef _MYSUBROUTINE_H_
#define _MYSUBROUTINE_H_

#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include "tiff.h"
#include "allocate.h"
#include "randlib.h"
#include "typeutil.h"
#include "mysubroutine.h"


struct pixel{
  int m,n;  /* m = row, n = col */
};

typedef struct node {
    struct pixel val;
    struct node * next;
} node_t;


void ConnectedNeighbors(struct pixel s,double T,
                        unsigned char **img,int width,
                        int height,int *M,struct pixel c[4]);

void ConnectedSet(struct pixel s,double T,
                unsigned char **img,int width,int height,
                int ClassLabel, uint8_t **seg,
                int *NumConPixels);
#endif