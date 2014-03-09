; ModuleID = '<stdin>'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@array_1 = common global [16 x i32] zeroinitializer, align 16
@array_2 = common global [16 x i32] zeroinitializer, align 16
@array_3 = common global [16 x i32] zeroinitializer, align 16
@array_4 = common global [16 x i32] zeroinitializer, align 16
@.str = private unnamed_addr constant [10 x i8] c"Array_1:\0A\00", align 1
@.str1 = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1
@.str2 = private unnamed_addr constant [11 x i8] c"\0AArray_2:\0A\00", align 1
@.str3 = private unnamed_addr constant [11 x i8] c"\0AArray_3:\0A\00", align 1
@.str4 = private unnamed_addr constant [11 x i8] c"\0AArray_4:\0A\00", align 1
@.str5 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1

; Function Attrs: nounwind uwtable
define void @populate_arrays() #0 {
entry:
  %"reg2mem alloca point" = bitcast i32 0 to i32
  store i32 0, i32* getelementptr inbounds ([16 x i32]* @array_1, i32 0, i64 0), align 4
  store i32 15, i32* getelementptr inbounds ([16 x i32]* @array_2, i32 0, i64 0), align 4
  store i32 5, i32* getelementptr inbounds ([16 x i32]* @array_3, i32 0, i64 0), align 4
  store i32 13, i32* getelementptr inbounds ([16 x i32]* @array_4, i32 0, i64 0), align 4
  store i32 1, i32* getelementptr inbounds ([16 x i32]* @array_1, i32 0, i64 1), align 4
  store i32 14, i32* getelementptr inbounds ([16 x i32]* @array_2, i32 0, i64 1), align 4
  store i32 5, i32* getelementptr inbounds ([16 x i32]* @array_3, i32 0, i64 1), align 4
  store i32 9, i32* getelementptr inbounds ([16 x i32]* @array_4, i32 0, i64 1), align 4
  store i32 2, i32* getelementptr inbounds ([16 x i32]* @array_1, i32 0, i64 2), align 4
  store i32 13, i32* getelementptr inbounds ([16 x i32]* @array_2, i32 0, i64 2), align 4
  store i32 5, i32* getelementptr inbounds ([16 x i32]* @array_3, i32 0, i64 2), align 4
  store i32 12, i32* getelementptr inbounds ([16 x i32]* @array_4, i32 0, i64 2), align 4
  store i32 3, i32* getelementptr inbounds ([16 x i32]* @array_1, i32 0, i64 3), align 4
  store i32 12, i32* getelementptr inbounds ([16 x i32]* @array_2, i32 0, i64 3), align 4
  store i32 5, i32* getelementptr inbounds ([16 x i32]* @array_3, i32 0, i64 3), align 4
  store i32 1, i32* getelementptr inbounds ([16 x i32]* @array_4, i32 0, i64 3), align 4
  store i32 4, i32* getelementptr inbounds ([16 x i32]* @array_1, i32 0, i64 4), align 4
  store i32 11, i32* getelementptr inbounds ([16 x i32]* @array_2, i32 0, i64 4), align 4
  store i32 5, i32* getelementptr inbounds ([16 x i32]* @array_3, i32 0, i64 4), align 4
  store i32 0, i32* getelementptr inbounds ([16 x i32]* @array_4, i32 0, i64 4), align 4
  store i32 5, i32* getelementptr inbounds ([16 x i32]* @array_1, i32 0, i64 5), align 4
  store i32 10, i32* getelementptr inbounds ([16 x i32]* @array_2, i32 0, i64 5), align 4
  store i32 5, i32* getelementptr inbounds ([16 x i32]* @array_3, i32 0, i64 5), align 4
  store i32 14, i32* getelementptr inbounds ([16 x i32]* @array_4, i32 0, i64 5), align 4
  store i32 6, i32* getelementptr inbounds ([16 x i32]* @array_1, i32 0, i64 6), align 4
  store i32 9, i32* getelementptr inbounds ([16 x i32]* @array_2, i32 0, i64 6), align 4
  store i32 5, i32* getelementptr inbounds ([16 x i32]* @array_3, i32 0, i64 6), align 4
  store i32 3, i32* getelementptr inbounds ([16 x i32]* @array_4, i32 0, i64 6), align 4
  store i32 7, i32* getelementptr inbounds ([16 x i32]* @array_1, i32 0, i64 7), align 4
  store i32 8, i32* getelementptr inbounds ([16 x i32]* @array_2, i32 0, i64 7), align 4
  store i32 5, i32* getelementptr inbounds ([16 x i32]* @array_3, i32 0, i64 7), align 4
  store i32 2, i32* getelementptr inbounds ([16 x i32]* @array_4, i32 0, i64 7), align 4
  store i32 8, i32* getelementptr inbounds ([16 x i32]* @array_1, i32 0, i64 8), align 4
  store i32 7, i32* getelementptr inbounds ([16 x i32]* @array_2, i32 0, i64 8), align 4
  store i32 5, i32* getelementptr inbounds ([16 x i32]* @array_3, i32 0, i64 8), align 4
  store i32 11, i32* getelementptr inbounds ([16 x i32]* @array_4, i32 0, i64 8), align 4
  store i32 9, i32* getelementptr inbounds ([16 x i32]* @array_1, i32 0, i64 9), align 4
  store i32 6, i32* getelementptr inbounds ([16 x i32]* @array_2, i32 0, i64 9), align 4
  store i32 5, i32* getelementptr inbounds ([16 x i32]* @array_3, i32 0, i64 9), align 4
  store i32 8, i32* getelementptr inbounds ([16 x i32]* @array_4, i32 0, i64 9), align 4
  store i32 10, i32* getelementptr inbounds ([16 x i32]* @array_1, i32 0, i64 10), align 4
  store i32 5, i32* getelementptr inbounds ([16 x i32]* @array_2, i32 0, i64 10), align 4
  store i32 5, i32* getelementptr inbounds ([16 x i32]* @array_3, i32 0, i64 10), align 4
  store i32 6, i32* getelementptr inbounds ([16 x i32]* @array_4, i32 0, i64 10), align 4
  store i32 11, i32* getelementptr inbounds ([16 x i32]* @array_1, i32 0, i64 11), align 4
  store i32 4, i32* getelementptr inbounds ([16 x i32]* @array_2, i32 0, i64 11), align 4
  store i32 5, i32* getelementptr inbounds ([16 x i32]* @array_3, i32 0, i64 11), align 4
  store i32 4, i32* getelementptr inbounds ([16 x i32]* @array_4, i32 0, i64 11), align 4
  store i32 12, i32* getelementptr inbounds ([16 x i32]* @array_1, i32 0, i64 12), align 4
  store i32 3, i32* getelementptr inbounds ([16 x i32]* @array_2, i32 0, i64 12), align 4
  store i32 5, i32* getelementptr inbounds ([16 x i32]* @array_3, i32 0, i64 12), align 4
  store i32 5, i32* getelementptr inbounds ([16 x i32]* @array_4, i32 0, i64 12), align 4
  store i32 13, i32* getelementptr inbounds ([16 x i32]* @array_1, i32 0, i64 13), align 4
  store i32 2, i32* getelementptr inbounds ([16 x i32]* @array_2, i32 0, i64 13), align 4
  store i32 5, i32* getelementptr inbounds ([16 x i32]* @array_3, i32 0, i64 13), align 4
  store i32 10, i32* getelementptr inbounds ([16 x i32]* @array_4, i32 0, i64 13), align 4
  store i32 14, i32* getelementptr inbounds ([16 x i32]* @array_1, i32 0, i64 14), align 4
  store i32 1, i32* getelementptr inbounds ([16 x i32]* @array_2, i32 0, i64 14), align 4
  store i32 5, i32* getelementptr inbounds ([16 x i32]* @array_3, i32 0, i64 14), align 4
  store i32 7, i32* getelementptr inbounds ([16 x i32]* @array_4, i32 0, i64 14), align 4
  store i32 15, i32* getelementptr inbounds ([16 x i32]* @array_1, i32 0, i64 15), align 4
  store i32 0, i32* getelementptr inbounds ([16 x i32]* @array_2, i32 0, i64 15), align 4
  store i32 5, i32* getelementptr inbounds ([16 x i32]* @array_3, i32 0, i64 15), align 4
  store i32 15, i32* getelementptr inbounds ([16 x i32]* @array_4, i32 0, i64 15), align 4
  ret void
}

