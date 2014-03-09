; ModuleID = '<stdin>'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@.str = private unnamed_addr constant [26 x i8] c"input a number, e.g. 255\0A\00", align 1
@.str1 = private unnamed_addr constant [3 x i8] c"%d\00", align 1
@.str2 = private unnamed_addr constant [4 x i8] c"odd\00", align 1
@.str3 = private unnamed_addr constant [5 x i8] c"even\00", align 1
@.str4 = private unnamed_addr constant [10 x i8] c"%d is %s\0A\00", align 1

; Function Attrs: nounwind uwtable
define i32 @main(i32 %argc, i8** %argv) #0 {
entry:
  %retval = alloca i32, align 4
  %argc.addr = alloca i32, align 4
  %argv.addr = alloca i8**, align 8
  %i = alloca i32, align 4
  %parity = alloca i32, align 4
  %answer = alloca i8*, align 8
  %"reg2mem alloca point" = bitcast i32 0 to i32
  store i32 0, i32* %retval
  store i32 %argc, i32* %argc.addr, align 4
  store i8** %argv, i8*** %argv.addr, align 8
  %call = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([26 x i8]* @.str, i32 0, i32 0))
  %call1 = call i32 (i8*, ...)* @__isoc99_scanf(i8* getelementptr inbounds ([3 x i8]* @.str1, i32 0, i32 0), i32* %i)
  %0 = load i32* %i, align 4
  %rem = srem i32 %0, 2
  store i32 %rem, i32* %parity, align 4
  %1 = load i32* %parity, align 4
  %cmp = icmp eq i32 %1, 0
  br i1 %cmp, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  br label %L1

if.end:                                           ; preds = %entry
  store i8* getelementptr inbounds ([4 x i8]* @.str2, i32 0, i32 0), i8** %answer, align 8
  br label %L2

L1:                                               ; preds = %if.then
  store i8* getelementptr inbounds ([5 x i8]* @.str3, i32 0, i32 0), i8** %answer, align 8
  br label %L2

L2:                                               ; preds = %L1, %if.end
  %2 = load i32* %i, align 4
  %3 = load i8** %answer, align 8
  %call2 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([10 x i8]* @.str4, i32 0, i32 0), i32 %2, i8* %3)
  ret i32 0
}

declare i32 @printf(i8*, ...) #1

declare i32 @__isoc99_scanf(i8*, ...) #1

attributes #0 = { nounwind uwtable "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf"="true" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf"="true" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "unsafe-fp-math"="false" "use-soft-float"="false" }
