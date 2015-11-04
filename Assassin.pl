#!/usr/bin/perl

use Fcntl;
use SDBM_File;

print "Content-type: text/html\n\n";
&Parse_Form;

#Randomize Seed
srand(time());

#Get Info From Fields
($Account, $Password, $Test, $Garbage) = split (/\?/, $ENV{QUERY_STRING});

if ($data{'account'} ne "") {
	tie (%UserHash, "SDBM_File", "/home/bluewand/data/ash/hash/Numbers", O_RDWR|O_EXCL, 0644) or print "Unable to open file ($!)";
	$Account  = $UserHash{uc($data{'account'})};
#	$Account =~ s/\D//g;
	untie %UserHash;
}

if (defined $data{'pword'}) {$Password = $data{'pword'};}
$Account =~ tr/ /_/;

#Define Links

$AssassinLink = qq!http://www.bluewand.com/cgi-bin/ash/Assassin.pl!;
$Font = qq!<font face=verdana size=-1>!;
$ASHPath = "/home/bluewand/data/ash/users";
#Check if password & account are entered
if (defined $Account) {
	if (-e "$ASHPath/$Account") {

		open (IN, "$ASHPath/$Account");
		flock (IN, 1);
		@CountryData = <IN>;
		close (IN);
		&chopper (@CountryData);
		($Blah, $Blah, $RPword) = split(/,/, @CountryData[0]);
		if ($Password eq $RPword) {
			($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);


			if (@CountryData[37] < $yday) {@CountryData[36] = 0;}
			if (@CountryData[36] < 10) {

				@CountryData[37] = $yday;
				my ($Vertical,$Horizontal) = split (/,/, @CountryData[35]);
				unless (@CountryData[35] =~ /(\d)+,(\d)+/) {$Vertical = int(rand(520))+1;$Horizontal =int(rand(432))+1;}
				@CountryData[35] = qq!$Vertical,$Horizontal!;

				my ($PVertical, $PHorizontal) = split (/,/, $Garbage);
				if ( ($PVertical <= $Vertical + 5 && $PVertical >= $Vertical) && ($PHorizontal <= $Horizontal + 5 && $PHorizontal >= $Horizontal) ) {
					$Var1 = int(rand(520) + 1);
					$Var2 = int(rand(432) + 1);
					@CountryData[35] = "$Var1,$Var2";
					$RandomNum = int(rand(6)) + 1;
				} else {
					$RandomNum = -1;
				}
				if ($RandomNum == -1 && $Test == 1) {
					if ($PHorizontal > $Horizontal + 5) {$DisplayMessage = qq!Up and !;}
					elsif ($PHorizontal < $Horizontal) {$DisplayMessage = qq!Down and !;}
					else {$DisplayMessage = qq!Vertical is good, and !;}

					if ($PVertical > $Vertical + 5) {$DisplayMessage .= qq!left.<BR><BR>!;}
					if ($PVertical < $Vertical) {$DisplayMessage .= qq!right.<BR><BR>!;}
					if ($PVertical <= $Vertical + 5 && $PVertical >= $Vertical) {$DisplayMessage .= qq!horizontal is good.<BR><BR>!;}
		
#					if ($Account == 6001) {print "$Vertical, $Horizontal<BR>";}
				}
				if ($RandomNum == 1 && $Test == 1) {
					$DisplayMessage = qq!You have hit your target.   Bounty recieved:  <B>!;
					@CountryData[36] ++;
					$RP = int(rand(4)) + 1;
					if ($RP == 1) {@CountryData[4] += 20;  $DisplayMessage .= qq!20 Housing Complexes</b><BR><BR>!;}
					if ($RP == 2) {@CountryData[5] += 20;  $DisplayMessage .= qq!20 Research Facilities</b><BR><BR>!;}
					if ($RP == 3) {@CountryData[6] += 20;  $DisplayMessage .= qq!20 Production Centres</b><BR><BR>!;}
					if ($RP == 4) {@CountryData[7] += 20;  $DisplayMessage .= qq!20 Government Installations</b><BR><BR>!;}
					if ($RP == 5) {@CountryData[8] += 20;  $DisplayMessage .= qq!20 Construction Stations</b><BR><BR>!;}		
				}
				if ($RandomNum == 2 && $Test == 1) {
					$DisplayMessage = qq!<B><BR><BR>You have hit your target.   Bounty recieved:  <BR><BR>!;
					@CountryData[36] ++;
					$RP = int(rand(4)) + 1;
					if ($RP == 1) {@CountryData[9] += 5;  $DisplayMessage .= qq!Five spies</b><BR><BR>!;}
					if ($RP == 2) {@CountryData[10] += 5;  $DisplayMessage .= qq!Five counter-spies</b><BR><BR>!;}
					if ($RP == 3) {@CountryData[9] += 10;  $DisplayMessage .= qq!Ten spies</b><BR><BR>!;}
					if ($RP == 4) {@CountryData[10] += 10;  $DisplayMessage .= qq!Ten counter-spies</b><BR><BR>!;}
					if ($RP == 5) {@CountryData[9] += 10; @CountryData[10] += 10;  $DisplayMessage .= qq!Ten spies and ten counter-spies</b><BR><BR>!;}
				}
				if ($RandomNum == 3 && $Test == 1) {
					$DisplayMessage = qq!<B><BR><BR>You have hit your target.   Bounty recieved:<BR><BR>!;
					@CountryData[36] ++;
					$RP = int(rand(4)) + 1;
					if ($RP == 1) {@CountryData[11] ++;  $DisplayMessage .= qq!One Commando</b><BR><BR>!;}
					if ($RP == 2) {@CountryData[11] += 2;  $DisplayMessage .= qq!Two Commandos</b><BR><BR>!;}
					if ($RP == 3) {@CountryData[11] += 3;  $DisplayMessage .= qq!Three Commandos</b><BR><BR>!;}
					if ($RP == 4) {@CountryData[11] += 4;  $DisplayMessage .= qq!Four Commandos</b><BR><BR>!;}
					if ($RP == 5) {@CountryData[11] += 5;  $DisplayMessage .= qq!Five Commandos</b><BR><BR>!;}
				}
				if ($RandomNum == 4 && $Test == 1) {
					$DisplayMessage = qq!<B><BR><BR>You have hit your target.   Bounty recieved: <BR><BR>!;
					@CountryData[36] ++;
					$RP = int(rand(4)) + 1;
					if ($RP == 1) {@CountryData[29] ++;  $DisplayMessage .= qq!One turn</b><BR><BR>!;}
					if ($RP == 2) {@CountryData[29] += 2;  $DisplayMessage .= qq!Two turns</b><BR><BR>!;}
					if ($RP == 3) {@CountryData[29] += 3;  $DisplayMessage .= qq!Three turns</b><BR><BR>!;}
					if ($RP == 4) {@CountryData[29] += 4;  $DisplayMessage .= qq!Four turns</b><BR><BR>!;}
					if ($RP == 5) {@CountryData[29] += 5;  $DisplayMessage .= qq!Five turns</b><BR><BR>!;}
				}
				if ($RandomNum == 5 && $Test == 1) {
					$DisplayMessage = qq!<B><BR><BR>You have hit your target.   Bounty recieved:  <BR><BR>!;
					@CountryData[36] ++;
					$RP = int(rand(4)) + 1;
					if ($RP == 1) {@CountryData[3] += 10000;  $DisplayMessage .= qq!\$10 000</b><BR><BR>!;}
					if ($RP == 2) {@CountryData[3] += 20000;  $DisplayMessage .= qq!\$20 000</b><BR><BR>!;}
					if ($RP == 3) {@CountryData[3] += 30000;  $DisplayMessage .= qq!\$30 000</b><BR><BR>!;}
					if ($RP == 4) {@CountryData[3] += 40000;  $DisplayMessage .= qq!\$40 000</b><BR><BR>!;}
					if ($RP == 5) {@CountryData[3] += 50000;  $DisplayMessage .= qq!\$50 000</b><BR><BR>!;}
				}
				if ($RandomNum == 6 && $Test == 1) {
					$DisplayMessage = qq!<B><BR><BR>You have hit your target.   Bounty recieved: <BR><BR>!;
					@CountryData[36] ++;
					$RP = int(rand(6)) + 1;
					if ($RP == 1) {@CountryData[12] += 100;  $DisplayMessage .= qq!100 Civil points</b><BR><BR>!;}
					if ($RP == 2) {@CountryData[13] += 100;  $DisplayMessage .= qq!100 Weaponry points</b><BR><BR>!;}
					if ($RP == 3) {@CountryData[14] += 100;  $DisplayMessage .= qq!100 Armour points</b><BR><BR>!;}
					if ($RP == 4) {@CountryData[15] += 100;  $DisplayMessage .= qq!100 Tactical points</b><BR><BR>!;}
					if ($RP == 5) {@CountryData[16] += 100;  $DisplayMessage .= qq!100 Covert points</b><BR><BR>!;}
					if ($RP == 6) {@CountryData[17] += 100;  $DisplayMessage .= qq!100 Spec Ops points</b><BR><BR>!;}
					if ($RP == 7) {@CountryData[18] += 100;  $DisplayMessage .= qq!100 Military points</b><BR><BR>!;}
				}	
			} else {
				$DisplayMessage = qq!<B><BR><BR>You have slain all available officials.  Try again tomorrow for more rewards.</b><BR><BR>!;
			}

			#Modify User File
			$Account =~ s/\D//g;
			open (OUT, ">$ASHPath/$Account") or $DisplayMessage = qqÄHaving trouble writing file. ($!)<BR>Ä;
			flock (OUT, 2);
			foreach $Item (@CountryData) {
				print OUT "$Item\n";
			}
			close (OUT);

		} else {
			$DisplayMessage = qq!<B><BR><BR>Invalid Password.</b><BR><BR>!;
		}
	} else {$DisplayMessage = qq!I'm sorry, the account $ASHPath/$Account does not exist<BR>!;}

print qqÑ
<html><head><title>ASH - Assassin Range</title></head>
<body bgcolor=black text=white>$Font<center>
<img src="../../ash/Logo2.jpg" border=0><BR><hr size=1 width=98%>

Find and assassinate the diplomat and other officials to reap rewards for your ASH country.<BR><BR>

$DisplayMessage<BR>

<center><a href="Assassin.pl?$Account?$Password?1"><img src=http://www.bluewand.com/ash/Target.jpg ISMAP border=0></a><BR>
</form>

<BR><BR><i>Copyright 2000-2001 Bluewand Entertainment</I><BR><BR><CEnter></center><BR>

</form>

</body></html>
Ñ;

} else {
print qqÑ
<html><head><title>ASH - Assassin Range -$Account-</title></head>
<body bgcolor=black text=white>$Font<center>

<img src="http://www.bluewand.com/ash/FinalLogo.gif" border=0><BR><hr size=1 width=98%>
<BR><BR>
<table width=60% border=0>
<TR><TD>$Font<B>Briefing:</b><BR>Welcome to ASH Assassin.  Somewhere in the building are scattered several diplomats and other high-level enemy officials.  Eliminate them and recieve bounties for your ASH country.<BR><BR></TD></TR>
</table><BR>

<form action=$AssassinLink method=POST><BR>


<Table width=60% border=0>
<TR><TD>$Font User Name:<BR><input type=text name=account value=$Account></TD><TD>$Font  Password:<BR><input type=password name=pword value=$Password></TD><TR>
</table><BR><BR><BR>
<input type=submit value="Log In To Assassin" name=target><BR><BR><BR><BR><i>Copyright 2000-2001 BlueWand Entertainment</I><BR><CEnter><BR>
</font>Ñ;


}

sub Parse_Form {

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
