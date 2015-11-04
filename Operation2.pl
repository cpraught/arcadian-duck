#!/usr/bin/perl

($Op,$Target) = split(/,/, $Misc);
$Target =~ s/\D//g;

print "Content-type: text/html\n\n";

$ZoneType{4} = "Housing Complexes";
$ZoneType{5} = "Research Facilities";
$ZoneType{6} = "Production Centres";
$ZoneType{7} = "Government Installations";
$ZoneType{8} = "Construction Stations";

@EliteLevels = (50,100,500,1000,2000,4000,6000,12000,18000,36000,1000000000000);

#Set Base Values
$AttMod = $DefMod = 1;

if (@CountryData[15] > @LevelUp[0]) {$AttMod = 1.02}
if (@CountryData[15] > @LevelUp[2]) {$AttMod = 1.05}
if (@CountryData[15] > @LevelUp[4]) {$AttMod = 1.07}
if (@CountryData[15] > @LevelUp[6]) {$AttMod = 1.10}
if (@CountryData[15] > @LevelUp[8]) {$AttMod = 1.20}

if (abs(int($data{'commando'})) <= @CountryData[11] && $Misc eq "Go" && @CountryData[29] >= 3) {
	if (substr(@CountryData[$data{'ELITE'}],0,4) ne "None" && $data{'ELITE'} != 0) {@EliteArray = split (/,/, @CountryData[$data{'ELITE'}]);}
	if (@EliteArray[15] != $yday) {
		@EliteArray[15] = $yday;
		$EliteGo = 1;
	}

	my $Operation = $data{'operation'};
	my $Launcher = @CountryData[34];
	$Launcher =~ tr/_/ /;
	$data{'target'} =~ s/\D//g;

	tie (%UserHash, "SDBM_File", "$MainPath/hash/PRanks", O_RDWR|O_EXCL, 0644) or print "Content-type: text/html\n\n   Cannot Open Scoreboard ($!) $MainPath/hash/Ranks<BR>";
	$AttackerRank = $UserHash{$User};
	$DefenderRank = $UserHash{$data{'target'}};
	$Difference = abs($AttackerRank - $DefenderRank);
	untie %UserHash;

	$BaseAttack = 24;
	if ($Difference < 100) {$BaseAttack = 24;}
	if ($Difference < 50) {$BaseAttack = 12;}
	if ($Difference < 25) {$BaseAttack = 8;}
	if ($Difference < 10) {$BaseAttack = 3;}

	if (-e "armageddon.now") {$BaseAttack = 0;}

	if (-e "$MainPath/users/$data{'target'}") {
		open (IN, "$MainPath/users/$data{'target'}");
		flock (IN, 1);
		@TargetData = <IN>;	
		close (IN);
		&chopper (@TargetData);

		if (@TargetData[40] >= 193 && @CountryData[29] >= $BaseAttack) {

			if (@TargetData[15] > @LevelUp[1]) {$DefMod = 1.02}
			if (@TargetData[15] > @LevelUp[3]) {$DefMod = 1.05}
			if (@TargetData[15] > @LevelUp[5]) {$DefMod = 1.07}
			if (@TargetData[15] > @LevelUp[7]) {$DefMod = 1.10}
			if (@TargetData[15] > @LevelUp[8]) {$DefMod = 1.20}


			#Determine Attacker Power
			if ($EliteGo == 1) {@EliteArray = &EliteActivity(@EliteArray);}

			$AttackerPower = $DefenderPower = 0;
			$AttackerPower = ($data{'commando'} * &TrainingBonus(@CountryData[4],@CountryData[5],@CountryData[6],@CountryData[7],@CountryData[8],@CountryData[19]) * &TechBonus(@CountryData[15]) + 	&FindStrength(0, @EliteArray));

			$DefenderPower = (@TargetData[11] * &TrainingBonus(@TargetData[4],@TargetData[5],@TargetData[6],@TargetData[7],@TargetData[8],@TargetData[19]) * &TechBonus(@TargetData[15]));

			#Set Actual Attacker & Defender Powers
			$AttackerPower = int($AttackerPower * (0.85 + rand(0.30)) * $AttMod);
			$DefenderPower = int($DefenderPower * (0.95 + rand(0.30)) * $DefMod);

			#Determine Success
			if ($AttackerPower > $DefenderPower) {
				#If Attacker wins, check to see if attacker is caught
				if ($AttackerPower > int(1.25 * $DefenderPower)) {
					$Success = 1;
					$Caught = 0;				
				} else {
					$Success = 1;
					$Caught = 1;
				}
			} else {
				$Success = 0;
				$Caught = 1;
			}

			for ($AttackCounter = 0; $AttackCounter < $BaseAttack; $AttackCounter ++) {	
				$TurnMessage .= &RunTurn;	
			}
	
	
			if ($Operation == 1) {
				#Demolition
				if ($Success == 1) {
					$BuildingsDest = int(@TargetData[4] * 0.025) + int(@TargetData[5] * 0.025) + int(@TargetData[6] * 0.025) + int(@TargetData[7] * 0.025) + int(@TargetData[8] * 0.025);
					$FinishedMessage = qq!$BuildingsDest buildings have been destroyed.  !;
	
					@TargetData[4] -= int(@TargetData[4] * 0.025);
					@TargetData[5] -= int(@TargetData[5] * 0.025);
					@TargetData[6] -= int(@TargetData[6] * 0.025);
					@TargetData[7] -= int(@TargetData[7] * 0.025);
					@TargetData[8] -= int(@TargetData[8] * 0.025);
	
					if (@TargetData[4] < 0) {@TargetData[4] = 0;}
					if (@TargetData[5] < 0) {@TargetData[5] = 0;}
					if (@TargetData[6] < 0) {@TargetData[6] = 0;}
					if (@TargetData[7] < 0) {@TargetData[7] = 0;}
					if (@TargetData[8] < 0) {@TargetData[8] = 0;}
	
					$DefenderComsKilled = int(@TargetData[11] * 0.05);
					if ($DefenderComsKilled > int(abs($data{'commando'}))) {$DefenderComsKilled = int(abs($data{'commando'}));}
					@TargetData[11] -= $DefenderComsKilled;
					$FinishedMessage .= qq!  @{[&Space($DefenderComsKilled)]} defending commandos were killed trying to prevent the bombings.  !;
						
					if ($Caught == 1) {
						$AttackerComsKilled = int(abs($data{'commando'}) * 0.25);
						if ($AttackerComsKilled > @TargetData[11]) {$AttackerComsKilled = @TargetData[11];}
						@CountryData[11] -= $AttackerComsKilled;
						$FinishedMessage2 = qq!The country of $Launcher has launched an operation against us.!;$DeadCommandos = int(@CountryData[11] * 0.05); $FinishedMessage .= qq!@{[&Space($AttackerComsKilled)]} attacking commandos were slain by defenders.!;
					}

					open (OUT, ">>$MainPath/messages/$data{'target'}");
					flock (OUT, 2);		
					# Type (0 - News / 1 - Message)|Date [time()]|Sender|Content
					print OUT qq!0|@{[time()]}|$User|$FinishedMessage2 $FinishedMessage.\n!;
					close (OUT);
				} else {
					$AttackerComsKilled = int(abs($data{'commando'}) * 0.25);
					if ($AttackerComsKilled > @TargetData[11]) {$AttackerComsKilled = @TargetData[11];}
					@CountryData[11] -= $AttackerComsKilled;
					$FinishedMessage = qq!The attack was a failure.  @{[&Space($AttackerComsKilled)]} commandos were killed attempting to place explosive devices.!;
	
					open (OUT, ">>$MainPath/messages/$data{'target'}");
					flock (OUT, 2);				
					# Type (0 - News / 1 - Message)|Date [time()]|Sender|Content
					print OUT qq!0|@{[time()]}|$User|The country of $Launcher has attempted a demolition operation on us.  $FinishedMessage.\n!;
					close (OUT);
				}			
			} elsif ($Operation == 2) {
				#Duel
				for (my $i = 24; $i < 29; $i ++) {
					if (@TargetData[$i] ne "None") {push (@DefenderEliteArray, @TargetData[$i]);}
				}
				my $Value = rand(int(scalar(@DefenderEliteArray)));
				@DefenderEliteArray = split (/,/,@DefenderEliteArray[$Value]);
				
				@AE = &FindStrength(1, @EliteArray);
				@DE = &FindStrength(1, @DefenderEliteArray);

				#Damages -
				$DefenderDamage = @AE[0] - @DE[1];
				$AttackerDamage = @DE[0] - @AE[1];
	
				if ($AttackerDamage > $DefenderDamage) {
					@DefenderEliteArray[3] += @AE[2];
					@EliteArray[3] += @DE[3];	
					if (@EliteArray[13] -= @AttackerDamage < 0)  {$ADead = 1; $Message .= qq!@EliteArray[0] was killed in the fight.!;}
					if (@DefenderEliteArray[13] -= @DefenderDamage < 0)  {$DDead = 1; $Message .= qq!@DefenderEliteArray[0] was killed in the fight.!;}
					$FinishedMessage = qq!@DefenderEliteArray[0] was challenged to a duel by @EliteArray[0] of $Launcher, and won.!;
				} else {
					@DefenderEliteArray[3] += @AE[3];
					@EliteArray[3] += @DE[2];
					$FinishedMessage = qq!@DefenderEliteArray[0] was challenged to a duel by @EliteArray[0] of $Launcher, and lost.!;
				}
	
				if ($ADead == 1 && $data{'ELITE'} != 0) {@CountryData[$data{'ELITE'}] = "None";}
				if ($DDead == 1 && $i != 0) {@TargetData[$i] = "None";}
	
				open (OUT, ">>$MainPath/messages/$data{'target'}");
				flock (OUT, 2);		
				# Type (0 - News / 1 - Message)|Date [time()]|Sender|Content
				print OUT qq!0|@{[time()]}|$User|$FinishedMessage\n!;
				close (OUT);
				
			} elsif ($Operation == 3) {
				#Tech Recovery
				if ($Success == 1) {
					$TechRecovered = int(abs(int($data{'commando'}))/2);
					$FinishedMessage = qq!$TechRecovered tech points have been recovered.!;
					$Tech = int($TechRecovered/7);
	
					for (my $i=12;$i<19;$i++) {
						$TempTech = $Tech;
						@TargetData[$i] -= $Tech;
						if (@TargetData[$i] < 0) {$TempTech = ($Tech + @TargetData[$i]);@TargetData[$i] = 0;}
						@CountryData[$i] += int(0.8 * $TempTech);
					}

					$Num = rand($RAF - $RDF);
					$DefenderComsKilled = int(@TargetData[11] * 0.05);
					if ($DefenderComsKilled > int(abs($data{'commando'}))) {$DefenderComsKilled = int(abs($data{'commando'}));}
					@TargetData[11] -= $DefenderComsKilled;
					$FinishedMessage .= qq!  @{[&Space($DefenderComsKilled)]} defending commandos were killed trying to prevent the operation.  !;

					if ($Caught == 1) {
						$AttackerComsKilled = int(abs($data{'commando'}) * 0.25);
						if ($AttackerComsKilled > @TargetData[11]) {$AttackerComsKilled = @TargetData[11];}
						@CountryData[11] -= $AttackerComsKilled;
						$FinishedMessage2 = qq!The country of $Launcher has launched an operation against us.  @{[&Space($AttackerComsKilled)]} attacking commandos were slain by defenders.!;
						$FinishedMessage .= qq!@{[&Space($AttackerComsKilled)]} attacking commandos were slain by defenders.!;
					}
	

					@TargetData[11] -= int($Num * @TargetData[11]);
	
					open (OUT, ">>$MainPath/messages/$data{'target'}");
					flock (OUT, 2);
			
					# Type (0 - News / 1 - Message)|Date [time()]|Sender|Content
					print OUT qq!0|@{[time()]}|$User|$FinishedMessage2 @{[&Space($TechRecovered)]} technology points have been stolen.\n!;
					close (OUT);
	
				} else {
					$AttackerComsKilled = int(abs($data{'commando'}) * 0.25);
					if ($AttackerComsKilled > @TargetData[11]) {$AttackerComsKilled = @TargetData[11];}
					@CountryData[11] -= $AttackerComsKilled;
					$FinishedMessage = qq!The attack was a failure.  @{[&Space($AttackerComsKilled)]} commandos were killed attempting to steal technology.!;
		
					open (OUT, ">>$MainPath/messages/$data{'target'}");
					flock (OUT, 2);
			
					# Type (0 - News / 1 - Message)|Date [time()]|Sender|Content
					print OUT qq!0|@{[time()]}|$User|The country of $Launcher has attempted a tech recovery operation on us.  $FinishedMessage.\n!;
					close (OUT);
				}
			} elsif ($Operation == 4) {
				#Explore For Land
				if (rand(100) > 25) {
					$LandRecovered = int(rand(1) * (abs(int($data{'commando'}))/10));
					$FinishedMessage = qq!$LandRecovered blocks of land have been claimed.<BR>!;
					@CountryData[19] += $LandRecovered;
				} else {
					$Casualties = int(rand(1) * abs(int($data{'commando'})));
					$FinishedMessage = qq!The expedition was ambushed.  $Casualties commandos have been lost.!;
					@CountryData[11] -= $Casualties;
				}
			} elsif ($Operation == 5) {
				#Incursion
				if ($Success == 1) {

					$DefenderComsKilled = int(@TargetData[11] * 0.05);
					if ($DefenderComsKilled > int(abs($data{'commando'}))) {$DefenderComsKilled = int(abs($data{'commando'}));}
					@TargetData[11] -= $DefenderComsKilled;

					$FinishedMessage = qq!The incursion was a success. @{[&Space(int(@TargetData[4] * 0.05))]} blocks of Residential, @{[&Space(int(@TargetData[5] * 0.05))]} Research Facilities, @{[&Space(int(@TargetData[6] * 0.05))]} Production Centres, @{[&Space(int(@TargetData[7] * 0.05))]} Government Installations, @{[&Space(int(@TargetData[8] * 0.05))]} Construction Stations, @{[&Space(int(@TargetData[19] * 0.50))]} blocks of free land, @{[&Space(int(@TargetData[3] * 0.2))]} dollars and @{[&Space(int(@TargetData[31] * 0.2))]} citizens have been eliminated in the attack.  @{[&Space($DefenderComsKilled)]} defending commandos and @{[&Space(int($data{'commando'} * 0.2))]} attacking commandos were killed.<BR>!;
	
					@TargetData[4] = int(@TargetData[4] * 0.95);
					@TargetData[5] = int(@TargetData[5] * 0.95);
					@TargetData[6] = int(@TargetData[6] * 0.95);
					@TargetData[7] = int(@TargetData[7] * 0.95);
					@TargetData[8] = int(@TargetData[8] * 0.95);
					@TargetData[3] = int(@TargetData[3] * 0.80);
					@TargetData[19] = int(@TargetData[19] * 0.50);
					@TargetData[31] = int(@TargetData[31] * 0.8);
					
					@TargetData[11] = int(@TargetData[11] * 0.95);
					@CountryData[11] -= int($data{'commando'} * 0.80);
	
	
					open (OUT, ">>$MainPath/messages/$data{'target'}");
					flock (OUT, 2);				
					# Type (0 - News / 1 - Message)|Date [time()]|Sender|Content
					print OUT qq!0|@{[time()]}|$User|The country of $Launcher has performed an incursion against our lands.  $FinishedMessage.\n!;
					close (OUT);
	
				} else {
					$Casualties = int(abs(int($data{'commando'})) * 0.3);
					$FinishedMessage = qq!The incursion was a failure.  @{[&Space($Casualties)]} attacking commandos have been lost.!;
					@CountryData[11] -= $Casualties;

					open (OUT, ">>$MainPath/messages/$data{'target'}");
					flock (OUT, 2);				
					# Type (0 - News / 1 - Message)|Date [time()]|Sender|Content
					print OUT qq!0|@{[time()]}|$User|The country of $Launcher has performed an incursion against our lands.  $FinishedMessage.\n!;
					close (OUT);

				}
			} elsif ($Operation == 6) {
				#Annex
				if ($Success == 1) {

					for ($i = 4; $i < 9;$i++) {
						@CountryData[$i] += int(abs(@TargetData[$i] * 0.05));
						$FinishedMessage .= qq!@{[&Space(int(abs(@TargetData[$i] * 0.05)))]} $ZoneType{$i}, !;
						@TargetData[$i] = int(abs(@TargetData[$i] * 0.95));
					}
					$FinishedMessage .= qq!have been seized.  !;

					#Take 1/4th of free land
					if (@TargetData[19] > 0) {
						@CountryData[19] += int(abs(@TargetData[19] * 0.25));
						$FinishedMessage .= qq!@{[&Space(int(abs(@TargetData[19] * 0.25)))]} blocks of free land have also been taken.!;
						@TargetData[19] = int(abs(@TargetData[19] * 0.75));
					}
	
					$DefenderComsKilled = int(@TargetData[11] * 0.10);
					if ($DefenderComsKilled > abs(int($data{'commando'}))) {$DefenderComsKilled = abs(int($data{'commando'}));}
					$DefenderComsKilled += &FindStrength (0, @EliteArray);
					$FinishedMessage .= qq!@{[&Space($DefenderComsKilled)]} defending and !;
					$AttackerComsKilled = int(abs(int($data{'commando'})) * 0.05);
					$FinishedMessage .= qq!@{[&Space($AttackerComsKilled)]} attacking commandos were killed.!;

					@TargetData[11] -= $DefenderComsKilled;
					@CountryData[11] -= $AttackerComsKilled;


					open (OUT, ">>$MainPath/messages/$data{'target'}");
					flock (OUT, 2);		
					# Type (0 - News / 1 - Message)|Date [time()]|Sender|Content
					print OUT qq!0|@{[time()]}|$User|The country of $Launcher has performed an annex operation against our lands.  $FinishedMessage.\n!;
					close (OUT);
				} else {	
					$DefenderComsKilled = (@TargetData[11] * 0.10);
					if ($DefenderComsKilled > abs(int($data{'commando'}))) {$DefenderComsKilled = abs(int($data{'commando'}));}
					$DefenderComsKilled += &FindStrength (0, @EliteArray);	
					$FinishedMessage = qq!@{[&Space($DefenderComsKilled)]} defending and !;		
					$AttackerComsKilled = int(abs(int($data{'commando'})) * 0.25);
					if ($AttackerComsKilled > @TargetData[11]) {$AttackerComsKilled = @TargetData[11];}
					$FinishedMessage .= qq!@{[&Space($AttackerComsKilled)]} attacking commandos were killed.!;

					@TargetData[11] -= $DefenderComsKilled;
					@CountryData[11] -= $AttackerComsKilled;
				
					open (OUT, ">>$MainPath/messages/$data{'target'}");
					flock (OUT, 2);
					# Type (0 - News / 1 - Message)|Date [time()]|Sender|Content
					print OUT qq!0|@{[time()]}|$User|The country of $Launcher has attempted an annex operation against our lands.  $FinishedMessage.\n!;
					close (OUT);
				}
			} elsif ($Operation == 7) {
				#Equipment theft
				if ($Success == 1) {			
				} else {
				}
			}

			#Calculate Opponents Networth
			&CalcNetworth;

			open (OUT, ">$MainPath/users/$data{'target'}");
			flock (OUT, 2);
			foreach $Item (@TargetData) {
				print OUT "$Item\n";
			}
			close (OUT);

			open (OUT, ">$MainPath/users/$User");
			flock (OUT, 2);
			foreach $Item (@CountryData) {
				print OUT "$Item\n";
			}
			close (OUT);


		} else {
			if (@TargetData[40] >= 193) {
				$FinishedMessage = qq!You need at least $BaseAttack turns to attack $data{'target'}.!;
			} else {
				$FinishedMessage = qq!Target # $data{'target'} is not yet out of protection.  Try again later.!;
			}
		}
	} else {
		$FinishedMessage = qq!Invalid country number.  Target # $data{'target'} does not exist.!;
	}
}


