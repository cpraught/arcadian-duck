#!/usr/bin/perl
print "Content-type: text/html\n\n";

&GatherInfo;

for (my $TechNum = 12; $TechNum < 19; $TechNum++) {
	for (my $Level = 0; $Level <= scalar(@LevelUp); $Level ++) {
		if (@CountryData[$TechNum] >= @LevelUp[$Level] && @CountryData[$TechNum] > 0) {


			$Werd = @Developments->[$TechNum-12][$Level];			
			$TechInformation .= qq!<B><font color=#008800>$Werd</font></B><BR><font size=-1 color=#00EE00>$Info{"$Werd"}</font><BR><BR><BR>!;

		}
	}
}




&StatLine;

print qq—
<head><Title>ASH - Tech Information</title></HEAD>
<body bgcolor=black text=white background=$BGPic>$Font<BR><BR>
<a name=top>
<center>

$BannerCode

</center><table border=0 width=100% cellspacing=0>


$LinkLine
</table>
<BR><BR>

<Table border=0 width=80%>
  <TR><TD>
	<div align=justify>
$TechInformation
  </TD></TR>
</table>

</body>—;

sub GatherInfo
{

#Civil
	$Info{"Scavenging"} = qq!Training men and women in the art of food scavenging increases the birth rate of your country. With higher birth rates comes a larger work force increasing your overall economic output. Your scavengers will also gather useful military data and resources that will develop your army.!;
	$Info{"Artifact Restoration"} = qq!Renewing old tools of trade increases the efficiency of your workers. Tradesmen and artisans will begin to spring up throughout your country increasing the amount of tax dollars brought in. !;
	$Info{"Bio-Engineering"} = qq!Increased genetic structures of a human lead to the increase in industrial output. This alongside improved reproductive systems increases birth rates, resulting in an increase in population and revenue collected.!;
	$Info{"Robotics"} = qq!The implementation of robots into the every day life of your people eliminates the demand for unskilled labor, which results in the rise of skilled labor. With this increase of skilled workers available, more money is created and taxed.!;
	$Info{"Nano-Technology"} = qq!With the introduction of nanites into your peopleís circulatory systems the average life expectancy of the individual will rise. Improved health will also cause your people to miss work far less resulting in more taxable income.!;
	$Info{"Plasma Technology"} = qq!New developments have lead to an advanced super-dense polycarbon fuel replacing the traditional forms of power. This new fuel has increased factory output and construction speed, which raises the general income of the country.!;
	$Info{"Cloning"} = qq!Creating duplicates of oneís self allows for a large population increase. With more workers there is more money created. !;
	$Info{"Fountain of Life"} = qq!A clinical drug developed that halts the aging process of the individual. The individual must inject this drug once per day to continue its effect. Without a death rate your population will continue to be employed generating money. With perpetual youth your citizens will continue to reproduce increasing the capacity of your countryís population.!;

#Tactical
	$Info{"Agility Booster"} = qq!Giving your spies a special develop drug will help them run faster, jump higher and last longer physically giving your men an advantage in the heat of battle.!;
	$Info{"Surveillance"} = qq!Motion detectors, heat sensors, and laser detectors give your counter-intelligence officers that added jump on their opposition. This will hamper enemy operations in your country.!;
	$Info{"Adrenaline Booster"} = qq!Giving your operatives a small needle to increase the blood flow in their systems will increase the physical strength of your men and the will to fight.!;
	$Info{"Defense Matrix"} = qq!Perimeter sentries, electric fencing, tripwire, and auto-guns force invading forces to go through more obstacles to successfully complete their mission. This increases the overall defensive rating of your country and raises the losses of the invaders.!;
	$Info{"Reaction Booster"} = qq!Injecting a super-caffeine drug into your operatives gives them an advantage in battle. Your offensive units will be more alert giving them the advantage of surprise in battle.!;
	$Info{"Controlled Access"} = qq!Secured areas and public curfews give your defensive units advanced knowledge of security breaches reducing response time which allows them to set ambushes on the retreating attackers.!;
	$Info{"Accuracy Training"} = qq!Extensive sniper training raises operation effectiveness as more combat takes place before closed range. By getting the jump on the defenders the snipers are able to take out a larger number of them, giving the attackers a higher level of surprise.!;
	$Info{"Implant Net"} = qq!By placing homing chips into your population and operatives, your defensive units can keep track of all people entering and leaving your country. This lets your defensive units know when a hostile unit enters your territory and allows them to respond accordingly.!;
	$Info{"Eye in the Sky"} = qq!By placing satellites in orbit around the earth your operatives can monitor other countries constantly. This gives a great advantage both offensively and defensively. Use of the satellites also helps reconnaissance allow operatives to plan out better strategies cutting the time of operations in half.!;

#Military
	$Info{"Armored Assault"} = qq!By employing a new titanium shell on vehicles your military is able to use fewer personnel, decreasing military costs by a small factor.!;
	$Info{"Mechanized Assault"} = qq!New inventions such as hover tanks and the fusion reactor make conventional vehicles and fuels inefficient.!;
	$Info{"Airborne Assault"} = qq!By using air-planes traveling costs for armies are decreased. Supply lines also become futile decreasing upkeep costs.!;
	$Info{"Chemical Assault"} = qq!Using chemical warfare makes the need for higher volumes of troops useless. By gassing the enemy, your army is able to have a smaller active force.!;
	$Info{"Paratroopers"} = qq!Using paratroopers in your army allows for these units to destroy critical components against the enemy. With these tanks and positions rendered useless, your required armament is lower.!;
	$Info{"Biological Assault"} = qq!The crudest of attacks in the game of war, enemy positions crumble at the sound of the bio-alarms and retreat easily. Bio-weaponry replaces chemical weapons taking away the upkeep and replacing it with cheaper bio-weapons.!;
	$Info{"Guerrilla Warfare"} = qq!Rapid attacks and ambushes make use of a smaller army. Major costs are eliminated by the use of these small fighting forces.!;
	$Info{"Molecular Shielding"} = qq!Increasing the life span of all military forces new recruits arenít needed as often. Fewer recruits mean a smaller standing army with smaller wages and maintenance costs.!;
	$Info{"Hand of God"} = qq!Orbital beam-cannons rain showers upon enemy positions allowing small forces to defeat larger ones. There is also a small chance that this beam weapon will rain on an enemy interior allowing buildings to be destroyed and the land stolen from your enemy.!;

#Weapons Technology
	$Info{"High Velocity Gun"} = qq!The High Velocity Gun (HVG) is a basic assault weapon, which fires packets, or bundles of between 5 and 15 titanium-alloy flechettes at speeds of well over mach 6. The HVG is used primarily in a ground-combat role against armored vehicles, defensive emplacements and heavily armored soldiers. Due to the spray area of the flechettes, it is not recommended that this weapon be used in populated areas.!;
	$Info{"Repeater Cannon"} = qq!The Repeater Cannon is a highly sophisticated weapon, with a cyclic rate of over 500 RPS (Rounds Per Second). It fires micronized compressed-explosive shells, approximately 14cm long and 5cm in diameter, each possessing an explosive force equivalent to about half a kilogram of TNT. As a result of the combination of RoF (Rate of Fire) and explosive potential, the Repeater Cannon is an extremely dangerous weapon.!;
	$Info{"Homing Laser"} = qq!Homing lasers are potent weapons, comprised of three major components; a sensor suite, re-positionable emitter, and a charge containment device. After acquiring a target, the wielder has to merely keep the weapon pointed in the general direction of the target, and the sensor suite automatically calculates all necessary changes in aim, including repositioning caused by the user moving.!;
	$Info{"Plasma Assaulter"} = qq!Plasma Assaulters fire a component shell consisting of an armour-piercing tip, and a plasma packet. When the shell strikes a surface, the AP tip shreds through the outer armour later, and at the same time, initiates a chemical reaction to turn the plasma packet into a super-heated gas. This gas enters the target through the damaged armour, literally vaporizing everything it comes in contact with. Test results have shown that flesh liquefies within 3 seconds.!;
	$Info{"Micro-Missile Cannon"} = qq!Micro-Missile Cannons are essentially miniaturized bazookas with an enhanced payload and capable of carrying multiple rounds, and are fired as one would use an assault rifle. The missiles themselves are approximately one-tenth the size of a bazooka round, and the launcher is capable of carrying a payload of 15 rounds. Despite the small clip size, MMC's are popular weapons, due to the fact that a variety of missiles can be used, including high-explosive, guided, heat-seeking and anti-radar.!;
	$Info{"Sonic Oscillator"} = qq!The Sonic Oscillator is a unique weapon, forgoing conventional projectile and beam weaponry to harness the power of sound. Sonic waves are emitted in a tightly focused beam, literally vibrating its target apart. The emitted waves are so powerful that the environment they are discharged into can be seen to shake as the wave passes through it.!;
	$Info{"Fusion Rifle"} = qq!Contrary to popular belief, this weapon does not fire shells which cause fusion explosions upon detonation, primarily due to the NBT (Nuclear Ban Treaty) of 2197. Rather, the fusion detonation is contained within the weapon itself, the resulting explosion used to project a solid tri-alloy slug at well over mach 20. There is currently no known armored substance powerful enough to resist even a single round fired from this weapon.!;
	$Info{"AM Cannon"} = qq!Reconstructed from prototype data recovered from the pre-war installation 'Northern Manitoba', the Anti-Matter Cannon is a devastatingly powerful weapon. Technically classified as a heavy-artillery weapon, it is nevertheless portable enough to be carried and fired as a modern assault rifle. By adjusting the amount of anti-matter fired, the wielder can adapt this weapon so that it is safe to use in close-range combat.!;

#Armour Technology
	$Info{"Poly-Carbonate Armor"} = qq!Poly-Carbonate armor is a simple yet elegant method of armor creation. Copying the basic concept of medieval armor, arms designers have combined light-weight metals with high-density ceramics to create a very light-weight personal body armour which is very resistant to thermal and armor-piercing effects. Concussion weapons have a slightly greater than normal effect on this armour however.!;
	$Info{"Tri-Alloy Armor"} = qq!A basic, but effective armor, the Tri-Alloy Armor is composed of three different high-density metals woven together on the molecular level. Scientists have found that by patterning the weave after a spiders web, extremely durable armor can be created, with incredible protective powers and a greatly reduced weight.!;
	$Info{"Mechanized Exo-Skeleton"} = qq!An extension of the Tri-Alloy Armor, the MES has an incorporated drive system controlled by a high-capacity computer, which allows the armor to detect and amplify the movements of the user. By interacting subtly with the armor, the wearer is able to control the exact force of the armor, which can range from the softest touch to rending titanium blast plating in the matter of an instant. The MES has the unfortunate side-effect of increasing user fatigue, so prolonged combat operations become much more difficult.!;
	$Info{"Blast Armor"} = qq!Utilizing new advances in molecular construction, scientists have managed to reduce the size of the Tri-Alloy, at the same time more than doubling its protective abilities. Additionally, Blast Armor incorporates a multitude of features designed to reduce user fatigue and stress, tasks at which it succeeds quite admirably. This armor is Environmentally Sealed, allowing soldiers equipped with it to operate in scenarios which would otherwise be extremely dangerous, if not lethal.!;
	$Info{"Hardened Blast Armor"} = qq!Using highly reinforced materials the hardened blast armor is capable of withstanding close range attacks from some of the strongest of conventional tank shots.!;
	$Info{"Light Power Armor"} = qq!Increasing maneuverability with flight, those equipped with power armor can respond faster to extreme situations.!;
	$Info{"Heavy Bionic Armor"} = qq!With limited regeneration, the bionic armor is an operativeís best friend for long missions as it repairs damage to itself.!;
	$Info{"Assault Power Armor"} = qq!Giving greater flight range and heavier protection, the assault armor is a much improved version of the light power armor.!;
	$Info{"Sentient Armor"} = qq!Completely alive this armor regenerates faster than the bionic armor. With a limited intelligence the sentient armor can assist the operative on his/her mission.!;

}
