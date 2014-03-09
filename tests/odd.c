#include <stdio.h>

int main(int argc, char**argv) {
  int i, parity;
  char *answer;
  printf("input a number, e.g. 255\n");
  scanf("%d", &i);
  parity = i % 2;
  if (parity == 0) goto L1;
  answer = "odd";
  goto L2;
 L1:;
  answer = "even";
 L2:
  printf("%d is %s\n", i, answer);
  return 0;
}