#Determine Strength of Elite
sub FindStrength 
{
	my ($Type, @TempArray) = @_;
	
	#        0		  1      2     3     4      5      6    7    8    9   10   11   12   13      14		15
	#FName "Callsign" LName,Ethos, Level, XP, Weapon, Armour, Cost,Str, Agi, Int, Dip, Acc, Rea, Hlt, Total Hlt, Last Used


	if ($Type == 0) {
		my $Strength = (@TempArray[2] * 2) + (@TempArray[4]) + (@TempArray[5]);
		return $Strength;
	} else {
		#Return Attack Strength, Defense Strength, Damage, XP for win, XP for loss
		my $AttackStrength = (@TempArray[4] * 2) + (int(@TempArray[11] + @TempArray[12])/10);
		my $DefendStrength = (@TempArray[4] * 2) + (int(@TempArray[8] + @TempArray[12])/10);
		my $XPWin = (@TempArray[2] * 10) + (@TempArray[4] * 2) + (@TempArray[5] * 2) + int((@TempArray[7] + @TempArray[8] + @TempArray[9] + @TempArray[10] + @TempArray[11] + @TempArray[12])/60);
		my $XPLoss = int((@TempArray[2] * 10) + (@TempArray[4] * 2) + (@TempArray[5] * 2) + int((@TempArray[7] + @TempArray[8] + @TempArray[9] + @TempArray[10] + @TempArray[11] + @TempArray[12])/60))/2;
		return ($AttackStrength, $DefendStrength, $XPWin, $XPLoss);
	}
}

