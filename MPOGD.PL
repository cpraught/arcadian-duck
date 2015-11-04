#!/usr/bin/perl

($User,$Pword,$Script,$Misc) = split(/&/,$ENV{QUERY_STRING});
$IP = $ENV{'REMOTE_ADDR'};
$User =~ s/\D//g;

$MainPath = "/home/admin/ash";
unless (-e "$MainPath/users/$User") {
	print "Content-type: text/html\n\n";
	print "<HEAD><title>ASH - Error<\/Title><\/head><body bgcolor=black text=white><BR><BR><font face=arial>Entry Error: 100-00<BR><BR>";
#	if ($User == 4079) {print "$MainPath/users/$User<BR>";}
	die;
}

open (IN, "$MainPath/users/$User");
flock (IN, 1);
@CountryData = <IN>;
close (IN);
&chopper (@CountryData);

unless ( ($Pword eq @CountryData[49]) && (time() - @CountryData[50] < 500) ) {
	print "Content-type: text/html\n\n";
	print "<HEAD><title>ASH - Error<\/Title><\/head><body bgcolor=black text=white><BR><BR>Entry Error: 100-01<BR>";
	die;
} else {
	($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
	if (@CountryData[43] < $yday) {
		@CountryData[29] += 5;
		@CountryData[43] = $yday;
		$Vote = 1;

		open (OUT, ">$MainPath/users/$User");
		flock (OUT, 2);
		foreach $Item (@CountryData) {
			print OUT "$Item\n";
		}
		close (OUT);
	} else {$Vote = 0;}

	if ($Vote == 1) {
print "Content-type: text/html\n\n";
		print qqÍ
<script>window.open("http://www.bluewand.com/ash/vote.html", "VoteWindow","width=490,height=150");</script>
<script>window.open("http://www.mpogd.com/gotm/vote.asp", "MpogdWindow","'toolbar=yes,status=yes,location=yes,scrollbars=yes,resizable=yes,width=600,height=480");history.back();</script>
You need javascript enabled for this to work.
		Í;
	} else {
print "Content-type: text/html\n\n";
print qqÍ<script>window.open("http://www.bluewand.com/ash/novote.html", "VoteWindow","width=490,height=150");history.back();</script>Í;
		die;
	}

}

sub chopper{
	foreach $k(@_){
		chop($k);
	}
}
