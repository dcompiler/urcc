; ModuleID = 'fibonacci.c.bc'
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:32:32-n8:16:32-S128"
target triple = "i386-pc-linux-gnu"

@array = common global [32 x i32] zeroinitializer, align 4
@.str = private unnamed_addr constant [53 x i8] c"The first few digits of the Fibonacci sequence are:\0A\00", align 1
@.str1 = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1

define void @initialize_array() nounwind {
entry:
  %idx = alloca i32, align 4
  %bound = alloca i32, align 4
  store i32 32, i32* %bound, align 4
  store i32 0, i32* %idx, align 4
  br label %while.cond

while.cond:                                       ; preds = %while.body, %entry
  %0 = load i32* %idx, align 4
  %1 = load i32* %bound, align 4
  %cmp = icmp slt i32 %0, %1
  br i1 %cmp, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %2 = load i32* %idx, align 4
  %arrayidx = getelementptr inbounds [32 x i32]* @array, i32 0, i32 %2
  store i32 -1, i32* %arrayidx, align 4
  %3 = load i32* %idx, align 4
  %add = add nsw i32 %3, 1
  store i32 %add, i32* %idx, align 4
  br label %while.cond

while.end:                                        ; preds = %while.cond
  ret void
}

define i32 @fib(i32 %val) nounwind {
entry:
  %retval = alloca i32, align 4
  %val.addr = alloca i32, align 4
  store i32 %val, i32* %val.addr, align 4
  %0 = load i32* %val.addr, align 4
  %cmp = icmp slt i32 %0, 2
  br i1 %cmp, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  store i32 1, i32* %retval
  br label %return

if.end:                                           ; preds = %entry
  %1 = load i32* %val.addr, align 4
  %arrayidx = getelementptr inbounds [32 x i32]* @array, i32 0, i32 %1
  %2 = load i32* %arrayidx, align 4
  %cmp1 = icmp eq i32 %2, -1
  br i1 %cmp1, label %if.then2, label %if.end6

if.then2:                                         ; preds = %if.end
  %3 = load i32* %val.addr, align 4
  %sub = sub nsw i32 %3, 1
  %call = call i32 @fib(i32 %sub)
  %4 = load i32* %val.addr, align 4
  %sub3 = sub nsw i32 %4, 2
  %call4 = call i32 @fib(i32 %sub3)
  %add = add nsw i32 %call, %call4
  %5 = load i32* %val.addr, align 4
  %arrayidx5 = getelementptr inbounds [32 x i32]* @array, i32 0, i32 %5
  store i32 %add, i32* %arrayidx5, align 4
  br label %if.end6

if.end6:                                          ; preds = %if.then2, %if.end
  %6 = load i32* %val.addr, align 4
  %arrayidx7 = getelementptr inbounds [32 x i32]* @array, i32 0, i32 %6
  %7 = load i32* %arrayidx7, align 4
  store i32 %7, i32* %retval
  br label %return

return:                                           ; preds = %if.end6, %if.then
  %8 = load i32* %retval
  ret i32 %8
}

define i32 @main() nounwind {
entry:
  %retval = alloca i32, align 4
  %idx = alloca i32, align 4
  %bound = alloca i32, align 4
  store i32 0, i32* %retval
  store i32 32, i32* %bound, align 4
  call void @initialize_array()
  store i32 0, i32* %idx, align 4
  %call = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([53 x i8]* @.str, i32 0, i32 0))
  br label %while.cond

while.cond:                                       ; preds = %while.body, %entry
  %0 = load i32* %idx, align 4
  %1 = load i32* %bound, align 4
  %cmp = icmp slt i32 %0, %1
  br i1 %cmp, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %2 = load i32* %idx, align 4
  %call1 = call i32 @fib(i32 %2)
  %call2 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([4 x i8]* @.str1, i32 0, i32 0), i32 %call1)
  %3 = load i32* %idx, align 4
  %add = add nsw i32 %3, 1
  store i32 %add, i32* %idx, align 4
  br label %while.cond

while.end:                                        ; preds = %while.cond
  %4 = load i32* %retval
  ret i32 %4
}

declare i32 @printf(i8*, ...)
