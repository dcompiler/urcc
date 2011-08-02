#define read(x) scanf("%d",&x)
#define write(x) printf("%d\n",x)
#define print(x) printf(x)

int square(int x)
{
    return (x*x+500)/1000;
}

int complex_abs_squared(int real, int imag)
{
    return square(real)+square(imag);
}

int check_for_bail(int real, int imag)
{
    if (real > 4000 || imag > 4000)
    {
	return 0;
    }
    if (1600 > complex_abs_squared(real, imag))
    {
	return 0;
    }
    return 1;
}

int absval(int x)
{
    if (x < 0)
    {
	return -1 * x;
    }
    return x;
}

int checkpixel(int x, int y)
{
    int real, imag, temp, iter, bail;
    real = 0;
    imag = 0;
    iter = 0;
    bail = 16000;
    while (iter < 255)
    {
	temp = square(real) - square(imag) + x;
	imag = ((2 * real * imag + 500) / 1000) + y;
	real = temp;

	if (absval(real) + absval(imag) > 5000)
	{
	    return 0;
	}
	iter = iter + 1;
    }

    return 1;
}

int main() 
{
    int x, y, on;
    y = 950;

    while (y > -950)
    {
	x = -2100;
	while (x < 1000)
	{
	    on = checkpixel(x, y);
	    if (1 == on)
	    {
		print("X");
	    }
	    if (0 == on)
	    {
		print(" ");
	    }
	    x = x + 40;
	}
	print("\n");

	y = y - 50;
    }
}

