; ModuleID = 'tax.c.bc'
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:32:32-n8:16:32-S128"
target triple = "i386-pc-linux-gnu"

@.str = private unnamed_addr constant [3 x i8] c"%d\00", align 1
@.str1 = private unnamed_addr constant [31 x i8] c"I need a non-negative number: \00", align 1
@.str2 = private unnamed_addr constant [63 x i8] c"Welcome to the United States 1040 federal income tax program.\0A\00", align 1
@.str3 = private unnamed_addr constant [65 x i8] c"(Note: this isn't the real 1040 form. If you try to submit your\0A\00", align 1
@.str4 = private unnamed_addr constant [47 x i8] c"taxes this way, you'll get what you deserve!\0A\0A\00", align 1
@.str5 = private unnamed_addr constant [60 x i8] c"Answer the following questions to determine what you owe.\0A\0A\00", align 1
@.str6 = private unnamed_addr constant [32 x i8] c"Total wages, salary, and tips? \00", align 1
@.str7 = private unnamed_addr constant [48 x i8] c"Taxable interest (such as from bank accounts)? \00", align 1
@.str8 = private unnamed_addr constant [64 x i8] c"Unemployment compensation, qualified state tuition, and Alaska\0A\00", align 1
@.str9 = private unnamed_addr constant [27 x i8] c"Permanent Fund dividends? \00", align 1
@.str10 = private unnamed_addr constant [32 x i8] c"Your adjusted gross income is: \00", align 1
@.str11 = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1
@.str12 = private unnamed_addr constant [65 x i8] c"Enter <1> if your parents or someone else can claim you on their\00", align 1
@.str13 = private unnamed_addr constant [32 x i8] c" return. \0AEnter <0> otherwise: \00", align 1
@.str14 = private unnamed_addr constant [54 x i8] c"Enter <1> if you are single, <0> if you are married: \00", align 1
@.str15 = private unnamed_addr constant [57 x i8] c"Enter <1> if your spouse can be claimed as a dependant, \00", align 1
@.str16 = private unnamed_addr constant [19 x i8] c"enter <0> if not: \00", align 1
@.str17 = private unnamed_addr constant [25 x i8] c"Your taxable income is: \00", align 1
@.str18 = private unnamed_addr constant [50 x i8] c"Enter the amount of Federal income tax withheld: \00", align 1
@.str19 = private unnamed_addr constant [53 x i8] c"Enter <1> if you get an earned income credit (EIC); \00", align 1
@.str20 = private unnamed_addr constant [20 x i8] c"enter 0 otherwise: \00", align 1
@.str21 = private unnamed_addr constant [55 x i8] c"OK, I'll give you a thousand dollars for your credit.\0A\00", align 1
@.str22 = private unnamed_addr constant [36 x i8] c"Your total tax payments amount to: \00", align 1
@.str23 = private unnamed_addr constant [30 x i8] c"Your total tax liability is: \00", align 1
@.str24 = private unnamed_addr constant [43 x i8] c"Congratulations, you get a tax refund of $\00", align 1
@.str25 = private unnamed_addr constant [38 x i8] c"Bummer. You owe the IRS a check for $\00", align 1
@.str26 = private unnamed_addr constant [29 x i8] c"Thank you for using ez-tax.\0A\00", align 1

define i32 @getinput() nounwind {
entry:
  %inp = alloca i32, align 4
  store i32 -1, i32* %inp, align 4
  br label %while.cond

while.cond:                                       ; preds = %if.end, %entry
  %0 = load i32* %inp, align 4
  %cmp = icmp sgt i32 0, %0
  br i1 %cmp, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %call = call i32 (i8*, ...)* @__isoc99_scanf(i8* getelementptr inbounds ([3 x i8]* @.str, i32 0, i32 0), i32* %inp)
  %1 = load i32* %inp, align 4
  %cmp1 = icmp sgt i32 0, %1
  br i1 %cmp1, label %if.then, label %if.end

if.then:                                          ; preds = %while.body
  %call2 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([31 x i8]* @.str1, i32 0, i32 0))
  br label %if.end

if.end:                                           ; preds = %if.then, %while.body
  br label %while.cond

while.end:                                        ; preds = %while.cond
  %2 = load i32* %inp, align 4
  ret i32 %2
}

declare i32 @__isoc99_scanf(i8*, ...)

declare i32 @printf(i8*, ...)

