struct	Record
{
struct Record		*PtrComp;
int		Discr;
int		EnumComp;
int		IntComp;
char StringComp[31];
};
extern int	Func1();
extern int		Func2();
main()
{
Proc0();
exit(0);
}
int		IntGlob;
int		BoolGlob;
char		Char1Glob;
char		Char2Glob;
int Array1Glob[51];
int Array2Glob[51][51];
struct Record *	PtrGlb;
struct Record *	PtrGlbNext;
struct Record RecA, RecB;
Proc0()
{
int		IntLoc1;
 int		IntLoc2;
int		IntLoc3;
 char		CharLoc;
 char		CharIndex;
int	 	EnumLoc;
char String1Loc[31];
char String2Loc[31];
extern char		*alloc();
register int	i;
PtrGlbNext = &RecB;
PtrGlb = &RecA;
PtrGlb->PtrComp = PtrGlbNext;
PtrGlb->Discr = 1;
PtrGlb->EnumComp = 3;
PtrGlb->IntComp = 40;
strcpy(PtrGlb->StringComp, "DHRYSTONE PROGRAM, SOME STRING");
strcpy(String1Loc, "DHRYSTONE PROGRAM, 1'ST STRING");
Array2Glob[8][7] = 10;
for (i = 0; i < 10000; ++i)
{
Proc5();
Proc4();
IntLoc1 = 2;
IntLoc2 = 3;
strcpy(String2Loc, "DHRYSTONE PROGRAM, 2'ND STRING");
EnumLoc = 2;
BoolGlob = ! Func2(String1Loc, String2Loc);
while (IntLoc1 < IntLoc2)
{
IntLoc3 = 5 * IntLoc1 - IntLoc2;
Proc7(IntLoc1, IntLoc2, &IntLoc3);
++IntLoc1;
}
Proc8(Array1Glob, Array2Glob, IntLoc1, IntLoc3);
Proc1(PtrGlb);
for (CharIndex = 'A'; CharIndex <= Char2Glob; ++CharIndex)
if (EnumLoc == Func1(CharIndex, 'C'))
Proc6(1, &EnumLoc);
IntLoc3 = IntLoc2 * IntLoc1;
IntLoc2 = IntLoc3 / IntLoc1;
IntLoc2 = 7 * (IntLoc3 - IntLoc2) - IntLoc1;
Proc2(&IntLoc1);
}
printf("DHRYCHECK %d %d %d %d %d %d %d\n",IntGlob,BoolGlob,Array1Glob[8],Array2Glob[8][7],IntLoc1,IntLoc2,IntLoc3);
printf("DHRYREC %d %d %d %d\n",PtrGlb->IntComp,PtrGlbNext->IntComp,Char1Glob,Char2Glob);
}
Proc1(PtrParIn)
 struct Record *	PtrParIn;
{
memcpy(&((*(PtrParIn->PtrComp))), PtrGlb, sizeof((*(PtrParIn->PtrComp))));
PtrParIn->IntComp = 5;
(*(PtrParIn->PtrComp)).IntComp = PtrParIn->IntComp;
(*(PtrParIn->PtrComp)).PtrComp = PtrParIn->PtrComp;
Proc3((*(PtrParIn->PtrComp)).PtrComp);
if ((*(PtrParIn->PtrComp)).Discr == 1)
{
(*(PtrParIn->PtrComp)).IntComp = 6;
Proc6(PtrParIn->EnumComp, &(*(PtrParIn->PtrComp)).EnumComp);
(*(PtrParIn->PtrComp)).PtrComp = PtrGlb->PtrComp;
Proc7((*(PtrParIn->PtrComp)).IntComp, 10, &(*(PtrParIn->PtrComp)).IntComp);
}
else
memcpy(PtrParIn, &((*(PtrParIn->PtrComp))), sizeof((*(PtrParIn->PtrComp))));
}
Proc2(IntParIO)
int	*IntParIO;
{
 int		IntLoc;
 int		EnumLoc;
IntLoc = *IntParIO + 10;
for(;;)
{
if (Char1Glob == 'A')
{
--IntLoc;
*IntParIO = IntLoc - IntGlob;
EnumLoc = 1;
}
if (EnumLoc == 1)
break;
}
}
Proc3(PtrParOut)
struct Record *	*PtrParOut;
{
if (PtrGlb != 0)
*PtrParOut = PtrGlb->PtrComp;
else
IntGlob = 100;
Proc7(10, IntGlob, &PtrGlb->IntComp);
}
Proc4()
{
 int	BoolLoc;
BoolLoc = Char1Glob == 'A';
BoolLoc =| BoolGlob;
Char2Glob = 'B';
}
Proc5()
{
Char1Glob = 'A';
BoolGlob = 0;
}
extern int Func3();
Proc6(EnumParIn, EnumParOut)
 int	EnumParIn;
 int	*EnumParOut;
{
*EnumParOut = EnumParIn;
if (! Func3(EnumParIn) )
*EnumParOut = 4;
switch (EnumParIn)
{
case 1:	*EnumParOut = 1; break;
case 2:	if (IntGlob > 100) *EnumParOut = 1;
else *EnumParOut = 4;
break;
case 3:	*EnumParOut = 2; break;
case 4:	break;
case 5:	*EnumParOut = 3;
}
}
Proc7(IntParI1, IntParI2, IntParOut)
int	IntParI1;
int	IntParI2;
int	*IntParOut;
{
 int	IntLoc;
IntLoc = IntParI1 + 2;
*IntParOut = IntParI2 + IntLoc;
}
Proc8(Array1Par, Array2Par, IntParI1, IntParI2)
int Array1Par[51];
int Array2Par[51][51];
int	IntParI1;
int	IntParI2;
{
 int	IntLoc;
 int	IntIndex;
IntLoc = IntParI1 + 5;
Array1Par[IntLoc] = IntParI2;
Array1Par[IntLoc+1] = Array1Par[IntLoc];
Array1Par[IntLoc+30] = IntLoc;
for (IntIndex = IntLoc; IntIndex <= (IntLoc+1); ++IntIndex)
Array2Par[IntLoc][IntIndex] = IntLoc;
++Array2Par[IntLoc][IntLoc-1];
Array2Par[IntLoc+20][IntLoc] = Array1Par[IntLoc];
IntGlob = 5;
}
int Func1(CharPar1, CharPar2)
char	CharPar1;
char	CharPar2;
{
 char	CharLoc1;
 char	CharLoc2;
CharLoc1 = CharPar1;
CharLoc2 = CharLoc1;
if (CharLoc2 != CharPar2)
return (1);
else
return (2);
}
int Func2(StrParI1, StrParI2)
char StrParI1[31];
char StrParI2[31];
{
 int		IntLoc;
 char	CharLoc;
IntLoc = 1;
while (IntLoc <= 1)
if (Func1(StrParI1[IntLoc], StrParI2[IntLoc+1]) == 1)
{
CharLoc = 'A';
++IntLoc;
}
if (CharLoc >= 'W' && CharLoc <= 'Z')
IntLoc = 7;
if (CharLoc == 'X')
return(1);
else
{
if (strcmp(StrParI1, StrParI2) > 0)
{
IntLoc =+ 7;
return (1);
}
else
return (0);
}
}
int Func3(EnumParIn)
 int	EnumParIn;
{
 int	EnumLoc;
EnumLoc = EnumParIn;
if (EnumLoc == 3) return (1);
return (0);
}
memcpy(d, s, l)
char	*d;
char	*s;
int	l;
{
while (l--) *d++ = *s++;
}

strcpy(d,s) char *d,*s; { while(*d++ = *s++); }
strcmp(a,b) char *a,*b; { while (*a == *b && *a != 0) { a++; b++; } return (*a - *b); }
