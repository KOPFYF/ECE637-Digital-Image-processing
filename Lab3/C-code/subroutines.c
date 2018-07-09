# include "subroutines.h"

#define alloc1d(p, val, num) \
p = malloc(sizeof(int) * num); \
memset(p, val, sizeof(int) * num); \

void ConnectedNeighbors(struct pixel s,double T,
                        unsigned char **img,int width,
                        int height,int *M,struct pixel c[4]){
*M = 4;
if (s.m == 0) {
  c[0].m = -1;
  c[0].n = -1;
  *M = *M - 1;
} else {
  if (abs(img[s.m][s.n] - img[s.m-1][s.n])<=T){
  c[0].m = s.m - 1 ;
  c[0].n = s.n;
}else{
  c[0].m = -1;
  c[0].n = -1;
  *M = *M - 1;}
}

if (s.n == 0) {
  c[1].m = -1;
  c[1].n = -1;
  *M = *M - 1;
} else{
  if (abs(img[s.m][s.n] - img[s.m][s.n-1])<=T){
  c[1].m = s.m;
  c[1].n = s.n - 1;
}else{
  c[1].m = -1;
  c[1].n = -1;
  *M = *M - 1;}
}

if (s.m == height - 1){
  c[2].m = -1;
  c[2].n = -1;
  *M = *M - 1;

} else{
  if (abs(img[s.m][s.n] - img[s.m+1][s.n])<=T){
  c[2].m = s.m + 1 ;
  c[2].n = s.n;
} else{
  c[2].m = -1;
  c[2].n = -1;
  *M = *M - 1;}
}

if (s.n == width - 1){
  c[3].m = -1;
  c[3].n = -1;
  *M = *M - 1;
} else{
  if (abs(img[s.m][s.n] - img[s.m][s.n+1])<=T){
  c[3].m = s.m;
  c[3].n = s.n + 1;
}else{
  c[3].m = -1;
  c[3].n = -1;
  *M = *M - 1;}
}
}

/*   a->b = (*a).b   */
void push(node_t ** tail, struct pixel val) {
	node_t * temp = NULL;
	if (*tail == NULL) {
		printf("fail to push!");
	}
	(*tail)->next = malloc(sizeof(node_t)); // memory allocation
	temp = (*tail)->next;
	temp->val = val;
	temp->next = NULL;
	*tail = temp;
}

struct pixel pop(node_t ** head) {
    node_t * next_node = NULL;
    struct pixel retval={-1,-1};
    if (*head == NULL) {
        printf("fail to pop!");
        return retval;
    }

    next_node = (*head)->next;
    retval = (*head)->val;
    free(*head);
    *head = next_node;
    return retval;
}

void ConnectedSet(struct pixel s,double T,
                unsigned char **img,int width,int height,
                int ClassLabel,uint8_t **seg, uint8_t **checkvisit,
                int *NumConPixels, int *large_area_number){
struct pixel c[4];
int neighbor_num;
int i, j, coordheight, coordwidth, n;
int times = 1;
struct pixel retrieve;
int *checkmatrix;
/* use link list to store */
node_t * head = NULL;
node_t * tail = NULL;

n = width * height;
head = malloc(sizeof(node_t));
head->val = s;
head->next = NULL;
tail = head;

alloc1d(checkmatrix, -1, n);

*NumConPixels = 0;

j = 0;
while (head!= NULL || times ==1 ){
        times = 2;
        ConnectedNeighbors (head->val,T,img,width,height, &neighbor_num, c);
        for (i =0; i < 4; i++){
                if (c[i].m!=-1 && c[i].n!=-1){
                        if(checkvisit[c[i].m][c[i].n]!= ClassLabel){
							  checkvisit[c[i].m][c[i].n] = ClassLabel;
								checkmatrix[j] = c[i].m * width + c[i].n;
                                /*printf("push c(%d,%d)",c[i].m,c[i].n); */
                                push(&tail,c[i]);
                                *NumConPixels += 1;
								j = j + 1;
                        }
                }
        }
        retrieve = pop(&head);
        /*printf("POP(%d ,%d)\n", retrieve.m,retrieve.n );*/
}

 if(*NumConPixels > 100) {
	j = 0;
	*large_area_number += 1;
	printf("\n=======================================\n");
	printf("Group Num: %d \n", *large_area_number);
	while (checkmatrix[j] != -1) {
		coordwidth = checkmatrix[j] % width;
		coordheight = (checkmatrix[j] - coordwidth)/width;
		printf("(%d, %d) ", coordheight, coordwidth);
		seg[coordheight][coordwidth] = ClassLabel;
		j++;	
    }
	printf("\n=======================================\n");
} 
 free(checkmatrix);

}