#See how the ELITE does
sub EliteActivity
{
	my (@TempArray) = @_;
	$DamageToElite = int(@TargetData[11] / 5);
	#If Damage to Elite is more than HP - 
	if ($DamageToElite > @TempArray[13]) {

		#70% Chance ELITE escapes with critical damage
		if (int(rand(100)+1) <= 70) {
			$EliteAttack = 0;
			@TempArray[13] = 1;
			$EliteMsg = qq!@TempArray[0] was ambushed and severely wounded in the attack.!;
			return @TempArray;
		#ELITE is dead
		} else {
			#Determine Damage
			$EliteAttack = (@TempArray[2] * 10) +  (@TempArray[4]) + (@TempArray[5]);
			@TempArray[13] = 0;
			$EliteMsg = qq!@TempArray[0] was been killed in the attack.!;
			return "None";
		}
	#ELITE Survivied - Do Damage
	} else {
		$EliteAttack = (@TempArray[2] * 10) +  (@TempArray[4]) + (@TempArray[5]);
		@TempArray[13] =- $DamageToElite;
		my $Xp = int(($EliteAttack * 2) * (@TempArray[9]/10));
	}
	if ((@TempArray[3] < @EliteLevels[@TempArray[2]+1]) && ((@TempArray[3] + $Xp) < @EliteLevels[@TempArray[2]+1])) {
		@TempArray[2] += 1;
		for (my $Counter = 7;$Counter < 13;$Counter ++) {
			@TempArray[$Counter] += int(rand(5) + 1 + @TempArray[2]);
		}
		@TempArray[13] += int(rand(10) + 1 + (@TempArray[2] * 2));
		$EliteMsg = qq!@TempArray[0] has reached level @TempArray[2]\!!;
	}
	return @TempArray;
}