define i32 @main() nounwind {
entry:
  %retval = alloca i32, align 4
  %line1 = alloca i32, align 4
  %line2 = alloca i32, align 4
  %line3 = alloca i32, align 4
  %line4 = alloca i32, align 4
  %line5 = alloca i32, align 4
  %line6 = alloca i32, align 4
  %line7 = alloca i32, align 4
  %line8 = alloca i32, align 4
  %deadline11 = alloca i32, align 4
  %deadline12 = alloca i32, align 4
  %line10 = alloca i32, align 4
  %dependant = alloca i32, align 4
  %single = alloca i32, align 4
  %b = alloca i32, align 4
  %c = alloca i32, align 4
  %d = alloca i32, align 4
  %e = alloca i32, align 4
  %f = alloca i32, align 4
  %g = alloca i32, align 4
  %eic = alloca i32, align 4
  %spousedependant = alloca i32, align 4
  store i32 0, i32* %retval
  %call = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([63 x i8]* @.str2, i32 0, i32 0))
  %call1 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([65 x i8]* @.str3, i32 0, i32 0))
  %call2 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([47 x i8]* @.str4, i32 0, i32 0))
  %call3 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([60 x i8]* @.str5, i32 0, i32 0))
  %call4 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([32 x i8]* @.str6, i32 0, i32 0))
  %call5 = call i32 @getinput()
  store i32 %call5, i32* %line1, align 4
  %call6 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([48 x i8]* @.str7, i32 0, i32 0))
  %call7 = call i32 @getinput()
  store i32 %call7, i32* %line2, align 4
  %call8 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([64 x i8]* @.str8, i32 0, i32 0))
  %call9 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([27 x i8]* @.str9, i32 0, i32 0))
  %call10 = call i32 @getinput()
  store i32 %call10, i32* %line3, align 4
  %0 = load i32* %line1, align 4
  %1 = load i32* %line2, align 4
  %add = add nsw i32 %0, %1
  %2 = load i32* %line3, align 4
  %add11 = add nsw i32 %add, %2
  store i32 %add11, i32* %line4, align 4
  %call12 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([32 x i8]* @.str10, i32 0, i32 0))
  %3 = load i32* %line4, align 4
  %call13 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([4 x i8]* @.str11, i32 0, i32 0), i32 %3)
  %call14 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([65 x i8]* @.str12, i32 0, i32 0))
  %call15 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([32 x i8]* @.str13, i32 0, i32 0))
  %call16 = call i32 @getinput()
  store i32 %call16, i32* %dependant, align 4
  %4 = load i32* %dependant, align 4
  %cmp = icmp ne i32 0, %4
  br i1 %cmp, label %if.then, label %if.end39

if.then:                                          ; preds = %entry
  store i32 700, i32* %b, align 4
  %5 = load i32* %b, align 4
  store i32 %5, i32* %c, align 4
  %6 = load i32* %c, align 4
  %7 = load i32* %line1, align 4
  %add17 = add nsw i32 %7, 250
  %cmp18 = icmp slt i32 %6, %add17
  br i1 %cmp18, label %if.then19, label %if.end

if.then19:                                        ; preds = %if.then
  %8 = load i32* %line1, align 4
  %add20 = add nsw i32 %8, 250
  store i32 %add20, i32* %c, align 4
  br label %if.end

if.end:                                           ; preds = %if.then19, %if.then
  %call21 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([54 x i8]* @.str14, i32 0, i32 0))
  %call22 = call i32 @getinput()
  store i32 %call22, i32* %single, align 4
  %9 = load i32* %single, align 4
  %cmp23 = icmp ne i32 0, %9
  br i1 %cmp23, label %if.then24, label %if.else

if.then24:                                        ; preds = %if.end
  store i32 7350, i32* %d, align 4
  br label %if.end25

if.else:                                          ; preds = %if.end
  store i32 7350, i32* %d, align 4
  br label %if.end25

if.end25:                                         ; preds = %if.else, %if.then24
  %10 = load i32* %c, align 4
  store i32 %10, i32* %e, align 4
  %11 = load i32* %e, align 4
  %12 = load i32* %d, align 4
  %cmp26 = icmp sgt i32 %11, %12
  br i1 %cmp26, label %if.then27, label %if.end28

if.then27:                                        ; preds = %if.end25
  %13 = load i32* %d, align 4
  store i32 %13, i32* %e, align 4
  br label %if.end28

if.end28:                                         ; preds = %if.then27, %if.end25
  store i32 0, i32* %f, align 4
  %14 = load i32* %single, align 4
  %cmp29 = icmp eq i32 %14, 0
  br i1 %cmp29, label %if.then30, label %if.end37

