#!/usr/bin/perl

use Fcntl;
use SDBM_File;

#Declare Paths
$MainPath = "/home/bluewand/data/ash";
$Zappa = time();
srand($Zappa);

#Get Form Data
&parse_form;

$data{'cname'} =~ tr/ /_/;
$data{'cname'} = uc($data{'cname'});

tie (%UserHash, "SDBM_File", "$MainPath/hash/Numbers", O_RDWR|O_EXCL, 0644) or print "Content-type: text/html\n\n  Unable to open file ($!)";
$Login  = $UserHash{$data{'cname'}};
untie %UserHash;

if (-e "$MainPath/users/$Login" && $Login ne "") {
	open (IN, "$MainPath/users/$Login");
	flock (IN, 1);
	@CountryData = <IN>;
	&chopper (@CountryData);
	close (IN);
	
	($Lname,$Email,$Pword) = split(/,/, @CountryData[0]);
	#If password matches that on record - login
	if ($data{'pword1'} eq $Pword) {
		#Log In	
		$PWord = int(rand(9)).chr(int(rand(26)) + 65).chr(int(rand(26)) + 65).int(rand(9)).int(rand(9)).int(rand(9)).int(rand(9)).chr(int(rand(26)) + 65).chr(int(rand(26)) + 65).int(rand(9));


		@CountryData[49] = $PWord;
		@CountryData[50] = time();

		open (OUT, ">$MainPath/users/$Login");
		flock (OUT, 2);
		foreach $Item (@CountryData) {
			print OUT "$Item\n";
		}
		close (OUT);

#		if ($Login == 6001) {
#			print "Location: http://www.bluewand.com/cgi-bin/ashv2/Runner2.pl?$Login&$PWord&1\n\n";
#		} else {
			print "Location: http://www.bluewand.com/cgi-bin/ash/Runner2.pl?$Login&$PWord&1\n\n";
#		}
		die;
	} else {	
		#Warn about invalid password
		print "Content-type: text/html\n\n";
		print "<SCRIPT>alert(\"That password does not match the one on record.\");history.back();</SCRIPT>";
		die;
	}	
} elsif ($data{'cname'} ne "") {
	print "Location: http://www.bluewand.com/ash/validate.html\n\n";
	die;
} else {
	#Warn about non-existant country
	print "Content-type: text/html\n\n";
	print "<SCRIPT>alert(\"That country does not exist.\");history.back();</SCRIPT>";
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
