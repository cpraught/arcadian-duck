#!/usr/bin/perl

my ($Alliance, $AcceptValue) = split(/,/, $Misc);
#View Stats

if ($AcceptValue == 1) {


#Accept `Em
} elsif ($AcceptValue == 2) {

	$Alliance =~ s/\D//g;
	open (IN, "$MainPath/users/$Alliance");
	flock (IN, 1);
	my @TempData = <IN>;
	close (IN);

	if (-e "$MainPath/clans/@CountryData[1]/@CountryData[38]" && @TempData[39] eq "@CountryData[38]\n") {
		open (IN, "$MainPath/clans/@CountryData[1]/@CountryData[38]");
		flock (IN, 1);
		my @AllyData = <IN>;
		close (IN);
		&chopper (@AllyData);

		if (@AllyData[0] eq $User) {
			@AllyData[5] .= ",$Alliance";
			my @TempArray = split (/,/, @AllyData[6]);
			foreach $ItemHere (@TempArray) {
				if ($ItemHere ne $Alliance) {
					$NewString .= "$ItemHere,";
				}
			} 
			@AllyData[6] = $NewString;
			open (OUT, ">$MainPath/clans/@CountryData[1]/@CountryData[38]");
			flock (OUT, 2);
			foreach $NewItem (@AllyData) {
				print OUT "$NewItem\n";
			}
			close (OUT);

			@AllyData[10] += @TempData[32];

			@TempData[39] = "\n";
			@TempData[38] = "@CountryData[38]\n";
			open (OUT, ">$MainPath/users/$Alliance");
			flock (OUT, 2);

			foreach $NewItem (@TempData) {
				print OUT "$NewItem";
			}
			close (OUT);

			open (OUT, ">>$MainPath/messages/$Alliance");
			# Type (0 - News / 1 - Message)|Date [time()]|Sender|Content
			@CountryData[38] =~ tr/_/ /;
			print OUT qq!0|@{[time()]}|@CountryData[34],$User|Your application to <B>@CountryData[38]</b> has been accepted.\n!;
			@CountryData[38] =~ tr/ /_/;
			close (OUT);
		}
	}
	print "Location: Runner2.pl?$User&$Pword&6\n\n";

#Stop Applying
} elsif ($AcceptValue == 3) {

	@CountryData[39] =~ tr/ /_/;
	if (-e "$MainPath/clans/@CountryData[1]/@CountryData[39]") {
		open (IN, "$MainPath/clans/@CountryData[1]/@CountryData[39]");
		flock (IN, 1);
		my @AllyData = <IN>;
		close (IN);
		&chopper (@AllyData);

		my @TempArray = split (/,/, @AllyData[6]);
		foreach $ItemHere (@TempArray) {
			if ($ItemHere ne $Alliance) {
				$NewString .= "$ItemHere,";
			}
		}
		@AllyData[6] = $NewString;
		open (OUT, ">$MainPath/clans/@CountryData[1]/@CountryData[39]");
		flock (OUT, 2);
		foreach $NewItem (@AllyData) {
			print OUT "$NewItem\n";
		}
		close (OUT);
		@CountryData[39] = "";
		@CountryData[38] = "";
	}
	print "Location: Runner2.pl?$User&$Pword&6\n\n";


#Apply To
} elsif ($AcceptValue == 4) {
	if (-e "$MainPath/clans/@CountryData[1]/$Alliance") {

		open (IN, "$MainPath/clans/@CountryData[1]/$Alliance");
		flock (IN, 1);
		my @AllyData = <IN>;
		close (IN);
		&chopper (@AllyData);

		if (@AllyData[6] ne "") {@AllyData[6] .= ",";}
		@AllyData[6] .= "$User";
	
		open (OUT, ">$MainPath/clans/@CountryData[1]/$Alliance");
		flock (OUT, 2);
		foreach $NewItem (@AllyData) {
			print OUT "$NewItem\n";
		}
		close (OUT);

		@CountryData[39] = $Alliance;
	}
	print "Location: Runner2.pl?$User&$Pword&6&$Alliance\n\n";

#Drop Applicant
} elsif ($AcceptValue == 5) {
	if (-e "$MainPath/clans/@CountryData[1]/@CountryData[38]") {
		
		open (IN, "$MainPath/clans/@CountryData[1]/@CountryData[38]");
		flock (IN, 1);
		my @AllyData = <IN>;
		close (IN);
		&chopper (@AllyData);

		if (@AllyData[0] eq $User) {
			my @TempArray = split (/,/, @AllyData[6]);

			foreach $ItemHere (@TempArray) {
				if ($ItemHere ne $Alliance) {
					$NewString .= "$ItemHere,";
				}
			}
			@AllyData[6] = $NewString;

			open (OUT, ">$MainPath/clans/@CountryData[1]/@CountryData[38]");
			flock (OUT, 2);
			foreach $NewItem (@AllyData) {
				print OUT "$NewItem\n";
			}
			close (OUT);

			open (IN, "$MainPath/users/$Alliance");
			flock (IN, 1);
			my @TempData = <IN>;
			close (IN);
			@TempData[39] = "\n";
			open (OUT, ">$MainPath/users/$Alliance");
			flock (OUT, 2);
			foreach $NewItem (@TempData) {
				print OUT "$NewItem";
			}
			close (OUT);

			open (OUT, ">>$MainPath/messages/$Alliance");
			# Type (0 - News / 1 - Message)|Date [time()]|Sender|Content
			@CountryData[38] =~ tr/_/ /;
			print OUT qq!0|@{[time()]}|@CountryData[34],$User|Your application to <B>@CountryData[38]</b> has been declined.\n!;
			@CountryData[38] =~ tr/ /_/;
			close (OUT);
		
		}
	}
	print "Location: Runner2.pl?$User&$Pword&6\n\n";

#Quit Faction (Sub)
} elsif ($AcceptValue == 6) {
	$Alliance =~ s/\D//g;
	open (IN, "$MainPath/users/$Alliance");
	flock (IN, 1);
	my @TempData = <IN>;
	close (IN);
	@CountryData[39] =~ tr/ /_/;

	my @AllyData = ();

	if (-e "$MainPath/clans/@CountryData[1]/@CountryData[38]") {

		open (IN, "$MainPath/clans/@CountryData[1]/@CountryData[38]") or print "Cannot find $MainPath/clans/@CountryData[1]/@CountryData[39]<BR>";
		flock (IN, 1);
		@AllyData = <IN>;
		close (IN);
		&chopper (@AllyData);

		if ($User eq @AllyData[0]) {

			my @TempArray = split (/,/, @AllyData[5]);
			foreach $ItemHere (@TempArray) {
				if ($ItemHere ne $Alliance) {
					$NewString .= "$ItemHere,";
				}
			}
			@AllyData[5] = $NewString;
			chop (@AllyData[5]);

			open (OUT, ">$MainPath/clans/@CountryData[1]/@CountryData[38]") or print "Cannot Open $MainPath/clans/@CountryData[1]/@CountryData[38]<BR>";
			flock (OUT, 2);
			foreach $NewItem (@AllyData) {
				print OUT "$NewItem\n";
			}
			close (OUT);
			@TempData[38] = "";

			open (OUT, "$MainPath/users/$Alliance");
			flock (OUT, 2);
			foreach $Item (@TempData) {
				print OUT "$Item\n";
			}
			close (OUT);
		}
	}
	@CountryData[39] =~ tr/ /_/;
	print "Location: Runner2.pl?$User&$Pword&6\n\n";

#Boot From Faction (Sub)
} elsif ($AcceptValue == 7) {
	$Alliance =~ s/\D//g;
	open (IN, "$MainPath/users/$Alliance");
	flock (IN, 1);
	my @TempData = <IN>;
	close (IN);
	@CountryData[39] =~ tr/ /_/;

	my @AllyData = ();
	if (-e "$MainPath/clans/@CountryData[1]/@CountryData[38]") {
		open (IN, "$MainPath/clans/@CountryData[1]/@CountryData[38]") or print "Cannot find $MainPath/clans/@CountryData[1]/@CountryData[39]<BR>";
		flock (IN, 1);
		@AllyData = <IN>;
		close (IN);
		&chopper (@AllyData);

		if (@AllyData[0] eq $User) {
			my @TempArray = split (/,/, @AllyData[5]);
			foreach $ItemHere (@TempArray) {
				if ($ItemHere ne $Alliance) {
					$NewString .= "$ItemHere,";
				}
			}
			@AllyData[5] = $NewString;
			chop (@AllyData[5]);
	
			open (OUT, ">$MainPath/clans/@CountryData[1]/@CountryData[38]") or print "Cannot Open $MainPath/clans/@CountryData[1]/@CountryData[38]<BR>";
			flock (OUT, 2);
			foreach $NewItem (@AllyData) {
				print OUT "$NewItem\n";
			}
			close (OUT);

			open (IN, "$MainPath/users/$Alliance");
			flock (IN, 1);
			my @TempData = <IN>;
			close (IN);

			@TempData[38] = "\n";
			@TempData[39] = "\n";

			open (OUT, ">$MainPath/users/$Alliance");
			flock (OUT, 2);
			foreach $Line (@TempData) {
				print OUT "$Line";
			}
			close (OUT);
			if ($User == $Alliance) {@CountryData[38] = ""; @CountryData[39] = "";}
		}
	}
	print "Location: Runner2.pl?$User&$Pword&6\n\n";
}
