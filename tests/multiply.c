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

int main(){
  int A[100];
  int B[100];

  int size, i,j;
  int result;

  printf("Please give the size of the vectors to be multiplied: ");
  size = getinput();

  A[0] = 0;
  for (i = 1; i<size; i++)
    A[i] = A[i-1] + i*i;
  
  B[0] = 0;
  for (i = 1; i<size; i++)
    B[i] = i + B[i-1];

  result = 0;
  for (i = 0; i< size; i++)
    result += A[i] * B[i];

  printf("0\n");
}