#Apply bonus for tech level (category 15, training bonus)
sub TechBonus
{
	my $TempValue = @_[0];
	my $Bonus = 1;
	if ($TempValue > 10) {$Bonus = 1.01;}
	if ($TempValue > 50) {$Bonus = 1.02;}
	if ($TempValue > 100) {$Bonus = 1.03;}
	if ($TempValue > 500) {$Bonus = 1.04;}
	if ($TempValue > 1000) {$Bonus = 1.05;}
	if ($TempValue > 2500) {$Bonus = 1.10;}
	if ($TempValue > 5000) {$Bonus = 1.15;}
	if ($TempValue > 7500) {$Bonus = 1.20;}
	if ($TempValue > 10000) {$Bonus = 1.25;}

	return $Bonus;
}



#Apply bonus for training facilities (based on total land owned)
sub TrainingBonus
{
	my @TempArray = @_;
	my $Bonus = 1;
	my $Ratio = (@TempArray[3] / @TempArray[0] + @TempArray[1] + @TempArray[2] + @TempArray[3] + @TempArray[4] + @TempArray[5]);
	if ($Ratio >= 0.25) {$Bonus = 1.01;}
	if ($Ratio >= 0.45) {$Bonus = 1.02;}
	if ($Ratio >= 0.50) {$Bonus = 1.03;}
	if ($Ratio >= 0.60) {$Bonus = 1.05;}
	if ($Ratio >= 0.90) {$Bonus = 1.08;}
	if ($Ratio >= 1.0) {$Bonus = 1.15;}

	return $Bonus;

}
	
