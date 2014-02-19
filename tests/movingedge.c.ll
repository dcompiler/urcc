; ModuleID = 'movingedge.c.bc'
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:32:32-n8:16:32-S128"
target triple = "i386-pc-linux-gnu"

@magic = global i32 35, align 4
@nbr_5 = common global [5 x i32] zeroinitializer, align 4
@.str = private unnamed_addr constant [3 x i8] c"%d\00", align 1
@.str1 = private unnamed_addr constant [45 x i8] c"I need a non-negative number less than 100: \00", align 1
@V = common global [100 x i32] zeroinitializer, align 4
@.str2 = private unnamed_addr constant [56 x i8] c"Please input the size of the vector to be transformed: \00", align 1
@.str3 = private unnamed_addr constant [18 x i8] c"Original vector:\0A\00", align 1
@.str4 = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1
@.str5 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str6 = private unnamed_addr constant [21 x i8] c"Moving edge vector:\0A\00", align 1

define void @init_nbr() nounwind {
entry:
  store i32 -3, i32* getelementptr inbounds ([5 x i32]* @nbr_5, i32 0, i32 0), align 4
  store i32 12, i32* getelementptr inbounds ([5 x i32]* @nbr_5, i32 0, i32 1), align 4
  store i32 17, i32* getelementptr inbounds ([5 x i32]* @nbr_5, i32 0, i32 2), align 4
  store i32 12, i32* getelementptr inbounds ([5 x i32]* @nbr_5, i32 0, i32 3), align 4
  store i32 -3, i32* getelementptr inbounds ([5 x i32]* @nbr_5, i32 0, i32 4), align 4
  ret void
}

define i32 @getinput() nounwind {
entry:
  %a = alloca i32, align 4
  store i32 -1, i32* %a, align 4
  br label %while.cond

while.cond:                                       ; preds = %if.end, %entry
  %0 = load i32* %a, align 4
  %cmp = icmp sgt i32 0, %0
  br i1 %cmp, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %call = call i32 (i8*, ...)* @__isoc99_scanf(i8* getelementptr inbounds ([3 x i8]* @.str, i32 0, i32 0), i32* %a)
  %1 = load i32* %a, align 4
  %cmp1 = icmp sgt i32 0, %1
  br i1 %cmp1, label %if.then, label %lor.lhs.false

lor.lhs.false:                                    ; preds = %while.body
  %2 = load i32* %a, align 4
  %cmp2 = icmp sgt i32 %2, 100
  br i1 %cmp2, label %if.then, label %if.end

if.then:                                          ; preds = %lor.lhs.false, %while.body
  %call3 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([45 x i8]* @.str1, i32 0, i32 0))
  store i32 -1, i32* %a, align 4
  br label %if.end

if.end:                                           ; preds = %if.then, %lor.lhs.false
  br label %while.cond

while.end:                                        ; preds = %while.cond
  %3 = load i32* %a, align 4
  ret i32 %3
}

declare i32 @__isoc99_scanf(i8*, ...)

declare i32 @printf(i8*, ...)

define void @moving(i32 %size) nounwind {
entry:
  %size.addr = alloca i32, align 4
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  %temp = alloca i32, align 4
  store i32 %size, i32* %size.addr, align 4
  store i32 2, i32* %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc8, %entry
  %0 = load i32* %i, align 4
  %1 = load i32* %size.addr, align 4
  %sub = sub nsw i32 %1, 2
  %cmp = icmp slt i32 %0, %sub
  br i1 %cmp, label %for.body, label %for.end10

for.body:                                         ; preds = %for.cond
  store i32 0, i32* %temp, align 4
  store i32 -2, i32* %j, align 4
  br label %for.cond1

for.cond1:                                        ; preds = %for.inc, %for.body
  %2 = load i32* %j, align 4
  %cmp2 = icmp slt i32 %2, 3
  br i1 %cmp2, label %for.body3, label %for.end

for.body3:                                        ; preds = %for.cond1
  %3 = load i32* %i, align 4
  %4 = load i32* %j, align 4
  %add = add nsw i32 %3, %4
  %arrayidx = getelementptr inbounds [100 x i32]* @V, i32 0, i32 %add
  %5 = load i32* %arrayidx, align 4
  %6 = load i32* %j, align 4
  %add4 = add nsw i32 %6, 2
  %arrayidx5 = getelementptr inbounds [5 x i32]* @nbr_5, i32 0, i32 %add4
  %7 = load i32* %arrayidx5, align 4
  %mul = mul nsw i32 %5, %7
  %8 = load i32* %temp, align 4
  %add6 = add nsw i32 %8, %mul
  store i32 %add6, i32* %temp, align 4
  br label %for.inc

for.inc:                                          ; preds = %for.body3
  %9 = load i32* %j, align 4
  %inc = add nsw i32 %9, 1
  store i32 %inc, i32* %j, align 4
  br label %for.cond1

for.end:                                          ; preds = %for.cond1
  %10 = load i32* %temp, align 4
  %11 = load i32* @magic, align 4
  %div = sdiv i32 %10, %11
  %12 = load i32* %i, align 4
  %arrayidx7 = getelementptr inbounds [100 x i32]* @V, i32 0, i32 %12
  store i32 %div, i32* %arrayidx7, align 4
  br label %for.inc8

for.inc8:                                         ; preds = %for.end
  %13 = load i32* %i, align 4
  %inc9 = add nsw i32 %13, 1
  store i32 %inc9, i32* %i, align 4
  br label %for.cond

for.end10:                                        ; preds = %for.cond
  ret void
}

