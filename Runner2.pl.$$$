#!/usr/bin/perl

($User,$Pword,$Script,$Misc) = split(/&/,$ENV{QUERY_STRING});
$IP = $ENV{'REMOTE_ADDR'};
$User =~ s/\D//g;

#Included Files
use Fcntl;
use SDBM_File;

#Paths & Formating
$MainPath = "/home/bluewand/data/ash";
$Font = qq!<Font face=verdana size=-1 color=white>!;
$Font2 = qq!<Font face=verdana size=-1 color=black>!;
$Font3 = qq!<Font face=verdana size=-1 color=white><B>!;
$Key = qq!<Font size=2 face=verdana>!;

$BGPic = "http://www.bluewand.com/ash/picture.gif";

$FacAlign{1} = "Terran Liberation Army";
$FacAlign{2} = "Free Republic";
$FacAlign{3} = "Socialist Federation";

@Developments = (
	["Scavenging","Artifact Restoration","Bio-Engineering","Robotics","Nano-Technology","Plasma Technology","Cloning","Fountain of Life","Civil Level Nine"],	#Civil
	["High Velocity Gun","Repeater Cannon", "Homing Laser","Plasma Assaulter","Micro-Missle Cannon","Sonic Oscillator","Fusion Rifle", "AM Cannon"],	#Weaponry
	["Poly-carbonate Armour", "Tri-Alloy Armour","Blast Armour","Mechanized Exo-Skeleton","Hardened Blast Armour", "Light Power Armour","Heavy Bionic Armour","Assault Power Armour","Sentient Armour"],	#Armour
	["Agility Booster","Surveillance","Adrenaline Booster","Defense Matrix","Reaction Booster","Controlled Access","Accuracy Training","Implant Net","Eye in the Sky"],	#Tactics
	["Sabotage Diplomacy","Sabotage Research", "Copy Technology","Disrupt Intelligence","Break Defense", "Sabotage ELITE","Convert Elite"],	#Covert
	["Demolition", "Duel", "Tech Recovery", "Expedition","Incursion","Annex", "Equipment Raid"],	#Spec Ops
	["Armoured Assault","Mechanized Assault", "Airborne Assault","Chemical Assault","Paratroopers","Biological Assault","Guerrilla Warfare","Molecular Shielding","Hand of God"],	#Military
);
@LevelUp = (1000,5000,10000,50000,100000,250000,500000,750000,1000000);

#This Months Sponsors

$BannerCode = qq!!;
$Sponsors = qq!Advertisements provided by no-one.!;


srand(time());
$LinkLine = qq—</table><center>

<table border=0 width=640 cellspacing=0 frame=box>
<TR><TD><a href="Runner2.pl?$User&$Pword&1" style="color:$FontColourOne">$Key<B>Main</b></a></tD><TD><a href="Runner2.pl?$User&$Pword&2" style="color:$FontColourOne">$Key<B>Build</A></TD><TD><a href="Runner2.pl?$User&$Pword&15" style="color:$FontColourOne">$Key<B>Troops</A></TD><TD><A href="Runner2.pl?$User&$Pword&16" style="color:$FontColourOne">$Key<B>Operations</a></TD><TD><a href="Runner2.pl?$User&$Pword&5" style="color:$FontColourOne">$Key<B>Economy</a></TD><TD><a href="Runner2.pl?$User&$Pword&6" style="color:$FontColourOne">$Key<B>Diplomacy</A></TD><TD><a href="Runner2.pl?$User&$Pword&8" style="color:$FontColourOne">$Key<B>Ranking</A></TD><TD><a href="Runner2.pl?$User&$Pword&9" style="color:$FontColourOne">$Key<B>Messages</A></TD><TD><a href="http://www.bluewand.com" style="color:$FontColourOne">$Key<B>Quit</b></a></tD><TD><a href="Assassin.pl" style="color:$FontColourOne" target=_blank>$Key<B>Assassin</b></a></TD></TR>
</table><table border=0 width=640 cellspacing=0 frame=box>—;

