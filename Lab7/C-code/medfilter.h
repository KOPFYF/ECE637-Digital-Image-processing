#ifndef __MEDFILTER_H_
#define __MEDFILTER_H_

void error(char *name);
unsigned int filter_med(struct TIFF_img in, int i, int j);
unsigned int** filter(struct TIFF_img in);

#endif