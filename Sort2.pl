#!/usr/bin/perl
print "Content-type: text/html\n\n";

&StatLine;

print qq—
<head><Title>ASH - Game Rankings</title></HEAD>
<body bgcolor=black text=white background=$BGPic alink=$FColourOne link=$FColourOne vlink=$FColourOne>$Font<BR><BR>
<a name=top>
<center>

$BannerCode

</center><table border=0 width=100% cellspacing=0>

$LinkLine
</table><BR><BR><BR><center>

<a href="http://www.bluewand.com/cgi-bin/ash/Runner2.pl?$User&$Pword&13" style="color:$FColorOne">ASH Player Rankings</a><BR><BR>
<a href="http://www.bluewand.com/cgi-bin/ash/Runner2.pl?$User&$Pword&14" style="color:$FColourOne">ASH Sub-Faction Rankings</a><BR><BR><BR><BR>
—;

open (IN, "$MainPath/Players.lst");
flock (IN, 1);
my @Players = <IN>;
&chopper (@Players);
close (IN);


print qq!
	<Table width=70% cellspacing=0 border=0>
	<TR><TD>$NewFont1 Number</tD><TD>$NewFont1 Rank</TD><TD>$NewFont1 Country Name</TD><TD>$NewFont1 Faction Name</TD><TD>$NewFont1 Networth</TD></TR>
	<TR height=3><TD colspan=5>$Font <HR width=100% height=1></TD></TR>
!;
for ($i = 0; $i < 10; $i ++) {
	open (IN, "$MainPath/users/@Players[$i]");
	flock (IN, 1);
	my @PlayerNfo = <IN>;
	close (IN);
	&chopper (@PlayerNfo);

	print qq!<TR><TD>$NewFont2 @Players[$i]</TD><TD>$NewFont2 @{[$i+1]}</TD><TD>$NewFont2 @PlayerNfo[34]</TD><TD>$NewFont1 $NewFont2 $FacAlign{@PlayerNfo[1]}</TD><TD>$NewFont2 @{[&Space(@PlayerNfo[32])]}</TD></TR>!;
	if ($i == 5) {print qq!<TR height=3><TD colspan=5>$Font <center><HR width=80% height=1></TD></TR>!;}
}

open (IN, "$MainPath/Factions.lst");
flock (IN, 1);
my @Factions = <IN>;
&chopper (@Factions);
close (IN);

print qq!
	</Table><BR><BR><BR><BR><BR>
	<Table width=70% cellspacing=0 border=0>
	<TR><TD>$NewFont1  Rank</TD><TD>$NewFont1 Sub-Faction Name</TD><TD>$NewFont1 Aligned</TD><TD>$NewFont1 Networth</TD></TR>
	<TR height=3><TD colspan=5><HR width=100% height=1></TD></TR>
!;

for ($i = 0; $i < 3; $i ++) {
	if (-e "$MainPath/clans/1/@Factions[$i]") {$FacValue = 1;}
	if (-e "$MainPath/clans/2/@Factions[$i]") {$FacValue = 2;}
	if (-e "$MainPath/clans/3/@Factions[$i]") {$FacValue = 3;}

	open (IN, "$MainPath/clans/$FacValue/@Factions[$i]");
	flock (IN, 1);
	my @FactionNfo = <IN>;
	close (IN);
	&chopper (@FactionNfo);

	my $TmpNme = @Factions[$i];
	$TmpNme =~ tr/_/ /;

	print qq!<TR><TD>$NewFont2 @{[$i+1]}</TD><TD>$NewFont2 $TmpNme</TD><TD>$NewFont2 $FacAlign{$FacValue}</TD><TD>$NewFont2 @{[&Space(@FactionNfo[10])]}</TD></TR>!;
	if ($i == 5) {print qq!<TR height=3><TD colspan=5>$Font <center><HR width=80% height=1></TD></TR>!;}
}
print qq!</table>!;
