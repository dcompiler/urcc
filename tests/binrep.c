#define read(x) scanf("%d",&x)
#define write(x) printf("%d\n",x)
#define print(x) printf(x)

void recursedigit(int n) {
    int on;
    if (0 == n) {
	return;
    }
    on = 0;
    if (0 != (n-((n/2)*2))) {
        on = 1;
    }
    recursedigit(n/2);
    if (0 == on) {
	print("0");
    }
    if (1 == on) {
	print("1");
    }
}

int main() {
    int a;
    a = 0;
    while (0 >= a) {
	print("Give me a number: ");
	read(a);
	
	if (0 >= a) {
	    print("I need a positive integer.\n");
	}
    }
    print("The binary representation of: ");
    write(a);
    print("is: ");
    recursedigit(a);
    print("\n\n");
}