for (my $i=24;$i<29;$i++) {
	if (substr(@CountryData[$i],0,4) ne "None") {
        	@EliteArray = split(/,/, @CountryData[$i]);
        	$EliteList .= qq!<option value=$i>@EliteArray[0]</option>!;
	}
}

$Operation{1} = "Demolition";
$Operation{2} = "Duel";
$Operation{3} = "Tech Recovery";
$Operation{4} = "Expedition";
$Operation{5} = "Incursion";
$Operation{6} = "Annex";
$Operation{7} = "Equipment Raid";

my ($Op, $Target) = split(/,/, $Misc);
&StatLine;

if ($Op == 2) {
	open (IN, "$MainPath/users/$Target");
	flock (IN, 1);
	@TargetData = <IN>;
	&chopper(@TargetData);

	$TargetList = qq!<TR><TD>$Font Target ELITE</TD><TD>$Font <select name=TELITE>!;
	for (my $j=24;$j < 29;$j++) {
		if (substr(@TargetData[$j],0,4) ne "None") {
	        	@TEliteArray = split(/,/, @TargetData[$j]);
			$TargetList .= qq!<option value=$j>@TEliteArray[0]</option>!;
		}
	}
	$TargetList .= qq!</select></TD></TR>!;
}
$Target =~ tr/_/ /;	
if ($Op == 1) {$Description = qq!Under a demolition op, commandos and ELITE infiltrate the target city, planting high-yield explosives around structures.   Success largely depends on how skilled the operatives are.!;}
if ($Op == 2) {$Description = qq!A duel is defined as combat between TWO ELITE.  While duels do not usually last until the death, fatalaties while dueling are not unheard of.  It is considered bad form to send commandos to assist your ELITE in the duel, however, many treacherous leaders do so.!;}
if ($Op == 3) {$Description = qq!A Tech Recovery operation is the forcible recovery of enemy research.  Unlike the spy operation, the enemy will lose technology that is stolen.  As research is a valuable commodity, resistance to this operation will be heavy. !;}
if ($Op == 4) {$Description = qq!A relatively low-risk operation, expeditions are good sources of free land.  These operations can turn dangerous when operatives run across enemy soldiers.!;}
if ($Op == 5) {$Description = qq!In this operation, commandos and ELITE infiltrate the enemy city-state, and proceed to damage/destroy as much as possible.  During an incursion nothing is safe, everything from civillians to buildings to spies are targeted.  This operation is a favourite of the Socialist Federation.!;}
if ($Op == 6) {$Description = qq!An Annex operation is the only way for your forces to capture enemy territory.  Unfortunately for your forces, do to the danger this operation poses to the enemy, ALL enemy ELITE will participate in city defense.!;}
if ($Op == 7) {$Description = qq!Similar to a Tech Recovery, in this operation, the ELITE dispatched will recover the most powerful weapon and armour the enemy nation possesses, and begin using it on her own.!;}

