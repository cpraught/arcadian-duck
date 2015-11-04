#!/usr/bin/perl
print "Content-type: text/html\n\n";

opendir (DIR, "$MainPath/users");
@Users = readdir (DIR);
closedir (DIR);

foreach $Item (sort(@Users)) {
	if (-f "$MainPath/users/$Item") {
		$Nitem = $Item;
		$Nitem =~ tr/_/ /;
		$List .= "<option name=$Item>$Nitem<\/option>";
	}
}

$TechCost = 5000;

$data{'send'} =~ s/\D//g;
if (-e "$MainPath/users/$data{'send'}" && $data{'send'} ne "") {

	if (@CountryData[45] < $yday) {

		open (IN, "$MainPath/users/$data{'send'}");
		flock (IN, 1);
		@SendData = <IN>;
		close (IN);
		&chopper (@SendData);

		if (@SendData[40] >= 193) {

			$ValueOne = (@SendData[9] + @SendData[10] + @SendData[11] + int(abs($data{'intop'})) + int(abs($data{'cintop'})) + int(abs($data{'commando'})));
			$ValueTwo = int((@SendData[4] + @SendData[5] + @SendData[6] + @SendData[7] + @SendData[8]) * 0.1);

			if (abs($data{'money'}) <= @CountryData[3]) {@SendData[3] += abs($data{'money'});@CountryData[3]-=abs($data{'money'});}

			if ($ValueOne < $ValueTwo) {

				if (abs($data{'intop'}) <= @CountryData[9]) {@SendData[9] += int(abs($data{'intop'})); @CountryData[9] -= int(abs($data{'intop'}));}	
				if (abs($data{'cintop'}) <= @CountryData[10]) {@SendData[10] += int(abs($data{'cintop'})); @CountryData[10] -= int(abs($data{'cintop'}));}
				if (abs($data{'commando'}) <= @CountryData[11]) {@SendData[11] += int(abs($data{'commando'})); @CountryData[11] -= int(abs($data{'commando'}));}
			}

			if (abs(int($data{'civil2'})) < @CountryData[12])    {$SCiv = abs(int($data{'civil2'}));   @SendData[12] += int(0.9 * $SCiv);@CountryData[12] -= $SCiv;}
			if (abs(int($data{'weapon2'})) < @CountryData[13])   {$SWpn = abs(int($data{'weapon2'}));  @SendData[13] += int(0.9 * $SWpn);@CountryData[13] -= $SWpn;}
			if (abs(int($data{'armour2'})) < @CountryData[14])   {$SArm = abs(int($data{'armou2r'}));  @SendData[14] += int(0.9 * $SArm);@CountryData[14] -= $SArm;}
			if (abs(int($data{'tactic2'})) < @CountryData[15])   {$STac = abs(int($data{'covert2'}));  @SendData[16] += int(0.9 * $SCov);@CountryData[16] -= $SCov;}
			if (abs(int($data{'spec2'})) < @CountryData[17])     {$SSpc = abs(int($data{'spec2'}));    @SendData[17] += int(0.9 * $SSpc);@CountryData[17] -= $SSpc;}
			if (abs(int($data{'military2'})) < @CountryData[18]) {$SMil = abs(int($data{'military2'}));@SendData[18] += int(0.9 * $SMil);@CountryData[18] -= $SMil;}

			open (OUT, ">$MainPath/users/$data{'send'}");
			flock (OUT, 2);
			foreach $Item (@SendData) {
		 		print OUT "$Item\n";
			}
			close (OUT);
			@CountryData[45] = $yday;
		} else {$Message = qq!<B>Cannot trade with targets in protection.</B><BR><BR>!;}
	} else {$Message = qq!<b>You may only make one trade per day.</b><BR><BR>!;}
}


$TotalPoints = (int(abs($data{'12'})) + int(abs($data{'13'})) + int(abs($data{'14'})) + int(abs($data{'15'})) + int(abs($data{'16'})) +int(abs($data{'17'})) + int(abs($data{'18'})));
&TechRate;

