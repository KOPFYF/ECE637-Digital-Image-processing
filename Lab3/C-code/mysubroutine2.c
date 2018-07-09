# include "mysubroutine2.h"

/*   connected pixels   */
/* c[0]:left, c[1]:up, c[2]:right, c[3]:down  */
void ConnectedNeighbors(struct pixel s,double T,
                        unsigned char **img,int width,
                        int height,int *M,struct pixel c[4]){
*M = 4;
if (s.m == 0) {
  c[0].m = -1;
  c[0].n = -1;
  (*M)--;
} else {
  if (abs(img[s.m][s.n] - img[s.m-1][s.n])<=T){
    c[0].m = s.m - 1 ;
    c[0].n = s.n;
  }else{
    c[0].m = -1;
    c[0].n = -1;
    (*M)--;}
  }

if (s.n == 0) {
  c[1].m = -1;
  c[1].n = -1;
  (*M)--;
} else{
  if (abs(img[s.m][s.n] - img[s.m][s.n-1])<=T){
    c[1].m = s.m;
    c[1].n = s.n - 1;
  }else{
    c[1].m = -1;
    c[1].n = -1;
    (*M)--;}
  }

if (s.m == height - 1){
  c[2].m = -1;
  c[2].n = -1;
  (*M)--;
} else{
  if (abs(img[s.m][s.n] - img[s.m+1][s.n])<=T){
    c[2].m = s.m + 1 ;
    c[2].n = s.n;
  } else{
    c[2].m = -1;
    c[2].n = -1;
    (*M)--;}
  }

if (s.n == width - 1){
  c[3].m = -1;
  c[3].n = -1;
  (*M)--;
} else{
  if (abs(img[s.m][s.n] - img[s.m][s.n+1])<=T){
    c[3].m = s.m;
    c[3].n = s.n + 1;
  }else{
    c[3].m = -1;
    c[3].n = -1;
    (*M)--;}
  }
}

/*   a->b = (*a).b   */
/* http://www.learn-c.org/en/Linked_lists */
/* Adding an item to the end of the list */

void push(node_t ** tail, struct pixel val) {
  node_t * temp = NULL;
  (*tail)->next = malloc(sizeof(node_t)); // memory allocation
  temp = (*tail)->next;
  temp->val = val;
  temp->next = NULL;
  *tail = temp;
}

/* Delete an item at the head of the list */
void pop(node_t ** head) {
  node_t * next_node = NULL;
  struct pixel retval;
  next_node = (*head)->next;
  retval = (*head)->val;
  free(*head);
  *head = next_node;
}

void ConnectedSet(struct pixel s,double T,
                unsigned char **img,int width,int height,
                int ClassLabel,uint8_t **seg, uint8_t **seg_original,
                int *NumConPixels, int *large_area_number){
struct pixel c[4];
int neighbor_num;
int i, j, x, y;
int loop = 1; // run for 1 time, set to 0 later
struct pixel retval;
int *expandedArray;
/* use linked list to store */
node_t * head = NULL;
node_t * tail = NULL;
head = malloc(sizeof(node_t));
head->val = s;
head->next = NULL;
tail = head;
expandedArray = malloc(sizeof(int) * width * height); 
memset(expandedArray, -1, sizeof(int) * width * height); // expandedArray initialization
// Sets the first n bytes of the block of memory pointed by ptr to the specified value 
*NumConPixels = 0;

j = 0;
while (head!= NULL || loop ==1 ){
  loop = 0;
  ConnectedNeighbors (head->val,T,img,width,height, &neighbor_num, c);
    for (i =0; i < 4; i++){
      if (c[i].m!=-1 && c[i].n!=-1){
        if(seg_original[c[i].m][c[i].n]!= ClassLabel){
          seg_original[c[i].m][c[i].n] = ClassLabel;
          expandedArray[j] = c[i].m * width + c[i].n; 
          // expand each satisfied set to one dimention, c[i].m leq height, c[i].n leq width
          /*printf("push c(%d,%d)",c[i].m,c[i].n); */
          push(&tail,c[i]);
          (*NumConPixels)++;
          j++;
        }
      }
    }
  // retval = pop(&head);
  pop(&head);
}

if(*NumConPixels > 100) {
  j = 0;
  (*large_area_number)++;
  printf("\n#########################\n");
  printf("Group Num: %d   #########\n", *large_area_number);
  printf("#########################\n");
  /* store the label for each pixel as a 2-D unsigned character array */
  while (expandedArray[j] != -1) {
    y = expandedArray[j] % width;
    x = (expandedArray[j] - y)/width;
    printf("(%d, %d) ", x, y);
    // seg[x][y] = ClassLabel;
    seg[x][y] = *large_area_number;
    j++;  
  }
} 
free(expandedArray);

}