; Function Attrs: nounwind uwtable
define void @print_arrays() #0 {
entry:
  %idx = alloca i32, align 4
  %bound = alloca i32, align 4
  %"reg2mem alloca point" = bitcast i32 0 to i32
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
  %idxprom = sext i32 %2 to i64
  %arrayidx = getelementptr inbounds [16 x i32]* @array_1, i32 0, i64 %idxprom
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
  br i1 %cmp4, label %while.body5, label %while.end10

while.body5:                                      ; preds = %while.cond3
  %7 = load i32* %idx, align 4
  %idxprom6 = sext i32 %7 to i64
  %arrayidx7 = getelementptr inbounds [16 x i32]* @array_2, i32 0, i64 %idxprom6
  %8 = load i32* %arrayidx7, align 4
  %call8 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([4 x i8]* @.str1, i32 0, i32 0), i32 %8)
  %9 = load i32* %idx, align 4
  %add9 = add nsw i32 %9, 1
  store i32 %add9, i32* %idx, align 4
  br label %while.cond3

while.end10:                                      ; preds = %while.cond3
  %call11 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([11 x i8]* @.str3, i32 0, i32 0))
  store i32 0, i32* %idx, align 4
  br label %while.cond12

while.cond12:                                     ; preds = %while.body14, %while.end10
  %10 = load i32* %idx, align 4
  %11 = load i32* %bound, align 4
  %cmp13 = icmp slt i32 %10, %11
  br i1 %cmp13, label %while.body14, label %while.end19

