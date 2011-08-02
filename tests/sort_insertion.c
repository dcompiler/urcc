int data[30];

void insertSort(int lb, int ub) {
    int t;
    int i, j;

    for (i = lb + 1; i <= ub; i++) {
        t = data[i];

        /* Shift elements down until */
        /* insertion point found.    */
        for (j = i-1; j >= lb && data[j]>t; j--)
            data[j+1] = data[j];

        /* insert */
        data[j+1] = t;
    }
}

void fill(int lb, int ub) {
    int i;
    srand(1);
    for (i = lb; i <= ub; i++) data[i] = rand()%1000;
}

int main(int argc, char *argv[]) {
    int maxnum, lb, ub, i;

    maxnum = 30;
    lb = 0; ub = maxnum - 1;

    fill(lb, ub);
    insertSort(lb, ub);

    printf("results:\n");
    for (i=lb; i<=ub; i++)
      printf("%d: %d\n",i,data[i]);

    return 0;
}
