; ModuleID = 'jacobi.c.bc'
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:32:32-n8:16:32-S128"
target triple = "i386-pc-linux-gnu"

@a = common global [144 x i32] zeroinitializer, align 4
@b = common global [144 x i32] zeroinitializer, align 4
@.str = private unnamed_addr constant [27 x i8] c"The sampled element is %d\0A\00", align 1

define i32 @main() nounwind {
entry:
  %retval = alloca i32, align 4
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  store i32 0, i32* %retval
  store i32 0, i32* %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc16, %entry
  %0 = load i32* %i, align 4
  %cmp = icmp slt i32 %0, 12
  br i1 %cmp, label %for.body, label %for.end18

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
  %arrayidx = getelementptr inbounds [144 x i32]* @a, i32 0, i32 %add7
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
  %arrayidx15 = getelementptr inbounds [144 x i32]* @b, i32 0, i32 %add14
  store i32 %conv12, i32* %arrayidx15, align 4
  br label %for.inc

for.inc:                                          ; preds = %for.body3
  %10 = load i32* %j, align 4
  %inc = add nsw i32 %10, 1
  store i32 %inc, i32* %j, align 4
  br label %for.cond1

for.end:                                          ; preds = %for.cond1
  br label %for.inc16

for.inc16:                                        ; preds = %for.end
  %11 = load i32* %i, align 4
  %inc17 = add nsw i32 %11, 1
  store i32 %inc17, i32* %i, align 4
  br label %for.cond

for.end18:                                        ; preds = %for.cond
  store i32 0, i32* %i, align 4
  br label %for.cond19

for.cond19:                                       ; preds = %for.inc52, %for.end18
  %12 = load i32* %i, align 4
  %cmp20 = icmp slt i32 %12, 11
  br i1 %cmp20, label %for.body22, label %for.end54

for.body22:                                       ; preds = %for.cond19
  store i32 0, i32* %j, align 4
  br label %for.cond23

for.cond23:                                       ; preds = %for.inc49, %for.body22
  %13 = load i32* %j, align 4
  %cmp24 = icmp slt i32 %13, 11
  br i1 %cmp24, label %for.body26, label %for.end51

for.body26:                                       ; preds = %for.cond23
  %14 = load i32* %i, align 4
  %sub = sub nsw i32 %14, 1
  %15 = load i32* %j, align 4
  %mul27 = mul nsw i32 %15, 12
  %add28 = add nsw i32 %sub, %mul27
  %arrayidx29 = getelementptr inbounds [144 x i32]* @b, i32 0, i32 %add28
  %16 = load i32* %arrayidx29, align 4
  %17 = load i32* %i, align 4
  %add30 = add nsw i32 %17, 1
  %18 = load i32* %j, align 4
  %mul31 = mul nsw i32 %18, 12
  %add32 = add nsw i32 %add30, %mul31
  %arrayidx33 = getelementptr inbounds [144 x i32]* @b, i32 0, i32 %add32
  %19 = load i32* %arrayidx33, align 4
  %add34 = add nsw i32 %16, %19
  %20 = load i32* %i, align 4
  %21 = load i32* %j, align 4
  %add35 = add nsw i32 %20, %21
  %sub36 = sub nsw i32 %add35, 12
  %arrayidx37 = getelementptr inbounds [144 x i32]* @b, i32 0, i32 %sub36
  %22 = load i32* %arrayidx37, align 4
  %add38 = add nsw i32 %add34, %22
  %23 = load i32* %i, align 4
  %24 = load i32* %j, align 4
  %add39 = add nsw i32 %23, %24
  %add40 = add nsw i32 %add39, 12
  %arrayidx41 = getelementptr inbounds [144 x i32]* @b, i32 0, i32 %add40
  %25 = load i32* %arrayidx41, align 4
  %add42 = add nsw i32 %add38, %25
  %conv43 = sitofp i32 %add42 to double
  %mul44 = fmul double 2.500000e-01, %conv43
  %conv45 = fptosi double %mul44 to i32
  %26 = load i32* %i, align 4
  %27 = load i32* %j, align 4
  %mul46 = mul nsw i32 %27, 12
  %add47 = add nsw i32 %26, %mul46
  %arrayidx48 = getelementptr inbounds [144 x i32]* @a, i32 0, i32 %add47
  store i32 %conv45, i32* %arrayidx48, align 4
  br label %for.inc49

for.inc49:                                        ; preds = %for.body26
  %28 = load i32* %j, align 4
  %inc50 = add nsw i32 %28, 1
  store i32 %inc50, i32* %j, align 4
  br label %for.cond23

for.end51:                                        ; preds = %for.cond23
  br label %for.inc52

for.inc52:                                        ; preds = %for.end51
  %29 = load i32* %i, align 4
  %inc53 = add nsw i32 %29, 1
  store i32 %inc53, i32* %i, align 4
  br label %for.cond19

for.end54:                                        ; preds = %for.cond19
  store i32 0, i32* %i, align 4
  br label %for.cond55

for.cond55:                                       ; preds = %for.inc72, %for.end54
  %30 = load i32* %i, align 4
  %cmp56 = icmp slt i32 %30, 11
  br i1 %cmp56, label %for.body58, label %for.end74

for.body58:                                       ; preds = %for.cond55
  store i32 0, i32* %j, align 4
  br label %for.cond59

for.cond59:                                       ; preds = %for.inc69, %for.body58
  %31 = load i32* %j, align 4
  %cmp60 = icmp slt i32 %31, 11
  br i1 %cmp60, label %for.body62, label %for.end71

for.body62:                                       ; preds = %for.cond59
  %32 = load i32* %i, align 4
  %33 = load i32* %j, align 4
  %mul63 = mul nsw i32 %33, 12
  %add64 = add nsw i32 %32, %mul63
  %arrayidx65 = getelementptr inbounds [144 x i32]* @a, i32 0, i32 %add64
  %34 = load i32* %arrayidx65, align 4
  %35 = load i32* %i, align 4
  %36 = load i32* %j, align 4
  %mul66 = mul nsw i32 %36, 12
  %add67 = add nsw i32 %35, %mul66
  %arrayidx68 = getelementptr inbounds [144 x i32]* @b, i32 0, i32 %add67
  store i32 %34, i32* %arrayidx68, align 4
  br label %for.inc69

for.inc69:                                        ; preds = %for.body62
  %37 = load i32* %j, align 4
  %inc70 = add nsw i32 %37, 1
  store i32 %inc70, i32* %j, align 4
  br label %for.cond59

for.end71:                                        ; preds = %for.cond59
  br label %for.inc72

for.inc72:                                        ; preds = %for.end71
  %38 = load i32* %i, align 4
  %inc73 = add nsw i32 %38, 1
  store i32 %inc73, i32* %i, align 4
  br label %for.cond55

for.end74:                                        ; preds = %for.cond55
  %39 = load i32* getelementptr inbounds ([144 x i32]* @b, i32 0, i32 78), align 4
  %call = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([27 x i8]* @.str, i32 0, i32 0), i32 %39)
  ret i32 0
}

declare i32 @printf(i8*, ...)
