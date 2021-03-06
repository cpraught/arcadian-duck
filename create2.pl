#!/usr/bin/perl

use Fcntl;
use SDBM_File;

#Declare Paths
($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
$MainPath = "/home/bluewand/data/ash";
$Zappa = time();
srand($Zappa);

opendir (DIR, "$MainPath");
@DirFiles = readdir (DIR);
closedir(DIR);

#Get Form Data
&parse_form;

$data{'uname'} =~ tr/ /_/;
$data{'uname'} = uc($data{'uname'});

if ($data{'cname'} eq "") {
	print "Content-type: text/html\n\n";	
	print "<SCRIPT>alert(\"You must specify a country name.\");history.back();</SCRIPT>";
	die;
}
if ($data{'uname'} eq "") {
	print "Content-type: text/html\n\n";	
	print "<SCRIPT>alert(\"You must specify a user name.\");history.back();</SCRIPT>";
	die;
}
if ($data{'lname'} eq "") {
	print "Content-type: text/html\n\n";	
	print "<SCRIPT>alert(\"You must specify a leader name.\");history.back();</SCRIPT>";
	die;
}
if ($data{'pword1'} ne $data{'pword2'}) {
	print "Content-type: text/html\n\n";	
	print "<SCRIPT>alert(\"Your password and confirmation must match.\");history.back();</SCRIPT>";
	die;
}
if ($data{'email'} eq "") {
	print "Content-type: text/html\n\n";	
	print "<SCRIPT>alert(\"You must specify an email address.\");history.back();</SCRIPT>";
}



#If passwords do not match - warn
if ($data{'pword1'} eq $data{'pword2'}) {
	#If Country Does Not Exist - Create (Else Warn)

	tie (%UserHash2, "SDBM_File", "$MainPath/hash/Names", O_RDWR|O_EXCL, 0766) or print "Content-type: text/html\n\n $MainPath/hash/Names ($!)<BR>";
	if ( ($UserHash2{$data{'uname'}} != 1) && ($UserHash2{$data{'cname'}} != 1) ) {$Flag = 1;}
	untie (%UserHash2);

	if ($Flag == 1) {
		#Check if Faction has been declared properly
		if ($data{'alignment'} 	>= 0 && $data{'alignment'} <= 3) {
			if (length($data{'cname'}) > 20) {$data{'cname'} = substr($data{'cname'},0,20);}

			&FindAlignment;

			$User = $data{'uname'};
			$IP = $ENV{'REMOTE_ADDR'};
#			require ("IPLog.pl");
			#If faction is 'auto' - set faction

			&EmailAuthIt;

			open (OUT, ">$MainPath/preusers/$authcode");
			flock (OUT, 2);
			print OUT "$data{'lname'},$data{'email'},$data{'pword1'}\n";
			print OUT "$data{'alignment'}\n";
			print OUT "10,50\n";
			print OUT "1200\n";
			print OUT "2\n";
			print OUT "0\n";
			print OUT "0\n";
			print OUT "0\n";
			print OUT "0\n";
			print OUT "0\n";
			print OUT "0\n";
			print OUT "0\n";
			print OUT "0,0\n";
			print OUT "0,0\n";
			print OUT "0,0\n";
			print OUT "0,0\n";
			print OUT "0,0\n";
			print OUT "0,0\n";
			print OUT "0,0\n";
			print OUT "80\n";
			print OUT "None,None\n";
			print OUT "None,None\n";
			print OUT "None,None\n";
			print OUT "None,None\n";	
			print OUT "None,None,None,None,None,None,None\n";
			print OUT "None,None,None,None,None,None,None\n";
			print OUT "None,None,None,None,None,None,None\n";
			print OUT "None,None,None,None,None,None,None\n";
			print OUT "None,None,None,None,None,None,None\n";
			print OUT "30\n";
			print OUT "$yday.$hour\n";
			print OUT "100\n";
			print OUT "0\n";
			print OUT "0\n";
			print OUT "$data{'cname'}\n";
			print OUT "$data{'uname'}\n";
			close (OUT);
			chmod (0777, "$MainPath/preusers/$authcode");

			#Call success page
			print "Location: http://www.bluewand.com/pages/ash/ashfinished.php\n\n";		
		} else {
			#Warn about improper faction alignment
			print "Content-type: text/html\n\n";
			print "<SCRIPT>alert(\"You have not selected a proper alignment. $data{'alignment'}\");history.back();</SCRIPT>";      	
		}	
	} else {
		#Warn about country already existing
		print "Content-type: text/html\n\n";
		print "<SCRIPT>alert(\"Your User name and/or Country name are invalid.  Please reselect and try again.\");history.back();</SCRIPT>";	
	}
} else {
	#Warn about passwords not matching
	print "Content-type: text/html\n\n";	
	print "<SCRIPT>alert(\"The confirmation and password do not match.\");history.back();</SCRIPT>";
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

sub FindAlignment
{ 
	my $PassAlign = 0;
	my $Val = 1;
	while ($Val < 4) {
		open (IN, "$MainPath/$Val");
		flock (IN, 1);
		@Numbers[$Val - 1] = <IN>;
		close (IN);
		$Total += @Numbers[$Val - 1];
		$Val ++;
	}

	$Total ++;
	unless (@Numbers[0] / $Total > 0.35) {@Go[1] = 1; $Small = 1;}
	unless (@Numbers[1] / $Total > 0.35) {@Go[2] = 1; if (@Numbers[1] < @Numbers[0]) {$Small = 2;}}
	unless (@Numbers[2] / $Total > 0.35) {@Go[3] = 1; if (@Numbers[2] < @Numbers[0] && @Numbers[2] < @Numbers[1]) {$Small = 3;}}


	if (@Go[$data{'alignment'}] == 1 && $data{'alignment'} > 0) {
		$PassAlign = 1;
	} elsif (@Go[$data{'alignment'}] != 1 && $data{'alignment'} > 0) {
		print "Content-type: text/html\n\n";
		print "<SCRIPT>alert(\"The faction you have selected is too full.\");history.back();</SCRIPT>";
		die;
	}



	while ($PassAlign < 1) {
		if ($data{'alignment'} == 0) {$data{'alignment'} = int(rand(2)); $RanVal = 1;}

		if (@Go[$data{'alignment'}] == 1 && $RanVal == 1) {
			$PassAlign = 1;
		}

		$Counter ++;
		if ($Counter > 3) {$PassAlign = 2; $data{'alignment'} = $Small;}
	}
}

sub EmailAuthIt {

	
	$data{'email'} =~ tr/ /_/;
	$data{'email'} =~ tr/%,://;
	srand();

	$authcode = int(rand(9)).chr(int(rand(26)) + 65).chr(int(rand(26)) + 65).int(rand(9)).int(rand(9)).int(rand(9)).int(rand(9)).chr(int(rand(26)) + 65).chr(int(rand(26)) + 65).int(rand(9));

	open(MAIL, "|/usr/sbin/sendmail $data{'email'}") or print "Content-type: text/html\n\n Sorry could not run mail program.";
	print MAIL "Reply-to: verification\@bluewand.com\n";
	print MAIL "From: A.S.H. E-mail Auth-Verification <chris\@bluewand.com.com>\n";
	print MAIL "Subject: E-Mail Verification\n\n";
	print MAIL "A.S.H.:\n";
	$data{'handle'} =~tr/_/ /;
	print MAIL "This is the authorization code for $data{'cname'}:\n";
	print MAIL $authcode."\n";
	print MAIL "Please save this code for future reference.  If you experience problems, it may be needed.";
	print MAIL "Treat your authorization code as you would your password.  Do not give it out to anyone.  The Bluewand ";
	print MAIL "Entertainment team will never ask you for your password, and has a special page setup for submitting your authorization code.  ";
	print MAIL "This page is located on the Bluewand server, will be used as necessary to submit your authorization code for validation purposes.\n\n";
	print MAIL "http://www.bluewand.com\n";

close(MAIL);
}