if.then30:                                        ; preds = %if.end28
  %call31 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([57 x i8]* @.str15, i32 0, i32 0))
  %call32 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([19 x i8]* @.str16, i32 0, i32 0))
  %call33 = call i32 @getinput()
  store i32 %call33, i32* %spousedependant, align 4
  %15 = load i32* %spousedependant, align 4
  %cmp34 = icmp eq i32 0, %15
  br i1 %cmp34, label %if.then35, label %if.end36

if.then35:                                        ; preds = %if.then30
  store i32 2800, i32* %f, align 4
  br label %if.end36

if.end36:                                         ; preds = %if.then35, %if.then30
  br label %if.end37

if.end37:                                         ; preds = %if.end36, %if.end28
  %16 = load i32* %e, align 4
  %17 = load i32* %f, align 4
  %add38 = add nsw i32 %16, %17
  store i32 %add38, i32* %g, align 4
  %18 = load i32* %g, align 4
  store i32 %18, i32* %line5, align 4
  br label %if.end39

if.end39:                                         ; preds = %if.end37, %entry
  %19 = load i32* %dependant, align 4
  %cmp40 = icmp eq i32 0, %19
  br i1 %cmp40, label %if.then41, label %if.end50

if.then41:                                        ; preds = %if.end39
  %call42 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([54 x i8]* @.str14, i32 0, i32 0))
  %call43 = call i32 @getinput()
  store i32 %call43, i32* %single, align 4
  %20 = load i32* %single, align 4
  %cmp44 = icmp ne i32 0, %20
  br i1 %cmp44, label %if.then45, label %if.end46

if.then45:                                        ; preds = %if.then41
  store i32 12950, i32* %line5, align 4
  br label %if.end46

if.end46:                                         ; preds = %if.then45, %if.then41
  %21 = load i32* %single, align 4
  %cmp47 = icmp eq i32 0, %21
  br i1 %cmp47, label %if.then48, label %if.end49

if.then48:                                        ; preds = %if.end46
  store i32 7200, i32* %line5, align 4
  br label %if.end49

if.end49:                                         ; preds = %if.then48, %if.end46
  br label %if.end50

if.end50:                                         ; preds = %if.end49, %if.end39
  %22 = load i32* %line4, align 4
  %23 = load i32* %line5, align 4
  %sub = sub nsw i32 %22, %23
  store i32 %sub, i32* %line6, align 4
  %24 = load i32* %line6, align 4
  %cmp51 = icmp slt i32 %24, 0
  br i1 %cmp51, label %if.then52, label %if.end53

if.then52:                                        ; preds = %if.end50
  store i32 0, i32* %line6, align 4
  br label %if.end53

if.end53:                                         ; preds = %if.then52, %if.end50
  %call54 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([25 x i8]* @.str17, i32 0, i32 0))
  %25 = load i32* %line6, align 4
  %call55 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([4 x i8]* @.str11, i32 0, i32 0), i32 %25)
  %call56 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([50 x i8]* @.str18, i32 0, i32 0))
  %call57 = call i32 @getinput()
  store i32 %call57, i32* %line7, align 4
  %call58 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([53 x i8]* @.str19, i32 0, i32 0))
  %call59 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([20 x i8]* @.str20, i32 0, i32 0))
  %call60 = call i32 @getinput()
  store i32 %call60, i32* %eic, align 4
  store i32 0, i32* %line8, align 4
  %26 = load i32* %eic, align 4
  %cmp61 = icmp ne i32 0, %26
  br i1 %cmp61, label %if.then62, label %if.end64

if.then62:                                        ; preds = %if.end53
  %call63 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([55 x i8]* @.str21, i32 0, i32 0))
  store i32 1000, i32* %line8, align 4
  br label %if.end64

if.end64:                                         ; preds = %if.then62, %if.end53
  %call65 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([36 x i8]* @.str22, i32 0, i32 0))
  %27 = load i32* %line8, align 4
  %28 = load i32* %line7, align 4
  %add66 = add nsw i32 %27, %28
  %call67 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([4 x i8]* @.str11, i32 0, i32 0), i32 %add66)
  %29 = load i32* %line6, align 4
  %mul = mul nsw i32 %29, 28
  %add68 = add nsw i32 %mul, 50
  %div = sdiv i32 %add68, 100
  store i32 %div, i32* %line10, align 4
  %call69 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([30 x i8]* @.str23, i32 0, i32 0))
  %30 = load i32* %line10, align 4
  %call70 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([4 x i8]* @.str11, i32 0, i32 0), i32 %30)
  %31 = load i32* %line8, align 4
  %32 = load i32* %line7, align 4
  %add71 = add nsw i32 %31, %32
  %33 = load i32* %line10, align 4
  %sub72 = sub nsw i32 %add71, %33
  %cmp73 = icmp slt i32 %sub72, 0
  br i1 %cmp73, label %if.then74, label %if.else75