while.body14:                                     ; preds = %while.cond12
  %12 = load i32* %idx, align 4
  %idxprom15 = sext i32 %12 to i64
  %arrayidx16 = getelementptr inbounds [16 x i32]* @array_3, i32 0, i64 %idxprom15
  %13 = load i32* %arrayidx16, align 4
  %call17 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([4 x i8]* @.str1, i32 0, i32 0), i32 %13)
  %14 = load i32* %idx, align 4
  %add18 = add nsw i32 %14, 1
  store i32 %add18, i32* %idx, align 4
  br label %while.cond12

while.end19:                                      ; preds = %while.cond12
  %call20 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([11 x i8]* @.str4, i32 0, i32 0))
  store i32 0, i32* %idx, align 4
  br label %while.cond21

while.cond21:                                     ; preds = %while.body23, %while.end19
  %15 = load i32* %idx, align 4
  %16 = load i32* %bound, align 4
  %cmp22 = icmp slt i32 %15, %16
  br i1 %cmp22, label %while.body23, label %while.end28

while.body23:                                     ; preds = %while.cond21
  %17 = load i32* %idx, align 4
  %idxprom24 = sext i32 %17 to i64
  %arrayidx25 = getelementptr inbounds [16 x i32]* @array_4, i32 0, i64 %idxprom24
  %18 = load i32* %arrayidx25, align 4
  %call26 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([4 x i8]* @.str1, i32 0, i32 0), i32 %18)
  %19 = load i32* %idx, align 4
  %add27 = add nsw i32 %19, 1
  store i32 %add27, i32* %idx, align 4
  br label %while.cond21

while.end28:                                      ; preds = %while.cond21
  %call29 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([2 x i8]* @.str5, i32 0, i32 0))
  ret void
}

declare i32 @printf(i8*, ...) #1

; Function Attrs: nounwind uwtable
define i32 @main() #0 {
entry:
  %retval = alloca i32, align 4
  %idx = alloca i32, align 4
  %bound = alloca i32, align 4
  %temp = alloca i32, align 4
  %"reg2mem alloca point" = bitcast i32 0 to i32
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
  %idxprom = sext i32 %2 to i64
  %arrayidx = getelementptr inbounds [16 x i32]* @array_1, i32 0, i64 %idxprom
  %3 = load i32* %arrayidx, align 4
  %4 = load i32* %idx, align 4
  %add = add nsw i32 %4, 1
  %idxprom1 = sext i32 %add to i64
  %arrayidx2 = getelementptr inbounds [16 x i32]* @array_1, i32 0, i64 %idxprom1
  %5 = load i32* %arrayidx2, align 4
  %cmp3 = icmp sgt i32 %3, %5
  br i1 %cmp3, label %if.then, label %if.end

if.then:                                          ; preds = %while.body
  %6 = load i32* %idx, align 4
  %idxprom4 = sext i32 %6 to i64
  %arrayidx5 = getelementptr inbounds [16 x i32]* @array_1, i32 0, i64 %idxprom4
  %7 = load i32* %arrayidx5, align 4
  store i32 %7, i32* %temp, align 4
  %8 = load i32* %idx, align 4
  %add6 = add nsw i32 %8, 1
  %idxprom7 = sext i32 %add6 to i64
  %arrayidx8 = getelementptr inbounds [16 x i32]* @array_1, i32 0, i64 %idxprom7
  %9 = load i32* %arrayidx8, align 4
  %10 = load i32* %idx, align 4
  %idxprom9 = sext i32 %10 to i64
  %arrayidx10 = getelementptr inbounds [16 x i32]* @array_1, i32 0, i64 %idxprom9
  store i32 %9, i32* %arrayidx10, align 4
  %11 = load i32* %temp, align 4
  %12 = load i32* %idx, align 4
  %add11 = add nsw i32 %12, 1
  %idxprom12 = sext i32 %add11 to i64
  %arrayidx13 = getelementptr inbounds [16 x i32]* @array_1, i32 0, i64 %idxprom12
  store i32 %11, i32* %arrayidx13, align 4
  store i32 0, i32* %idx, align 4
  br label %while.cond

