#!/usr/bin/perl

print "Content-type: text/html\n\n";

#Determine Unit Costs
my $SpyCost = 15000;
my $CSpyCost = 15000;
my $CommandoCost = 25000;
my $EliteCost = 250000;

$Spy = int($data{'spy'});
$CSpy = int($data{'cspy'});
$Commando = int($data{'commando'});

$EliteCounter = 0;
for (my $i = 24;$i < 29;$i++) {
	if (@CountryData[$i] ne "None,None,None,None,None,None,None") {$EliteCounter ++;}
}

#Spies
if ($Spy > 0) {
	if (($Spy + @CountryData[9] + @CountryData[10] + @CountryData[11]) < int((@CountryData[4] + @CountryData[5] + @CountryData[6] + @CountryData[7] + @CountryData[8]) * 0.1)) {
		$TCost = int(abs($Spy)) * $SpyCost;
		if ($TCost < @CountryData[3]) {
			@CountryData[9] += int(abs($Spy));
			@CountryData[3] -= $TCost;
		} else {
			$OpMessage = qq!You cannot afford this many units.<BR><BR>!;
		}
	} else {$OpMessage = qq!Your land cannot support this many units.<BR><BR>!;}
} elsif ($Spy < 0) {
	if ($Spy + @CountryData[9] < 0) {@CountryData[9] = 0;} else {@CountryData[9] += $Spy;}
}


#Counter-Spies

if ($CSpy > 0) {
	if (($CSpy + @CountryData[9] + @CountryData[10] + @CountryData[11]) < int((@CountryData[4] + @CountryData[5] + @CountryData[6] + @CountryData[7] + @CountryData[8]) * 0.1)) {
		$TCost = $CSpy * $CSpyCost;
		if ($TCost < @CountryData[3]) {
			@CountryData[10] += $CSpy;
			@CountryData[3] -= $TCost;
		} else {
			$OpMessage = qq!You cannot afford this many units.<BR><BR>!;
		}
	} else {$OpMessage = qq!Your land cannot support this many units.<BR><BR>!;}
} elsif ($CSpy < 0) {
	if ($CSpy + @CountryData[10] < 0) {@CountryData[10] = 0;} else {@CountryData[10] += $CSpy;}
}

#Commandos
if ($Commando > 0) {
	if (($Commando + @CountryData[9] + @CountryData[10] + @CountryData[11]) < int((@CountryData[4] + @CountryData[5] + @CountryData[6] + @CountryData[7] + @CountryData[8]) * 0.1)) {
		$TCost = $Commando * $CommandoCost;
		if ($TCost < @CountryData[3]) {
			@CountryData[11] += $Commando;
			@CountryData[3] -= $TCost;
		} else {
			$OpMessage = qq!You cannot afford this many units.<BR><BR>!;
		}
	} else {$OpMessage = qq!Your land cannot support this many units.<BR><BR>!;}
} elsif ($Commando < 0) {
	if ($Commando + @CountryData[11] < 0) {@CountryData[10] = 0;} else {@CountryData[11] += $Commando;}
}

