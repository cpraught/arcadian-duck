#!/usr/bin/perl

print "Content-type: text/html\n\n";
$MailPath = "$MainPath/messages";

$OperationList = qq!<option value=1>General Intelligence</option><option value=2>Diplomatic Intelligence</option><option value=3>Research Intelligence</option>!;
if (@CountryData[16] >= @LevelUp[0]) {$OperationList .= "<option value=4>Sabotage Diplomacy</option>";@Op[4] = 1;}
if (@CountryData[16] >= @LevelUp[1]) {$OperationList .= "<option value=5>Infiltrate Country</option>";@Op[5]=1;}
if (@CountryData[16] >= @LevelUp[2]) {$OperationList .= "<option value=6>Copy Technology</option>";@Op[6]=1;}
if (@CountryData[16] >= @LevelUp[3]) {$OperationList .= "<option value=7>Disrupt Intelligence</option>";@Op[7]=1;}
if (@CountryData[16] >= @LevelUp[4]) {$OperationList .= "<option value=8>Break Defense</option>";@Op[8]=1;}
if (@CountryData[16] >= @LevelUp[5]) {$OperationList .= "<option Value=9>Sabotage ELITE</option>";@Op[9]=1;}
if (@CountryData[16] >= @LevelUp[6]) {$OperationList .= "<option value=10>Convert ELITE</option>";@Op[10]=1;}

if (@CountryData[17] >= @LevelUp[0]) {$OperationList2 .= "<option value=1>Demolitions</option>";@Op2[0] = 1;}
if (@CountryData[17] >= @LevelUp[1]) {$OperationList2 .= "<option value=2>Exploration</option>";@Op2[1]=1;}
if (@CountryData[17] >= @LevelUp[2]) {$OperationList2 .= "<option value=3>Tech Raid</option>";@Op2[2]=1;}
if (@CountryData[17] >= @LevelUp[3]) {$OperationList2 .= "<option value=4>Annex</option>";@Op2[3]=1;}
if (@CountryData[17] >= @LevelUp[4]) {$OperationList2 .= "<option value=5>Incursion</option>";@Op2[4]=1;}
if (@CountryData[17] >= @LevelUp[5]) {$OperationList2 .= "<option Value=6>Assassination</option>";@Op2[5]=1;}

$View = "Welcome to the Operations Room.  It is from here that you will launch attacks against your enemies.";

if ($data{'go'} == 1) {&RunOps;}
&StatLine;

for ($i = 24; $i < 29; $i ++) {
	unless (substr (@CountryData[$i],0,4) eq "None") {
		my @TempElite = split(/,/, @CountryData[$i]);
		$EliteList .= qq!<option value=$i>@TempElite[0]</option>!;
	}

}

print qq!
<head><Title>ASH - Operations Menu</title></HEAD>
</HEAD>
<body bgcolor=black text=white background="$BGPic" alink=$FColourOne link=$FColourOne vlink=$FColourOne>$Font<BR><BR>
<a name=top>
<center>
<center>

$BannerCode

</center><table border=0 width=100% cellspacing=0>
$LinkLine
</table>
<BR><BR>
<center>$FinishedMessage
<form method=POST action="Runner2.pl?$User&$Pword&16">
$View<BR><BR>
<Table border=0 cellpadding=0 cellspacing=0 width=70%>

<TR><TD width=50%>

  <table width=100%>
  <TR><TD colspan=2>$NewFont1 <font size=+1><B>Covert Operation</td></TR>
  <TR><TD>$NewFont2 Operation</TD><TD>$Font<select name=op><option value=0>None</option>$OperationList</select></TD></TR>
  <TR><TD>$NewFont2 Covert Intelligence Operatives</TD><TD>$Font<input type=text name=spy value=0 size=6></TD></TR>
  <TD>$NewFont2 ELITE</TD><TD>$Font <select name=ELITE><option value=0>None</option>$EliteList</select></TD>
  <TR><TD>$NewFont2 Target</TD><TD>$Font<input type=text name=target value=0 size=4 maxsize=4></TD></TR>
  </table>

</TD><TD>

  <table width=100%>
  <TR><TD colspan=2>$NewFont1 <font size=+1><B>Commando Operation</td></TR>
  <TR><TD>$NewFont2 Operation</TD><TD>$Font<select name=op2><option value=0>None</option>$OperationList2</select></TD></TR>
  <TR><TD>$NewFont2 Commandos</TD> <TD>$Font<input type=text name=commando value=0 size=6></TD></TR>
  <TD>$NewFont2 ELITE</TD><TD>$Font <select name=ELITE><option value=0>None</option>$EliteList</select></TD>
  <TR><TD>$NewFont2 Target</TD><TD>$Font<input type=text name=target2 value=0 size=4 maxsize=4></TD></TR>
  </table>

</TD></TR></table><BR>
$TargetList
</table>
<input type=hidden value=1 name=go>
<input type=submit value=" Launch Mission " name=submit>
</form><BR><center>$TurnMessage</center>
!;

sub RunOps 
{

	if (@CountryData[40] > 193) {

		if (int(abs($data{'op'})) > 0) {
			require ("SpyOperations.pl");
		} elsif (int(abs($data{'op2'})) > 0) {
			require ("CommandoOperations.pl");
		}

	} else {$View = qq!You are still in protection.  Operations cannot be undertaken.!;}
}

sub RankFinder
{
	my $TotalNet = @CountryData[32] + @TargetData[32];
	my $TempVal = 0;
	if (@CountryData[32] > @TargetData[32]) {$TempVal = @CountryData[32];} else {$TempVal = @TargetData[32];}

	my $Percent = $TempVal / $TotalNet;

	$TurnsToRun = 4;
	if ($Percent >= 0.60) {$TurnsToRun = 6;}
	if ($Percent >= 0.70) {$TurnsToRun = 8;}
	if ($Percent >= 0.80) {$TurnsToRun = 10;}
	if ($Percent >= 0.85) {$TurnsToRun = 12;}
	if ($Percent >= 0.90) {$TurnsToRun = 14;}
	if ($Percent >= 0.95) {$TurnsToRun = 16;}
}
