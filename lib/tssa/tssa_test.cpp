#include "tssa.h"
#include <iostream>

char **stack;

void foo(int tid, void *stack)
{
    int t = rd_stack(stack, 0, t);
    std::cout << t << std::endl;
    wr_stack(stack, 0, t+1);
}

int main()
{
    int i;
    int r;
    task_init(1, foo, &stack, 4);
    for (i=0; i<10; i++) {
        wr_next_stack(1, 0, i);
        task_begin(1);
        task_join(1);
        r= task_omega(1, i, 0);
        assert(r==i+1);
    }
}
