#!/usr/bin/perl

$Path = "/home/bluewand/data/ash/preusers";

opendir (DIR, "$Path");
@Items = readdir (DIR);
closedir (DIR);

print "Content-type: text/html\n\n";
foreach $Item (@Items)
{
	open (IN, "$Path/$Item");
	flock (IN, 1);
	@Data = <IN>;
	close (IN);
	@LineOne = split (/,/, @Data[0]);

	if (@LineOne[0] eq "Sorro")
	{
		&EmailAuthIt;
		print "$Item - @LineOne[0] to: @LineOne[1]<BR>";
	}

}


sub EmailAuthIt {

	
	$data{'email'} =~ tr/ /_/;
	$data{'email'} =~ tr/%,://;
	srand();

	open(MAIL, "|/usr/sbin/sendmail @LineOne[1]") or print "Content-type: text/html\n\n $!";
	print MAIL "Reply-to: verification\@bluewand.com\n" or print $!
	print MAIL "From: A.S.H. E-mail Auth-Verification <chris\@bluewand.com>";
	print MAIL "Subject: E-Mail Verification\n\n";
	print MAIL "A.S.H.:\n";
	print MAIL "This is the authorization code for @Data[34]\n";
	print MAIL $Item."\n";
	print MAIL "Please save this code for future reference.  If you experience problems, it may be needed.";
	print MAIL "Treat your authorization code as you would your password.  Do not give it out to anyone.  The Bluewand ";
	print MAIL "Entertainment team will never ask you for your password, and has a special page setup for submitting your authorization code.  ";
	print MAIL "This page is located on the Bluewand server, will be used as necessary to submit your authorization code for validation purposes.\n\n";
	print MAIL "http://www.bluewand.com\n";

	close(MAIL) or print $!;
}
