; ModuleID = 'sort.c.bc'
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:32:32-n8:16:32-S128"
target triple = "i386-pc-linux-gnu"

@array_1 = common global [16 x i32] zeroinitializer, align 4
@array_2 = common global [16 x i32] zeroinitializer, align 4
@array_3 = common global [16 x i32] zeroinitializer, align 4
@array_4 = common global [16 x i32] zeroinitializer, align 4
@.str = private unnamed_addr constant [10 x i8] c"Array_1:\0A\00", align 1
@.str1 = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1
@.str2 = private unnamed_addr constant [11 x i8] c"\0AArray_2:\0A\00", align 1
@.str3 = private unnamed_addr constant [11 x i8] c"\0AArray_3:\0A\00", align 1
@.str4 = private unnamed_addr constant [11 x i8] c"\0AArray_4:\0A\00", align 1
@.str5 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1

define void @populate_arrays() nounwind {
entry:
  store i32 0, i32* getelementptr inbounds ([16 x i32]* @array_1, i32 0, i32 0), align 4
  store i32 15, i32* getelementptr inbounds ([16 x i32]* @array_2, i32 0, i32 0), align 4
  store i32 5, i32* getelementptr inbounds ([16 x i32]* @array_3, i32 0, i32 0), align 4
  store i32 13, i32* getelementptr inbounds ([16 x i32]* @array_4, i32 0, i32 0), align 4
  store i32 1, i32* getelementptr inbounds ([16 x i32]* @array_1, i32 0, i32 1), align 4
  store i32 14, i32* getelementptr inbounds ([16 x i32]* @array_2, i32 0, i32 1), align 4
  store i32 5, i32* getelementptr inbounds ([16 x i32]* @array_3, i32 0, i32 1), align 4
  store i32 9, i32* getelementptr inbounds ([16 x i32]* @array_4, i32 0, i32 1), align 4
  store i32 2, i32* getelementptr inbounds ([16 x i32]* @array_1, i32 0, i32 2), align 4
  store i32 13, i32* getelementptr inbounds ([16 x i32]* @array_2, i32 0, i32 2), align 4
  store i32 5, i32* getelementptr inbounds ([16 x i32]* @array_3, i32 0, i32 2), align 4
  store i32 12, i32* getelementptr inbounds ([16 x i32]* @array_4, i32 0, i32 2), align 4
  store i32 3, i32* getelementptr inbounds ([16 x i32]* @array_1, i32 0, i32 3), align 4
  store i32 12, i32* getelementptr inbounds ([16 x i32]* @array_2, i32 0, i32 3), align 4
  store i32 5, i32* getelementptr inbounds ([16 x i32]* @array_3, i32 0, i32 3), align 4
  store i32 1, i32* getelementptr inbounds ([16 x i32]* @array_4, i32 0, i32 3), align 4
  store i32 4, i32* getelementptr inbounds ([16 x i32]* @array_1, i32 0, i32 4), align 4
  store i32 11, i32* getelementptr inbounds ([16 x i32]* @array_2, i32 0, i32 4), align 4
  store i32 5, i32* getelementptr inbounds ([16 x i32]* @array_3, i32 0, i32 4), align 4
  store i32 0, i32* getelementptr inbounds ([16 x i32]* @array_4, i32 0, i32 4), align 4
  store i32 5, i32* getelementptr inbounds ([16 x i32]* @array_1, i32 0, i32 5), align 4
  store i32 10, i32* getelementptr inbounds ([16 x i32]* @array_2, i32 0, i32 5), align 4
  store i32 5, i32* getelementptr inbounds ([16 x i32]* @array_3, i32 0, i32 5), align 4
  store i32 14, i32* getelementptr inbounds ([16 x i32]* @array_4, i32 0, i32 5), align 4
  store i32 6, i32* getelementptr inbounds ([16 x i32]* @array_1, i32 0, i32 6), align 4
  store i32 9, i32* getelementptr inbounds ([16 x i32]* @array_2, i32 0, i32 6), align 4
  store i32 5, i32* getelementptr inbounds ([16 x i32]* @array_3, i32 0, i32 6), align 4
  store i32 3, i32* getelementptr inbounds ([16 x i32]* @array_4, i32 0, i32 6), align 4
  store i32 7, i32* getelementptr inbounds ([16 x i32]* @array_1, i32 0, i32 7), align 4
  store i32 8, i32* getelementptr inbounds ([16 x i32]* @array_2, i32 0, i32 7), align 4
  store i32 5, i32* getelementptr inbounds ([16 x i32]* @array_3, i32 0, i32 7), align 4
  store i32 2, i32* getelementptr inbounds ([16 x i32]* @array_4, i32 0, i32 7), align 4
  store i32 8, i32* getelementptr inbounds ([16 x i32]* @array_1, i32 0, i32 8), align 4
  store i32 7, i32* getelementptr inbounds ([16 x i32]* @array_2, i32 0, i32 8), align 4
  store i32 5, i32* getelementptr inbounds ([16 x i32]* @array_3, i32 0, i32 8), align 4
  store i32 11, i32* getelementptr inbounds ([16 x i32]* @array_4, i32 0, i32 8), align 4
  store i32 9, i32* getelementptr inbounds ([16 x i32]* @array_1, i32 0, i32 9), align 4
  store i32 6, i32* getelementptr inbounds ([16 x i32]* @array_2, i32 0, i32 9), align 4
  store i32 5, i32* getelementptr inbounds ([16 x i32]* @array_3, i32 0, i32 9), align 4
  store i32 8, i32* getelementptr inbounds ([16 x i32]* @array_4, i32 0, i32 9), align 4
  store i32 10, i32* getelementptr inbounds ([16 x i32]* @array_1, i32 0, i32 10), align 4
  store i32 5, i32* getelementptr inbounds ([16 x i32]* @array_2, i32 0, i32 10), align 4
  store i32 5, i32* getelementptr inbounds ([16 x i32]* @array_3, i32 0, i32 10), align 4
  store i32 6, i32* getelementptr inbounds ([16 x i32]* @array_4, i32 0, i32 10), align 4
  store i32 11, i32* getelementptr inbounds ([16 x i32]* @array_1, i32 0, i32 11), align 4
  store i32 4, i32* getelementptr inbounds ([16 x i32]* @array_2, i32 0, i32 11), align 4
  store i32 5, i32* getelementptr inbounds ([16 x i32]* @array_3, i32 0, i32 11), align 4
  store i32 4, i32* getelementptr inbounds ([16 x i32]* @array_4, i32 0, i32 11), align 4
  store i32 12, i32* getelementptr inbounds ([16 x i32]* @array_1, i32 0, i32 12), align 4
  store i32 3, i32* getelementptr inbounds ([16 x i32]* @array_2, i32 0, i32 12), align 4
  store i32 5, i32* getelementptr inbounds ([16 x i32]* @array_3, i32 0, i32 12), align 4
  store i32 5, i32* getelementptr inbounds ([16 x i32]* @array_4, i32 0, i32 12), align 4
  store i32 13, i32* getelementptr inbounds ([16 x i32]* @array_1, i32 0, i32 13), align 4
  store i32 2, i32* getelementptr inbounds ([16 x i32]* @array_2, i32 0, i32 13), align 4
  store i32 5, i32* getelementptr inbounds ([16 x i32]* @array_3, i32 0, i32 13), align 4
  store i32 10, i32* getelementptr inbounds ([16 x i32]* @array_4, i32 0, i32 13), align 4
  store i32 14, i32* getelementptr inbounds ([16 x i32]* @array_1, i32 0, i32 14), align 4
  store i32 1, i32* getelementptr inbounds ([16 x i32]* @array_2, i32 0, i32 14), align 4
  store i32 5, i32* getelementptr inbounds ([16 x i32]* @array_3, i32 0, i32 14), align 4
  store i32 7, i32* getelementptr inbounds ([16 x i32]* @array_4, i32 0, i32 14), align 4
  store i32 15, i32* getelementptr inbounds ([16 x i32]* @array_1, i32 0, i32 15), align 4
  store i32 0, i32* getelementptr inbounds ([16 x i32]* @array_2, i32 0, i32 15), align 4
  store i32 5, i32* getelementptr inbounds ([16 x i32]* @array_3, i32 0, i32 15), align 4
  store i32 15, i32* getelementptr inbounds ([16 x i32]* @array_4, i32 0, i32 15), align 4
  ret void
}

