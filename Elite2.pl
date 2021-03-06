#!/usr/bin/perl

if ($data{'fire'} eq "on") {
	@CountryData[$Misc] = "None";


	#Write Data (After game modifications)
	open (OUT, ">$MainPath/users/$User") or print "Cannot open $MainPath/users/$User ($!)<BR>";
	flock (OUT, 2);
	foreach $Line (@CountryData) {
		print OUT "$Line\n";
	}
	close (OUT);


	print "Location: http://www.bluewand.com/cgi-bin/ash/Runner2.pl?$User&$Pword&15\n\n";
}
print "Content-type: text/html\n\n";


@EliteArray = split (/,/,@CountryData[$Misc]);

@WeaponArray = ("None","High Velocity Gun","Repeater Cannon", "Homing Laser","Plasma Assaulter","Micro-Missile Cannon","Sonic Oscillator","Fusion Rifle", "AM Cannon");
@ArmourArray = ("None","Poly-Carbonate Armour", "Tri-Alloy Armour","Blast Armour","Mechanized Exo-Skeleton","Hardened Blast Armour", "Light Power Armour","Heavy Bionic Armour","Assault Power Armour","Sentient Armour");

@LevelUp = (0, 10,50,100,500,1000,2500,5000,7500,10000);

if (@CountryData[13] >= @LevelUp[$data{'weapon'}] && $data{'weapon'} ne "") {@EliteArray[4] = @WeaponArray[$data{'weapon'}];}
if (@CountryData[14] >= @LevelUp[$data{'armour'}] && $data{'armour'} ne "") {@EliteArray[5] = @ArmourArray[$data{'armour'}];}






if (@EliteArray[1] eq "Professional") {$EthosStats = "Extremely stable and trustworthy individuals, professional ELITEs have a high regard for honour and loyalty.  It is extremely hard for enemies to bribe or convert professionals, as they hold their contracts in high regard.  As a rule however, the contracts for professional ELITEs are much more expensive to maintain, and they hold their employers to the same high standards which they hold themselves.";}
if (@EliteArray[1] eq "Mercenary")    {$EthosStats = "Mercenary ELITE are generally regarded as the most ruthless of all types of ELITE, and their willingness to preform all types of missions.  Extremely competitant soldiers, mercenary ELITE are widely sought after.  Unfortunately for their employers, they are also motivated by profit, and are much more likely to desert if their contracts cannot be fufilled.  They are also quite receptive to enemy bribes.";}
if (@EliteArray[1] eq "Rogue") 	      {$EthosStats = "Highly skilled and enhanced to levels which even their fellow ELITE find astonishing, rogue ELITE would the most sought after soldiers in existence, were it not for their questionable loyalty, shakey moral codes, and the apparent randomness of their decisions.  Rogue ELITE have been known to reverse their positiosn on any stand, any affiliation on a whim, which makes them extremely susceptible to enemy bribes.";}
if (@EliteArray[1] eq "Soldiers")     {$EthosStats = "Unquestionably loyal and admirably profficient at their work, soldier ELITE are dedicated warriors, serving in virtually every city-state.  Soldier ELITE are capable of sustained operations while cut off from home, and have been known to continue fighting long after their employers have been defeated and destroyed.  Soldiers, as a general rule, are slightly weaker than their contemporaries, and advance at a slower rate.";}

