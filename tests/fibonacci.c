#include <stdio.h>

#define read(x) scanf("%d",&x)
#define write(x) printf("%d\n",x)
#define print(x) printf(x)

int array[32];

void initialize_array(void)
{
    int idx, bound;
    bound = 32;

    idx = 0;
    while (idx < bound)
    {
	array[idx] = -1;
	idx = idx + 1;
    }
}

int fib(int val)
{
    if (val < 2)
    {
	return 1;
    }
    if (array[val] == -1)
    {
	array[val] = fib(val - 1) + fib(val - 2);
    }

    return array[val];
}

int main(void)
{
    int idx, bound;
    bound = 32;

    initialize_array();
    
    idx = 0;

    print("The first few digits of the Fibonacci sequence are:\n");
    while (idx < bound)
    {
	write(fib(idx));
	idx = idx + 1;
    }
}