define void @print_arrays() nounwind {
entry:
  %idx = alloca i32, align 4
  %bound = alloca i32, align 4
  store i32 16, i32* %bound, align 4
  %call = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([10 x i8]* @.str, i32 0, i32 0))
  store i32 0, i32* %idx, align 4
  br label %while.cond

while.cond:                                       ; preds = %while.body, %entry
  %0 = load i32* %idx, align 4
  %1 = load i32* %bound, align 4
  %cmp = icmp slt i32 %0, %1
  br i1 %cmp, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %2 = load i32* %idx, align 4
  %arrayidx = getelementptr inbounds [16 x i32]* @array_1, i32 0, i32 %2
  %3 = load i32* %arrayidx, align 4
  %call1 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([4 x i8]* @.str1, i32 0, i32 0), i32 %3)
  %4 = load i32* %idx, align 4
  %add = add nsw i32 %4, 1
  store i32 %add, i32* %idx, align 4
  br label %while.cond

while.end:                                        ; preds = %while.cond
  %call2 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([11 x i8]* @.str2, i32 0, i32 0))
  store i32 0, i32* %idx, align 4
  br label %while.cond3

while.cond3:                                      ; preds = %while.body5, %while.end
  %5 = load i32* %idx, align 4
  %6 = load i32* %bound, align 4
  %cmp4 = icmp slt i32 %5, %6
  br i1 %cmp4, label %while.body5, label %while.end9

