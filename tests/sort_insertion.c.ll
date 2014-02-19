; ModuleID = 'sort_insertion.c.bc'
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:32:32-n8:16:32-S128"
target triple = "i386-pc-linux-gnu"

@data = common global [30 x i32] zeroinitializer, align 4
@.str = private unnamed_addr constant [10 x i8] c"results:\0A\00", align 1
@.str1 = private unnamed_addr constant [8 x i8] c"%d: %d\0A\00", align 1

define void @insertSort(i32 %lb, i32 %ub) nounwind {
entry:
  %lb.addr = alloca i32, align 4
  %ub.addr = alloca i32, align 4
  %t = alloca i32, align 4
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  store i32 %lb, i32* %lb.addr, align 4
  store i32 %ub, i32* %ub.addr, align 4
  %0 = load i32* %lb.addr, align 4
  %add = add nsw i32 %0, 1
  store i32 %add, i32* %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc11, %entry
  %1 = load i32* %i, align 4
  %2 = load i32* %ub.addr, align 4
  %cmp = icmp sle i32 %1, %2
  br i1 %cmp, label %for.body, label %for.end12

for.body:                                         ; preds = %for.cond
  %3 = load i32* %i, align 4
  %arrayidx = getelementptr inbounds [30 x i32]* @data, i32 0, i32 %3
  %4 = load i32* %arrayidx, align 4
  store i32 %4, i32* %t, align 4
  %5 = load i32* %i, align 4
  %sub = sub nsw i32 %5, 1
  store i32 %sub, i32* %j, align 4
  br label %for.cond1

for.cond1:                                        ; preds = %for.inc, %for.body
  %6 = load i32* %j, align 4
  %7 = load i32* %lb.addr, align 4
  %cmp2 = icmp sge i32 %6, %7
  br i1 %cmp2, label %land.rhs, label %land.end

land.rhs:                                         ; preds = %for.cond1
  %8 = load i32* %j, align 4
  %arrayidx3 = getelementptr inbounds [30 x i32]* @data, i32 0, i32 %8
  %9 = load i32* %arrayidx3, align 4
  %10 = load i32* %t, align 4
  %cmp4 = icmp sgt i32 %9, %10
  br label %land.end

land.end:                                         ; preds = %land.rhs, %for.cond1
  %11 = phi i1 [ false, %for.cond1 ], [ %cmp4, %land.rhs ]
  br i1 %11, label %for.body5, label %for.end

for.body5:                                        ; preds = %land.end
  %12 = load i32* %j, align 4
  %arrayidx6 = getelementptr inbounds [30 x i32]* @data, i32 0, i32 %12
  %13 = load i32* %arrayidx6, align 4
  %14 = load i32* %j, align 4
  %add7 = add nsw i32 %14, 1
  %arrayidx8 = getelementptr inbounds [30 x i32]* @data, i32 0, i32 %add7
  store i32 %13, i32* %arrayidx8, align 4
  br label %for.inc

for.inc:                                          ; preds = %for.body5
  %15 = load i32* %j, align 4
  %dec = add nsw i32 %15, -1
  store i32 %dec, i32* %j, align 4
  br label %for.cond1

for.end:                                          ; preds = %land.end
  %16 = load i32* %t, align 4
  %17 = load i32* %j, align 4
  %add9 = add nsw i32 %17, 1
  %arrayidx10 = getelementptr inbounds [30 x i32]* @data, i32 0, i32 %add9
  store i32 %16, i32* %arrayidx10, align 4
  br label %for.inc11

for.inc11:                                        ; preds = %for.end
  %18 = load i32* %i, align 4
  %inc = add nsw i32 %18, 1
  store i32 %inc, i32* %i, align 4
  br label %for.cond

for.end12:                                        ; preds = %for.cond
  ret void
}

define void @fill(i32 %lb, i32 %ub) nounwind {
entry:
  %lb.addr = alloca i32, align 4
  %ub.addr = alloca i32, align 4
  %i = alloca i32, align 4
  store i32 %lb, i32* %lb.addr, align 4
  store i32 %ub, i32* %ub.addr, align 4
  call void @srand(i32 1) nounwind
  %0 = load i32* %lb.addr, align 4
  store i32 %0, i32* %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %1 = load i32* %i, align 4
  %2 = load i32* %ub.addr, align 4
  %cmp = icmp sle i32 %1, %2
  br i1 %cmp, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %call = call i32 @rand() nounwind
  %rem = srem i32 %call, 1000
  %3 = load i32* %i, align 4
  %arrayidx = getelementptr inbounds [30 x i32]* @data, i32 0, i32 %3
  store i32 %rem, i32* %arrayidx, align 4
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %4 = load i32* %i, align 4
  %inc = add nsw i32 %4, 1
  store i32 %inc, i32* %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  ret void
}

declare void @srand(i32) nounwind

declare i32 @rand() nounwind

define i32 @main(i32 %argc, i8** %argv) nounwind {
entry:
  %retval = alloca i32, align 4
  %argc.addr = alloca i32, align 4
  %argv.addr = alloca i8**, align 4
  %maxnum = alloca i32, align 4
  %lb = alloca i32, align 4
  %ub = alloca i32, align 4
  %i = alloca i32, align 4
  store i32 0, i32* %retval
  store i32 %argc, i32* %argc.addr, align 4
  store i8** %argv, i8*** %argv.addr, align 4
  store i32 30, i32* %maxnum, align 4
  store i32 0, i32* %lb, align 4
  %0 = load i32* %maxnum, align 4
  %sub = sub nsw i32 %0, 1
  store i32 %sub, i32* %ub, align 4
  %1 = load i32* %lb, align 4
  %2 = load i32* %ub, align 4
  call void @fill(i32 %1, i32 %2)
  %3 = load i32* %lb, align 4
  %4 = load i32* %ub, align 4
  call void @insertSort(i32 %3, i32 %4)
  %call = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([10 x i8]* @.str, i32 0, i32 0))
  %5 = load i32* %lb, align 4
  store i32 %5, i32* %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %6 = load i32* %i, align 4
  %7 = load i32* %ub, align 4
  %cmp = icmp sle i32 %6, %7
  br i1 %cmp, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %8 = load i32* %i, align 4
  %9 = load i32* %i, align 4
  %arrayidx = getelementptr inbounds [30 x i32]* @data, i32 0, i32 %9
  %10 = load i32* %arrayidx, align 4
  %call1 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([8 x i8]* @.str1, i32 0, i32 0), i32 %8, i32 %10)
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %11 = load i32* %i, align 4
  %inc = add nsw i32 %11, 1
  store i32 %inc, i32* %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  ret i32 0
}

declare i32 @printf(i8*, ...)