if ($data{'changed'} == 1 ) {	
	if ( ($TotalPoints <= 100) && ($TotalPoints >= 0) ) {
		@CountryData[51] = abs(int($data{'12'}));
		@CountryData[52] = abs(int($data{'13'}));
		@CountryData[53] = abs(int($data{'14'}));
		@CountryData[54] = abs(int($data{'15'}));
		@CountryData[55] = abs(int($data{'16'}));
		@CountryData[56] = abs(int($data{'17'}));
		@CountryData[57] = abs(int($data{'18'}));
	}
}

$Civil    = &PercentFinder(@CountryData[12]);
$Weapon   = &PercentFinder(@CountryData[13]);
$Armour   = &PercentFinder(@CountryData[14]);
$Tactic   = &PercentFinder(@CountryData[15]);
$Covert   = &PercentFinder(@CountryData[16]);
$Spec     = &PercentFinder(@CountryData[17]);
$Military = &PercentFinder(@CountryData[18]);

&StatLine;

print qq—
<head><Title>ASH - Economy Menu</title></HEAD>
<body bgcolor=black text=white background=$BGPic alink=$FColourOne link=$FColourOne vlink=$FColourOne>$Font<BR><BR>
<a name=top>
<center>

$BannerCode

</center><table border=0 width=100% cellspacing=0>


$LinkLine
</table>
<BR><BR>
<center>
<form method=POST action="Runner2.pl?$User&$Pword&5">

<center><BR>$Message
<Table width=50% border=0 cellspacing=0>
<TR><TD>$$NewFont1 Send trade envoy to (country number)</TD><TD>$Font<input type=text name=send size=6></TD></TR>
</table></center>
<table width=40% width=1 cellspacing=0>
<TR><TD colspan=2>$NewFont1 Points Per Turn</TD><TD>$NewFont2 $TechPoints</TD><TD>&nbsp;</TD></TR>
</table><BR>
<table width=70% width=1 cellspacing=0>
<TR><TD>$NewFont1 Type</TD><TD>$NewFont1 Percent Complete</TD><TD>$NewFont1 Percent of Total</TD><TD>$NewFont1 Trade</TD></TR>
<TR><TD>$NewFont2 <A href="Runner2.pl?$User&$Pword&17" style=color:$FColourTwo>Civil</a>    </TD><TD>$NewFont2 $Civil%</TD><TD>$NewFont2<input type=text name=12 size=3 			maxsize=3 value="@CountryData[51]"></TD><TD>$NewFont2 <input type=text name=civil2 size=10></Td></TR>
<TR><TD>$NewFont2 <A href="Runner2.pl?$User&$Pword&17" style=color:$FColourTwo>Weaponry</a> </TD><TD>$NewFont2 $Weapon%</TD><TD>$NewFont2 <input type=text name=13 size=3 		maxsize=3 value="@CountryData[52]"></TD><TD>$NewFont2 <input type=text name=weapon2 size=10></Td></TR>
<TR><TD>$NewFont2 <A href="Runner2.pl?$User&$Pword&17" style=color:$FColourTwo>Armour</a>   </TD><TD>$NewFont2 $Armour%</TD><TD>$NewFont2 <input type=text name=14 size=3 		maxsize=3 value="@CountryData[53]"></TD><TD>$NewFont2 <input type=text name=armour2 size=10></Td></TR>
<TR><TD>$NewFont2 <A href="Runner2.pl?$User&$Pword&17" style=color:$FColourTwo>Tactics</a>  </TD><TD>$NewFont2 $Tactic%</TD><TD>$NewFont2 <input type=text name=15 size=3 		maxsize=3 value="@CountryData[54]"></TD><TD>$NewFont2 <input type=text name=tactic2 size=10></Td></TR>
<TR><TD>$NewFont2 <A href="Runner2.pl?$User&$Pword&17" style=color:$FColourTwo>Covert</a>   </TD><TD>$NewFont2 $Covert%</TD><TD>$NewFont2 <input type=text name=16 size=3 		maxsize=3 value="@CountryData[55]"></TD><TD>$NewFont2 <input type=text name=covert2 size=10></Td></TR>
<TR><TD>$NewFont2 <A href="Runner2.pl?$User&$Pword&17" style=color:$FColourTwo>Spec Ops</a> </TD><TD>$NewFont2 $Spec%</TD><TD>$NewFont2 <input type=text name=17 size=3 		maxsize=3 value="@CountryData[56]"></TD><TD>$NewFont2 <input type=text name=spec2 size=10></Td></TR>
<TR><TD>$NewFont2 <A href="Runner2.pl?$User&$Pword&17" style=color:$FColourTwo>Military</a> </TD><TD>$NewFont2 $Military%</TD><TD>$NewFont2 <input type=text name=18 size=3 		maxsize=3 value="@CountryData[57]"></TD><TD>$NewFont2 <input type=text name=military2 size=10></Td></TR>
</table><BR><BR>

