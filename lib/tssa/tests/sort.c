#define TASK_BEGIN task_begin()
#define TASK_END task_end()

#define ROW 100
#define COL 10000

int adata[ROW][COL];

void insertSort(int idx, int lb, int ub) {
    int t;
    int i, j;

    for (i = lb + 1; i <= ub; i++) {
        t = adata[idx][i];

        for (j = i-1; j >= lb && adata[idx][j]>t; j--)
            adata[idx][j+1] = adata[idx][j];

        adata[idx][j+1] = t;
    }
}

void fill(int idx, int lb, int ub) {
    int i;
    for (i = lb; i <= ub; i++) {
        adata[idx][i] = rand()%1000;
    }
}

void fill_and_sort(int idx)
{
    int j;
    int maxnum, lb, ub, i;
    maxnum = COL;
    lb = 0; ub = maxnum - 1;

    fill(idx, lb, ub);
    insertSort(idx, lb, ub);
}


int verify(int idx) {
    int i;
    for (i = 1; i < COL; i++) {
        if (adata[idx][i]<adata[idx][i-1])
            return 1;
    }
    return 0;
}

int main()
{
    int failed;
    int row;
    srand(1);

    failed = 0;
    row = 0;
    
    while (row < ROW) {
        TASK_BEGIN;
        fill_and_sort(row);
        if (verify(row))
            failed = 1;
        TASK_END;
        row += 1;
    }

    if (failed==1)
        printf("Failed!\n");
    else
        printf("OK!\n");
}