while.body5:                                      ; preds = %while.cond3
  %7 = load i32* %idx, align 4
  %arrayidx6 = getelementptr inbounds [16 x i32]* @array_2, i32 0, i32 %7
  %8 = load i32* %arrayidx6, align 4
  %call7 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([4 x i8]* @.str1, i32 0, i32 0), i32 %8)
  %9 = load i32* %idx, align 4
  %add8 = add nsw i32 %9, 1
  store i32 %add8, i32* %idx, align 4
  br label %while.cond3

while.end9:                                       ; preds = %while.cond3
  %call10 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([11 x i8]* @.str3, i32 0, i32 0))
  store i32 0, i32* %idx, align 4
  br label %while.cond11

while.cond11:                                     ; preds = %while.body13, %while.end9
  %10 = load i32* %idx, align 4
  %11 = load i32* %bound, align 4
  %cmp12 = icmp slt i32 %10, %11
  br i1 %cmp12, label %while.body13, label %while.end17

while.body13:                                     ; preds = %while.cond11
  %12 = load i32* %idx, align 4
  %arrayidx14 = getelementptr inbounds [16 x i32]* @array_3, i32 0, i32 %12
  %13 = load i32* %arrayidx14, align 4
  %call15 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([4 x i8]* @.str1, i32 0, i32 0), i32 %13)
  %14 = load i32* %idx, align 4
  %add16 = add nsw i32 %14, 1
  store i32 %add16, i32* %idx, align 4
  br label %while.cond11

while.end17:                                      ; preds = %while.cond11
  %call18 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([11 x i8]* @.str4, i32 0, i32 0))
  store i32 0, i32* %idx, align 4
  br label %while.cond19

while.cond19:                                     ; preds = %while.body21, %while.end17
  %15 = load i32* %idx, align 4
  %16 = load i32* %bound, align 4
  %cmp20 = icmp slt i32 %15, %16
  br i1 %cmp20, label %while.body21, label %while.end25

while.body21:                                     ; preds = %while.cond19
  %17 = load i32* %idx, align 4
  %arrayidx22 = getelementptr inbounds [16 x i32]* @array_4, i32 0, i32 %17
  %18 = load i32* %arrayidx22, align 4
  %call23 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([4 x i8]* @.str1, i32 0, i32 0), i32 %18)
  %19 = load i32* %idx, align 4
  %add24 = add nsw i32 %19, 1
  store i32 %add24, i32* %idx, align 4
  br label %while.cond19

while.end25:                                      ; preds = %while.cond19
  %call26 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([2 x i8]* @.str5, i32 0, i32 0))
  ret void
}

declare i32 @printf(i8*, ...)

