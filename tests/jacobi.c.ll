; ModuleID = '<stdin>'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@a = common global [144 x i32] zeroinitializer, align 16
@b = common global [144 x i32] zeroinitializer, align 16
@.str = private unnamed_addr constant [27 x i8] c"The sampled element is %d\0A\00", align 1

; Function Attrs: nounwind uwtable
define i32 @main() #0 {
entry:
  %retval = alloca i32, align 4
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  %"reg2mem alloca point" = bitcast i32 0 to i32
  store i32 0, i32* %retval
  store i32 0, i32* %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc17, %entry
  %0 = load i32* %i, align 4
  %cmp = icmp slt i32 %0, 12
  br i1 %cmp, label %for.body, label %for.end19

for.body:                                         ; preds = %for.cond
  store i32 0, i32* %j, align 4
  br label %for.cond1

for.cond1:                                        ; preds = %for.inc, %for.body
  %1 = load i32* %j, align 4
  %cmp2 = icmp slt i32 %1, 12
  br i1 %cmp2, label %for.body3, label %for.end

for.body3:                                        ; preds = %for.cond1
  %2 = load i32* %i, align 4
  %conv = sitofp i32 %2 to double
  %add = fadd double 1.200000e+01, %conv
  %3 = load i32* %j, align 4
  %conv4 = sitofp i32 %3 to double
  %add5 = fadd double %add, %conv4
  %conv6 = fptosi double %add5 to i32
  %4 = load i32* %j, align 4
  %5 = load i32* %i, align 4
  %mul = mul nsw i32 %5, 12
  %add7 = add nsw i32 %4, %mul
  %idxprom = sext i32 %add7 to i64
  %arrayidx = getelementptr inbounds [144 x i32]* @a, i32 0, i64 %idxprom
  store i32 %conv6, i32* %arrayidx, align 4
  %6 = load i32* %i, align 4
  %conv8 = sitofp i32 %6 to double
  %add9 = fadd double 1.200000e+01, %conv8
  %7 = load i32* %j, align 4
  %conv10 = sitofp i32 %7 to double
  %add11 = fadd double %add9, %conv10
  %conv12 = fptosi double %add11 to i32
  %8 = load i32* %j, align 4
  %9 = load i32* %i, align 4
  %mul13 = mul nsw i32 %9, 12
  %add14 = add nsw i32 %8, %mul13
  %idxprom15 = sext i32 %add14 to i64
  %arrayidx16 = getelementptr inbounds [144 x i32]* @b, i32 0, i64 %idxprom15
  store i32 %conv12, i32* %arrayidx16, align 4
  br label %for.inc

for.inc:                                          ; preds = %for.body3
  %10 = load i32* %j, align 4
  %inc = add nsw i32 %10, 1
  store i32 %inc, i32* %j, align 4
  br label %for.cond1

for.end:                                          ; preds = %for.cond1
  br label %for.inc17

for.inc17:                                        ; preds = %for.end
  %11 = load i32* %i, align 4
  %inc18 = add nsw i32 %11, 1
  store i32 %inc18, i32* %i, align 4
  br label %for.cond

for.end19:                                        ; preds = %for.cond
  store i32 0, i32* %i, align 4
  br label %for.cond20

for.cond20:                                       ; preds = %for.inc58, %for.end19
  %12 = load i32* %i, align 4
  %cmp21 = icmp slt i32 %12, 11
  br i1 %cmp21, label %for.body23, label %for.end60

for.body23:                                       ; preds = %for.cond20
  store i32 0, i32* %j, align 4
  br label %for.cond24

for.cond24:                                       ; preds = %for.inc55, %for.body23
  %13 = load i32* %j, align 4
  %cmp25 = icmp slt i32 %13, 11
  br i1 %cmp25, label %for.body27, label %for.end57