if.end:                                           ; preds = %while.body
  %13 = load i32* %idx, align 4
  %add14 = add nsw i32 %13, 1
  store i32 %add14, i32* %idx, align 4
  br label %while.cond

while.end:                                        ; preds = %while.cond
  store i32 0, i32* %idx, align 4
  br label %while.cond15

while.cond15:                                     ; preds = %if.end36, %if.then25, %while.end
  %14 = load i32* %idx, align 4
  %15 = load i32* %bound, align 4
  %sub16 = sub nsw i32 %15, 1
  %cmp17 = icmp slt i32 %14, %sub16
  br i1 %cmp17, label %while.body18, label %while.end38

while.body18:                                     ; preds = %while.cond15
  %16 = load i32* %idx, align 4
  %idxprom19 = sext i32 %16 to i64
  %arrayidx20 = getelementptr inbounds [16 x i32]* @array_2, i32 0, i64 %idxprom19
  %17 = load i32* %arrayidx20, align 4
  %18 = load i32* %idx, align 4
  %add21 = add nsw i32 %18, 1
  %idxprom22 = sext i32 %add21 to i64
  %arrayidx23 = getelementptr inbounds [16 x i32]* @array_2, i32 0, i64 %idxprom22
  %19 = load i32* %arrayidx23, align 4
  %cmp24 = icmp sgt i32 %17, %19
  br i1 %cmp24, label %if.then25, label %if.end36

if.then25:                                        ; preds = %while.body18
  %20 = load i32* %idx, align 4
  %idxprom26 = sext i32 %20 to i64
  %arrayidx27 = getelementptr inbounds [16 x i32]* @array_2, i32 0, i64 %idxprom26
  %21 = load i32* %arrayidx27, align 4
  store i32 %21, i32* %temp, align 4
  %22 = load i32* %idx, align 4
  %add28 = add nsw i32 %22, 1
  %idxprom29 = sext i32 %add28 to i64
  %arrayidx30 = getelementptr inbounds [16 x i32]* @array_2, i32 0, i64 %idxprom29
  %23 = load i32* %arrayidx30, align 4
  %24 = load i32* %idx, align 4
  %idxprom31 = sext i32 %24 to i64
  %arrayidx32 = getelementptr inbounds [16 x i32]* @array_2, i32 0, i64 %idxprom31
  store i32 %23, i32* %arrayidx32, align 4
  %25 = load i32* %temp, align 4
  %26 = load i32* %idx, align 4
  %add33 = add nsw i32 %26, 1
  %idxprom34 = sext i32 %add33 to i64
  %arrayidx35 = getelementptr inbounds [16 x i32]* @array_2, i32 0, i64 %idxprom34
  store i32 %25, i32* %arrayidx35, align 4
  store i32 0, i32* %idx, align 4
  br label %while.cond15

if.end36:                                         ; preds = %while.body18
  %27 = load i32* %idx, align 4
  %add37 = add nsw i32 %27, 1
  store i32 %add37, i32* %idx, align 4
  br label %while.cond15

while.end38:                                      ; preds = %while.cond15
  store i32 0, i32* %idx, align 4
  br label %while.cond39

while.cond39:                                     ; preds = %if.end60, %if.then49, %while.end38
  %28 = load i32* %idx, align 4
  %29 = load i32* %bound, align 4
  %sub40 = sub nsw i32 %29, 1
  %cmp41 = icmp slt i32 %28, %sub40
  br i1 %cmp41, label %while.body42, label %while.end62

while.body42:                                     ; preds = %while.cond39
  %30 = load i32* %idx, align 4
  %idxprom43 = sext i32 %30 to i64
  %arrayidx44 = getelementptr inbounds [16 x i32]* @array_3, i32 0, i64 %idxprom43
  %31 = load i32* %arrayidx44, align 4
  %32 = load i32* %idx, align 4
  %add45 = add nsw i32 %32, 1
  %idxprom46 = sext i32 %add45 to i64
  %arrayidx47 = getelementptr inbounds [16 x i32]* @array_3, i32 0, i64 %idxprom46
  %33 = load i32* %arrayidx47, align 4
  %cmp48 = icmp sgt i32 %31, %33
  br i1 %cmp48, label %if.then49, label %if.end60

