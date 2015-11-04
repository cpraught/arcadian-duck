#!/usr/bin/perl

$data{'target'} =~ s/\D//g;
if ($data{'target'} ne "none" && $data{'target'} ne "") {print "Location: http://www.bluewand.com/cgi-bin/ash/Runner2.pl?$User&$Pword&10&$data{'operation'},$data{'target'}\n\n";}

opendir (DIR, "$MainPath/users");
@Users = readdir (DIR);
closedir (DIR);

print "Content-type: text/html\n\n";

if ($data{'operation'} ne "none" && $data{'operation'} ne "" && @CountryData[29] >= 3) {
	if (-e "$MainPath/users/$data{'target'}") {
		open (IN, "$MainPath/users/$data{'target'}");
		flock (IN, 1);
		@TargetData = <IN>;	
		close (IN);
		&chopper (@TargetData);
	}
	if (@TargetData[40] >= 193) {
		&StatLine;

		$Operation{1} = "Demolition";
		$Operation{2} = "Duel";
		$Operation{3} = "Tech Recovery";
		$Operation{4} = "Expedition";
		$Operation{5} = "Incursion";
		$Operation{6} = "Annex";
		$Operation{7} = "Equipment Raid";

		$Op = $data{'operation'};
		$Target = $data{'target'};

		$TargetList = qq!<TR><TD>$Font Target ELITE</TD><TD>$Font <select name=TELITE><option value=None>None</option>!;
		for (my $j=24;$j < 29;$j++) {
			if (substr(@TargetData[$j],0,4) ne "None") {
	        		@TEliteArray = split(/,/, @TargetData[$j]);
				$TargetList .= qq!<option value=$j>@TEliteArray[0]</option>!;
			}
		}
		$TargetList .= qq!</select></TD></TR>!;
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
<body bgcolor=black text=white alink=$FColourOne link=$FColourOne vlink=$FColourOne>$Font<BR><BR>

<a name=top>
<center>



</center><table border=0 width=100% cellspacing=0>

$LinkLine
</table>
<BR><BR>
<center>$FinishedMessage
<table width=60% border=0 cellspacing=0>
<TR><TD>$Font Operation</TD><TD>$Font $Operation{$Op}</TD><TD>$Font Target</TD><TD>$Font $Target</TD></TR>
<TR><TD colspan=4><hr width=100% height=1>$Font $Description</TD></TR>
</table><BR><BR><BR>
<form method=POST action="Runner2.pl?$User&$Pword&10">
<input type=hidden name=target value="$Target"><input type=hidden name=operation value="$Op">
<Table border=0 cellspacing=0 width=80%>
<TR><TD>$Font Commandos</TD><TD>$Font<input type=text name=commando value=0></TD><TD>$Font ELITE</TD><TD>$Font <select name=ELITE><option value=0>None</option>$EliteList</select></TD></TR>
$TargetList
</table><input type=submit name=submit value=" Launch Mission ">
</form>
—;
	die;
	} else {
	&StatLine;
print qq—
<head><Title>ASH - Operations Menu</title></HEAD>
<body bgcolor=black text=white>$Font<BR><BR>

<a name=top>
<center>

<!-- BEGIN RICH-MEDIA BURST! CODE --> 
<script language="JavaScript"> 
<!-- /* © 1997-1999 BURST! Media, LLC. All Rights Reserved.*/ 
var TheAdcode = 'ad3998a'; 
var bN = navigator.appName; 
var bV = parseInt(navigator.appVersion); 
var base='http://www.burstnet.com/'; 
var Tv=''; 
var agt=navigator.userAgent.toLowerCase(); 
if (bV>=4) 
  {ts=window.location.pathname+window.location.search; 
   i=0; Tv=0; while (i< ts.length) 
      { Tv=Tv+ts.charCodeAt(i); i=i+1; } Tv="/"+Tv;} 
  else   {Tv=escape(window.location.pathname); 
   if( Tv.charAt(0)!='/' ) Tv="/"+Tv; 
          else if (Tv.charAt(1)=="/")
Tv=""; 
  if( Tv.charAt(Tv.length-1) == "/") 
    Tv = Tv + "_";} 
if (bN=='Netscape'){ 
     if ((bV>=4)&&(agt.indexOf("mac")==-1))
{  document.write('<s'+'cript src="'+ 
      base+'cgi-bin/ads/'+TheAdcode+'.cgi/RETURN-CODE/JS' 
      +Tv+'">'); 
     document.write('</'+'script>');    
} 
     else if (bV>=3) {document.write('<'+'a href="'+base+'ads/'+ 
        TheAdcode+'-map.cgi'+Tv+'"target=_top>'); 
        document.write('<img src="' + base + 'cgi-bin/ads/' + 
        TheAdcode + '.cgi' + Tv + '" ismap width="468" height="60"' + 
        ' border="0" alt="Click Here"></a>');} 
 } 
if (bN=='Microsoft Internet Explorer') 
 document.write('<ifr'+'ame id="BURST" src="'+base+'cgi-bin/ads/'
+ 
  TheAdcode + '.cgi' + Tv + '/RETURN-CODE" width="468" height="60"' + 
  'marginwidth="0" marginheight="0" hspace="0" vspace="0" ' + 
  'frameborder="0" scrolling="no"></ifr'+'ame>'); 
// --> 
</script> <noscript><a href="http://www.burstnet.com/ads/ad3998a-map.cgi" target="_top"> 
<img src="http://www.burstnet.com/cgi-bin/ads/ad3998a.cgi" 
 width="468" height="60" border="0" alt="Click Here"></a> 
</noscript> 
<!-- END BURST CODE --><BR><font size=-2 face=arial><B>This Months Featured Sponsors Are: <font color=blue>EquityAlert, MSN Home Advisor, Gateway and MSN Carpoint<BR>Please support our sponsors!</font></b></font><BR><BR>


</center><table border=0 width=100% cellspacing=0>

$LinkLine
</table>
<BR><BR>
<center>$FinishedMessage
<table width=60% border=0 cellspacing=0>
<TR><TD>$Font Operation</TD><TD>$Font $Operation{$Op}</TD><TD>$Font Target</TD><TD>$Font $Target</TD></TR>
<TR><TD colspan=4><hr width=100% height=1>$Font $Description</TD></TR>
</table><BR><BR><BR>
Target is not yet out of protection.  Try again later.
—;
	die;

	}
}

