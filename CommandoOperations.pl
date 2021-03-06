#!/usr/bin/perl

$TechType{0} = "Civil";
$TechType{1} = "Weaponry";
$TechType{2} = "Armour";
$TechType{3} = "Tactics";
$TechType{4} = "Covert";
$TechType{5} = "Spec Ops";
$TechType{6} = "Military";


$MailPath = "$MainPath/messages";
$OpNumber = $data{'op2'};
$AttackerSent = int(abs($data{'commando'}));

&Operation_Function2;

sub Operation_Function2
{

	$Target = $data{'target2'};
	$Target =~ s/\D//g;

	if (-e "$MainPath/users/$Target") {

		open (IN, "$MainPath/users/$Target");
		flock (IN, 1);
		@TargetData = <IN>;
		close (IN);
		&chopper (@TargetData);

		&CalcElite;
		&RankFinder;

		if ($AttackerSent > @CountryData[11]) {$AttackerSent = @CountryData[11];}

		$DLandValue = (@TargetData[4] + @TargetData[5] + @TargetData[6] + @TargetData[7] + @TargetData[8]) / 10;
		$ALandValue = (@CountryData[4] + @CountryData[5] + @CountryData[6] + @CountryData[7] + @CountryData[8]) / 10;
		if ($AttackerSent > 0) {
			$AttackerRatio = (($AttackerSent * $EliteModBonus) * 10) / $ALandValue;
		} elsif ($data{'ELITE'} > 0)  {
			$AttackerRatio = (($EliteModBonus) * 10) / $ALandValue;
		}


		$DefenderRatio = (@TargetData[11] * 10) / $DLandValue;

		$AttackStr = rand($AttackerRatio);
		$DefendStr = rand($DefenderRatio);

		&Experience;


		if ($AttackStr > $DefendStr) {$Success = 1;} else {$Success = 0;}
		if ($TurnsToRun == 0) {$Success = -1; $Flag = 3;}
		if ($AttackerSent < 1) {$Success = -1; $Flag = 4;}
		if (@CountryData[29] < $TurnsToRun) {$Success = -1; $Flag = 1;}
		if (@TargetData[40] <= 193) {$Success = -1; $Flag = 2;}

		if ($Success > -1) {
			for (my $i=0; $i < $TurnsToRun; $i++) {
				$TurnMessage .= &RunTurn;
			}
		}

	} else {$Success = 0; $Flag = 0;}


	#Check if operation is successful (determined beforehand)
	if ($Success > 0)  {

		$DefenderLosses = int(abs($AttackerSent * 0.15));
		$AttackerLosses = int(abs($AttackerSent * 0.05));

		$DefendersLeft = @TargetData[11] - $DefenderLosses;
		if ($DefendersLeft < 0) {$DefendersLeft = 0;}

		if ($AttackerLosses > $DefendersLeft) {$AttackerLosses = $DefendersLeft;}

		@CountryData[11] -= $AttackerLosses;
		@TargetData[11] -= $DefenderLosses;
		if (@CountryData[11] < 0) {@CountryData[11] = 0;}
		if (@TargetData[11] < 0) {@TargetData[11] = 0;}

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
		close (OUT);
		print "";



	#Operation has failed
	} elsif ($Success == 0) {
		#Reduce Operatives Involved In Mission
		$AttackerLosses = int(abs($AttackerSent * 0.15));
		$DefenderLosses = int(abs(($AttackerSent - $AttackerLosses) * 0.05));

		@CountryData[11] -= abs($AttackerLosses);
		@TargetData[11] -= abs($DefenderLosses);
		if (@CountryData[11] < 0) {@CountryData[11] = 0;}
		if (@TargetData[11] < 0) {@TargetData[11] = 0;}

		#Write to Defender News	
		$NewsVal = 2;
		&WriteDefNews($OpNumber);

		&MinIt;
		&CalcNetworth;

		open (OUT, ">$MainPath/users/$Target");
		flock (OUT, 2);
		foreach $OutLine (@TargetData) {
			print OUT "$OutLine\n";
		}
		close (OUT);
		print "";

	} else {
		if ($Flag == 0) {$View = qq!Target does not exist.!;}
		if ($Flag == 1) {$View = qq!You do not have enough turns to attack the target.!;}
		if ($Flag == 2) {$View = qq!Target is still in protection and cannot be attacked.!;}
		if ($Flag == 3) {$View = qq!Target does not exist.!;}
		if ($Flag == 4) {$View = qq!You cannot attack without commandos.!;}
		print "";
	}
}


