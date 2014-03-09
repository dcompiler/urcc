; ModuleID = '<stdin>'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@.str = private unnamed_addr constant [2 x i8] c"X\00", align 1
@.str1 = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str2 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1

; Function Attrs: nounwind uwtable
define i32 @square(i32 %x) #0 {
entry:
  %x.addr = alloca i32, align 4
  %"reg2mem alloca point" = bitcast i32 0 to i32
  store i32 %x, i32* %x.addr, align 4
  %0 = load i32* %x.addr, align 4
  %1 = load i32* %x.addr, align 4
  %mul = mul nsw i32 %0, %1
  %add = add nsw i32 %mul, 500
  %div = sdiv i32 %add, 1000
  ret i32 %div
}

; Function Attrs: nounwind uwtable
define i32 @complex_abs_squared(i32 %real, i32 %imag) #0 {
entry:
  %real.addr = alloca i32, align 4
  %imag.addr = alloca i32, align 4
  %"reg2mem alloca point" = bitcast i32 0 to i32
  store i32 %real, i32* %real.addr, align 4
  store i32 %imag, i32* %imag.addr, align 4
  %0 = load i32* %real.addr, align 4
  %call = call i32 @square(i32 %0)
  %1 = load i32* %imag.addr, align 4
  %call1 = call i32 @square(i32 %1)
  %add = add nsw i32 %call, %call1
  ret i32 %add
}

; Function Attrs: nounwind uwtable
define i32 @check_for_bail(i32 %real, i32 %imag) #0 {
entry:
  %retval = alloca i32, align 4
  %real.addr = alloca i32, align 4
  %imag.addr = alloca i32, align 4
  %"reg2mem alloca point" = bitcast i32 0 to i32
  store i32 %real, i32* %real.addr, align 4
  store i32 %imag, i32* %imag.addr, align 4
  %0 = load i32* %real.addr, align 4
  %cmp = icmp sgt i32 %0, 4000
  br i1 %cmp, label %entry.if.then_crit_edge, label %lor.lhs.false

entry.if.then_crit_edge:                          ; preds = %entry
  br label %if.then

lor.lhs.false:                                    ; preds = %entry
  %1 = load i32* %imag.addr, align 4
  %cmp1 = icmp sgt i32 %1, 4000
  br i1 %cmp1, label %lor.lhs.false.if.then_crit_edge, label %if.end

lor.lhs.false.if.then_crit_edge:                  ; preds = %lor.lhs.false
  br label %if.then

if.then:                                          ; preds = %lor.lhs.false.if.then_crit_edge, %entry.if.then_crit_edge
  store i32 0, i32* %retval
  br label %return

if.end:                                           ; preds = %lor.lhs.false
  %2 = load i32* %real.addr, align 4
  %3 = load i32* %imag.addr, align 4
  %call = call i32 @complex_abs_squared(i32 %2, i32 %3)
  %cmp2 = icmp sgt i32 1600, %call
  br i1 %cmp2, label %if.then3, label %if.end4

if.then3:                                         ; preds = %if.end
  store i32 0, i32* %retval
  br label %return

if.end4:                                          ; preds = %if.end
  store i32 1, i32* %retval
  br label %return

return:                                           ; preds = %if.end4, %if.then3, %if.then
  %4 = load i32* %retval
  ret i32 %4
}

; Function Attrs: nounwind uwtable
define i32 @absval(i32 %x) #0 {
entry:
  %retval = alloca i32, align 4
  %x.addr = alloca i32, align 4
  %"reg2mem alloca point" = bitcast i32 0 to i32
  store i32 %x, i32* %x.addr, align 4
  %0 = load i32* %x.addr, align 4
  %cmp = icmp slt i32 %0, 0
  br i1 %cmp, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %1 = load i32* %x.addr, align 4
  %mul = mul nsw i32 -1, %1
  store i32 %mul, i32* %retval
  br label %return

if.end:                                           ; preds = %entry
  %2 = load i32* %x.addr, align 4
  store i32 %2, i32* %retval
  br label %return

return:                                           ; preds = %if.end, %if.then
  %3 = load i32* %retval
  ret i32 %3
}

; Function Attrs: nounwind uwtable
define i32 @checkpixel(i32 %x, i32 %y) #0 {
entry:
  %retval = alloca i32, align 4
  %x.addr = alloca i32, align 4
  %y.addr = alloca i32, align 4
  %real = alloca i32, align 4
  %imag = alloca i32, align 4
  %temp = alloca i32, align 4
  %iter = alloca i32, align 4
  %bail = alloca i32, align 4
  %"reg2mem alloca point" = bitcast i32 0 to i32
  store i32 %x, i32* %x.addr, align 4
  store i32 %y, i32* %y.addr, align 4
  store i32 0, i32* %real, align 4
  store i32 0, i32* %imag, align 4
  store i32 0, i32* %iter, align 4
  store i32 16000, i32* %bail, align 4
  br label %while.cond

