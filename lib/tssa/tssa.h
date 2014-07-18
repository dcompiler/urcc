#ifndef _TSSA_H_
#define _TSSA_H_

#include <cassert>

static inline void task_begin() {}
static inline void task_end() {}

typedef void (*task_func)(int tid, void *stack);

int task_begin(int task);

void task_join(int task);

int next_tid(int task);
void *next_stack(int task);

void *last_write(int task, int offset);

template<typename T> 
inline T task_omega(int task, T val, int offset) {
    void *last_val = last_write(task, offset);
    return last_val ? *(T*)last_val : val;
}

void task_init(int task, task_func f, char** *stack, int stack_size);

template<typename T> 
inline T rd_stack(void *stack, int offset, T) {
    int size = *(int*)((char*)stack);
    //assert(offset+sizeof(T)<=size && offset%4==0);
    return *(T*)((char*)stack+4+offset);
}

template<typename T> 
inline void wr_stack(void *stack, int offset, T val) {
    int size = *(int*)((char*)stack);
    //assert(offset+sizeof(T)<=size && offset%4==0);
    *(T*)((char*)stack+4+offset) = val;
    for (int i=0; i<(sizeof(T)+3)/4; i++)
        ((char*)stack)[4+size+offset/4+i*4] = 1;
}

template<typename T> 
inline void wr_next_stack(int task, int offset, T val) {
    char *stack = (char*)next_stack(task);
    int size = *(int*)(stack);
    //assert(offset+sizeof(T)<=size && offset%4==0);
    *(T*)(stack+4+offset) = val;
}


#endif