define i32 @main() nounwind {
entry:
  %retval = alloca i32, align 4
  %size = alloca i32, align 4
  %i = alloca i32, align 4
  store i32 0, i32* %retval
  %call = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([56 x i8]* @.str2, i32 0, i32 0))
  %call1 = call i32 @getinput()
  store i32 %call1, i32* %size, align 4
  store i32 0, i32* %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %0 = load i32* %i, align 4
  %1 = load i32* %size, align 4
  %cmp = icmp slt i32 %0, %1
  br i1 %cmp, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %call2 = call i32 @rand() nounwind
  %rem = srem i32 %call2, 100
  %2 = load i32* %i, align 4
  %arrayidx = getelementptr inbounds [100 x i32]* @V, i32 0, i32 %2
  store i32 %rem, i32* %arrayidx, align 4
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %3 = load i32* %i, align 4
  %inc = add nsw i32 %3, 1
  store i32 %inc, i32* %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %call3 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([18 x i8]* @.str3, i32 0, i32 0))
  store i32 0, i32* %i, align 4
  br label %for.cond4

for.cond4:                                        ; preds = %for.inc9, %for.end
  %4 = load i32* %i, align 4
  %5 = load i32* %size, align 4
  %cmp5 = icmp slt i32 %4, %5
  br i1 %cmp5, label %for.body6, label %for.end11

for.body6:                                        ; preds = %for.cond4
  %6 = load i32* %i, align 4
  %arrayidx7 = getelementptr inbounds [100 x i32]* @V, i32 0, i32 %6
  %7 = load i32* %arrayidx7, align 4
  %call8 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([4 x i8]* @.str4, i32 0, i32 0), i32 %7)
  br label %for.inc9

for.inc9:                                         ; preds = %for.body6
  %8 = load i32* %i, align 4
  %inc10 = add nsw i32 %8, 1
  store i32 %inc10, i32* %i, align 4
  br label %for.cond4

for.end11:                                        ; preds = %for.cond4
  %call12 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([2 x i8]* @.str5, i32 0, i32 0))
  call void @init_nbr()
  %9 = load i32* %size, align 4
  call void @moving(i32 %9)
  %call13 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([21 x i8]* @.str6, i32 0, i32 0))
  store i32 0, i32* %i, align 4
  br label %for.cond14

for.cond14:                                       ; preds = %for.inc19, %for.end11
  %10 = load i32* %i, align 4
  %11 = load i32* %size, align 4
  %cmp15 = icmp slt i32 %10, %11
  br i1 %cmp15, label %for.body16, label %for.end21

for.body16:                                       ; preds = %for.cond14
  %12 = load i32* %i, align 4
  %arrayidx17 = getelementptr inbounds [100 x i32]* @V, i32 0, i32 %12
  %13 = load i32* %arrayidx17, align 4
  %call18 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([4 x i8]* @.str4, i32 0, i32 0), i32 %13)
  br label %for.inc19

for.inc19:                                        ; preds = %for.body16
  %14 = load i32* %i, align 4
  %inc20 = add nsw i32 %14, 1
  store i32 %inc20, i32* %i, align 4
  br label %for.cond14

for.end21:                                        ; preds = %for.cond14
  %call22 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([2 x i8]* @.str5, i32 0, i32 0))
  %15 = load i32* %retval
  ret i32 %15
}

declare i32 @rand() nounwind
