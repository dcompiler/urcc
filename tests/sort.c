#include <stdio.h>

#define read(x) scanf("%d",&x)
#define write(x) printf("%d\n",x)
#define print(x) printf(x)

int array_1[16];
int array_2[16];
int array_3[16];
int array_4[16];

void populate_arrays(void)
{
    array_1[0] = 0; array_2[0] = 15; array_3[0] = 5; array_4[0] = 13;
    array_1[1] = 1; array_2[1] = 14; array_3[1] = 5; array_4[1] = 9;
    array_1[2] = 2; array_2[2] = 13; array_3[2] = 5; array_4[2] = 12;
    array_1[3] = 3; array_2[3] = 12; array_3[3] = 5; array_4[3] = 1;
    array_1[4] = 4; array_2[4] = 11; array_3[4] = 5; array_4[4] = 0;
    array_1[5] = 5; array_2[5] = 10; array_3[5] = 5; array_4[5] = 14;
    array_1[6] = 6; array_2[6] = 9; array_3[6] = 5; array_4[6] = 3;
    array_1[7] = 7; array_2[7] = 8; array_3[7] = 5; array_4[7] = 2;
    array_1[8] = 8; array_2[8] = 7; array_3[8] = 5; array_4[8] = 11;
    array_1[9] = 9; array_2[9] = 6; array_3[9] = 5; array_4[9] = 8;
    array_1[10] = 10; array_2[10] = 5; array_3[10] = 5; array_4[10] = 6;
    array_1[11] = 11; array_2[11] = 4; array_3[11] = 5; array_4[11] = 4;
    array_1[12] = 12; array_2[12] = 3; array_3[12] = 5; array_4[12] = 5;
    array_1[13] = 13; array_2[13] = 2; array_3[13] = 5; array_4[13] = 10;
    array_1[14] = 14; array_2[14] = 1; array_3[14] = 5; array_4[14] = 7;
    array_1[15] = 15; array_2[15] = 0; array_3[15] = 5; array_4[15] = 15;
}

void print_arrays(void)
{
    int idx, bound;
    bound = 16;
    print("Array_1:\n");
    idx = 0;
    while (idx < bound)
    {
	write(array_1[idx]);
	idx = idx + 1;
    }

    print("\nArray_2:\n");
    idx = 0;
    while (idx < bound)
    {
	write(array_2[idx]);
	idx = idx + 1;
    }

    print("\nArray_3:\n");
    idx = 0;
    while (idx < bound)
    {
	write(array_3[idx]);
	idx = idx + 1;
    }

    print("\nArray_4:\n");
    idx = 0;
    while (idx < bound)
    {
	write(array_4[idx]);
	idx = idx + 1;
    }
    print("\n");    
}

int main() 
{
    int idx, bound, temp;
    bound = 16;

    populate_arrays();
    print_arrays();

    bound = 16;

    idx = 0;
    while (idx < bound - 1)
    {
	if (array_1[idx] > array_1[idx + 1])
	{
	    temp = array_1[idx];
	    array_1[idx] = array_1[idx + 1];
	    array_1[idx + 1] = temp;
	    idx = 0;
	    continue;
	}
	
	idx = idx + 1;
    }

    idx = 0;
    while (idx < bound - 1)
    {
	if (array_2[idx] > array_2[idx + 1])
	{
	    temp = array_2[idx];
	    array_2[idx] = array_2[idx + 1];
	    array_2[idx + 1] = temp;
	    idx = 0;
	    continue;
	}
	
	idx = idx + 1;
    }


    idx = 0;
    while (idx < bound - 1)
    {
	if (array_3[idx] > array_3[idx + 1])
	{
	    temp = array_1[idx];
	    array_3[idx] = array_3[idx + 1];
	    array_3[idx + 1] = temp;
	    idx = 0;
	    continue;
	}
	
	idx = idx + 1;
    }

    idx = 0;
    while (idx < bound - 1)
    {
	if (array_4[idx] > array_4[idx + 1])
	{
	    temp = array_4[idx];
	    array_4[idx] = array_4[idx + 1];
	    array_4[idx + 1] = temp;
	    idx = 0;
	    continue;
	}
	
	idx = idx + 1;
    }

    print_arrays();
}

