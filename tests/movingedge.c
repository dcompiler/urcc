#include <stdio.h>
#include <stdlib.h>

int nbr_5[5];
int magic = 35;
int V[100];

void init_nbr(){
  nbr_5[0] = -3;
  nbr_5[1] = 12;
  nbr_5[2] = 17;
  nbr_5[3] = 12;
  nbr_5[4] = -3;
}

int getinput(void)
{
    int a;
    a = -1;
    while (0 > a)
    {
	scanf("%d",&a);
	if (0 > a || a >100)
	{
	    printf("I need a non-negative number less than 100: ");
	    a = -1;
	}
    }

    return a;
}  

void moving(int size){
  int i,j;
  for (i=2; i<size-2;i++){
    int temp=0;
    for (j=-2;j<3;j++){
      temp += V[i+j]*nbr_5[j+2];
     }
    V[i] = temp / magic;
  }
}

int main(){
  int size;
  int i;

  printf("Please input the size of the vector to be transformed: ");
  size = getinput();

  for (i=0; i<size;i++){
    V[i] = rand()%100;
  }

  printf("Original vector:\n");
  for (i= 0; i<size; i++)
    printf("%d\n", V[i]);
  printf("\n");

  init_nbr();

  moving(size);
  printf("Moving edge vector:\n");
  for (i= 0; i<size; i++)
    printf("%d\n", V[i]);
  printf("\n");

}
