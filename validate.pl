#!/usr/bin/perl

#print "Content-type: text/html\n\n";

use Fcntl;
use SDBM_File;

#Declare Paths
$MainPath = "/home/bluewand/data/ash";
$Zappa = time();
srand($Zappa);

#Get Form Data
&parse_form;

$EPword = $data{'pword'};
$AuthCode = $data{'vcode'};

if (-e "$MainPath/preusers/$AuthCode") {
	open (IN, "$MainPath/preusers/$AuthCode");
	flock (IN, 1);
	@IncomingData = <IN>;
	@CountryData = @IncomingData;
	close (IN);
	&chopper (@CountryData);

	($Lname,$Email,$Pword) = split(/,/, @CountryData[0]);
	if ($EPword eq $Pword) {


		my $Value = (@CountryData[1] * 20000) + 1;
		while (-e "$MainPath/users/$Value") {
			$Value++;  
		}

		if ($Value > 2000) {
			open (IN, "$MainPath/@CountryData[1]");
			flock (IN, 1);
			my $UCount = <IN>;
			close (IN);
			$UCount++;
	
			unless (-e "$MainPath/hash/Numbers") {
				tie (%UserHash, "SDBM_File", "$MainPath/hash/Numbers", O_RDWR|O_EXCL|O_CREAT, 0777);
				$UserHash{""} = 3000;
				untie %UserHash;
			}
			unless (-e "$MainPath/hash/Names") {
				tie (%UserHash, "SDBM_File", "$MainPath/hash/Names", O_RDWR|O_EXCL|O_CREAT, 0777);
				$UserHash{""} = 3000;
				untie %UserHash;
			}

			tie (%UserHash, "SDBM_File", "$MainPath/hash/Numbers", O_RDWR|O_EXCL, 0777) or print "Content-type: text/html\n\n   Cannot tie ($!) $MainPath/hash/Numbers<BR>";
			tie (%UserHash2, "SDBM_File", "$MainPath/hash/Names", O_RDWR|O_EXCL, 0777) or print "Content-type: text/html\n\n   Cannot tie ($!) $MainPath/hash/Names<BR>";

			$UserHash{@CountryData[35]} = $Value or print $!;

			$UserHash2{@CountryData[35]} = 1;
			$UserHash2{@CountryData[34]} = 1;

	
			untie %UserHash;
			untie %UserHash2;

			open (OUT, ">$MainPath/@CountryData[1]");
			flock (OUT, 2);
			print OUT $UCount++;
			close (OUT);

#			open (OUT, ">$MainPath/user/$Value");
#			flock (OUT, 2);
#			print OUT @IncomingData;
#			close (OUT);


			#If password matches that on record - login
			if ($EPword eq $Pword) {
				#Log In	
				$PWord = int(rand(9)).chr(int(rand(26)) + 65).chr(int(rand(26)) + 65).int(rand(9)).int(rand(9)).int(rand(9)).int(rand(9)).chr(int(rand(26)) + 65).chr(int(rand(26)) + 65).int(rand(9));

				@CountryData[49] = $PWord;
				@CountryData[50] = time();
	
				open (OUT, ">$MainPath/users/$Value");
				flock (OUT, 2);
				foreach $Item (@CountryData) {
					print OUT "$Item\n";
				}
				close (OUT);
				chmod (0777, "$MainPath/users/$Value");
	
#				open (OUT, ">$MainPath/user/$Value");
#				flock (OUT, 2);
#				foreach $Item (@CountryData) {
#					print OUT "$Item\n";
#					}
#				close (OUT);

				open (OUT, ">$MainPath/messages/$Value");
				flock (OUT, 2);
				print OUT qq@1|987384984|Admin,0000|Welcome to ASH!<p>If you are an experienced player, or want to jump right in, disregard this message.  If you're new, or want a few helpful hints, keep reading.  <p>Building - what it does<p>Housing Complexes - Generates people<br>Research Facility - New developments<br>Production Centre - Generates money<br>Government Inst   - Efficiency bonuses<br>Construction St.  - Build rate<p>When starting off, build a number of Production Centres so that you'll have income each turn.  <p>Troops - What they do<br>Intel Officer - Spies<br>Counter Intel - Prevents spying<br>Commando      - Attack / Defend<br>ELITE         - Powerful spy / commando<p>Operations - <p>In order to be able to run operations against enemies, you must first research them, which can be done on the research screen.<p>Research - <p>In order to be able to research, you must have at least one Research Facility constructed.  After this is complete, allocate percentages to each category.  (For example, to focus all research on Civil research, put 100 in its box.  For equal research between two different types, put 50 in both boxes.)<p>Diplomacy - <p>Interaction with other players will make or break your country.  On this screen, you can set diplomatic levels with different countries and join or create sub-factions.<p>Ranking - <p>Displays your rank (and sub-faction rank, if applicable.)<p>Messages - <p>Send messages to other players.  Send the same message to up to five countries by seperating their numbers by commas.<p>Quit - <p>Log out of the game.<p>Assassin - <p>Bonus game!  Kill up to 10 diplomats each day for bonuses to your country.\n@;
				close (OUT);
				chmod (0777, "$MainPath/messages/$Value");
	
				unlink ("$MainPath/preusers/$AuthCode");
	
				print "Location: http://www.bluewand.com/cgi-bin/ash/Runner2.pl?$Value&$PWord&1\n\n";
				die;
			}
		}
	} else {	
	print "Content-type: text/html\n\n";
	print qq!<BR><BR><BR><BR><BR><BR><BR><center><font face=arial>The password you have entered is incorrect.<BR><BR>!;
	die;
	}
	} else {
	print "Content-type: text/html\n\n";
	print qq!<BR><BR><BR><BR><BR><BR><BR><center><font face=arial>Your country has already been validated.<BR><BR>!;
	die;


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
