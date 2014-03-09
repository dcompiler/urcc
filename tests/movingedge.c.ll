; ModuleID = '<stdin>'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@magic = global i32 35, align 4
@nbr_5 = common global [5 x i32] zeroinitializer, align 16
@.str = private unnamed_addr constant [3 x i8] c"%d\00", align 1
@.str1 = private unnamed_addr constant [45 x i8] c"I need a non-negative number less than 100: \00", align 1
@V = common global [100 x i32] zeroinitializer, align 16
@.str2 = private unnamed_addr constant [56 x i8] c"Please input the size of the vector to be transformed: \00", align 1
@.str3 = private unnamed_addr constant [18 x i8] c"Original vector:\0A\00", align 1
@.str4 = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1
@.str5 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str6 = private unnamed_addr constant [21 x i8] c"Moving edge vector:\0A\00", align 1

; Function Attrs: nounwind uwtable
define void @init_nbr() #0 {
entry:
  %"reg2mem alloca point" = bitcast i32 0 to i32
  store i32 -3, i32* getelementptr inbounds ([5 x i32]* @nbr_5, i32 0, i64 0), align 4
  store i32 12, i32* getelementptr inbounds ([5 x i32]* @nbr_5, i32 0, i64 1), align 4
  store i32 17, i32* getelementptr inbounds ([5 x i32]* @nbr_5, i32 0, i64 2), align 4
  store i32 12, i32* getelementptr inbounds ([5 x i32]* @nbr_5, i32 0, i64 3), align 4
  store i32 -3, i32* getelementptr inbounds ([5 x i32]* @nbr_5, i32 0, i64 4), align 4
  ret void
}

; Function Attrs: nounwind uwtable
define i32 @getinput() #0 {
entry:
  %a = alloca i32, align 4
  %"reg2mem alloca point" = bitcast i32 0 to i32
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
  br i1 %cmp1, label %while.body.if.then_crit_edge, label %lor.lhs.false

while.body.if.then_crit_edge:                     ; preds = %while.body
  br label %if.then

lor.lhs.false:                                    ; preds = %while.body
  %2 = load i32* %a, align 4
  %cmp2 = icmp sgt i32 %2, 100
  br i1 %cmp2, label %lor.lhs.false.if.then_crit_edge, label %lor.lhs.false.if.end_crit_edge

lor.lhs.false.if.end_crit_edge:                   ; preds = %lor.lhs.false
  br label %if.end

lor.lhs.false.if.then_crit_edge:                  ; preds = %lor.lhs.false
  br label %if.then

if.then:                                          ; preds = %lor.lhs.false.if.then_crit_edge, %while.body.if.then_crit_edge
  %call3 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([45 x i8]* @.str1, i32 0, i32 0))
  store i32 -1, i32* %a, align 4
  br label %if.end

if.end:                                           ; preds = %lor.lhs.false.if.end_crit_edge, %if.then
  br label %while.cond

while.end:                                        ; preds = %while.cond
  %3 = load i32* %a, align 4
  ret i32 %3
}

declare i32 @__isoc99_scanf(i8*, ...) #1

declare i32 @printf(i8*, ...) #1

; Function Attrs: nounwind uwtable
define void @moving(i32 %size) #0 {
entry:
  %size.addr = alloca i32, align 4
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  %temp = alloca i32, align 4
  %"reg2mem alloca point" = bitcast i32 0 to i32
  store i32 %size, i32* %size.addr, align 4
  store i32 2, i32* %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc10, %entry
  %0 = load i32* %i, align 4
  %1 = load i32* %size.addr, align 4
  %sub = sub nsw i32 %1, 2
  %cmp = icmp slt i32 %0, %sub
  br i1 %cmp, label %for.body, label %for.end12

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
  %idxprom = sext i32 %add to i64
  %arrayidx = getelementptr inbounds [100 x i32]* @V, i32 0, i64 %idxprom
  %5 = load i32* %arrayidx, align 4
  %6 = load i32* %j, align 4
  %add4 = add nsw i32 %6, 2
  %idxprom5 = sext i32 %add4 to i64
  %arrayidx6 = getelementptr inbounds [5 x i32]* @nbr_5, i32 0, i64 %idxprom5
  %7 = load i32* %arrayidx6, align 4
  %mul = mul nsw i32 %5, %7
  %8 = load i32* %temp, align 4
  %add7 = add nsw i32 %8, %mul
  store i32 %add7, i32* %temp, align 4
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
  %idxprom8 = sext i32 %12 to i64
  %arrayidx9 = getelementptr inbounds [100 x i32]* @V, i32 0, i64 %idxprom8
  store i32 %div, i32* %arrayidx9, align 4
  br label %for.inc10