print qq—
<head><Title>ASH - Operations Menu</title></HEAD>
<body bgcolor=black text=white>$Font<BR><BR>

<a name=top>
<center>

</center><table border=0 width=100% cellspacing=0>

$LinkLine
</table>
<BR><BR>
<center>$FinishedMessage<BR><BR>
<table width=60% border=0 cellspacing=0>
<TR><TD>$Font Operation</TD><TD>$Font $Operation{$Op}</TD><TD>$Font Target</TD><TD>$Font $Target</TD></TR>
<TR><TD colspan=4><hr width=100% size=1>$Font $Description</TD></TR>
</table><BR><BR><BR>
<form method=POST action="Runner2.pl?$User&$Pword&10&Go">
<input type=hidden name=target value="$Target">
<input type=hidden name=operation value="$Op">
<Table border=0 cellspacing=0 width=80%>
<TR><TD>$Font Commandos</TD><TD>$Font<input type=text name=commando value=0 size=6></TD><TD rowspan=2>$Font<input type=submit value=" Launch Mission " name=submit></TR>
<TR><TD>$Font ELITE</TD><TD>$Font <select name=ELITE><option value=0>None</option>$EliteList</select></TD></TR>
$TargetList
</table>
</form><BR><center>$TurnMessage</center>
—;

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