sub RunOpEffects
{
	my $Operation = @_[0];
	if ($Operation == 1) {

		my @BuildingsDown = ();		
		@BuildingsDown[0] = abs(int(@TargetData[4] * 0.02));
		@BuildingsDown[1] = abs(int(@TargetData[5] * 0.02));
		@BuildingsDown[2] = abs(int(@TargetData[6] * 0.02));
		@BuildingsDown[3] = abs(int(@TargetData[7] * 0.02));
		@BuildingsDown[4] = abs(int(@TargetData[8] * 0.02));

		$View = qq!@BuildingsDown[0] housing complexes, @BuildingsDown[1] research facilities, @BuildingsDown[2] production centres, @BuildingsDown[3] government installations and @BuildingsDown[4] construction stations were destroyed in the blast.!;
		$Amount = $View;
		for ($Counter = 0; $Counter < 4; $Counter++) {
			@TargetData[4 + $Counter] -= @BuildingsDown[$Counter];
		}
		
	} elsif ($Operation == 2) {

		$TotalLand = @CountryData[4] + @CountryData[5] + @CountryData[6] + @CountryData[7] + @CountryData[8] + @CountryData[19];
		$LandAdded = int((200 * ((@CountryData[11] * 10) / $TotalLand)) * (0.9 + rand(0.20)));
		@CountryData[19] += $LandAdded;

		$View = qq!@{[&Space($LandAdded)]} blocks of land have been gained through our efforts.!;

	} elsif ($Operation == 3) {

		my @TechLost = ();

		for ($Counter = 0; $Counter < 7; $Counter++) {
			@TechLost[$Counter] = abs(int(@TargetData[12 + $Counter] * 0.05));
			@CountryData[12 + $Counter] += @TechLost[$Counter];
			@TargetData[12 + $Counter] -= @TechLost[$Counter];

			$View .= qq!@{[&Space(@TechLost[$Counter])]} points of $TechType{$Counter} have been stolen.  !;
		}
	} elsif ($Operation == 4) {

		my @BuildingsTaken = ();

		#Sieze Buildings - 2% of buildings, 10% of free land
		for ($Counter = 0; $Counter < 5; $Counter ++) {
			@BuildingsTaken[$Counter] = abs(int(@TargetData[4 + $Counter] * 0.02));
		}

		@BuildingsTaken[5] = abs(int(@TargetData[19] * 0.10));
		#Write Message
		$Amount = qq!@BuildingsTaken[0] housing complexes, @BuildingsTaken[1] research facilities, @BuildingsTaken[2] production centres, @BuildingsTaken[3] government installations and @BuildingsTaken[4] construction stations, as well as @BuildingsTaken[5] blocks of land!;
		$View = qq!The annex was a success\!  @BuildingsTaken[0] housing complexes, @BuildingsTaken[1] research facilities, @BuildingsTaken[2] production centres, @BuildingsTaken[3] government installations and @BuildingsTaken[4] construction stations, as well as @BuildingsTaken[5] blocks of land were siezed by our soldiers\!!;
		for ($Counter = 0; $Counter < 5; $Counter ++) {
			@TargetData[4 + $Counter] -= @BuildingsTaken[$Counter];
			@CountryData[4 + $Counter] += @BuildingsTaken[$Counter];
		}
		@TargetData[19] -= @BuildingsTaken[5];
		@CountryData[19] -= @BuildingsTaken[5];

	} elsif ($Operation == 5) {
		my @BuildingsTaken = ();

		#RaZe Buildings - 4% of buildings, 15% of free land
		for ($Counter = 0; $Counter < 4; $Counter ++) {
			@BuildingsTaken[$Counter] = abs(int(@TargetData[4 + $Counter] * 0.04));
		}
		@BuildingsTaken[5] = abs(int(@TargetData[19] * 0.15));
		#Write Message
		$View = qq!The incursion was a success\!  @BuildingsTaken[0] housing complexes, @BuildingsTaken[1] research facilities, @BuildingsTaken[2] production centres, @BuildingsTaken[3] government installations and @BuildingsTaken[4] construction stations, as well as @BuildingsTaken[5] blocks of land have been torched\!!;
		for ($Counter = 0; $Counter < 6; $Counter ++) {
			@TargetData[4 + $Counter] -= @BuildingsTaken[$Counter];
		}
	} elsif ($Operation == 6) {

		my $DeadCom = abs(int(@TargetData[11] * 0.5));
		@TargetData[11] -= $DeadCom;
		$View = qq!Our men have assassinated @{[&Space($DeadCom)]} enemy commandos.!;
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
	#Demolition
	if ($OpNumber == 1) {
		if ($Condition == 1) {
			$Message = qq!An enemy demolition op from @CountryData[34] has destroyed a number of our structures.  $Amount.  @{[&Space($DefenderLosses)]} of our men were killed attempting to repel the enemy.  @{[&Space($AttackerLosses)]} attackers will eliminated by our defenses.!;
		} else {
			$Message = qq!An enemy demolition op from @CountryData[34] has been foiled.  @{[&Space($DefenderLosses)]} of our men were killed repelling the enemy.  @{[&Space($AttackerLosses)]} attackers will eliminated by our defenses.!;
			$View = qq!We have failed the demolition operation.  @{[&Space($AttackerLosses)]} of our men were killed.  @{[&Space($DefenderLosses)]} defenders will eliminated by our troops.!;
		}
	#Exploration
	} elsif ($OpNumber == 2) {
		if ($Condition == 1) {
			$Message = qq!We were successful in obtaining new land.  $Amount blocks of new land have been added to our country.!;
		} else {
			$Message = qq!Our attempts at expansion were unsuccessful.   @{[&Space($AttackerLosses)]} attackers were lost attempting to sieze the area from bandits.!;
			$View = qq!We have failed the exploration.  @{[&Space($AttackerLosses)]} of our men were killed by unknown elements.!;
		}
	#Tech Raid
	} elsif ($OpNumber == 3) {
		if ($Condition == 1) {
			$Message = qq!The nation of @CountryData[34] raided our technology storehouses.  $Amount has been stolen by the enemy.  @{[&Space($DefenderLosses)]} of our security forces were killed and the enemy lost @{[&Space($AttackerLosses)]} men in the raid.!; 
		} else {
			$Message = qq!@CountryData[34] made an unsuccessful attempt to raid our technology storehouses.  @{[&Space($DefenderLosses)]} of our men were killed repelling the enemy.  @{[&Space($AttackerLosses)]} attackers will eliminated by our defenses.!;
			$View = qq!We have failed the tech raid.  @{[&Space($AttackerLosses)]} of our men were killed.  @{[&Space($DefenderLosses)]} defenders will eliminated by our troops.!;
		}
	#Annex
	} elsif ($OpNumber == 4) {
		if ($Condition == 1) {
			$Message = qq!The nation of @CountryData[34] has annexed part of our lands.  $Amount has been siezed and occupied by the enemy.  @{[&Space($DefenderLosses)]} of our security forces were killed and the enemy lost @{[&Space($AttackerLosses)]} men in the attack.!;
		} else {
			$Message = qq!Our men have defeated an annexation attempt by @CountryData[34]. @{[&Space($DefenderLosses)]} of our men were killed repelling the enemy.  @{[&Space($AttackerLosses)]} attackers will eliminated by our defenses.!;
			$View = qq!We have failed the annex.  @{[&Space($AttackerLosses)]} of our men were killed.  @{[&Space($DefenderLosses)]} defenders will eliminated by our troops.!;
		}
	#Incursion
	} elsif ($OpNumber == 5) {
		if ($Condition == 1) {
			$Message = qq!@CountryData[34] has launched an assault against us.  $Amount has been utterly destroyed.  @{[&Space($DefenderLosses)]} of our security forces were killed and the enemy lost @{[&Space($AttackerLosses)]} men in the raid.!; 
		} else {
			$Message = qq!@CountryData[34] made an unsuccessful incursion against us.  @{[&Space($DefenderLosses)]} of our men were killed repelling the enemy.  @{[&Space($AttackerLosses)]} attackers will eliminated by our defenses.!;
			$View = qq!We have failed the incursion.  @{[&Space($AttackerLosses)]} of our men were killed.  @{[&Space($DefenderLosses)]} defenders will eliminated by our troops.!;
		}
	#Assassination
	} elsif ($OpNumber == 6) {
		if ($Condition == 1) {
			$Message = qq!The nation of @CountryData[34] has assassinated a number of Commandos.  @{[&Space($DefenderLosses)]} of our security forces were killed and the enemy lost @{[&Space($AttackerLosses)]} men in the raid.!; 
		} else {
			$Message = qq!Our men prevented an assassination attempt by the nation of @CountryData[34].  @{[&Space($DefenderLosses)]} of our men were killed repelling the enemy.  @{[&Space($AttackerLosses)]} attackers will eliminated by our defenses.!;
			$View = qq!We have failed the assassination.  @{[&Space($AttackerLosses)]} of our men were killed.  @{[&Space($DefenderLosses)]} defenders will eliminated by our troops.!;
		}
	}
	# Type (0 - News / 1 - Message)|Date [time()]|Sender|Content
	print OUT qq!0|@{[time()]}|$User|$Message.\n!;
	close (OUT);
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
					#  Level			Int			Reac			Gun
			$EliteModBonus = ((10 * @TempElite[2]) + (3  * @TempElite[9]) + (2 * @TempElite[12]) + (5 * @TempElite[4]));
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