if.then74:                                        ; preds = %if.end64
  store i32 0, i32* %deadline11, align 4
  br label %if.end76

if.else75:                                        ; preds = %if.end64
  store i32 0, i32* %deadline11, align 4
  br label %if.end76

if.end76:                                         ; preds = %if.else75, %if.then74
  %34 = load i32* %line8, align 4
  %35 = load i32* %line7, align 4
  %add77 = add nsw i32 %34, %35
  %36 = load i32* %line10, align 4
  %sub78 = sub nsw i32 %add77, %36
  %cmp79 = icmp sgt i32 %sub78, 0
  br i1 %cmp79, label %if.then80, label %if.end85

if.then80:                                        ; preds = %if.end76
  %call81 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([43 x i8]* @.str24, i32 0, i32 0))
  %37 = load i32* %line8, align 4
  %38 = load i32* %line7, align 4
  %add82 = add nsw i32 %37, %38
  %39 = load i32* %line10, align 4
  %sub83 = sub nsw i32 %add82, %39
  %call84 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([4 x i8]* @.str11, i32 0, i32 0), i32 %sub83)
  br label %if.end85

if.end85:                                         ; preds = %if.then80, %if.end76
  %40 = load i32* %line10, align 4
  %41 = load i32* %line8, align 4
  %42 = load i32* %line7, align 4
  %add86 = add nsw i32 %41, %42
  %sub87 = sub nsw i32 %40, %add86
  %cmp88 = icmp sge i32 %sub87, 0
  br i1 %cmp88, label %if.then89, label %if.end94

if.then89:                                        ; preds = %if.end85
  %call90 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([38 x i8]* @.str25, i32 0, i32 0))
  %43 = load i32* %line10, align 4
  %44 = load i32* %line8, align 4
  %45 = load i32* %line7, align 4
  %add91 = add nsw i32 %44, %45
  %sub92 = sub nsw i32 %43, %add91
  %call93 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([4 x i8]* @.str11, i32 0, i32 0), i32 %sub92)
  br label %if.end94

if.end94:                                         ; preds = %if.then89, %if.end85
  %46 = load i32* %line10, align 4
  %47 = load i32* %line8, align 4
  %48 = load i32* %line7, align 4
  %add95 = add nsw i32 %47, %48
  %sub96 = sub nsw i32 %46, %add95
  %cmp97 = icmp slt i32 %sub96, 0
  br i1 %cmp97, label %if.then98, label %if.else99

if.then98:                                        ; preds = %if.end94
  store i32 0, i32* %deadline12, align 4
  br label %if.end100

if.else99:                                        ; preds = %if.end94
  store i32 0, i32* %deadline12, align 4
  br label %if.end100

if.end100:                                        ; preds = %if.else99, %if.then98
  %49 = load i32* %line6, align 4
  %call101 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([4 x i8]* @.str11, i32 0, i32 0), i32 %49)
  %50 = load i32* %line8, align 4
  %51 = load i32* %line7, align 4
  %add102 = add nsw i32 %50, %51
  %call103 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([4 x i8]* @.str11, i32 0, i32 0), i32 %add102)
  %52 = load i32* %line10, align 4
  %call104 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([4 x i8]* @.str11, i32 0, i32 0), i32 %52)
  %53 = load i32* %b, align 4
  %call105 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([4 x i8]* @.str11, i32 0, i32 0), i32 %53)
  %54 = load i32* %e, align 4
  %call106 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([4 x i8]* @.str11, i32 0, i32 0), i32 %54)
  %55 = load i32* %d, align 4
  %call107 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([4 x i8]* @.str11, i32 0, i32 0), i32 %55)
  %56 = load i32* %deadline11, align 4
  %call108 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([4 x i8]* @.str11, i32 0, i32 0), i32 %56)
  %57 = load i32* %deadline12, align 4
  %call109 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([4 x i8]* @.str11, i32 0, i32 0), i32 %57)
  %58 = load i32* %line10, align 4
  store i32 %58, i32* %line6, align 4
  store i32 0, i32* %line8, align 4
  store i32 0, i32* %line10, align 4
  %59 = load i32* %b, align 4
  %60 = load i32* %deadline12, align 4
  %add110 = add nsw i32 %59, %60
  store i32 %add110, i32* %deadline11, align 4
  %61 = load i32* %e, align 4
  %62 = load i32* %d, align 4
  %add111 = add nsw i32 %61, %62
  store i32 %add111, i32* %deadline12, align 4
  %call112 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([29 x i8]* @.str26, i32 0, i32 0))
  %63 = load i32* %retval
  ret i32 %63
}