for.body27:                                       ; preds = %for.cond24
  %14 = load i32* %i, align 4
  %sub = sub nsw i32 %14, 1
  %15 = load i32* %j, align 4
  %mul28 = mul nsw i32 %15, 12
  %add29 = add nsw i32 %sub, %mul28
  %idxprom30 = sext i32 %add29 to i64
  %arrayidx31 = getelementptr inbounds [144 x i32]* @b, i32 0, i64 %idxprom30
  %16 = load i32* %arrayidx31, align 4
  %17 = load i32* %i, align 4
  %add32 = add nsw i32 %17, 1
  %18 = load i32* %j, align 4
  %mul33 = mul nsw i32 %18, 12
  %add34 = add nsw i32 %add32, %mul33
  %idxprom35 = sext i32 %add34 to i64
  %arrayidx36 = getelementptr inbounds [144 x i32]* @b, i32 0, i64 %idxprom35
  %19 = load i32* %arrayidx36, align 4
  %add37 = add nsw i32 %16, %19
  %20 = load i32* %i, align 4
  %21 = load i32* %j, align 4
  %add38 = add nsw i32 %20, %21
  %sub39 = sub nsw i32 %add38, 12
  %idxprom40 = sext i32 %sub39 to i64
  %arrayidx41 = getelementptr inbounds [144 x i32]* @b, i32 0, i64 %idxprom40
  %22 = load i32* %arrayidx41, align 4
  %add42 = add nsw i32 %add37, %22
  %23 = load i32* %i, align 4
  %24 = load i32* %j, align 4
  %add43 = add nsw i32 %23, %24
  %add44 = add nsw i32 %add43, 12
  %idxprom45 = sext i32 %add44 to i64
  %arrayidx46 = getelementptr inbounds [144 x i32]* @b, i32 0, i64 %idxprom45
  %25 = load i32* %arrayidx46, align 4
  %add47 = add nsw i32 %add42, %25
  %conv48 = sitofp i32 %add47 to double
  %mul49 = fmul double 2.500000e-01, %conv48
  %conv50 = fptosi double %mul49 to i32
  %26 = load i32* %i, align 4
  %27 = load i32* %j, align 4
  %mul51 = mul nsw i32 %27, 12
  %add52 = add nsw i32 %26, %mul51
  %idxprom53 = sext i32 %add52 to i64
  %arrayidx54 = getelementptr inbounds [144 x i32]* @a, i32 0, i64 %idxprom53
  store i32 %conv50, i32* %arrayidx54, align 4
  br label %for.inc55

for.inc55:                                        ; preds = %for.body27
  %28 = load i32* %j, align 4
  %inc56 = add nsw i32 %28, 1
  store i32 %inc56, i32* %j, align 4
  br label %for.cond24

for.end57:                                        ; preds = %for.cond24
  br label %for.inc58

for.inc58:                                        ; preds = %for.end57
  %29 = load i32* %i, align 4
  %inc59 = add nsw i32 %29, 1
  store i32 %inc59, i32* %i, align 4
  br label %for.cond20

for.end60:                                        ; preds = %for.cond20
  store i32 0, i32* %i, align 4
  br label %for.cond61

for.cond61:                                       ; preds = %for.inc80, %for.end60
  %30 = load i32* %i, align 4
  %cmp62 = icmp slt i32 %30, 11
  br i1 %cmp62, label %for.body64, label %for.end82

for.body64:                                       ; preds = %for.cond61
  store i32 0, i32* %j, align 4
  br label %for.cond65

for.cond65:                                       ; preds = %for.inc77, %for.body64
  %31 = load i32* %j, align 4
  %cmp66 = icmp slt i32 %31, 11
  br i1 %cmp66, label %for.body68, label %for.end79

for.body68:                                       ; preds = %for.cond65
  %32 = load i32* %i, align 4
  %33 = load i32* %j, align 4
  %mul69 = mul nsw i32 %33, 12
  %add70 = add nsw i32 %32, %mul69
  %idxprom71 = sext i32 %add70 to i64
  %arrayidx72 = getelementptr inbounds [144 x i32]* @a, i32 0, i64 %idxprom71
  %34 = load i32* %arrayidx72, align 4
  %35 = load i32* %i, align 4
  %36 = load i32* %j, align 4
  %mul73 = mul nsw i32 %36, 12
  %add74 = add nsw i32 %35, %mul73
  %idxprom75 = sext i32 %add74 to i64
  %arrayidx76 = getelementptr inbounds [144 x i32]* @b, i32 0, i64 %idxprom75
  store i32 %34, i32* %arrayidx76, align 4
  br label %for.inc77

for.inc77:                                        ; preds = %for.body68
  %37 = load i32* %j, align 4
  %inc78 = add nsw i32 %37, 1
  store i32 %inc78, i32* %j, align 4
  br label %for.cond65

for.end79:                                        ; preds = %for.cond65
  br label %for.inc80

for.inc80:                                        ; preds = %for.end79
  %38 = load i32* %i, align 4
  %inc81 = add nsw i32 %38, 1
  store i32 %inc81, i32* %i, align 4
  br label %for.cond61

for.end82:                                        ; preds = %for.cond61
  %39 = load i32* getelementptr inbounds ([144 x i32]* @b, i32 0, i64 78), align 4
  %call = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([27 x i8]* @.str, i32 0, i32 0), i32 %39)
  ret i32 0
}

declare i32 @printf(i8*, ...) #1

attributes #0 = { nounwind uwtable "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf"="true" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf"="true" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "unsafe-fp-math"="false" "use-soft-float"="false" }