for.inc10:                                        ; preds = %for.end
  %13 = load i32* %i, align 4
  %inc11 = add nsw i32 %13, 1
  store i32 %inc11, i32* %i, align 4
  br label %for.cond

for.end12:                                        ; preds = %for.cond
  ret void
}

; Function Attrs: nounwind uwtable
define i32 @main() #0 {
entry:
  %retval = alloca i32, align 4
  %size = alloca i32, align 4
  %i = alloca i32, align 4
  %"reg2mem alloca point" = bitcast i32 0 to i32
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
  %call2 = call i32 @rand() #3
  %rem = srem i32 %call2, 100
  %2 = load i32* %i, align 4
  %idxprom = sext i32 %2 to i64
  %arrayidx = getelementptr inbounds [100 x i32]* @V, i32 0, i64 %idxprom
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

for.cond4:                                        ; preds = %for.inc10, %for.end
  %4 = load i32* %i, align 4
  %5 = load i32* %size, align 4
  %cmp5 = icmp slt i32 %4, %5
  br i1 %cmp5, label %for.body6, label %for.end12

for.body6:                                        ; preds = %for.cond4
  %6 = load i32* %i, align 4
  %idxprom7 = sext i32 %6 to i64
  %arrayidx8 = getelementptr inbounds [100 x i32]* @V, i32 0, i64 %idxprom7
  %7 = load i32* %arrayidx8, align 4
  %call9 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([4 x i8]* @.str4, i32 0, i32 0), i32 %7)
  br label %for.inc10

for.inc10:                                        ; preds = %for.body6
  %8 = load i32* %i, align 4
  %inc11 = add nsw i32 %8, 1
  store i32 %inc11, i32* %i, align 4
  br label %for.cond4

for.end12:                                        ; preds = %for.cond4
  %call13 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([2 x i8]* @.str5, i32 0, i32 0))
  call void @init_nbr()
  %9 = load i32* %size, align 4
  call void @moving(i32 %9)
  %call14 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([21 x i8]* @.str6, i32 0, i32 0))
  store i32 0, i32* %i, align 4
  br label %for.cond15

for.cond15:                                       ; preds = %for.inc21, %for.end12
  %10 = load i32* %i, align 4
  %11 = load i32* %size, align 4
  %cmp16 = icmp slt i32 %10, %11
  br i1 %cmp16, label %for.body17, label %for.end23

for.body17:                                       ; preds = %for.cond15
  %12 = load i32* %i, align 4
  %idxprom18 = sext i32 %12 to i64
  %arrayidx19 = getelementptr inbounds [100 x i32]* @V, i32 0, i64 %idxprom18
  %13 = load i32* %arrayidx19, align 4
  %call20 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([4 x i8]* @.str4, i32 0, i32 0), i32 %13)
  br label %for.inc21

for.inc21:                                        ; preds = %for.body17
  %14 = load i32* %i, align 4
  %inc22 = add nsw i32 %14, 1
  store i32 %inc22, i32* %i, align 4
  br label %for.cond15

for.end23:                                        ; preds = %for.cond15
  %call24 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([2 x i8]* @.str5, i32 0, i32 0))
  %15 = load i32* %retval
  ret i32 %15
}

; Function Attrs: nounwind
declare i32 @rand() #2

attributes #0 = { nounwind uwtable "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf"="true" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf"="true" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #2 = { nounwind "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf"="true" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { nounwind }
