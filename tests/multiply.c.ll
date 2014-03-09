; ModuleID = '<stdin>'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@.str = private unnamed_addr constant [3 x i8] c"%d\00", align 1
@.str1 = private unnamed_addr constant [45 x i8] c"I need a non-negative number less than 100: \00", align 1
@.str2 = private unnamed_addr constant [55 x i8] c"Please give the size of the vectors to be multiplied: \00", align 1
@.str3 = private unnamed_addr constant [3 x i8] c"0\0A\00", align 1

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
define i32 @main() #0 {
entry:
  %retval = alloca i32, align 4
  %A = alloca [100 x i32], align 16
  %B = alloca [100 x i32], align 16
  %size = alloca i32, align 4
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  %result = alloca i32, align 4
  %"reg2mem alloca point" = bitcast i32 0 to i32
  store i32 0, i32* %retval
  %call = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([55 x i8]* @.str2, i32 0, i32 0))
  %call1 = call i32 @getinput()
  store i32 %call1, i32* %size, align 4
  %arrayidx = getelementptr inbounds [100 x i32]* %A, i32 0, i64 0
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
  %idxprom = sext i32 %sub to i64
  %arrayidx2 = getelementptr inbounds [100 x i32]* %A, i32 0, i64 %idxprom
  %3 = load i32* %arrayidx2, align 4
  %4 = load i32* %i, align 4
  %5 = load i32* %i, align 4
  %mul = mul nsw i32 %4, %5
  %add = add nsw i32 %3, %mul
  %6 = load i32* %i, align 4
  %idxprom3 = sext i32 %6 to i64
  %arrayidx4 = getelementptr inbounds [100 x i32]* %A, i32 0, i64 %idxprom3
  store i32 %add, i32* %arrayidx4, align 4
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %7 = load i32* %i, align 4
  %inc = add nsw i32 %7, 1
  store i32 %inc, i32* %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %arrayidx5 = getelementptr inbounds [100 x i32]* %B, i32 0, i64 0
  store i32 0, i32* %arrayidx5, align 4
  store i32 1, i32* %i, align 4
  br label %for.cond6

for.cond6:                                        ; preds = %for.inc15, %for.end
  %8 = load i32* %i, align 4
  %9 = load i32* %size, align 4
  %cmp7 = icmp slt i32 %8, %9
  br i1 %cmp7, label %for.body8, label %for.end17

for.body8:                                        ; preds = %for.cond6
  %10 = load i32* %i, align 4
  %11 = load i32* %i, align 4
  %sub9 = sub nsw i32 %11, 1
  %idxprom10 = sext i32 %sub9 to i64
  %arrayidx11 = getelementptr inbounds [100 x i32]* %B, i32 0, i64 %idxprom10
  %12 = load i32* %arrayidx11, align 4
  %add12 = add nsw i32 %10, %12
  %13 = load i32* %i, align 4
  %idxprom13 = sext i32 %13 to i64
  %arrayidx14 = getelementptr inbounds [100 x i32]* %B, i32 0, i64 %idxprom13
  store i32 %add12, i32* %arrayidx14, align 4
  br label %for.inc15

for.inc15:                                        ; preds = %for.body8
  %14 = load i32* %i, align 4
  %inc16 = add nsw i32 %14, 1
  store i32 %inc16, i32* %i, align 4
  br label %for.cond6

for.end17:                                        ; preds = %for.cond6
  store i32 0, i32* %result, align 4
  store i32 0, i32* %i, align 4
  br label %for.cond18

for.cond18:                                       ; preds = %for.inc27, %for.end17
  %15 = load i32* %i, align 4
  %16 = load i32* %size, align 4
  %cmp19 = icmp slt i32 %15, %16
  br i1 %cmp19, label %for.body20, label %for.end29

for.body20:                                       ; preds = %for.cond18
  %17 = load i32* %i, align 4
  %idxprom21 = sext i32 %17 to i64
  %arrayidx22 = getelementptr inbounds [100 x i32]* %A, i32 0, i64 %idxprom21
  %18 = load i32* %arrayidx22, align 4
  %19 = load i32* %i, align 4
  %idxprom23 = sext i32 %19 to i64
  %arrayidx24 = getelementptr inbounds [100 x i32]* %B, i32 0, i64 %idxprom23
  %20 = load i32* %arrayidx24, align 4
  %mul25 = mul nsw i32 %18, %20
  %21 = load i32* %result, align 4
  %add26 = add nsw i32 %21, %mul25
  store i32 %add26, i32* %result, align 4
  br label %for.inc27

for.inc27:                                        ; preds = %for.body20
  %22 = load i32* %i, align 4
  %inc28 = add nsw i32 %22, 1
  store i32 %inc28, i32* %i, align 4
  br label %for.cond18

for.end29:                                        ; preds = %for.cond18
  %call30 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([3 x i8]* @.str3, i32 0, i32 0))
  %23 = load i32* %retval
  ret i32 %23
}

attributes #0 = { nounwind uwtable "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf"="true" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf"="true" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "unsafe-fp-math"="false" "use-soft-float"="false" }
