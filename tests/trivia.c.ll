; ModuleID = '<stdin>'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@.str = private unnamed_addr constant [33 x i8] c"Please input an integer number: \00", align 1
@.str1 = private unnamed_addr constant [3 x i8] c"%d\00", align 1
@.str2 = private unnamed_addr constant [22 x i8] c"Final Result: s = %d\0A\00", align 1

; Function Attrs: nounwind uwtable
define i32 @main(i32 %argc, i8** %argv) #0 {
entry:
  %argc.addr = alloca i32, align 4
  %argv.addr = alloca i8**, align 8
  %a = alloca i32, align 4
  %b = alloca i32, align 4
  %c = alloca i32, align 4
  %s = alloca i32, align 4
  %"reg2mem alloca point" = bitcast i32 0 to i32
  store i32 %argc, i32* %argc.addr, align 4
  store i8** %argv, i8*** %argv.addr, align 8
  %call = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([33 x i8]* @.str, i32 0, i32 0))
  %call1 = call i32 (i8*, ...)* @__isoc99_scanf(i8* getelementptr inbounds ([3 x i8]* @.str1, i32 0, i32 0), i32* %a)
  store i32 50, i32* %b, align 4
  store i32 500, i32* %c, align 4
  store i32 0, i32* %s, align 4
  %0 = load i32* %c, align 4
  %1 = load i32* %c, align 4
  %div = sdiv i32 %0, %1
  %2 = load i32* %s, align 4
  %div2 = sdiv i32 %2, %div
  store i32 %div2, i32* %s, align 4
  %3 = load i32* %c, align 4
  %4 = load i32* %c, align 4
  %add = add nsw i32 %3, %4
  %5 = load i32* %s, align 4
  %add3 = add nsw i32 %5, %add
  store i32 %add3, i32* %s, align 4
  %6 = load i32* %c, align 4
  %7 = load i32* %a, align 4
  %div4 = sdiv i32 %6, %7
  %8 = load i32* %s, align 4
  %div5 = sdiv i32 %8, %div4
  store i32 %div5, i32* %s, align 4
  %9 = load i32* %b, align 4
  %10 = load i32* %c, align 4
  %add6 = add nsw i32 %9, %10
  store i32 %add6, i32* %c, align 4
  %11 = load i32* %b, align 4
  %12 = load i32* %a, align 4
  %add7 = add nsw i32 %11, %12
  %13 = load i32* %s, align 4
  %add8 = add nsw i32 %13, %add7
  store i32 %add8, i32* %s, align 4
  %14 = load i32* %b, align 4
  %15 = load i32* %a, align 4
  %add9 = add nsw i32 %14, %15
  %16 = load i32* %s, align 4
  %add10 = add nsw i32 %16, %add9
  store i32 %add10, i32* %s, align 4
  %17 = load i32* %b, align 4
  %18 = load i32* %c, align 4
  %add11 = add nsw i32 %17, %18
  %19 = load i32* %s, align 4
  %add12 = add nsw i32 %19, %add11
  store i32 %add12, i32* %s, align 4
  %20 = load i32* %a, align 4
  %21 = load i32* %b, align 4
  %add13 = add nsw i32 %20, %21
  %22 = load i32* %s, align 4
  %add14 = add nsw i32 %22, %add13
  store i32 %add14, i32* %s, align 4
  %23 = load i32* %a, align 4
  %24 = load i32* %a, align 4
  %div15 = sdiv i32 %23, %24
  %25 = load i32* %s, align 4
  %div16 = sdiv i32 %25, %div15
  store i32 %div16, i32* %s, align 4
  %26 = load i32* %b, align 4
  %27 = load i32* %a, align 4
  %div17 = sdiv i32 %26, %27
  store i32 %div17, i32* %c, align 4
  %28 = load i32* %b, align 4
  %29 = load i32* %a, align 4
  %div18 = sdiv i32 %28, %29
  %30 = load i32* %s, align 4
  %div19 = sdiv i32 %30, %div18
  store i32 %div19, i32* %s, align 4
  %31 = load i32* %c, align 4
  %32 = load i32* %b, align 4
  %add20 = add nsw i32 %31, %32
  %33 = load i32* %s, align 4
  %add21 = add nsw i32 %33, %add20
  store i32 %add21, i32* %s, align 4
  %34 = load i32* %a, align 4
  %35 = load i32* %b, align 4
  %add22 = add nsw i32 %34, %35
  %36 = load i32* %s, align 4
  %add23 = add nsw i32 %36, %add22
  store i32 %add23, i32* %s, align 4
  %37 = load i32* %c, align 4
  %38 = load i32* %a, align 4
  %add24 = add nsw i32 %37, %38
  %39 = load i32* %s, align 4
  %add25 = add nsw i32 %39, %add24
  store i32 %add25, i32* %s, align 4
  %40 = load i32* %c, align 4
  %41 = load i32* %c, align 4
  %add26 = add nsw i32 %40, %41
  %42 = load i32* %s, align 4
  %add27 = add nsw i32 %42, %add26
  store i32 %add27, i32* %s, align 4
  %43 = load i32* %c, align 4
  %44 = load i32* %b, align 4
  %add28 = add nsw i32 %43, %44
  %45 = load i32* %s, align 4
  %add29 = add nsw i32 %45, %add28
  store i32 %add29, i32* %s, align 4
  %46 = load i32* %b, align 4
  %47 = load i32* %a, align 4
  %add30 = add nsw i32 %46, %47
  store i32 %add30, i32* %c, align 4
  %48 = load i32* %c, align 4
  %49 = load i32* %b, align 4
  %div31 = sdiv i32 %48, %49
  %50 = load i32* %s, align 4
  %div32 = sdiv i32 %50, %div31
  store i32 %div32, i32* %s, align 4
  %51 = load i32* %c, align 4
  %52 = load i32* %a, align 4
  %add33 = add nsw i32 %51, %52
  store i32 %add33, i32* %b, align 4
  %53 = load i32* %b, align 4
  %54 = load i32* %a, align 4
  %div34 = sdiv i32 %53, %54
  %55 = load i32* %s, align 4
  %div35 = sdiv i32 %55, %div34
  store i32 %div35, i32* %s, align 4
  %56 = load i32* %a, align 4
  %57 = load i32* %b, align 4
  %add36 = add nsw i32 %56, %57
  %58 = load i32* %s, align 4
  %add37 = add nsw i32 %58, %add36
  store i32 %add37, i32* %s, align 4
  %59 = load i32* %c, align 4
  %60 = load i32* %b, align 4
  %add38 = add nsw i32 %59, %60
  %61 = load i32* %s, align 4
  %add39 = add nsw i32 %61, %add38
  store i32 %add39, i32* %s, align 4
  %62 = load i32* %c, align 4
  %63 = load i32* %a, align 4
  %add40 = add nsw i32 %62, %63
  %64 = load i32* %s, align 4
  %add41 = add nsw i32 %64, %add40
  store i32 %add41, i32* %s, align 4
  %65 = load i32* %a, align 4
  %66 = load i32* %a, align 4
  %add42 = add nsw i32 %65, %66
  store i32 %add42, i32* %c, align 4
  %67 = load i32* %a, align 4
  %68 = load i32* %c, align 4
  %add43 = add nsw i32 %67, %68
  %69 = load i32* %s, align 4
  %add44 = add nsw i32 %69, %add43
  store i32 %add44, i32* %s, align 4
  %70 = load i32* %b, align 4
  %71 = load i32* %a, align 4
  %add45 = add nsw i32 %70, %71
  store i32 %add45, i32* %c, align 4
  %72 = load i32* %a, align 4
  %73 = load i32* %a, align 4
  %add46 = add nsw i32 %72, %73
  %74 = load i32* %s, align 4
  %add47 = add nsw i32 %74, %add46
  store i32 %add47, i32* %s, align 4
  %75 = load i32* %b, align 4
  %76 = load i32* %a, align 4
  %div48 = sdiv i32 %75, %76
  store i32 %div48, i32* %c, align 4
  %77 = load i32* %b, align 4
  %78 = load i32* %c, align 4
  %div49 = sdiv i32 %77, %78
  store i32 %div49, i32* %c, align 4
  %79 = load i32* %a, align 4
  %80 = load i32* %c, align 4
  %div50 = sdiv i32 %79, %80
  store i32 %div50, i32* %a, align 4
  %81 = load i32* %b, align 4
  %82 = load i32* %a, align 4
  %add51 = add nsw i32 %81, %82
  %83 = load i32* %s, align 4
  %add52 = add nsw i32 %83, %add51
  store i32 %add52, i32* %s, align 4
  %84 = load i32* %s, align 4
  %call53 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([22 x i8]* @.str2, i32 0, i32 0), i32 %84)
  ret i32 0
}

declare i32 @printf(i8*, ...) #1

declare i32 @__isoc99_scanf(i8*, ...) #1

attributes #0 = { nounwind uwtable "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf"="true" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf"="true" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "unsafe-fp-math"="false" "use-soft-float"="false" }
