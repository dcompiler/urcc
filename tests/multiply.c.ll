; ModuleID = 'multiply.c.bc'
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:32:32-n8:16:32-S128"
target triple = "i386-pc-linux-gnu"

@.str = private unnamed_addr constant [3 x i8] c"%d\00", align 1
@.str1 = private unnamed_addr constant [45 x i8] c"I need a non-negative number less than 100: \00", align 1
@.str2 = private unnamed_addr constant [55 x i8] c"Please give the size of the vectors to be multiplied: \00", align 1
@.str3 = private unnamed_addr constant [3 x i8] c"0\0A\00", align 1

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

define i32 @main() nounwind {
entry:
  %retval = alloca i32, align 4
  %A = alloca [100 x i32], align 4
  %B = alloca [100 x i32], align 4
  %size = alloca i32, align 4
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  %result = alloca i32, align 4
  store i32 0, i32* %retval
  %call = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([55 x i8]* @.str2, i32 0, i32 0))
  %call1 = call i32 @getinput()
  store i32 %call1, i32* %size, align 4
  %arrayidx = getelementptr inbounds [100 x i32]* %A, i32 0, i32 0
  store i32 0, i32* %arrayidx, align 4
  store i32 1, i32* %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %0 = load i32* %i, align 4
  %1 = load i32* %size, align 4
  %cmp = icmp slt i32 %0, %1
  br i1 %cmp, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %2 = load i32* %i, align 4
  %sub = sub nsw i32 %2, 1
  %arrayidx2 = getelementptr inbounds [100 x i32]* %A, i32 0, i32 %sub
  %3 = load i32* %arrayidx2, align 4
  %4 = load i32* %i, align 4
  %5 = load i32* %i, align 4
  %mul = mul nsw i32 %4, %5
  %add = add nsw i32 %3, %mul
  %6 = load i32* %i, align 4
  %arrayidx3 = getelementptr inbounds [100 x i32]* %A, i32 0, i32 %6
  store i32 %add, i32* %arrayidx3, align 4
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %7 = load i32* %i, align 4
  %inc = add nsw i32 %7, 1
  store i32 %inc, i32* %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %arrayidx4 = getelementptr inbounds [100 x i32]* %B, i32 0, i32 0
  store i32 0, i32* %arrayidx4, align 4
  store i32 1, i32* %i, align 4
  br label %for.cond5

for.cond5:                                        ; preds = %for.inc12, %for.end
  %8 = load i32* %i, align 4
  %9 = load i32* %size, align 4
  %cmp6 = icmp slt i32 %8, %9
  br i1 %cmp6, label %for.body7, label %for.end14

for.body7:                                        ; preds = %for.cond5
  %10 = load i32* %i, align 4
  %11 = load i32* %i, align 4
  %sub8 = sub nsw i32 %11, 1
  %arrayidx9 = getelementptr inbounds [100 x i32]* %B, i32 0, i32 %sub8
  %12 = load i32* %arrayidx9, align 4
  %add10 = add nsw i32 %10, %12
  %13 = load i32* %i, align 4
  %arrayidx11 = getelementptr inbounds [100 x i32]* %B, i32 0, i32 %13
  store i32 %add10, i32* %arrayidx11, align 4
  br label %for.inc12

for.inc12:                                        ; preds = %for.body7
  %14 = load i32* %i, align 4
  %inc13 = add nsw i32 %14, 1
  store i32 %inc13, i32* %i, align 4
  br label %for.cond5

for.end14:                                        ; preds = %for.cond5
  store i32 0, i32* %result, align 4
  store i32 0, i32* %i, align 4
  br label %for.cond15

for.cond15:                                       ; preds = %for.inc22, %for.end14
  %15 = load i32* %i, align 4
  %16 = load i32* %size, align 4
  %cmp16 = icmp slt i32 %15, %16
  br i1 %cmp16, label %for.body17, label %for.end24

for.body17:                                       ; preds = %for.cond15
  %17 = load i32* %i, align 4
  %arrayidx18 = getelementptr inbounds [100 x i32]* %A, i32 0, i32 %17
  %18 = load i32* %arrayidx18, align 4
  %19 = load i32* %i, align 4
  %arrayidx19 = getelementptr inbounds [100 x i32]* %B, i32 0, i32 %19
  %20 = load i32* %arrayidx19, align 4
  %mul20 = mul nsw i32 %18, %20
  %21 = load i32* %result, align 4
  %add21 = add nsw i32 %21, %mul20
  store i32 %add21, i32* %result, align 4
  br label %for.inc22

for.inc22:                                        ; preds = %for.body17
  %22 = load i32* %i, align 4
  %inc23 = add nsw i32 %22, 1
  store i32 %inc23, i32* %i, align 4
  br label %for.cond15

for.end24:                                        ; preds = %for.cond15
  %call25 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([3 x i8]* @.str3, i32 0, i32 0))
  %23 = load i32* %retval
  ret i32 %23
}