#["High Velocity Gun","Repeater Cannon", "Homing Laser","Plasma Assaulter","Micro-Missle Cannon","Sonic Oscillator","Fusion Rifle", "AM Cannon"],	#Weaponry
if (@EliteArray[4] eq "None")	 	   {$WeaponStats = "This ELITE is not equiped with a weapon.";}
if (@EliteArray[4] eq "High Velocity Gun") {$WeaponStats = "The High Velocity Gun, or HVG is a basic assault weapon, which fires packets, or bundles of between 5 and 15 titanium-alloy flechettes at speeds of well over mach 6.  The HVG is used primarily in a ground-combat role against armoured vehicles, defensive emplacements and heavily armoured soldiers.  Due to the spray area of the flechettes, it is not recommended that this weapon be used in populated areas.";}
if (@EliteArray[4] eq "Repeater Cannon")   {$WeaponStats = "The Repeater Cannon is a highly sophisticated weapon, with a cyclic rate of over 500 RPS (Rounds Per Second).  It fires micronized compressed-explosive shells, approximately 14cm long and 5cm in diameter, each possessing an explosive force equivalent to about half a kilogram of TNT. As a result of the combination of RoF (Rate of Fire) and explosive potential, the Repeater Cannon is an extremely dangerous weapon.";}
if (@EliteArray[4] eq "Homing Laser")  	   {$WeaponStats = "Homing lasers are potent weapons, comprised of three major components; a sensor suite, repositionable emitter, and a charge containment device.  After acquiring a target, the wielder has to merely keep the weapon pointed in the general direction of the target, and the sensor suite automatically calculates all necessary changes in aim, including repositioning caused by the user moving.";}
if (@EliteArray[4] eq "Plasma Assaulter")  {$WeaponStats = "Plasma Assaulters fire a component shell consisting of an armour-piercing tip, and a plasma packet.  When the shell strikes a surface, the AP tip shreds through the outer armour later, and at the same time, initiates a chemical reaction to turn the plasma packet into a super-heated gas.  This gas enters the target through the damaged armour, literally vapourizing everything it comes in contact with.  Test results have shown that flesh liquifies within 3 seconds.";}
if (@EliteArray[4] eq "Micro-Missile Cannon")  {$WeaponStats = "Micro-Missile Cannons are essentially miniaturized bazookas with an enhanced payload and capable of carrying multiple rounds, and are fired as one would use an assault rifle.  The missiles themselves are approximately one-tenth the size of a bazooka round, and the launcher is capable of carrying a payload of 15 rounds.  Despite the small clip size, MMC's are popular weapons, due to the fact that a variety of missiles can be used, including high-explosive, guided, heat-seaking and anti-radar.";}
if (@EliteArray[4] eq "Sonic Oscillator")  {$WeaponStats = "The Sonic Oscillator is a unique weapon, forgoing conventional projectile and beam weaponry to harness the power of sound.  Sonic waves are emitted in a tightly focussed beam, literally vibrating its target apart.  The emitted waves are so powerful that the environment they are discharged into can be seen to shake as the wave passes through them.";}
if (@EliteArray[4] eq "Fusion Rifle")	   {$WeaponStats = "Contrary to popular belief, this weapon does not fire shells which cause fusion explosions upon detonation, primarily due to the NBT (Nuclear Ban Treaty) of 2197.  Rather, the fusion detonation is contained within the weapon itself, the resulting explosion used to project a solid tri-alloy slug at well over mach 20.  There is currently no known armoured substance powerful enough to resist even a single round fired from this weapon.";}
if (@EliteArray[4] eq "AM Cannon") 	   {$WeaponStats = "Reconstructed from prototype data recovered from the pre-war installation 'Northern Manitoba', the Anti-Matter Cannon is a devestatingly powerful weapon.  Technically classified as a heavy-artillery weapon, it is nevertheless portable enough to be carried and fired as a modern assault rifle.  By adjusting the amount of anti-matter fired, the weilder can adapt this weapon so that it is safe to use in close-range combat.";}


if (@CountryData[13] > 10) {$WeapLink = "<option value=1>High Velocity Gun</option>";}
if (@CountryData[13] > 50) {$WeapLink .= "<option value=2>Repeater Cannon</option>";}
if (@CountryData[13] > 100) {$WeapLink .= "<option value=3>Homing Laser</option>";}
if (@CountryData[13] > 500) {$WeapLink .= "<option value=4>Plasma Assaulter</option>";}
if (@CountryData[13] > 1000) {$WeapLink .= "<option value=5>Micro-Missile Cannon</option>";}
if (@CountryData[13] > 2500) {$WeapLink .= "<option value=6>Sonic Oscillator</option>";}
if (@CountryData[13] > 5000) {$WeapLink .= "<option value=7>Fusion Rifle</option>";}
if (@CountryData[13] > 7500) {$WeapLink .= "<option value=8>AM Cannon</option>";}


#["Poly-carbonate Armour", "Tri-Alloy Armour","Blast Armour","Mechanized Exo-Skeleton","Hardened Blast Armour", "Light Power Armour","Heavy Bionic Armour","Assault Power Armour","Sentient Armour"],	#Armour
if (@EliteArray[5] eq "None") 			{$ArmourStats = "This ELITE is not equiped with armour.";}
if (@EliteArray[5] eq "Poly-Carbonate Armour")  {$ArmourStats = "Poly-Carbonate armour is a simple yet elagant method of armour creation.  Copying the basic concept of medieval armour, arms designers have combined light-weight metals with high-density ceramics to create a very light-weight personal body armour which is very resistant to thermal and armour-piercing effects.  Concussion weapons have a slightly greater than normal effect on this armour however.";}
if (@EliteArray[5] eq "Tri-Alloy Armour") 	{$ArmourStats = "A basic, but effective armour, the Tri-Alloy Armour is composed of three different high-density metals woven together on the molecular level.  Scientists have found that by patterning the weave after a spiders web, extremely durable armour can be created, with incredible protective powers and a greatly reduced weight.";}
if (@EliteArray[5] eq "Mechanized Exo-Skeleton"){$ArmourStats = "An extension of the Tri-Alloy Armour, the MES has an incorporated drive system controlled by a high-capacity computer, which allows the armour to detect and amplify the movements of the user.  By interacting subtley with the armour, the wearer is able to control the exact force of the armour, which can range from the softest touch to rending titanium blast plating in the matter of an instant.  The MES has the unfortunate side-effect of increasing user fatigue, so prolonged combat operations become much more difficult.";}
if (@EliteArray[5] eq "Blast Armour") 		{$ArmourStats = "Utilizing new advances in molecular construction, scientsits have managed to reduce the size of the Tri-Alloy, at the same time more than doubling its protective abilities.  Additionally, Blast Armour incorporates a multitude of features designed to reduce user fatigue and stress, tasks at which it succeeds quite admirably.  This armour is Environmentally Sealed, allowing soldiers equiped with it to operate in scenarios which would otherwise be extremely dangerous, if not leathal.";}