define i32 @main() nounwind {
entry:
  %retval = alloca i32, align 4
  %idx = alloca i32, align 4
  %bound = alloca i32, align 4
  %temp = alloca i32, align 4
  store i32 0, i32* %retval
  store i32 16, i32* %bound, align 4
  call void @populate_arrays()
  call void @print_arrays()
  store i32 16, i32* %bound, align 4
  store i32 0, i32* %idx, align 4
  br label %while.cond

while.cond:                                       ; preds = %if.end, %if.then, %entry
  %0 = load i32* %idx, align 4
  %1 = load i32* %bound, align 4
  %sub = sub nsw i32 %1, 1
  %cmp = icmp slt i32 %0, %sub
  br i1 %cmp, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %2 = load i32* %idx, align 4
  %arrayidx = getelementptr inbounds [16 x i32]* @array_1, i32 0, i32 %2
  %3 = load i32* %arrayidx, align 4
  %4 = load i32* %idx, align 4
  %add = add nsw i32 %4, 1
  %arrayidx1 = getelementptr inbounds [16 x i32]* @array_1, i32 0, i32 %add
  %5 = load i32* %arrayidx1, align 4
  %cmp2 = icmp sgt i32 %3, %5
  br i1 %cmp2, label %if.then, label %if.end

if.then:                                          ; preds = %while.body
  %6 = load i32* %idx, align 4
  %arrayidx3 = getelementptr inbounds [16 x i32]* @array_1, i32 0, i32 %6
  %7 = load i32* %arrayidx3, align 4
  store i32 %7, i32* %temp, align 4
  %8 = load i32* %idx, align 4
  %add4 = add nsw i32 %8, 1
  %arrayidx5 = getelementptr inbounds [16 x i32]* @array_1, i32 0, i32 %add4
  %9 = load i32* %arrayidx5, align 4
  %10 = load i32* %idx, align 4
  %arrayidx6 = getelementptr inbounds [16 x i32]* @array_1, i32 0, i32 %10
  store i32 %9, i32* %arrayidx6, align 4
  %11 = load i32* %temp, align 4
  %12 = load i32* %idx, align 4
  %add7 = add nsw i32 %12, 1
  %arrayidx8 = getelementptr inbounds [16 x i32]* @array_1, i32 0, i32 %add7
  store i32 %11, i32* %arrayidx8, align 4
  store i32 0, i32* %idx, align 4
  br label %while.cond

if.end:                                           ; preds = %while.body
  %13 = load i32* %idx, align 4
  %add9 = add nsw i32 %13, 1
  store i32 %add9, i32* %idx, align 4
  br label %while.cond

while.end:                                        ; preds = %while.cond
  store i32 0, i32* %idx, align 4
  br label %while.cond10

while.cond10:                                     ; preds = %if.end25, %if.then18, %while.end
  %14 = load i32* %idx, align 4
  %15 = load i32* %bound, align 4
  %sub11 = sub nsw i32 %15, 1
  %cmp12 = icmp slt i32 %14, %sub11
  br i1 %cmp12, label %while.body13, label %while.end27

while.body13:                                     ; preds = %while.cond10
  %16 = load i32* %idx, align 4
  %arrayidx14 = getelementptr inbounds [16 x i32]* @array_2, i32 0, i32 %16
  %17 = load i32* %arrayidx14, align 4
  %18 = load i32* %idx, align 4
  %add15 = add nsw i32 %18, 1
  %arrayidx16 = getelementptr inbounds [16 x i32]* @array_2, i32 0, i32 %add15
  %19 = load i32* %arrayidx16, align 4
  %cmp17 = icmp sgt i32 %17, %19
  br i1 %cmp17, label %if.then18, label %if.end25

if.then18:                                        ; preds = %while.body13
  %20 = load i32* %idx, align 4
  %arrayidx19 = getelementptr inbounds [16 x i32]* @array_2, i32 0, i32 %20
  %21 = load i32* %arrayidx19, align 4
  store i32 %21, i32* %temp, align 4
  %22 = load i32* %idx, align 4
  %add20 = add nsw i32 %22, 1
  %arrayidx21 = getelementptr inbounds [16 x i32]* @array_2, i32 0, i32 %add20
  %23 = load i32* %arrayidx21, align 4
  %24 = load i32* %idx, align 4
  %arrayidx22 = getelementptr inbounds [16 x i32]* @array_2, i32 0, i32 %24
  store i32 %23, i32* %arrayidx22, align 4
  %25 = load i32* %temp, align 4
  %26 = load i32* %idx, align 4
  %add23 = add nsw i32 %26, 1
  %arrayidx24 = getelementptr inbounds [16 x i32]* @array_2, i32 0, i32 %add23
  store i32 %25, i32* %arrayidx24, align 4
  store i32 0, i32* %idx, align 4
  br label %while.cond10

if.end25:                                         ; preds = %while.body13
  %27 = load i32* %idx, align 4
  %add26 = add nsw i32 %27, 1
  store i32 %add26, i32* %idx, align 4
  br label %while.cond10

while.end27:                                      ; preds = %while.cond10
  store i32 0, i32* %idx, align 4
  br label %while.cond28

while.cond28:                                     ; preds = %if.end43, %if.then36, %while.end27
  %28 = load i32* %idx, align 4
  %29 = load i32* %bound, align 4
  %sub29 = sub nsw i32 %29, 1
  %cmp30 = icmp slt i32 %28, %sub29
  br i1 %cmp30, label %while.body31, label %while.end45

while.body31:                                     ; preds = %while.cond28
  %30 = load i32* %idx, align 4
  %arrayidx32 = getelementptr inbounds [16 x i32]* @array_3, i32 0, i32 %30
  %31 = load i32* %arrayidx32, align 4
  %32 = load i32* %idx, align 4
  %add33 = add nsw i32 %32, 1
  %arrayidx34 = getelementptr inbounds [16 x i32]* @array_3, i32 0, i32 %add33
  %33 = load i32* %arrayidx34, align 4
  %cmp35 = icmp sgt i32 %31, %33
  br i1 %cmp35, label %if.then36, label %if.end43

if.then36:                                        ; preds = %while.body31
  %34 = load i32* %idx, align 4
  %arrayidx37 = getelementptr inbounds [16 x i32]* @array_1, i32 0, i32 %34
  %35 = load i32* %arrayidx37, align 4
  store i32 %35, i32* %temp, align 4
  %36 = load i32* %idx, align 4
  %add38 = add nsw i32 %36, 1
  %arrayidx39 = getelementptr inbounds [16 x i32]* @array_3, i32 0, i32 %add38
  %37 = load i32* %arrayidx39, align 4
  %38 = load i32* %idx, align 4
  %arrayidx40 = getelementptr inbounds [16 x i32]* @array_3, i32 0, i32 %38
  store i32 %37, i32* %arrayidx40, align 4
  %39 = load i32* %temp, align 4
  %40 = load i32* %idx, align 4
  %add41 = add nsw i32 %40, 1
  %arrayidx42 = getelementptr inbounds [16 x i32]* @array_3, i32 0, i32 %add41
  store i32 %39, i32* %arrayidx42, align 4
  store i32 0, i32* %idx, align 4
  br label %while.cond28

if.end43:                                         ; preds = %while.body31
  %41 = load i32* %idx, align 4
  %add44 = add nsw i32 %41, 1
  store i32 %add44, i32* %idx, align 4
  br label %while.cond28

while.end45:                                      ; preds = %while.cond28
  store i32 0, i32* %idx, align 4
  br label %while.cond46

while.cond46:                                     ; preds = %if.end61, %if.then54, %while.end45
  %42 = load i32* %idx, align 4
  %43 = load i32* %bound, align 4
  %sub47 = sub nsw i32 %43, 1
  %cmp48 = icmp slt i32 %42, %sub47
  br i1 %cmp48, label %while.body49, label %while.end63

while.body49:                                     ; preds = %while.cond46
  %44 = load i32* %idx, align 4
  %arrayidx50 = getelementptr inbounds [16 x i32]* @array_4, i32 0, i32 %44
  %45 = load i32* %arrayidx50, align 4
  %46 = load i32* %idx, align 4
  %add51 = add nsw i32 %46, 1
  %arrayidx52 = getelementptr inbounds [16 x i32]* @array_4, i32 0, i32 %add51
  %47 = load i32* %arrayidx52, align 4
  %cmp53 = icmp sgt i32 %45, %47
  br i1 %cmp53, label %if.then54, label %if.end61

if.then54:                                        ; preds = %while.body49
  %48 = load i32* %idx, align 4
  %arrayidx55 = getelementptr inbounds [16 x i32]* @array_4, i32 0, i32 %48
  %49 = load i32* %arrayidx55, align 4
  store i32 %49, i32* %temp, align 4
  %50 = load i32* %idx, align 4
  %add56 = add nsw i32 %50, 1
  %arrayidx57 = getelementptr inbounds [16 x i32]* @array_4, i32 0, i32 %add56
  %51 = load i32* %arrayidx57, align 4
  %52 = load i32* %idx, align 4
  %arrayidx58 = getelementptr inbounds [16 x i32]* @array_4, i32 0, i32 %52
  store i32 %51, i32* %arrayidx58, align 4
  %53 = load i32* %temp, align 4
  %54 = load i32* %idx, align 4
  %add59 = add nsw i32 %54, 1
  %arrayidx60 = getelementptr inbounds [16 x i32]* @array_4, i32 0, i32 %add59
  store i32 %53, i32* %arrayidx60, align 4
  store i32 0, i32* %idx, align 4
  br label %while.cond46

if.end61:                                         ; preds = %while.body49
  %55 = load i32* %idx, align 4
  %add62 = add nsw i32 %55, 1
  store i32 %add62, i32* %idx, align 4
  br label %while.cond46

while.end63:                                      ; preds = %while.cond46
  call void @print_arrays()
  %56 = load i32* %retval
  ret i32 %56
}
