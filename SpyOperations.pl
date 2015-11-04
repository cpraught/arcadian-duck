#!/usr/bin/perl

$TechType{0} = "Civil";
$TechType{1} = "Weaponry";
$TechType{2} = "Armour";
$TechType{3} = "Tactics";
$TechType{4} = "Covert";
$TechType{5} = "Spec Ops";
$TechType{6} = "Military";
$Types{'1'} = "Allied";$Types{'2'} = "Friendly";$Types{'3'} = "Hostile";$Types{'4'} = "War";

$MailPath = "$MainPath/messages";
$OpNumber = $data{'op'};
$AttackerSent = int(abs($data{'spy'}));

&Operation_Function;

sub Operation_Function
{

	$Target = $data{'target'};
	$Target =~ s/\D//g;

	if (-e "$MainPath/users/$Target") {

		open (IN, "$MainPath/users/$Target");
		flock (IN, 1);
		@TargetData = <IN>;
		close (IN);
		&chopper (@TargetData);

		&CalcElite;
		&RankFinder;

		if ($AttackerSent > @CountryData[9]) {$AttackerSent = @CountryData[9];}

		$ALandValue = (@CountryData[4] + @CountryData[5] + @CountryData[6] + @CountryData[7] + @CountryData[8]) / 10;
		$DLandValue = (@TargetData[4] + @TargetData[5] + @TargetData[6] + @TargetData[7] + @TargetData[8]) / 10;

		if ($AttackerSent > 0) {
			$AttackerRatio = (($AttackerSent * $EliteModBonus) * 10) / ($ALandValue + 1);
		} elsif ($data{'ELITE'} > 0)  {
			$AttackerRatio = (($EliteModBonus) * 10) / ($ALandValue + 1);
		}

		$DefenderRatio = (@TargetData[10] * 10) / ($DLandValue + 1);

		$AttackStr = rand($AttackerRatio);
		$DefendStr = rand($DefenderRatio);

		&Experience;

		if ($AttackStr > $DefendStr) {$Success = 1;} else {$Success = 0;}

		if (@CountryData[29] < $TurnsToRun) {$Success = -1; $Flags = 1;}
		if ($TurnsToRun == 0) {$Success = -1; $Flags = 3;}
		if ($AttackerSent < 1) {$Success = -1; $Flags = 4;}
		if (@TargetData[40] <= 193) {$Success = -1; $Flags = 2;}

		if ($Success  > -1) {
			for (my $i=0; $i < $TurnsToRun; $i++) {
				$TurnMessage .= &RunTurn;
			}
		}

	} else {$Success = 0; $Flags = 0;}


	#Check if operation is successful (determined beforehand)
	if ($Success > 0)  {

		$DefenderLosses = int(abs($AttackerSent * 0.15));
		$AttackerLosses = int(abs($AttackerSent * 0.05));
		$DefendersLeft = @TargetData[10] - $DefenderLosses;
		if ($DefendersLeft < 0) {$DefendersLeft = 0;}
		if ($AttackerLosses > $DefendersLeft) {$AttackerLosses = $DefendersLeft;}

		@CountryData[9] -= $AttackerLosses;
		@TargetData[10] -= $DefenderLosses;
		if (@CountryData[9] < 0) {@CountryData[9] = 0;}
		if (@TargetData[10] < 0) {@TargetData[10] = 0;}

		#Successful Operation Damages Target
		&RunOpEffects($OpNumber);

		#Write to Defenders News
		$NewsVal = 1;
		&WriteDefNews($OpNumber);

		&MinIt;
		&CalcNetworth;

		open (OUT, ">$MainPath/users/$Target");
		flock (OUT, 2);
		foreach $OutLine (@TargetData) {
			print OUT "$OutLine\n";
		}
		close (IN);
		print "";



	#Operation has failed
	} elsif ($Success == 0) {

		#Reduce Operatives Involved In Mission
		$AttackerLosses = int(abs($AttackerSent * 0.15));
		$DefenderLosses = int(abs($AttackerSent - $AttackerLosses) * 0.05);

		@CountryData[9] -= $AttackerLosses;
		@TargetData[10] -= $DefenderLosses;
		if (@CountryData[9] < 0) {@CountryData[9] = 0;}
		if (@TargetData[10] < 0) {@TargetData[10] = 0;}

		#Write to Defender News	
		$NewsVal = 2;
		&WriteDefNews($OpNumber,2);

		&MinIt;
		&CalcNetworth;

		open (OUT, ">$MainPath/users/$Target");
		flock (OUT, 2);
		foreach $OutLine (@TargetData) {
			print OUT "$OutLine\n";
		}
		close (IN);
		print "";


	} elsif ($Success < 0) {
		if ($Flags == 0) {$View = qq!Target does not exist.!;}
		if ($Flags == 1) {$View = qq!You do not have enough turns to attack the target.!;}
		if ($Flags == 2) {$View = qq!Target is still in protection and cannot be attacked.!;}
		if ($Flags == 3) {$View = qq!Target does not exist.!;}
		if ($Flags == 4) {$View = qq!You cannot attack without intelligence officers.!;}
		print "";
	}
}

