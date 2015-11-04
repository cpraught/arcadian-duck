#!/usr/bin/perl

if (@CountryData[29] >= abs(int($data{'turn'})) ) {
	for (my $i=0;$i < abs(int($data{'turn'}));$i++) {
	$TurnMessage .= &RunTurn;
	}
}


($Tax, $War) = split(/,/, @CountryData[2]);
$Population = &Space(@CountryData[31]);
$Money = &Space(@CountryData[3]);

($Res, $ResB) = split (/,/, @CountryData[4]);
($Com, $ResB) = split (/,/, @CountryData[5]);
($Ind, $ResB) = split (/,/, @CountryData[6]);
($Gov, $ResB) = split (/,/, @CountryData[7]);
($Con, $ResB) = split (/,/, @CountryData[8]);

$Spy = &Space(@CountryData[9]);
$CSpy = &Space(@CountryData[10]);
$Commando = &Space(@CountryData[11]);

if (-e "$MainPath/messages/$User") {
open (IN, "$MainPath/messages/$User") or print "Cannot Open $MainPath/messages/$User";
flock (IN, 1);
@Message = <IN>;
close (IN);
&chopper (@Message);

foreach $Items (@Message) {
	my @Mesf = split(/\|/, $Items);
	if (@Mesf[0] == 1) {$Mess++;push (@NewNews, "$Items\n");} else {
		($Sec,$Min,$Hour,$Mday,$Mon,$Year,$Wday,$Ydays,$Isdst) = localtime(time());	
		($Sec,$Min,$Hour,$Mday,$Mon,$Year,$Wday,$Yday,$Isdst) = localtime(@Mesf[1]);
		$Mon++;
		$Year += 1900;
		if (length($Sec) == 1) {$Sec = "0$Sec"}
		if (length($Min) == 1) {$Min = "0$Min"}
		if (length($Hour) == 1) {$Hour = "0$Hour"}
					
		$Log .= qq!
<TR><TD>$Font $Mon/$Mday/$Year</TD><TD align=right>$Font  $Hour:$Min:$Sec</TD></TR>
<TR><TD colspan=2><HR height=1 width=100%>$Font @Mesf[3]</TD></TR>
<TR><TD colspan=2>&nbsp;</TD></TR>!;

		if ($Ydays - $Yday < 1) {
			push (@NewNews, "$Items\n");
		}
	}	

}
	open (OUT, ">$MainPath/messages/$User");
	flock (OUT, 2);
	print OUT @NewNews;
	close (OUT);
}

if ($Mess > 0) {$MessLine = qq+<B><Br><BR><I><a href="Runner2.pl?$User&$Pword&9" style="color:$FColourTwo">You have messages waiting!</a></I></b><BR>+;}
$Spec = 0;
for ($i = 24;$i <29;$i ++) {
	if (substr(@CountryData[$i],0,4) ne "None") {$Spec++;}
}

if (-e "$MainPath/clans/@CountryData[1]/@CountryData[38]" && @CountryData[38] ne "") {
	open (IN, "$MainPath/clans/@CountryData[1]/@CountryData[38]");
	flock (IN, 1);
	my @AllyTemp = <IN>;
	close (IN);
	&chopper (@AllyTemp);

	$AllyMessage = qq!<table width=60% border=0><TR><TD>$Font<B><font size=-1>Message From Sub-Faction Leader</b></td></TR><TR><TD>$Font@AllyTemp[4]</TD></TR></Table><BR><BR>!;
}

	if (@CountryData[40] < 193) {$ProtMess = qq!$Font You have <B>@{[193-@CountryData[40]]}</b> turns of protection</b> left.!;}
	if (-e "armageddon.now") {$ProtMess .= qq!<BR><font size=+1><B>Welcome to Armageddon</b></font><BR><BR>!;}


print "Content-type: text/html\n\n";

&StatLine or print "Error ($!)";
print qq—
<html>
<head><title>ASH - Main Menu</title></head>
<body bgcolor=black text=white background="$BGPic" alink=$FColourOne link=$FColourOne vlink=$FColourOne><font face=arial size=-1>
<BR><BR>
<a name=top>
<center>

$BannerCode

</center><table border=0 width=100% cellspacing=0>

$LinkLine

</table><center>$MessLine</center>
<center><BR>$AllyMessage$ProtMess<BR><BR>
<table width=80% width=1 cellspacing=2 cellpadding=2 border=0>
<tr><TD colspan=8>$Font<font color="white"><B><font size=+1>$Nuser (#$User)</B></TD></TR>
<TR><TD>$NewFont1 Affiliation</TD><TD colspan=7>$NewFont2 $Side{@CountryData[1]}</TD></TR>

<TR><TD>$NewFont1 Population</TD><TD>$NewFont2 @{[&Space($Population)]}</TD> <tD>$NewFont1 Housing Complexes </TD><TD>$NewFont2 $Res</TD>			<TD>$NewFont1 Covert Operatves</TD><TD>$NewFont2 $Spy</TD></TR>
<TR><TD>$NewFont1 Tax Rate</TD><TD>$NewFont2 $Tax%</TD>		<tD>$NewFont1 Research Facility</TD><TD>$NewFont2 $Com</TD>		<TD>$NewFont1 Counter-Int Officers</TD><TD>$NewFont2 $CSpy</TD></TR>
<TR><TD>$NewFont1 Military Funding</TD><TD>$NewFont2 $War%</TD>	<TD>$NewFont1 Production Centre</TD><TD>$NewFont2 $Ind</TD>		<TD>$NewFont1 Commandos</TD><TD>$NewFont2 $Commando</Td></TR>
<TR><TD>$NewFont1 Money</TD><TD>$NewFont2 \$@{[&Space(@CountryData[3])]}</TD>	<TD>$NewFont1 Government Installation</TD><TD>$NewFont2 $Gov</TD>	<TD>$NewFont1 ELITE</TD><TD>$NewFont2 $Spec</TD></TR>
<TR><TD>$NewFont1 Networth</TD><TD>$NewFont2  @{[&Space(@CountryData[32]+250)]}</TD><TD>$NewFont1 Construction Station</TD><TD>$NewFont2 $Con</TD>		</TR>

</table>
<form method=POST action="Runner2.pl?$User&$Pword&01">
<table width=40% cellspacing=0 cellpadding=0>
<TR><TD>$NewFont1 Turns to Run</TD><TD>$Font<input type=text name=turn size=5></TD></TR>
<TR><TD>$NewFont2 Run Turns To Generate Income</TD></TR>
</table><BR><BR>$NewFont1
<input type=submit name=go value="Run Turns">
</form><BR>

<table width=65% border=0>
$Log
</table>
$TurnMessage
</center>—;