my %Level;
$Level{'0'} = "Low";
$Level{'1'} = "Medicore";
$Level{'3'} = "Mid-Level";
$Level{'3'} = "Good";
$Level{'4'} = "Excellent";
$Level{'5'} = "Superb";
my $Effectiveness = 0;
my $CommandoCost = 25000;
my $EliteCost = 250000;

#Hire New Commandos / Fire old Commandos

$data{'commando'} = int($data{'commando'});

if ($data{'commando'} > 0) {
	if (($data{'commando'} + @CountryData[9] + @CountryData[10] + @CountryData[11]) < int((@CountryData[4] + @CountryData[5] + @CountryData[6] + @CountryData[7] + @CountryData[8]) * 0.10)) {
		my $TCost = $data{'commando'} * $CommandoCost;
		if ($TCost < @CountryData[3]) {@CountryData[11] += $data{'commando'};@CountryData[3] -= $TCost;}
	} else {$OpMessage = qq!Your land cannot support this many units.<BR><BR>!;}
} elsif ($data{'commando'} < 0) {
	if ($data{'commando'} + @CountryData[11] < 0) {@CountryData[11] = 0;} else {@CountryData[11] += $data{'commando'};}
}

if ($data{'spec'} eq "On") {
	if (@CountryData[3] > $EliteCost && $Elites + 1 <= 6) {
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
			       		
				#FName "Callsign" LName,Ethos, Level, XP, Weapon, Armour, Cost,Str, Agi, Int, Dip, Acc, Rea, Hlt
				@CountryData[$i] = qq!$Fname "$Clsgn" $Lname,$Ethos,0,0,None,None,125000,$Str,$Agi,$Int,$Dip,$Acc,$Rea,$Hlt, $Hlt!;
				$BuiltFlag = 1;
			}			
		}		
	} else {$Message .= "ELITE could not be hired.  You may only have a maximum of 6 ELITE, and must be able to pay the contract fee.<BR><BR>";}
}


if (@CountryData[17] > 10) {$Ops = "<option value=1>Demolition</option>";@Op[1] = 1;}
if (@CountryData[17] > 50) {$Ops .= "<option value=2>Duel</option>";@Op[2]=1;}
if (@CountryData[17] > 100) {$Ops .= "<option value=3>Tech Recovery</option>";@Op[3]=1;}
if (@CountryData[17] > 500) {$Ops .= "<option value=4>Expidition</option>";@Op[4]=1;}
if (@CountryData[17] > 1000) {$Ops .= "<option value=5>Incursion</option>";@Op[5]=1;}
if (@CountryData[17] > 2500) {$Ops .= "<option Value=6>Annex</option>";@Op[6]=1;}
if (@CountryData[17] > 5000) {$Ops .= "<option value=7>Equipment Raid</option>";@Op[7]=1;}

&StatLine;

print qq—
<head><Title>ASH - Spec Ops Menu</title></HEAD>
<body bgcolor=black text=white>$Font<BR><BR>

<a name=top>
<center>

<!-- BEGIN RICH-MEDIA BURST! CODE --> 
<script language="JavaScript"> 
<!-- /* © 1997-1999 BURST! Media, LLC. All Rights Reserved.*/ 
var TheAdcode = 'ad3998a'; 
var bN = navigator.appName; 
var bV = parseInt(navigator.appVersion); 
var base='http://www.burstnet.com/'; 
var Tv=''; 
var agt=navigator.userAgent.toLowerCase(); 
if (bV>=4) 
  {ts=window.location.pathname+window.location.search; 
   i=0; Tv=0; while (i< ts.length) 
      { Tv=Tv+ts.charCodeAt(i); i=i+1; } Tv="/"+Tv;} 
  else   {Tv=escape(window.location.pathname); 
   if( Tv.charAt(0)!='/' ) Tv="/"+Tv; 
          else if (Tv.charAt(1)=="/")
Tv=""; 
  if( Tv.charAt(Tv.length-1) == "/") 
    Tv = Tv + "_";} 
if (bN=='Netscape'){ 
     if ((bV>=4)&&(agt.indexOf("mac")==-1))
{  document.write('<s'+'cript src="'+ 
      base+'cgi-bin/ads/'+TheAdcode+'.cgi/RETURN-CODE/JS' 
      +Tv+'">'); 
     document.write('</'+'script>');    
} 
     else if (bV>=3) {document.write('<'+'a href="'+base+'ads/'+ 
        TheAdcode+'-map.cgi'+Tv+'"target=_top>'); 
        document.write('<img src="' + base + 'cgi-bin/ads/' + 
        TheAdcode + '.cgi' + Tv + '" ismap width="468" height="60"' + 
        ' border="0" alt="Click 