sub RunOpEffects
{
	my $Operation = @_[0];

	if ($Operation == 1) {

		$View = qq!<TABLE cellSpacing=2 cellPadding=2 width="80%" border=0>
  <TBODY>
  <TR>
    <TD colSpan=8><FONT face=verdana size=-1><B><FONT size=+1>@TargetData[34] (#$Target)</B></FONT></FONT></FONT></TD></TR>
  <TR>
    <TD><FONT face=verdana size=-1 color="#008800">Affiliation</FONT></TD>
    <TD colSpan=7><FONT face=verdana size=-1 color="#00FF00">$FacAlign{@TargetData[1]}</FONT></TD></TR>
  <TR>
    <TD><FONT face=verdana size=-1 color="#008800">Population</FONT></TD>
    <TD><FONT face=verdana size=-1 color="#00FF00">@TargetData[31]</FONT></TD>
    <TD><FONT face=verdana size=-1 color="#008800">Housing Complexes </FONT></TD>
    <TD><FONT face=verdana size=-1 color="#00FF00">@TargetData[4]</FONT></TD>
    <TD><FONT face=verdana size=-1 color="#008800">Covert Operatves</FONT></TD>
    <TD><FONT face=verdana size=-1 color="#00FF00">@TargetData[9]</FONT></TD></TR>
  <TR>
    <TD><FONT face=verdana size=-1 color="#008800">Tax Rate</FONT></TD>
    <TD><FONT face=verdana size=-1 color="#00FF00">@TargetData[2]</FONT></TD>
    <TD><FONT face=verdana size=-1 color="#008800">Research Facility</FONT></TD>
    <TD><FONT face=verdana size=-1 color="#00FF00">@TargetData[6]</FONT></TD>
    <TD><FONT face=verdana size=-1 color="#008800">Counter-Int Officers</FONT></TD>
    <TD><FONT face=verdana size=-1 color="#00FF00">@TargetData[10]</FONT></TD></TR>
  <TR>
    <TD><FONT face=verdana size=-1 color="#008800">Military Funding</FONT></TD>
    <TD><FONT face=verdana size=-1 color="#00FF00">@TargetData[2]</FONT></TD>
    <TD><FONT face=verdana size=-1 color="#008800">Production Centre</FONT></TD>
    <TD><FONT face=verdana size=-1 color="#00FF00">@TargetData[2]</FONT></TD>
    <TD><FONT face=verdana size=-1 color="#008800">Commandos</FONT></TD>
    <TD><FONT face=verdana size=-1 color="#00FF00">@TargetData[11]</FONT></TD></TR>
  <TR>
    <TD><FONT face=verdana size=-1 color="#008800">Money</FONT></TD>
    <TD><FONT face=verdana size=-1 color="#00FF00">\$@TargetData[3]</FONT></TD>
    <TD><FONT face=verdana size=-1 color="#008800">Government Installation</FONT></TD>
    <TD><FONT face=verdana size=-1 color="#00FF00">@TargetData[7]</FONT></TD>
    <TD><FONT face=verdana size=-1 color="#008800">ELITE</FONT></TD>
    <TD><FONT face=verdana size=-1 color="#00FF00">2</FONT></TD></TR>
  <TR>
    <TD><FONT face=verdana size=-1 color="#008800">Networth</FONT></TD>
    <TD><FONT face=verdana size=-1 color="#00FF00">@TargetData[32]</FONT></TD>
    <TD><FONT face=verdana size=-1 color="#008800">Construction Station</FONT></TD>
    <TD><FONT face=verdana size=-1 color="#00FF00">@TargetData[8]</FONT></TD></TR></TBODY></TABLE>!;

	} elsif ($Operation == 2) {

		($C[0], $C2[0]) = split (/,/, @TargetData[20]);
		($C[1], $C2[1]) = split (/,/, @TargetData[21]);
		($C[2], $C2[2]) = split (/,/, @TargetData[22]);
		($C[3], $C2[3]) = split (/,/, @TargetData[23]);
		$View = qq!
<table width=70% width=1 cellspacing=0 border=0>
<TR><TD colspan=2><Font face=verdana size=-1> Nation</TD><TD colspan=2><Font face=verdana size=-1> Relation Type</TD></TR>
<TR><TD><Font face=verdana size=-1>$C[0]</TD><TD>$Types{$C2[0]}</TD></TR>
<TR><TD><Font face=verdana size=-1>$C[1]</TD><TD>$Types{$C2[1]}</TD></TR>
<TR><TD><Font face=verdana size=-1>$C[2]</TD><TD>$Types{$C2[2]}</TD></TR>
<TR><TD><Font face=verdana size=-1>$C[3]</TD><TD>$Types{$C2[3]}</TD></TR>
</table><BR><BR>
		!;
	} elsif ($Operation == 3) {

		@Total[0] = @TargetData[12]/1000000;
		@Total[1] = @TargetData[13]/1000000;
		@Total[2] = @TargetData[14]/1000000;
		@Total[3] = @TargetData[15]/1000000;
		@Total[4] = @TargetData[16]/1000000;
		@Total[5] = @TargetData[17]/1000000;
		@Total[6] = @TargetData[18]/1000000;

		$View = qq!
<table width=70% width=1 cellspacing=0>
<TR><TD><Font face=verdana size=-1> Type</TD><TD><Font face=verdana size=-1> Percent Complete</TD></TR>
<TR><TD><Font face=verdana size=-1> Civil</TD><TD><Font face=verdana size=-1> 		@Total[0]%</TD></TR>
<TR><TD><Font face=verdana size=-1> Weaponry</TD><TD><Font face=verdana size=-1> 	@Total[1]%</TD></TR>
<TR><TD><Font face=verdana size=-1> Armour</TD><TD><Font face=verdana size=-1> 		@Total[2]%</TD></TR>
<TR><TD><Font face=verdana size=-1> Tactics</TD><TD><Font face=verdana size=-1>		@Total[3]%</TD></TR>
<TR><TD><Font face=verdana size=-1> Covert</TD><TD><Font face=verdana size=-1> 		@Total[4]%</TD></TR>
<TR><TD><Font face=verdana size=-1> Spec Ops</TD><TD><Font face=verdana size=-1>	@Total[5]%</TD></TR>
<TR><TD><Font face=verdana size=-1> Military</TD><TD><Font face=verdana size=-1> 	@Total[6]%</TD></TR>
</table>
		!;

	} elsif ($Operation == 4) {
		for (my $i = 20; $i < 24 ;$i++) {			
			unless (@TargetData[$i] =~ "None") {
				my ($N,$R) = split(/,/,@TargetData[$i]);
				if ($R < 4) {$R++;}
				@TargetData[$i] = "$N,$R";
		
				if ($R == 4) {open (OUT, ">>$MainPath/messages/$N");print OUT "0|@{[time()]}|$data{'target'}|@TargetData[34] has declared war on us!\n";close(OUT);}
				if ($R == 3) {open (OUT, ">>$MainPath/messages/$N");print OUT "0|@{[time()]}|$data{'target'}|@TargetData[34] has declared itself to be hostile with us!\n";close(OUT);}
				if ($R == 2) {open (OUT, ">>$MainPath/messages/$N");print OUT "0|@{[time()]}|$data{'target'}|@TargetData[34] has downgraded their relations with us to friendly.\n";close(OUT);}
	
				open (IN, "$MainPath/users/$N");
				flock (IN, 1);
				my @NewTargetData = <IN>;
				close (IN);
			
				$View .= qq+@TargetData[34]'s relations with @NewTargetData[34] have been downgraded!<BR>+;
			}		
		}
	} elsif ($Operation == 5) {
		if (-e "$MainPath/ops/$Target") {
			open (IN, "$MainPath/ops/$Target");
			flock (IN, 1);
			@RunningOps = <IN>;
			close (IN);
			&chopper (@RunningOps);
		} else {$OpNumbers = 0;}


		if ($OpNumbers > 4) {
			$View = qq!Your infiltration team was wiped out by another team operating in @CountryData[34].!;
			@CountryData[9] += $AttackerLosses;
			@CountryData[9] -= $data{'commando'};
		} else {
			open (OUT, ">>$MainPath/ops/$Target");
			flock (OUT, 2);
			my $Val = $data{'commando'} - $AttackerLosses;
			print OUT "$User|$Val\n";
			$View = qq!The infiltration team has been successfully inserted into @TargetData[34].  They will begin their mission immediately.!;
		}
	#Copy Technology
	} elsif ($Operation == 6) {

		my @TechLost = ();

		for ($Counter = 0; $Counter < 7; $Counter++) {
			@TechLost[$Counter] = abs(int(@TargetData[12 + $Counter] * 0.05));
			@CountryData[12 + $Counter] += @TechLost[$Counter];

			$View .= qq!@{[&Space(@TechLost[$Counter])]} points of $TechType{$Counter} have been copied.  !;
		}


	#Assassinate ELITE
	} elsif ($Operation == 7) {


	}
}




sub WriteDefNews
{
	#Initialize Variables
	my ($Operation) = @_[0];
	my $Condition = $NewsVal;
	my $Message = "";

	#Open and lock file
	open (OUT, ">>$MailPath/$Target");
	flock (OUT, 2);

	#Determine Message
	if ($Operation == 1) {
		if ($Condition == 2) {
			$Message = qq!Enemy agents have from @CountryData[34] have unsuccessfully attempted to gather general intelligence.  @{[&Space($AttackerLosses)]} enemy agents have been killed.  We lost @{[&Space($DefenderLosses)]} men.!;
			$View  = qq!We were unable to gather intelligence.  We lost @{[&Space($AttackerLosses)]} men.!;
		} else {

		}
	} elsif ($Operation == 2) {
		if ($Condition == 2) {
			$Message = qq!Enemy agents have from @CountryData[34] have unsuccessfully attempted to gather diplomatic intelligence.  @{[&Space($AttackerLosses)]} enemy agents have been killed.  We lost @{[&Space($DefenderLosses)]} men.!;
			$View  = qq!We were unable to gather intelligence.  We lost @{[&Space($AttackerLosses)]} men.!;
		} else {

		}
	} elsif ($Operation == 3) {
		if ($Condition == 2) {
			$Message = qq!Enemy agents have from @CountryData[34] have unsuccessfully attempted to gather technological intelligence.  @{[&Space($AttackerLosses)]} enemy agents have been killed.  We lost @{[&Space($DefenderLosses)]} men.!;
			$View  = qq!We were unable to gather intelligence.  We lost @{[&Space($AttackerLosses)]} men.!;
		} else {

		}
	} elsif ($Operation == 4) {
		if ($Condition == 2) {
			$Message = qq!Enemy agents have from @CountryData[34] have unsuccessfully attempted to sabotage diplomatic relations.  @{[&Space($AttackerLosses)]} enemy agents have been killed.  We lost @{[&Space($DefenderLosses)]} men.!;
			$View  = qq!Our mission was a failure.  We lost @{[&Space($AttackerLosses)]} men.!;
		} else {

		}
	} elsif ($Operation == 5) {
		if ($Condition == 2) {
			$Message = qq!Enemy agents have from @CountryData[34] have unsuccessfully attempted to infiltrate our country.  @{[&Space($AttackerLosses)]} enemy agents have been killed.  We lost @{[&Space($DefenderLosses)]} men.!;
			$View  = qq!Our mission was a failure.  We lost @{[&Space($AttackerLosses)]} men.!;
		} else {

		}
	} elsif ($Operation == 6) {
		if ($Condition == 2) {
			$Message = qq!Enemy agents have from @CountryData[34] have unsuccessfully attempted to sabotage our research.  @{[&Space($AttackerLosses)]} enemy agents have been killed.  We lost @{[&Space($DefenderLosses)]} men.!;
			$View  = qq!Our mission was a failure.  We lost @{[&Space($AttackerLosses)]} men.!;
		} else {

		}
	} elsif ($Operation == 7) {
		if ($Condition == 2) {
			$Message = qq!Enemy agents have from @CountryData[34] have unsuccessfully attempted to assassinate one of our ELITE.  @{[&Space($AttackerLosses)]} enemy agents have been killed.  We lost @{[&Space($DefenderLosses)]} men.!;
			$View  = qq!Our mission was a failure.  We lost @{[&Space($AttackerLosses)]} men.!;
		} else {

		}
	}

	if ($Condition == 2) {
		# Type (0 - News / 1 - Message)|Date [time()]|Sender|Content
		print OUT qq!0|@{[time()]}|$User|$Message.\n!;
		close (OUT);
	}
}

sub MinIt
{
	if (@TargetData[9] < 0) {@TargetData[9] = 0;}
	if (@TargetData[10] < 0) {@TargetData[10] = 0;}
	if (@TargetData[11] < 0) {@TargetData[11] = 0;}

}


sub CalcNetworth
{
	$OldNet = @TargetData[32];
	my $TechPts = (@TargetData[12] + @TargetData[13] + @TargetData[14] + @TargetData[15] + @TargetData[16] + @TargetData[17] + @TargetData[18]) * .002;
	my $SpyPts = (@TargetData[9] * 100) + (@TargetData[10] * 100) + (@TargetData[11] * 250);
	my $BldingPts = (@TargetData[4] * 5) +(@TargetData[5] * 5) +(@TargetData[6] * 5) +(@TargetData[7] * 5) +(@TargetData[8] * 5);
	my $ElitePts = 0;
	for (my $i=24;$i<29;$i++) {
		my @EliteArray = split(/,/, @TargetData[$i]);
		$ElitePts += (@EliteArray[2] * 1500) + (@EliteArray[7] * 10) +(@EliteArray[8] * 10) +(@EliteArray[9] * 10) +(@EliteArray[10] * 10) +(@EliteArray[11] * 10) +(@EliteArray[12] * 10) + (@EliteArray[13] * 5);	
	}
	@TargetData[32] = int($TechPts + $SpyPts + $ElitePts + $BldingPts + int(@TargetData[31] * 0.35));

	if (@TargetData[38] ne "" && -e "$MainPath/clans/@TargetData[1]/@TargetData[38]") {
		open (IN, "$MainPath/clans/@TargetData[1]/@TargetData[38]");
		flock (IN, 1);
		@AllyData = <IN>;
		close (IN);
		&chopper (@AllyData);

		@AllyData[10] = (@AllyData[10] - $OldNet + @TargetData[32]);

		open (OUT, ">$MainPath/clans/@TargetData[1]/@TargetData[38]");
		flock (OUT, 2);
		foreach $WriteLine (@AllyData) {
			print OUT "$WriteLine\n";
		}
		close (OUT);
	}
}

sub CalcElite
{
	if ($AttackerSent > 0) {
		if ($data{'ELITE'} > 0 && $data{'ELITE'} > 23 && $data{'ELITE'} < 29) {
			my @TempElite = split (/,/, @CountryData[$data{'ELITE'}]);
			$EliteModBonus = 1 + ((0.02 * @TempElite[2]) + (0.002  * @TempElite[9]) + (0.001 * @TempElite[12]));
		}
	} else {
		if ($data{'ELITE'} > 0 && $data{'ELITE'} > 23 && $data{'ELITE'} < 29) {
			my @TempElite = split (/,/, @CountryData[$data{'ELITE'}]);
			$EliteModBonus = 1 + ((0.02 * @TempElite[2]) + (0.002  * @TempElite[9]) + (0.001 * @TempElite[12]));
		}
	}
}

sub Experience
{
	if ($data{'ELITE'} > 0 && $data{'ELITE'} > 23 && $data{'ELITE'} < 29)
	{
		#FName "Callsign" LName,Ethos, Level, XP, Weapon, Armour, Cost,Str, Agi, Int, Dip, Acc, Rea, Hlt, MaxHlth
		my @TempElite = split (/,/, @CountryData[$data{'ELITE'}]);
		my @ArmourBlock = (0, 0.1, 0.15, 0.20, 0.275, 0.35, 0.4, 0.6);

		my $TotalLand = $DLandValue * 10;
		my $TotalDefenders = @TargetData[11];
		my $DamageTaken = $TotalDefenders / 15;

		$DamageTaken = int($DamageTaken * @ArmourBlock[@TempElite[5]]);

		@TempElite[13] -= $DamageTaken;

		if (@TempElite[13] < 0)
		{
			$View .= qq!@TempElite[0] has been killed in the operation.!;
			$#TempElite = 0;
			@CountryData[$data{'ELITE'}] = "None";


		} else
		{
			my $xpAdded = int ($TotalLand / 20) + int($TotalDefenders / 50);
			if ((@TempElite[3] + $xpAdded) > @LevelUp[@TempElite[2]])
			{
				@TempElite[2] ++;

				@TempElite[7] = int(rand(10)) + 1;	#Strength
				@TempElite[8] = int(rand(10)) + 4;	#Agility
				@TempElite[9] = int(rand(10)) + 4;	#Intelligence
				@TempElite[10] = int(rand(10)) + 4;	#Diplomacy
				@TempElite[11] = int(rand(10)) + 4;	#Accuracy
				@TempElite[12] = int(rand(10)) + 4;	#Reactions
				@TempElite[14] = int(rand(20)) + 10;	#Health

				$View .= qq!@TempElite[0] has gained a level.!;

				foreach $Item (@TempElite) {
					$writeString .= qq!$Item,!;
				}
				chop ($writeString);
				@CountryData[$data{'ELITE'}] = $writeString;

			}
		}
	}
}