unless (-e "$MainPath/users/$User") {
	print "Content-type: text/html\n\n";
	print "<HEAD><title>ASH - Error<\/Title><\/head><body bgcolor=black text=white><BR><BR><font face=arial>Entry Error: 100-00<BR><BR><BR>If you are absolutely sure your password is correct, we may be experiencing difficulty with the server, especially in the first few days.  Recreate your country.";
	die;

}

open (IN, "$MainPath/users/$User");
flock (IN, 1);
@CountryData = <IN>;
close (IN);
&chopper (@CountryData);
$Nuser = @CountryData[34];
$Nuser =~ tr/_/ /;

if (@CountryData[1] == 1) {						#TLA
	$FColourOne = "#008800";
	$FColourTwo = "#00EE00";
} elsif (@CountryData[1] == 2) {					#FR
	$FColourOne = "#0000EE";
	$FColourTwo = "gray";
} else {								#SF
	$FColourOne = "#880000";
	$FColourTwo = "#EE0000";
}

	$NewFont1 = qq!<font face=verdana size=-1 color="$FColourOne">!;
	$NewFont2 = qq!<font face=verdana size=-1 color="$FColourTwo">!;


if (@CountryData[40] < 1) {
	($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
	if ($mday == 23 && $mon == 7) {@CountryData[30] = 30;}
	@CountryData[40] = 0;
}

unless ( ($Pword eq @CountryData[49]) && (time() - @CountryData[50] < 1500) ) {
	print "Content-type: text/html\n\n";
	print "<HEAD><title>ASH - Error<\/Title><\/head><body bgcolor=black text=white><font face=arial size=-1><BR><BR>Entry Error: 100-01<BR><BR><BR>Your Password has expired or is invalid.  You must re-log into A.S.H.";
	die;
} else {

	@CountryData[50] = time();
        #Add To Turns, If Necessary
	($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
	@TimeUntil = split(/\./,@CountryData[30]);
	$Days = $yday - @TimeUntil[0];
	$Hours = $hour - @TimeUntil[1];
	$TotalTurns += ($Days * 96) + ($Hours * 4);
	@CountryData[29] += $TotalTurns;
	if (@CountryData[29] < 0) {@CountryData[29] = 0;}
	if (@CountryData[29] > 80) {@CountryData[29] = 80;}
	@CountryData[30] = "$yday.$hour";

	#Write Data
	open (OUT, ">$MainPath/users/$data{'cname'}");
	flock (OUT, 2);
	foreach $Line (@CountryData) {
		print OUT "$Line\n";
	}
	close (OUT);

	open (IN, "$MainPath/counters/$mon-$mday");
	flock (IN, 1);
	my @HitData = <IN>;
	close (IN);
	&chopper (@HitData);
	@HitData[$hour]++;
	@HitData[25] ++;

	open (OUT, ">$MainPath/counters/$mon-$mday");
	flock (OUT, 2);
	foreach $Item (@HitData) {
		print OUT "$Item\n";
	}
	close (OUT);	
	

	my ($Tax, $War);
	#Read form data (if any)
	&parse_form;

	if (@CountryData[19] < 1) {@CountryData[19] = 0;}
	&GainValues;

	if ($Script eq "01") {$Script = 1;}
	
	#Run actual commands

	if ($Script == 1) {require ("Main2.pl");}
	if ($Script == 2) {require ("Government2.pl");}
	if ($Script == 3) {require ("Spy2.pl");}
	if ($Script == 4) {require ("Spec2.pl");}
	if ($Script == 5) {require ("Economy2.pl");}
	if ($Script == 6) {require ("Diplomacy2.pl");}
	if ($Script == 7) {require ("Elite2.pl");}
	if ($Script == 8) {require ("Sort2.pl");}
	if ($Script == 9) {require ("Message2.pl");}
	if ($Script == 10) {require ("Operation2.pl");}
	if ($Script == 11) {require ("Skillless2.pl");}
	if ($Script == 12) {require ("AllyMod2.pl");}		
	if ($Script == 13) {require ("PlayerSort.pl");}
	if ($Script == 14) {require ("FactionSort.pl");}
	if ($Script == 15) {require ("Hire.pl");}
	if ($Script == 16) {require ("RunOperation.pl");}
	if ($Script == 17) {require ("ViewTech.pl");}

	#/Calculate Networth	
	&CalcNetworth;
	
	#Write Data (After game modifications)
	open (OUT, ">$MainPath/users/$User") or print "Cannot open $MainPath/users/$User ($!)<BR>";
	flock (OUT, 2);
	foreach $Line (@CountryData) {
		print OUT "$Line\n";
	}
	close (OUT);

	my $RandomNumber2 = int(rand(100000));	
	print qq—<BR><BR><center><a href=#top style="color:$FontColourOne">$NewFont1 Back to Top</font></a> | <A href="http://www.bluewand.com/cgi-bin/boards/ikonboard.cgi" target=Boards style="color:$FontColourOne">Forums</A><BR>$Font<i>All Rights Reserved | copyright © 2000-2002 Bluewand Entertainment</I><BR><CEnter><BR>

</center>—;

}

sub StatLine
{
	&GainValues;
	$LinkLine .= qq!<TR><TD colspan=7><hr size=1 width=100%></TD></TR>
	<TR><TD>$Font3 Turns Remaining / Taken</TD><TD>$Font3 @CountryData[29] / @CountryData[40]</TD><TD>$Font3 Money</TD><TD>$Font3 \$@{[&Space(@CountryData[3])]}</TD><TD>$Font3 Total Profit</TD><TD colspan=3>$Font3 \$@{[&Space($Income-$Cost)]}</TD></TR>!;
}


sub GainValues
{
	$Side{1} = "Terran Liberation Army";
	$Side{2} = "Free Republic";
	$Side{3} = "Socialist Federation";

	($Tax,$War) = split (/,/,@CountryData[2]);
	my $SpyCost = (1250 * @CountryData[9]);
	my $CSpyCost = (1250 * @CountryData[10]);
	my $CommandoCost = (1250 * @CountryData[11]);
	my $EliteCost;
	for (my $i=24;$i<29;$i++) {
		my @EliteArray	= split (/,/,@CountryData[$i]);
		$EliteCost += @EliteArray[6];
	}
	$Cost = $SpyCost + $CSpyCost + $CommandoCost + $EliteCost;

	$IncomeBonus = 1;
	$PopBonus = 1;

	@CountryData[9] = int (@CountryData[9]);
	@CountryData[10] = int (@CountryData[10]);
	@CountryData[11] = int (@CountryData[11]);
	if (@CountryData[12] > @LevelUp[0]) {$IncomeBonus = 1.02; $PopBonus = 1.02;}
	if (@CountryData[12] > @LevelUp[1]) {$IncomeBonus = 1.05; $PopBonus = 1.02;}
	if (@CountryData[12] > @LevelUp[2]) {$IncomeBonus = 1.07; $PopBonus = 1.05;}
	if (@CountryData[12] > @LevelUp[3]) {$IncomeBonus = 1.10; $PopBonus = 1.05;}
	if (@CountryData[12] > @LevelUp[4]) {$IncomeBonus = 1.12; $PopBonus = 1.07;}
	if (@CountryData[12] > @LevelUp[5]) {$IncomeBonus = 1.15; $PopBonus = 1.07;}
	if (@CountryData[12] > @LevelUp[6]) {$IncomeBonus = 1.17; $PopBonus = 1.1;}
	if (@CountryData[12] > @LevelUp[7]) {$IncomeBonus = 1.2; $PopBonus = 1.2; $Density = 1.25}

#	if (@CountryData[1] == 2) {$IncomeBonus += .01;}
	$Income = (@CountryData[6] * 150 * $IncomeBonus) + (@CountryData[31] * $Tax/10 * $IncomeBonus) - (@CountryData[5] * 50);	
	$Income = int($Income);
	$WarFund = int($Income * $War/100);
	$Cost += $WarFund;	
}


sub RunTurn
{
	$TurnMessages = "";
	$IncomeBonus = $PopBonus = $Density = 1;
	&GainValues;
	if (@CountryData[31] == 0) {@CountryData[31] = (@CountryData[4] * 2);}
	@CountryData[31] = int(@CountryData[31] * 1.10 * $PopBonus);
	if (@CountryData[31] > ((@CountryData[4] * 50) + (@CountryData[5] + @CountryData[6] + @CountryData[7] + @CountryData[8]) * 5) * $Density) {@CountryData[31] = (@CountryData[4] * 50) + (@CountryData[5] + @CountryData[6] + @CountryData[7] + @CountryData[8]) * 5;}
	$WarEvent = 0.75;
	if (rand(2) > $WarEvent + $War/100) {
		if (rand(1) > $War/50) {
			$TurnMessages = "Your military has suffered a setback in the war!<BR>";
			$TurnMessages .= qq!@{[&Space(@CountryData[4] - int(@CountryData[4] * 0.99))]} Housing Complexes, @{[&Space(@CountryData[5] - int(@CountryData[5] * 0.99))]} Research Facilities, @{[&Space(@CountryData[6] - int(@CountryData[6] * 0.99))]} Production Centres, @{[&Space(@CountryData[7] - int(@CountryData[7] * 0.99))]} Government Installations, and @{[&Space(@CountryData[8] - int(@CountryData[8] * 0.99))]} Construction Stations have been destroyed in the fighting. @{[&Space(int(@CountryData[19] * 0.5))]}  blocks of free land have been lost.!;
			@CountryData[4] = int(@CountryData[4] * 0.99);
			@CountryData[5] = int(@CountryData[5] * 0.99);
			@CountryData[6] = int(@CountryData[6] * 0.99);
			@CountryData[7] = int(@CountryData[7] * 0.99);
			@CountryData[8] = int(@CountryData[8] * 0.99);
			@CountryData[19] = int(@CountryData[19] * 0.5);	
			if (@CountryData[19] <= 0) {@CountryData[19] = 0;}											
		}
	 	else {
	 		$TurnMessages = "Your military has achieved a breakthrough in the war!";
			$Newland = int(rand(40)+1);
	 		$TurnMessages .= qq! $Newland blocks of land have been captured by our forces.!;
	 		@CountryData[19] += $Newland;
	 	}
 	}

	#Check For Revolt
	if ($Tax > 10) {
		if (int(rand(100 - $Tax) + 1) > int(rand(50))) {

			#5% of everything is lost
			$TurnMessages .= qq!Large-scale disturbance has broken out in our city-state. The insurrection has been put down, but the cost was great.  Lower our taxes to prevent this tragedy from happening again.!;

			@CountryData[4] = int(@CountryData[4] * 0.95);
			@CountryData[5] = int(@CountryData[5] * 0.95);
			@CountryData[6] = int(@CountryData[6] * 0.95);
			@CountryData[7] = int(@CountryData[7] * 0.95);
			@CountryData[8] = int(@CountryData[8] * 0.95);
			@CountryData[19] = int(@CountryData[19] * 0.95);
			@CountryData[31] = int(@CountryData[31] * 0.80);

			@CountryData[12] = int(@CountryData[12] * 0.975);
			@CountryData[13] = int(@CountryData[13] * 0.975);
			@CountryData[14] = int(@CountryData[14] * 0.975);
			@CountryData[15] = int(@CountryData[15] * 0.975);
			@CountryData[16] = int(@CountryData[16] * 0.975);
			@CountryData[17] = int(@CountryData[17] * 0.975);
			@CountryData[18] = int(@CountryData[18] * 0.975);
		}
	}
	&TechRate;

	#Increase Tech
	for (my $b=12;$b<19;$b++) {
		my $OldValue = @CountryData[$b];
		@CountryData[$b] += int(abs(@CountryData[39+$b]/100) * $TechPoints);
		$TekCount = 0;
		for ($TekCount = 0; $TekCount < 8; $TekCount++) {

			if ($OldValue < @LevelUp[$TekCount] && @CountryData[$b]  >= @LevelUp[$TekCount]) {

				$Werd = @Developments->[$b-12][$TekCount];
				$TurnMessages .= qq!Scientists have developed <i>$Werd</i><BR><BR>!;

			}
			if (@CountryData[$b] > @LevelUp[scalar(@LevelUp)-1]) {@CountryData[$b] = @LevelUp[scalar(@LevelUp)-1];}
		}		
	}

	#TLA = 1, FR = 2, SF = 3
	my $FacInMod = 1.10;
	if (@CountryData[1] == 1) {$FacInMod = 0.85;} elsif (@CountryData[1] == 2) {$FacInMod = 1.10;} else {$FacInMod = 0.90;}
	$MoneyInTheBank = int(@CountryData[3]);
	@CountryData[3] = int (@CountryData[3]);
	@CountryData[3] += (int($Income * $FacInMod) - $Cost);

	#Debt Penalties
	if (@CountryData[3] < 0) {
		$MinAmount = abs(@CountryData[3]);
		$PercentEliminated = (int((($MoneyInTheBank + $Income)/$Cost) * 100)/100);

		$Intel = abs(int(@CountryData[9] * $PercentEliminated));
		$CIntel = abs(int(@CountryData[10] * $PercentEliminated));
		$Comman = abs(int(@CountryData[11] * $PercentEliminated));

		if ($Intel > @CountryData[9]) {$Intel = @CountryData[9];}
		if ($CIntel > @CountryData[10]) {$CIntel = @CountryData[10];}
		if ($Comman > @CountryData[11]) {$Comman = @CountryData[11];}

		$TurnMessages .= qq!@{[&Space($Intel)]} Intel Agents have deserted.  @{[&Space($CIntel)]} Counter-Intel Agents have deserted.  @{[&Space($Comman)]} Commandos have deserted.<BR>!;
		@CountryData[9] -= int ($Intel);
		@CountryData[10] -= int ($CIntel);
		@CountryData[11] -= int ($Comman);

		for (my $I = 24;$I<29;$I++) {
			my @Array = split(/,/,@CountryData[$I]);
			if (@Array[1] eq "Mercenary") {
				if (int(rand(100)) <= 25) {
					@CountryData[$I] = "None";
					$TurnMessages .= qq!<BR>@Array[0] has deserted because contract could not be paid.!;
				}	
			}
			if (@Array[1] eq "Rogue") {
				if (int(rand(100)) <= 45) {
					@CountryData[$I] = "None";
					$TurnMessages .= qq!<BR>@Array[0] has deserted because contract could not be paid.!;
				}	
			}

			if (@Array[1] eq "Soldier") {
				if (int(rand(100)) <= 10) {
					@CountryData[$I] = "None";
					$TurnMessages .= qq!<BR>@Array[0] has deserted because contract could not be paid.!;
				}	
			}

			if (@Array[1] eq "Professional") {
				if (int(rand(100)) <= 18) {
					@CountryData[$I] = "None";
					$TurnMessages .= qq!<BR>@Array[0] has deserted because contract could not be paid.!;
				}	
			}
		}
		@CountryData[3] = 0;
	}


	#Reduce Army Size if too big
	if ((@CountryData[9] + @CountryData[10] + @CountryData[11]) > 0) {
		if ((@CountryData[9] + @CountryData[10] + @CountryData[11]) > int((@CountryData[4] + @CountryData[5] + @CountryData[6] + @CountryData[7] + @CountryData[8]) * 0.10)) {
			$TurnMessages .= qq!Your forces have been downsized because your land cannot support them all.!;
			@CountryData[9] = int(abs(@CountryData[9] * 0.85));
			@CountryData[10] = int(abs(@CountryData[10] * 0.85));
			@CountryData[11] = int(abs(@CountryData[11] * 0.85));
		}
	}

	#Bottom - Out Unit numbers
	if (@CountryData[9] < 0) {$CountryData[9] = 0;}
	if (@CountryData[10] < 0) {$CountryData[10] = 0;}
	if (@CountryData[11] < 0) {$CountryData[11] = 0;}

	#Reduce Turns by One
	@CountryData[29] --;
	@CountryData[40] ++;

	if (-e "armageddon.now") {@CountryData[29] ++;}	
	
	return qq!
	<table border=0 cellspacing=0 width=80%>
	<TR><TD colspan=6><B><font face=verdana color=#008800>Turn</TD></TR>
	<TR><TD>$NewFont1 Income</TD><TD>$NewFont2 \$@{[&Space($Income)]}</TD><TD>$NewFont1 Expenses</TD><TD>$NewFont2 \$@{[&Space($Cost)]}</TD><TD>$NewFont1 Money</TD><TD>$NewFont2 \$@{[&Space(@CountryData[3])]}</TD></TR>
	<TR><TD>$NewFont1 Tax Rate</TD><TD>$NewFont2 $Tax%</TD><TD>$NewFont1 Military Funding</TD><TD>$NewFont2$War%</TD><TD>$NewFont1 (Military Spending</TD><TD>$NewFont2 \$@{[&Space($WarFund)]} $NewFont1 )</TD></TR>
	<TR><TD colspan=6>$Font $TurnMessages$T</td></TR>
	</table><BR><BR>!;
}

sub CalcNetworth
{
	$OldNet = @CountryData[32];
	my $TechPts = (@CountryData[12] + @CountryData[13] + @CountryData[14] + @CountryData[15] + @CountryData[16] + @CountryData[17] + @CountryData[18]) * .002;
	my $SpyPts = (@CountryData[9] * 100) + (@CountryData[10] * 100) + (@CountryData[11] * 250);
	my $BldingPts = (@CountryData[4] * 5) +(@CountryData[5] * 5) +(@CountryData[6] * 5) +(@CountryData[7] * 5) +(@CountryData[8] * 5);
	my $ElitePts = 0;
	for (my $i=24;$i<29;$i++) {
		my @EliteArray = split(/,/, @CountryData[$i]);
		$ElitePts += (@EliteArray[2] * 1500) + (@EliteArray[7] * 10) +(@EliteArray[8] * 10) +(@EliteArray[9] * 10) +(@EliteArray[10] * 10) +(@EliteArray[11] * 10) +(@EliteArray[12] * 10) + (@EliteArray[13] * 5);	
	}
	@CountryData[32] = int($TechPts + $SpyPts + $ElitePts + $BldingPts + int(@CountryData[31] * 0.35));

	if (@CountryData[38] ne "" && -e "$MainPath/clans/@CountryData[1]/@CountryData[38]") {
		open (IN, "$MainPath/clans/@CountryData[1]/@CountryData[38]");
		flock (IN, 1);
		@AllyData = <IN>;
		close (IN);
		&chopper (@AllyData);

		@AllyData[10] = (@AllyData[10] - $OldNet + @CountryData[32]);

		open (OUT, ">$MainPath/clans/@CountryData[1]/@CountryData[38]");
		flock (OUT, 2);
		foreach $WriteLine (@AllyData) {
			print OUT "$WriteLine\n";
		}
		close (OUT);


	}
}


sub parse_form {

   # Get the input
   read(STDIN, $buffer, $ENV{'CONTENT_LENGTH'});

   # Split the name-value pairs
   @pairs = split(/&/, $buffer);

   foreach $pair (@pairs) {
      ($name, $value) = split(/=/, $pair);

      # Un-Webify plus signs and %-encoding
      $value =~ tr/+/ /;
      $value =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
      $value =~ s/<!--(.|\n)*-->//g;
      $value =~ s/<([^>]|\n)*>//g;



      $data{$name} = $value;
      }
}

sub chopper{
	foreach $k(@_){
		chop($k);
	}
}

sub Space {
  local($_) = @_;
  1 while s/^(-?\d+)(\d{3})/$1 $2/;
  return $_;
}

sub dirty {
	foreach $text (@_) {
		$text =~ s/\cM//g;
		$text =~ s/\n\n/<p>/g;
		$text =~ s/\n/<br>/g;
		$text =~ s/&lt;/</g; 
		$text =~ s/&gt;/>/g; 
		$text =~ s/&quot;/"/g;
	}
	return @_;
}


sub clean {
	foreach $temp (@_) {
		$temp =~ s/<p>/\n\n/g;
		$temp =~ s/<br>/\n/g;
		$temp =~ s/</&lt;/g; 
		$temp =~ s/>/&gt;/g; 
		$temp =~ s/"/&quot;/g;
	}
	return @_;
}


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
	$TechPoints = int(@CountryData[5] * 0.15 * $Rate);
}