if ($data{'spec'} eq "On") {
	if (@CountryData[3] > $EliteCost && $Elites + 1 < 6) {
		@CountryData[3] -= $EliteCost;
		for (my $i = 24;$i < 29;$i++) {
			unless (substr(@CountryData[$i],0,4) eq "None") {next;}
			unless ($BuiltFlag == 1) {
				$Str = int(rand(16)) + 4;	#Strength
				$Agi = int(rand(16)) + 4;	#Agility
				$Int = int(rand(16)) + 4;	#Intelligence
				$Dip = int(rand(16)) + 4;	#Diplomacy
				$Acc = int(rand(16)) + 4;	#Accuracy
				$Rea = int(rand(16)) + 4;	#Reactions
				$Hlt = int(rand(20)) + 10;	#Health
				&Names;
				$Fname = @FNames[rand($#FNames)];
				$Lname = @LNames[rand($#LNames)];
				$Clsgn = @Clsgns[rand($#Clsgns)];
				$Ethos = @EthosTypes[rand($#EthosTypes)];
			       		
				#FName "Callsign" LName,Ethos, Level, XP, Weapon, Armour, Cost,Str, Agi, Int, Dip, Acc, Rea, Hlt, MaxHlth
				@CountryData[$i] = qq!$Fname "$Clsgn" $Lname,$Ethos,0,0,None,None,125000,$Str,$Agi,$Int,$Dip,$Acc,$Rea,$Hlt, $Hlt!;
				$BuiltFlag = 1;
			}			
		}		
	} else {$Message .= "ELITE could not be hired.  You may only have a maximum of 5 ELITE, and must be able to pay the contract fee.<BR><BR>";}
}




	
&StatLine;

print qq�
<head>
<Title>ASH - Operative Menu</title>
</HEAD>
<body bgcolor=black text=white background="$BGPic" alink=$FColourOne link=$FColourOne vlink=$FColourOne>$Font<BR><BR>
<a name=top>
<center>

$BannerCode

</center><table border=0 width=100% cellspacing=0>


$LinkLine</table><BR><BR>
<center>
<form method=POST action="Runner2.pl?$User&$Pword&15">
<BR><BR><center>$OpMessage</center>

<table width=70% width=1 cellspacing=0>
<Tr><TD>$NewFont1 Type</TD><TD>$NewFont1 Employed</TD><TD>$NewFont1 Cost</TD><TD>$NewFont1 Hire</TD></TR>
<TR><TD>$NewFont2 Covert Intelligence Operative</TD><TD>$NewFont2 @{[&Space(@CountryData[9])]}</TD><TD>$NewFont2 \$@{[&Space($SpyCost)]}</TD><TD>$NewFont2 <input type=text name=spy size=10></TD></TR>
<TR><TD>$NewFont2 Counter-Intelligence Officer</TD><TD>$NewFont2 @{[&Space(@CountryData[10])]}</TD><TD>$NewFont2 \$@{[&Space($CSpyCost)]}</TD><TD>$NewFont2 <input type=text name=cspy size=10></TD></TR>
<TR><TD>$NewFont2 Commandos</TD><TD>$NewFont2 @{[&Space(@CountryData[11])]}</TD><TD>$NewFont2 \$@{[&Space($CommandoCost)]}</TD><TD>$NewFont2 <input type=text name=commando size=10></TD></TR>
<TR><TD>$NewFont2 ELITE</TD><TD>$NewFont2 $EliteCounter</TD><TD>$NewFont2 \$@{[&Space($EliteCost)]}</TD><TD>$NewFont2 <input type=checkbox name=spec value=On><TR>

</table><BR><BR>
<table width=70% width=1 cellspacing=0>
<TR><TD>$NewFont1 Name (Status Link)</TD><TD>$NewFont1 Ethos</TD><TD>$NewFont1 Level</TD><TD>$NewFont1 Weapon</TD><TD>$NewFont1 Armour</TD><TD>$NewFont1 Cost</TD></TR>
<TR><td colspan=6><hr width=100% size=1></TD></TR>
�;
	for (my $i = 24;$i < 29;$i++) {
		my @Array = split(/,/,@CountryData[$i]);
		if (@Array[0] ne "None") {
			print qq!<TR><TD>$NewFont1 <A href="Runner2.pl?$User&$Pword&7&$i" style="color:green">@Array[0]</A></TD><TD>$NewFont2 @Array[1]</TD><TD>$NewFont2 @Array[2]</TD><TD>$NewFont2 @Array[4]</TD><TD>$NewFont2 @Array[5]</tD><TD>$NewFont2 \$@{[&Space(@Array[6])]}</TD></TR>!;
		}
	}

print qq!</table><BR><BR>

<input type=submit name=submit value="Adjust Troops"></form><BR>
<BR>$TurnMessage
</center>


</body>!;


sub Names
{
	@FNames[0] = "Chris";
	@FNames[1] = "Rick";
	@FNames[2] = "Mike";
	@FNames[3] = "Sarah";
	@FNames[4] = "Kate";
	@FNames[5] = "Turner";
	@FNames[6] = "Warren";
	@FNames[7] = "Charlene";
	@FNames[8] = "Polly";	

	@LNames[0] = "Pastin";
	@LNames[1] = "Katho";
	@LNames[2] = "Sarcas";
	@LNames[3] = "Duasi";
	@LNames[4] = "Opear";
	@LNames[5] = "Mathais";
	@LNames[6] = "Elenic";
	@LNames[7] = "Copas";
	@LNames[8] = "Tangre";
	@LNames[9] = "Skavic";
	@LNames[10] = "Ester";

	@Clsgns[0] = "Rocket";
	@Clsgns[1] = "Tank";
	@Clsgns[2] = "Tread";
	@Clsgns[3] = "Defender";
	@Clsgns[4] = "Dragon";
	@Clsgns[5] = "Warrior";
	@Clsgns[6] = "Fox";
	@Clsgns[7] = "JackRabbit";
	@Clsgns[8] = "Striker";
	@Clsgns[9] = "Blade";
	
	@EthosTypes[0] = "Mercenary";
	@EthosTypes[1] = "Rogue";
	@EthosTypes[2] = "Soldier";
	@EthosTypes[3] = "Professional";			
}
