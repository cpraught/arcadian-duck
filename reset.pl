#!/usr/bin/perl

use Fcntl;
use SDBM_File;

#Declare Paths
($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
$MainPath = "/home/bluewand/data/ash";

&parse_form;

tie (%UserHash, "SDBM_File", "$MainPath/hash/Numbers", O_RDWR|O_EXCL, 0644) or print "Unable to open file ($!)";
$Name2  = $UserHash{uc($data{'cname'})};

delete ($UserHash{uc($data{'cname'})});

untie %UserHash;

open (IN, "$MainPath/users/$Name2") or print "Content-type: text/html\n\n   Cannot open $MainPath/users/$Name2<BR>";
flock (IN, 1);
@CountryData = <IN>;
close (IN);
&chopper(@CountryData);
my @LineZero = split(/,/,@CountryData[0]);

if (@LineZero[2] eq $data{'pword1'}) {
	unlink ("$MainPath/users/$Name2");
	unlink ("$MainPath/messages/$Name2");
	tie (%UserHash, "SDBM_File", "$MainPath/hash/Names", O_RDWR|O_EXCL, 0644) or print "Unable to open file ($!)";
	delete ($UserHash{@CountryData[34]});
	delete ($UserHas{$data{'came'}});
	untie ($UserHash);

	print "Location: http://www.bluewand.com/ashdelete.php\n\n";
	die;
} else {
	print "Location: http://www.bluewand.com/ashdelete2.php\n\n";
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
