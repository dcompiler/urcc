
#define Size 12
#define a(i,j) a[i+j*Size]
#define b(i,j) b[i+j*Size]

int a[Size*Size], b[Size*Size];

int main() {
  int i,j;

  for (i =0; i<Size; i++)
    for (j =0; j<Size; j++) {
      a(j, i) = 12.0+i+j;
      b(j, i) = 12.0+i+j;
    }

  for (i =0; i<Size-1; i++)
    for (j =0; j<Size-1; j++) {
      a(i, j) = 0.25 * (b(i - 1, j) + b(i + 1, j) + b(i, j - 1) + b(i, j + 1));
    }

  for (i =0; i<Size-1; i++)
    for (j =0; j<Size-1; j++) {
      b(i, j) = a(i, j);
    }

  printf("The sampled element is %d\n", b(Size/2,Size/2));
  return 0;
}
