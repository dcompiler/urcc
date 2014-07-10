#include "tssa.h"
#include <pthread.h>
#include <unistd.h>
#include <cstdio>
#include <vector>
#include <list>
#include <cassert>
#include <cstring>

using namespace std;

const int PROC_NUM = sysconf(_SC_NPROCESSORS_CONF);

void *pthread_worker(void *t);

struct Task;

struct Thread {
    Task *task;
    int tid;
    pthread_t thd;
    void *stk;

    Thread(Task *t, int id, void *stack)
        :task(t), tid(id), stk(stack) 
    {}

    void start() { pthread_create(&thd, NULL, &pthread_worker, this); }
    void join() { pthread_join(thd, NULL); }
};

struct Task {
    int next_tid;
    list<Thread> threads;
    task_func func;
    vector<char*> stks;
    int stk_size;
    vector<bool> writes;
    vector<char> last_stack;

   void join_one() {
        threads.front().join();
        update_stack(threads.front().stk);
        memset((char*)threads.front().stk+4, 0, stk_size+stk_size/4);
        threads.pop_front();
    }

    void update_stack(void *stk) {
        int off = 4 + stk_size;
        for (int i=0; i<stk_size/4; i++) {
            if (((char*)stk)[off+i]==true) {
                writes[i] = true;
                memcpy(&last_stack[4+4*i], (char*)stk+4+4*i, 4);
            }
        }
    }

    ~Task() {
        for (int i=0; i<stks.size(); i++) 
            delete[] stks[i];
    }
};

static vector<Task> tasks(8);

void *last_write(int task, int offset) {
    assert(task>0 && task<=tasks.size() && offset%4==0);

    Task &t = tasks[task-1];
    return t.writes[offset/4] ? &t.last_stack[4+offset] : 0;
}

int next_tid(int task) {
    assert(task>0 && task<=tasks.size());

    Task &t = tasks[task-1];
    if (t.threads.size() >= PROC_NUM)
        t.join_one(); 

    return t.next_tid;
}

void *next_stack(int task) {
    assert(task>0 && task<=tasks.size());

    Task &t = tasks[task-1];
    return t.stks[next_tid(task)]; 
}

void task_init(int task, task_func f, char** *stack, int stack_size)
{   
    assert(task>0 && task<=tasks.size() && stack_size%4==0);

    Task &t = tasks[task-1];
    t.next_tid = 0;
    t.func = f;
    t.stk_size = stack_size;
    t.stks.resize(PROC_NUM, 0);
    t.writes.resize(stack_size/4, false);
    t.last_stack.resize(4+stack_size, 0);
    if (stack_size > 0) {
        for (int i=0; i<t.stks.size(); i++) {
            t.stks[i] = new char[4+stack_size+stack_size/4];
            memset(t.stks[i], 0, 4+stack_size+stack_size/4);
            *(int*)(t.stks[i]) = stack_size;
        }
    }
    if (stack)
        *stack = &t.stks[0];
}

int task_begin(int task)
{
    assert(task>0 && task<=tasks.size());

    Task &t = tasks[task-1];
    if (t.threads.size() >= PROC_NUM)
        t.join_one();

    Thread thd(&t, t.next_tid, t.stks[t.next_tid]);
    t.threads.push_back(thd);
    t.threads.back().start();
    t.next_tid = (t.next_tid+1)%PROC_NUM;
    return t.threads.back().tid;
}

void task_join(int task)
{
    assert(task>0 && task<=tasks.size());

    Task &t = tasks[task-1];
    while (!t.threads.empty())
        t.join_one();
}

void *pthread_worker(void *t)
{
    Thread *thd = (Thread*)t;
    thd->task->func(thd->tid, thd->stk);
    return NULL;
}