if.then49:                                        ; preds = %while.body42
  %34 = load i32* %idx, align 4
  %idxprom50 = sext i32 %34 to i64
  %arrayidx51 = getelementptr inbounds [16 x i32]* @array_1, i32 0, i64 %idxprom50
  %35 = load i32* %arrayidx51, align 4
  store i32 %35, i32* %temp, align 4
  %36 = load i32* %idx, align 4
  %add52 = add nsw i32 %36, 1
  %idxprom53 = sext i32 %add52 to i64
  %arrayidx54 = getelementptr inbounds [16 x i32]* @array_3, i32 0, i64 %idxprom53
  %37 = load i32* %arrayidx54, align 4
  %38 = load i32* %idx, align 4
  %idxprom55 = sext i32 %38 to i64
  %arrayidx56 = getelementptr inbounds [16 x i32]* @array_3, i32 0, i64 %idxprom55
  store i32 %37, i32* %arrayidx56, align 4
  %39 = load i32* %temp, align 4
  %40 = load i32* %idx, align 4
  %add57 = add nsw i32 %40, 1
  %idxprom58 = sext i32 %add57 to i64
  %arrayidx59 = getelementptr inbounds [16 x i32]* @array_3, i32 0, i64 %idxprom58
  store i32 %39, i32* %arrayidx59, align 4
  store i32 0, i32* %idx, align 4
  br label %while.cond39

if.end60:                                         ; preds = %while.body42
  %41 = load i32* %idx, align 4
  %add61 = add nsw i32 %41, 1
  store i32 %add61, i32* %idx, align 4
  br label %while.cond39

while.end62:                                      ; preds = %while.cond39
  store i32 0, i32* %idx, align 4
  br label %while.cond63

while.cond63:                                     ; preds = %if.end84, %if.then73, %while.end62
  %42 = load i32* %idx, align 4
  %43 = load i32* %bound, align 4
  %sub64 = sub nsw i32 %43, 1
  %cmp65 = icmp slt i32 %42, %sub64
  br i1 %cmp65, label %while.body66, label %while.end86

while.body66:                                     ; preds = %while.cond63
  %44 = load i32* %idx, align 4
  %idxprom67 = sext i32 %44 to i64
  %arrayidx68 = getelementptr inbounds [16 x i32]* @array_4, i32 0, i64 %idxprom67
  %45 = load i32* %arrayidx68, align 4
  %46 = load i32* %idx, align 4
  %add69 = add nsw i32 %46, 1
  %idxprom70 = sext i32 %add69 to i64
  %arrayidx71 = getelementptr inbounds [16 x i32]* @array_4, i32 0, i64 %idxprom70
  %47 = load i32* %arrayidx71, align 4
  %cmp72 = icmp sgt i32 %45, %47
  br i1 %cmp72, label %if.then73, label %if.end84

if.then73:                                        ; preds = %while.body66
  %48 = load i32* %idx, align 4
  %idxprom74 = sext i32 %48 to i64
  %arrayidx75 = getelementptr inbounds [16 x i32]* @array_4, i32 0, i64 %idxprom74
  %49 = load i32* %arrayidx75, align 4
  store i32 %49, i32* %temp, align 4
  %50 = load i32* %idx, align 4
  %add76 = add nsw i32 %50, 1
  %idxprom77 = sext i32 %add76 to i64
  %arrayidx78 = getelementptr inbounds [16 x i32]* @array_4, i32 0, i64 %idxprom77
  %51 = load i32* %arrayidx78, align 4
  %52 = load i32* %idx, align 4
  %idxprom79 = sext i32 %52 to i64
  %arrayidx80 = getelementptr inbounds [16 x i32]* @array_4, i32 0, i64 %idxprom79
  store i32 %51, i32* %arrayidx80, align 4
  %53 = load i32* %temp, align 4
  %54 = load i32* %idx, align 4
  %add81 = add nsw i32 %54, 1
  %idxprom82 = sext i32 %add81 to i64
  %arrayidx83 = getelementptr inbounds [16 x i32]* @array_4, i32 0, i64 %idxprom82
  store i32 %53, i32* %arrayidx83, align 4
  store i32 0, i32* %idx, align 4
  br label %while.cond63

if.end84:                                         ; preds = %while.body66
  %55 = load i32* %idx, align 4
  %add85 = add nsw i32 %55, 1
  store i32 %add85, i32* %idx, align 4
  br label %while.cond63

while.end86:                                      ; preds = %while.cond63
  call void @print_arrays()
  %56 = load i32* %retval
  ret i32 %56
}

attributes #0 = { nounwind uwtable "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf"="true" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf"="true" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "unsafe-fp-math"="false" "use-soft-float"="false" }
