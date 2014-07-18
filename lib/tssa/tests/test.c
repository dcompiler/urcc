#define TASK_BEGIN task_begin()
#define TASK_END task_end()


int main()
{
    int x,y,z;
    x = 1;
    z = 3;

    TASK_BEGIN;
    if (z > 1) 
        x = 2;
    y = 2;
    TASK_END;

    z=2;
    printf("x=%d, y=%d, z=%d\n", x, y, z);
}
