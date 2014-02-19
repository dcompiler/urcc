; ModuleID = 'binrep.c.bc'
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:32:32-n8:16:32-S128"
target triple = "i386-pc-linux-gnu"

@.str = private unnamed_addr constant [2 x i8] c"0\00", align 1
@.str1 = private unnamed_addr constant [2 x i8] c"1\00", align 1
@.str2 = private unnamed_addr constant [19 x i8] c"Give me a number: \00", align 1
@.str3 = private unnamed_addr constant [3 x i8] c"%d\00", align 1
@.str4 = private unnamed_addr constant [28 x i8] c"I need a positive integer.\0A\00", align 1
@.str5 = private unnamed_addr constant [31 x i8] c"The binary representation of: \00", align 1
@.str6 = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1
@.str7 = private unnamed_addr constant [5 x i8] c"is: \00", align 1
@.str8 = private unnamed_addr constant [3 x i8] c"\0A\0A\00", align 1

define void @recursedigit(i32 %n) nounwind {
entry:
  %n.addr = alloca i32, align 4
  %on = alloca i32, align 4
  store i32 %n, i32* %n.addr, align 4
  %0 = load i32* %n.addr, align 4
  %cmp = icmp eq i32 0, %0
  br i1 %cmp, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  br label %if.end11

if.end:                                           ; preds = %entry
  store i32 0, i32* %on, align 4
  %1 = load i32* %n.addr, align 4
  %2 = load i32* %n.addr, align 4
  %div = sdiv i32 %2, 2
  %mul = mul nsw i32 %div, 2
  %sub = sub nsw i32 %1, %mul
  %cmp1 = icmp ne i32 0, %sub
  br i1 %cmp1, label %if.then2, label %if.end3

if.then2:                                         ; preds = %if.end
  store i32 1, i32* %on, align 4
  br label %if.end3

if.end3:                                          ; preds = %if.then2, %if.end
  %3 = load i32* %n.addr, align 4
  %div4 = sdiv i32 %3, 2
  call void @recursedigit(i32 %div4)
  %4 = load i32* %on, align 4
  %cmp5 = icmp eq i32 0, %4
  br i1 %cmp5, label %if.then6, label %if.end7

if.then6:                                         ; preds = %if.end3
  %call = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([2 x i8]* @.str, i32 0, i32 0))
  br label %if.end7

if.end7:                                          ; preds = %if.then6, %if.end3
  %5 = load i32* %on, align 4
  %cmp8 = icmp eq i32 1, %5
  br i1 %cmp8, label %if.then9, label %if.end11

if.then9:                                         ; preds = %if.end7
  %call10 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([2 x i8]* @.str1, i32 0, i32 0))
  br label %if.end11

if.end11:                                         ; preds = %if.then9, %if.end7, %if.then
  ret void
}

declare i32 @printf(i8*, ...)

define i32 @main() nounwind {
entry:
  %retval = alloca i32, align 4
  %a = alloca i32, align 4
  store i32 0, i32* %retval
  store i32 0, i32* %a, align 4
  br label %while.cond

while.cond:                                       ; preds = %if.end, %entry
  %0 = load i32* %a, align 4
  %cmp = icmp sge i32 0, %0
  br i1 %cmp, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %call = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([19 x i8]* @.str2, i32 0, i32 0))
  %call1 = call i32 (i8*, ...)* @__isoc99_scanf(i8* getelementptr inbounds ([3 x i8]* @.str3, i32 0, i32 0), i32* %a)
  %1 = load i32* %a, align 4
  %cmp2 = icmp sge i32 0, %1
  br i1 %cmp2, label %if.then, label %if.end

if.then:                                          ; preds = %while.body
  %call3 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([28 x i8]* @.str4, i32 0, i32 0))
  br label %if.end

if.end:                                           ; preds = %if.then, %while.body
  br label %while.cond

while.end:                                        ; preds = %while.cond
  %call4 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([31 x i8]* @.str5, i32 0, i32 0))
  %2 = load i32* %a, align 4
  %call5 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([4 x i8]* @.str6, i32 0, i32 0), i32 %2)
  %call6 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([5 x i8]* @.str7, i32 0, i32 0))
  %3 = load i32* %a, align 4
  call void @recursedigit(i32 %3)
  %call7 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([3 x i8]* @.str8, i32 0, i32 0))
  %4 = load i32* %retval
  ret i32 %4
}

declare i32 @__isoc99_scanf(i8*, ...)