while.cond:                                       ; preds = %if.end, %entry
  %0 = load i32* %iter, align 4
  %cmp = icmp slt i32 %0, 255
  br i1 %cmp, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %1 = load i32* %real, align 4
  %call = call i32 @square(i32 %1)
  %2 = load i32* %imag, align 4
  %call1 = call i32 @square(i32 %2)
  %sub = sub nsw i32 %call, %call1
  %3 = load i32* %x.addr, align 4
  %add = add nsw i32 %sub, %3
  store i32 %add, i32* %temp, align 4
  %4 = load i32* %real, align 4
  %mul = mul nsw i32 2, %4
  %5 = load i32* %imag, align 4
  %mul2 = mul nsw i32 %mul, %5
  %add3 = add nsw i32 %mul2, 500
  %div = sdiv i32 %add3, 1000
  %6 = load i32* %y.addr, align 4
  %add4 = add nsw i32 %div, %6
  store i32 %add4, i32* %imag, align 4
  %7 = load i32* %temp, align 4
  store i32 %7, i32* %real, align 4
  %8 = load i32* %real, align 4
  %call5 = call i32 @absval(i32 %8)
  %9 = load i32* %imag, align 4
  %call6 = call i32 @absval(i32 %9)
  %add7 = add nsw i32 %call5, %call6
  %cmp8 = icmp sgt i32 %add7, 5000
  br i1 %cmp8, label %if.then, label %if.end

if.then:                                          ; preds = %while.body
  store i32 0, i32* %retval
  br label %return

if.end:                                           ; preds = %while.body
  %10 = load i32* %iter, align 4
  %add9 = add nsw i32 %10, 1
  store i32 %add9, i32* %iter, align 4
  br label %while.cond

while.end:                                        ; preds = %while.cond
  store i32 1, i32* %retval
  br label %return

return:                                           ; preds = %while.end, %if.then
  %11 = load i32* %retval
  ret i32 %11
}

; Function Attrs: nounwind uwtable
define i32 @main() #0 {
entry:
  %retval = alloca i32, align 4
  %x = alloca i32, align 4
  %y = alloca i32, align 4
  %on = alloca i32, align 4
  %"reg2mem alloca point" = bitcast i32 0 to i32
  store i32 0, i32* %retval
  store i32 950, i32* %y, align 4
  br label %while.cond

while.cond:                                       ; preds = %while.end, %entry
  %0 = load i32* %y, align 4
  %cmp = icmp sgt i32 %0, -950
  br i1 %cmp, label %while.body, label %while.end11

while.body:                                       ; preds = %while.cond
  store i32 -2100, i32* %x, align 4
  br label %while.cond1

while.cond1:                                      ; preds = %if.end9, %while.body
  %1 = load i32* %x, align 4
  %cmp2 = icmp slt i32 %1, 1000
  br i1 %cmp2, label %while.body3, label %while.end

while.body3:                                      ; preds = %while.cond1
  %2 = load i32* %x, align 4
  %3 = load i32* %y, align 4
  %call = call i32 @checkpixel(i32 %2, i32 %3)
  store i32 %call, i32* %on, align 4
  %4 = load i32* %on, align 4
  %cmp4 = icmp eq i32 1, %4
  br i1 %cmp4, label %if.then, label %while.body3.if.end_crit_edge

while.body3.if.end_crit_edge:                     ; preds = %while.body3
  br label %if.end

if.then:                                          ; preds = %while.body3
  %call5 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([2 x i8]* @.str, i32 0, i32 0))
  br label %if.end

if.end:                                           ; preds = %while.body3.if.end_crit_edge, %if.then
  %5 = load i32* %on, align 4
  %cmp6 = icmp eq i32 0, %5
  br i1 %cmp6, label %if.then7, label %if.end.if.end9_crit_edge

if.end.if.end9_crit_edge:                         ; preds = %if.end
  br label %if.end9

if.then7:                                         ; preds = %if.end
  %call8 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([2 x i8]* @.str1, i32 0, i32 0))
  br label %if.end9

if.end9:                                          ; preds = %if.end.if.end9_crit_edge, %if.then7
  %6 = load i32* %x, align 4
  %add = add nsw i32 %6, 40
  store i32 %add, i32* %x, align 4
  br label %while.cond1

while.end:                                        ; preds = %while.cond1
  %call10 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([2 x i8]* @.str2, i32 0, i32 0))
  %7 = load i32* %y, align 4
  %sub = sub nsw i32 %7, 50
  store i32 %sub, i32* %y, align 4
  br label %while.cond

while.end11:                                      ; preds = %while.cond
  %8 = load i32* %retval
  ret i32 %8
}

declare i32 @printf(i8*, ...) #1

attributes #0 = { nounwind uwtable "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf"="true" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf"="true" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "unsafe-fp-math"="false" "use-soft-float"="false" }