<table width=70% width=1 cellspacing=0>
<TR><TD>$NewFont1 Resource Type</TD><TD>$NewFont1 Number Owned</TD><TD>$NewFont1 Transfer</TD></TR>
<TR><TD>$NewFont2 Covert Intelligence Operative</TD><TD>$NewFont2 @CountryData[9]</TD><TD>$NewFont2 <input type=text name=intop size=5></TD></TR>
<TR><TD>$NewFont2 Counter-Intelligence Officer</TD><TD>$NewFont2 @CountryData[10]</TD><TD>$NewFont2 <input type=text name=cintop size=5></TD></TR>
<TR><TD>$NewFont2 Commando</TD><TD>$NewFont2 @CountryData[11]</TD><TD>$NewFont2 <input type=text name=commando size=5></TD></TR>
<TR><TD>$NewFont2 Money</TD><TD>$NewFont2 \$@{[&Space(@CountryData[3])]}</TD><TD>$NewFont2 <input type=text name=money></Td></TR>
</table><BR><BR>

<input type=hidden name=changed value=1>
<center><input type=submit name=submit value="Apply Changes">
</form><BR>$TurnMessage
</center>


</body>—;


sub TechRate
{

	$Res = @CountryData[4];
	$Com = @CountryData[5];
	$Ind = @CountryData[6];
	$Gov = @CountryData[7];
	$Con = @CountryData[8];	

	$TotalBuildings = $Res + $Com + $Ind + $Gov + $Con + @CountryData[19];
	if ($Com == 0) {$ConPercent = 0;} else {$ConPercent = $Com/$TotalBuildings;}
	if ($ConPercent >= 0.00) {$Rate = 1.00;}
	if ($ConPercent >= 0.02) {$Rate = 1.02;}
	if ($ConPercent >= 0.04) {$Rate = 1.04;}
	if ($ConPercent >= 0.05) {$Rate = 1.08;}
	if ($ConPercent >= 0.06) {$Rate = 1.10;}
	if ($ConPercent >= 0.10) {$Rate = 1.12;}
	if ($ConPercent >= 0.11) {$Rate = 1.14;}
	if ($ConPercent >= 0.15) {$Rate = 1.16;}
	if ($ConPercent >= 0.16) {$Rate = 1.18;}
	if ($ConPercent >= 0.20) {$Rate = 1.20;}
	if ($ConPercent >= 0.16) {$Rate = 1.25;}
	if ($ConPercent >= 0.30) {$Rate = 1.35;}
	if ($ConPercent >= 0.50) {$Rate = 1.50;}
	$TechPoints = int(@CountryData[5] * 1 * $Rate);
}

sub PercentFinder
{
	my $Value = @_[0];
	my $Counter = 0;
	my $Percent = 0;
	for ($Counter = 0; $Counter < scalar(@LevelUp); $Counter ++) {

		if ($Value < @LevelUp[$Counter] && $Counter == 0) {
			$Percent = int(($Value / @LevelUp[0]) * 100);
			$Counter = scalar(@LevelUp) + 1;

		} elsif ($Value < @LevelUp[$Counter] && $Value >= @LevelUp[$Counter-1] && $Counter != 0) {

			$Percent = int(( ($Value - @LevelUp[$Counter-1]) / (@LevelUp[$Counter] - @LevelUp[$Counter-1]) ) * 100);
			$Counter = scalar(@LevelUp) + 1;
		}
	}
	if ($Percent < 0) {$Percent = 0;}
	return $Percent;

}
