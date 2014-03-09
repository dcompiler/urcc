; ModuleID = '<stdin>'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@data = common global [30 x i32] zeroinitializer, align 16
@.str = private unnamed_addr constant [10 x i8] c"results:\0A\00", align 1
@.str1 = private unnamed_addr constant [8 x i8] c"%d: %d\0A\00", align 1

; Function Attrs: nounwind uwtable
define void @insertSort(i32 %lb, i32 %ub) #0 {
entry:
  %lb.addr = alloca i32, align 4
  %ub.addr = alloca i32, align 4
  %t = alloca i32, align 4
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  %cmp5.reg2mem = alloca i1
  %.reg2mem = alloca i1
  %"reg2mem alloca point" = bitcast i32 0 to i32
  store i32 %lb, i32* %lb.addr, align 4
  store i32 %ub, i32* %ub.addr, align 4
  %0 = load i32* %lb.addr, align 4
  %add = add nsw i32 %0, 1
  store i32 %add, i32* %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc15, %entry
  %1 = load i32* %i, align 4
  %2 = load i32* %ub.addr, align 4
  %cmp = icmp sle i32 %1, %2
  br i1 %cmp, label %for.body, label %for.end16

for.body:                                         ; preds = %for.cond
  %3 = load i32* %i, align 4
  %idxprom = sext i32 %3 to i64
  %arrayidx = getelementptr inbounds [30 x i32]* @data, i32 0, i64 %idxprom
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
  br i1 %cmp2, label %land.rhs, label %for.cond1.land.end_crit_edge

for.cond1.land.end_crit_edge:                     ; preds = %for.cond1
  store i1 false, i1* %.reg2mem
  br label %land.end

land.rhs:                                         ; preds = %for.cond1
  %8 = load i32* %j, align 4
  %idxprom3 = sext i32 %8 to i64
  %arrayidx4 = getelementptr inbounds [30 x i32]* @data, i32 0, i64 %idxprom3
  %9 = load i32* %arrayidx4, align 4
  %10 = load i32* %t, align 4
  %cmp5 = icmp sgt i32 %9, %10
  store i1 %cmp5, i1* %cmp5.reg2mem
  %cmp5.reload = load i1* %cmp5.reg2mem
  store i1 %cmp5.reload, i1* %.reg2mem
  br label %land.end

land.end:                                         ; preds = %for.cond1.land.end_crit_edge, %land.rhs
  %.reload = load i1* %.reg2mem
  br i1 %.reload, label %for.body6, label %for.end

for.body6:                                        ; preds = %land.end
  %11 = load i32* %j, align 4
  %idxprom7 = sext i32 %11 to i64
  %arrayidx8 = getelementptr inbounds [30 x i32]* @data, i32 0, i64 %idxprom7
  %12 = load i32* %arrayidx8, align 4
  %13 = load i32* %j, align 4
  %add9 = add nsw i32 %13, 1
  %idxprom10 = sext i32 %add9 to i64
  %arrayidx11 = getelementptr inbounds [30 x i32]* @data, i32 0, i64 %idxprom10
  store i32 %12, i32* %arrayidx11, align 4
  br label %for.inc

for.inc:                                          ; preds = %for.body6
  %14 = load i32* %j, align 4
  %dec = add nsw i32 %14, -1
  store i32 %dec, i32* %j, align 4
  br label %for.cond1

for.end:                                          ; preds = %land.end
  %15 = load i32* %t, align 4
  %16 = load i32* %j, align 4
  %add12 = add nsw i32 %16, 1
  %idxprom13 = sext i32 %add12 to i64
  %arrayidx14 = getelementptr inbounds [30 x i32]* @data, i32 0, i64 %idxprom13
  store i32 %15, i32* %arrayidx14, align 4
  br label %for.inc15

for.inc15:                                        ; preds = %for.end
  %17 = load i32* %i, align 4
  %inc = add nsw i32 %17, 1
  store i32 %inc, i32* %i, align 4
  br label %for.cond

for.end16:                                        ; preds = %for.cond
  ret void
}

; Function Attrs: nounwind uwtable
define void @fill(i32 %lb, i32 %ub) #0 {
entry:
  %lb.addr = alloca i32, align 4
  %ub.addr = alloca i32, align 4
  %i = alloca i32, align 4
  %"reg2mem alloca point" = bitcast i32 0 to i32
  store i32 %lb, i32* %lb.addr, align 4
  store i32 %ub, i32* %ub.addr, align 4
  call void @srand(i32 1) #3
  %0 = load i32* %lb.addr, align 4
  store i32 %0, i32* %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %1 = load i32* %i, align 4
  %2 = load i32* %ub.addr, align 4
  %cmp = icmp sle i32 %1, %2
  br i1 %cmp, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %call = call i32 @rand() #3
  %rem = srem i32 %call, 1000
  %3 = load i32* %i, align 4
  %idxprom = sext i32 %3 to i64
  %arrayidx = getelementptr inbounds [30 x i32]* @data, i32 0, i64 %idxprom
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

; Function Attrs: nounwind
declare void @srand(i32) #1

; Function Attrs: nounwind
declare i32 @rand() #1

; Function Attrs: nounwind uwtable
define i32 @main(i32 %argc, i8** %argv) #0 {
entry:
  %retval = alloca i32, align 4
  %argc.addr = alloca i32, align 4
  %argv.addr = alloca i8**, align 8
  %maxnum = alloca i32, align 4
  %lb = alloca i32, align 4
  %ub = alloca i32, align 4
  %i = alloca i32, align 4
  %"reg2mem alloca point" = bitcast i32 0 to i32
  store i32 0, i32* %retval
  store i32 %argc, i32* %argc.addr, align 4
  store i8** %argv, i8*** %argv.addr, align 8
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
  %idxprom = sext i32 %9 to i64
  %arrayidx = getelementptr inbounds [30 x i32]* @data, i32 0, i64 %idxprom
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

declare i32 @printf(i8*, ...) #2

attributes #0 = { nounwind uwtable "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf"="true" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf"="true" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #2 = { "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf"="true" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { nounwind }
