; ModuleID = 'ab.c.bc'
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:32:32-n8:16:32-S128"
target triple = "i386-pc-linux-gnu"

@.str = private unnamed_addr constant [10 x i8] c"19 s=%2d\0A\00", align 1

define i32 @main() nounwind {
entry:
  %x = alloca i32, align 4
  %y = alloca i32, align 4
  %z = alloca i32, align 4
  store i32 0, i32* %y, align 4
  store i32 1, i32* %x, align 4
  %0 = load i32* %x, align 4
  %1 = load i32* %y, align 4
  %add = add nsw i32 %0, %1
  store i32 %add, i32* %z, align 4
  %2 = load i32* %z, align 4
  %call = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([10 x i8]* @.str, i32 0, i32 0), i32 %2)
  ret i32 0
}

declare i32 @printf(i8*, ...)
