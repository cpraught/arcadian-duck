#!/usr/bin/perl
print "Content-type: text/html\n\n";

if (defined $data{'tax'} || defined $data{'war'}) {
	$data{'tax'} = int(abs($data{'tax'}));
	$data{'war'} = int(abs($data{'war'}));
	if ($data{'tax'} > 100) {$data{'tax'} = 100;}
	if ($data{'tax'} < 0) {$data{'tax'} = 0;}
	if ($data{'war'} > 100) {$data{'war'} = 100;}
	if ($data{'war'} < 0) {$data{'war'} = 0;}
	@CountryData[2] = "$data{'tax'},$data{'war'}";
}

($Tax, $War) = split(/,/, @CountryData[2]);

$Res = @CountryData[4];
$Com = @CountryData[5];
$Ind = @CountryData[6];
$Gov = @CountryData[7];
$Con = @CountryData[8];

$TotalBuildings = $Res + $Com + $Ind + $Gov + $Con + @CountryData[19];
if ($Con == 0) {$ConPercent = 0;} else {$ConPercent = $Con/$TotalBuildings;}

&BuildRate;
if ($Tax > 10) {$TaxWarnMessage = qq!$Font<font color=red>Warning.  Citizens will protest any rate above 10%  We MAY be forced to put down a rebellion.!;}

$TotalConstruct = abs($data{'res'}) + abs($data{'com'}) + abs($data{'gov'}) + abs($data{'con'}) + abs($data{'ind'});
$TurnsToUse = $TotalConstruct/$Rate;

$BuildCost = int(abs(($TotalBuildings - @CountryData[19]) / 300)) * 100 + 100;
if ($TurnsToUse - int($TurnsToUse) > 0) {$TurnsToUse = int($TurnsToUse+1);}
if (@CountryData[29] < $TurnsToUse) {$Message = "Not enough turns to complete construction.<BR><BR>";}
if ($TotalConstruct * $BuildCost > @CountryData[3]) {$Message = "Not enough money to complete construction.<BR><BR>";}
if ($TotalConstruct > @CountryData[19]) {$Message = "Not enough free land to construct buildings.<BR><BR>";}

if ($Message eq "") {
	for ($i = 0; $i < $TurnsToUse;$i++) {
		$TurnMessage .= &RunTurn;
	}	
	@CountryData[4] += int(abs($data{'res'}));
	@CountryData[5] += int(abs($data{'com'}));
	@CountryData[6] += int(abs($data{'ind'}));
	@CountryData[7] += int(abs($data{'gov'}));
	@CountryData[8] += int(abs($data{'con'}));
	@CountryData[3] -= ($TotalConstruct * $BuildCost);
	
	$Res = @CountryData[4];
	$Com = @CountryData[5];
	$Ind = @CountryData[6];
	$Gov = @CountryData[7];
	$Con = @CountryData[8];	
	@CountryData[19] -= $TotalConstruct;
}

$TotalBuildings = $Res + $Com + $Ind + $Gov + $Con + @CountryData[19];
if ($Con == 0) {$ConPercent = 0;} else {$ConPercent = $Con/$TotalBuildings;}
&BuildRate;
&StatLine;

print qqÑ
<head>
<Title>ASH - Government Menu</title>
</HEAD>
<body bgcolor=black text=white background=$BGPic alink=$FColourOne link=$FColourOne vlink=$FColourOne>
$Font
<BR><BR>
<form method=POST action="Runner2.pl?$User&$Pword&02 ">
<a name=top>
<center>

$BannerCode

</center><table border=0 width=100% cellspacing=0>


$LinkLine
</table><BR><BR>
<center>$Message
<table border=0 width=60% cellspacing=0>
<TR><TD>$NewFont1 Tax Rate</TD><TD>$NewFont2 <input type=text name=tax size=5 value=$Tax>%</TD><TD>$NewFont1 Military Funding</TD><TD>$NewFont2<input type=text name=war size=5 value=$War>%</TD><TD>$NewFont1 Free Land</TD><TD>$NewFont2 @{[&Space(@CountryData[19])]}</TD></tR>
<TR><TD colspan=7>$TaxWarnMessage</TD></TR>
<TR><TD>$NewFont1 Build Rate</TD><TD>$NewFont2 $Rate / Turn</TD><TD>$NewFont1 Build Cost</tD><TD colspan=2>$NewFont2 \$@{[&Space($BuildCost)]} / Building</TD></TR>
</table>
<BR><BR>
<table width=70% width=1 cellspacing=0>
<TR><TD>$NewFont1 Type</TD><TD>$NewFont1 Current Buildings</TD><TD>$NewFont1 Build</TD></TR>
<TR><TD>$NewFont2 Housing Complexes</TD><TD>$NewFont2$Res</TD><TD>$NewFont2 <input type=text size=5 name=res></TD></TR>
<TR><TD>$NewFont2 Research Facility</TD><TD>$NewFont2$Com</TD><TD>$NewFont2<input type=text size=5 name=com></TD></TR>
<TR><TD>$NewFont2 Production Centre</TD><TD>$NewFont2$Ind</TD><TD>$NewFont2<input type=text size=5 name=ind></TD></TR>
<TR><TD>$NewFont2 Government Installation</TD><TD>$NewFont2$Gov</TD><TD>$NewFont2<input type=text size=5 name=gov></TD></TR>
<TR><TD>$NewFont2 Construction Station</TD><TD>$NewFont2$Con</TD><TD>$NewFont2<input type=text size=5 name=con></TD></TR>
</table>
<input type=submit name=submit value="Apply Changes">
</form><BR>$TurnMessage
</center>


</body>Ñ;

sub BuildRate
{
	if ($ConPercent >= 0.00) {$Rate = 4;}
	if ($ConPercent >= 0.02) {$Rate = 5;}
	if ($ConPercent >= 0.04) {$Rate = 6;}
	if ($ConPercent >= 0.05) {$Rate = 7;}
	if ($ConPercent >= 0.06) {$Rate = 8;}
	if ($ConPercent >= 0.10) {$Rate = 9;}
	if ($ConPercent >= 0.11) {$Rate = 10;}
	if ($ConPercent >= 0.15) {$Rate = 11;}
	if ($ConPercent >= 0.16) {$Rate = 12;}
	if ($ConPercent >= 0.20) {$Rate = 13;}
	if ($ConPercent >= 0.16) {$Rate = 14;}
	if ($ConPercent >= 0.30) {$Rate = 15;}
	if ($ConPercent >= 0.50) {$Rate = 16;}
}