if (@CountryData[14] > 10) {$ArmLink = "<option value=1>Poly-Carbonate Armour</option>";}
if (@CountryData[14] > 50) {$ArmLink .= "<option value=2>Tri-Alloy Armour</option>";}
if (@CountryData[14] > 100) {$ArmLink .= "<option value=3>Blast Armour</option>";}
if (@CountryData[14] > 500) {$ArmLink .= "<option value=4>Mechanized Exo-Skeleton</option>";}
if (@CountryData[14] > 1000) {$ArmLink .= "<option value=5>Hardened Blast Armour</option>";}
if (@CountryData[14] > 2500) {$ArmLink .= "<option value=6>Light Power Armour</option>";}
if (@CountryData[14] > 5000) {$ArmLink .= "<option value=7>Heavy Bionic Armour</option>";}
if (@CountryData[14] > 7500) {$ArmLink .= "<option value=8>Assault Power Armour</option>";}
if (@CountryData[14] > 10000) {$ArmLink .= "<option value=9>Sentient Armour</option>";}

@CountryData[$Misc] = qq!@EliteArray[0],@EliteArray[1],@EliteArray[2],@EliteArray[3],@EliteArray[4],@EliteArray[5],@EliteArray[6],@EliteArray[7],@EliteArray[8],@EliteArray[9],@EliteArray[10],@EliteArray[11],@EliteArray[12],@EliteArray[13]!;

&StatLine;

print qq�
<head><title>ASH - ELITE</title></head>
<body bgcolor=black text=white background=$BGPic alink=$FColourOne link=$FColourOne vlink=$FColourOne>$Font<BR><BR>

<a name=top>
<center>

$BannerCode

</center><table border=0 width=100% cellspacing=0>


<form METHOD=post action="Runner2.pl?$User&$Pword&7&$Misc">
$LinkLine
</table><BR><BR>

<table width=100% border=0 cellspacing=0>
<TR>
<TD width=35%>

<table width=100% border=0 cellspacing=0>
<TR><TD colspan=2><B>$NewFont1 @EliteArray[0]</TD></TR>
<TR><TD>$NewFont1 Strength</TD><TD>$NewFont2 @EliteArray[7]</TD></TR>
<TR><TD>$NewFont1 Agility</TD><TD>$NewFont2 @EliteArray[8]</TD></TR>
<TR><TD>$NewFont1 Intelligence</TD><TD>$NewFont2 @EliteArray[9]</tD></TR>
<TR><TD>$NewFont1 Diplomacy</TD><TD>$NewFont2 @EliteArray[10]</TD></TR>
<TR><TD>$NewFont1 Accuracy</TD><TD>$NewFont2 @EliteArray[11]</TD></TR>
<TR><TD>$NewFont1 Reactions</TD><TD>$NewFont2 @EliteArray[12]</TD></TR>
<TR><TD>$NewFont1 Health</TD><TD>$NewFont2 @EliteArray[13]</TD></TR>
</table>

</TD><TD align=middle valign=middle>

<BR>

</TD></TR>

<TR><TD><BR></TD></TR>

<TR><TD colspan=2>$NewFont1<B>Description</Td></TR>
<TR><TD><BR><BR></TD></TR>
<TR><TD colspan=2>$NewFont1<B>Ethos - @EliteArray[1] - </B><BR>$NewFont2 $EthosStats</Td></TR>
<TR><TD><BR></TD></TR>
<TR><TD colspan=2>$NewFont1<B>Weapon - @EliteArray[4] - </B><select name=weapon><option name=0>None</option>$WeapLink</option></select><BR>$NewFont2 $WeaponStats</Td></TR>
<TR><TD><BR></TD></TR>
<TR><TD colspan=2>$NewFont1<B>Armour - @EliteArray[5] - </B><select name=armour><option name=0>None</option>$ArmLink</option></select><BR>$NewFont2 $ArmourStats</Td></TR>
<TR><TD><BR></TD></TR>
<TR><TD colspan=2>$NewFont1<B>Dismiss Elite <input type=checkbox name=fire value=on>  <input type=submit name=dismiss value="Process Changes"></Td></TR>
</table>
</form>
�;
