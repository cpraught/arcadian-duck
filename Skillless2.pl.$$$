#!/usr/bin/perl

if ($data{'name'} ne "") {
	$data{'name'} =~ tr/ /_/;
	$data{'name'} =~ tr/,//;
	if ($data{'charter'} ne "" && $data{'history'} ne "") {
		open (IN, "$MainPath/clans/@CountryData[1]");
		flock (IN, 1);
		my $Count == <IN>;
		close (IN);

		if ($Count < 10) {	
			my $i = 0;
			while (-f "$MainPath/clans/@CountryData[1]/$i") {
				$i++;
			}
			$data{'name'} = substr($data{'name'},0, 20);
			open (OUT, ">$MainPath/clans/@CountryData[1]/@CountryData[1].$i") or print "Cannot Open";
			flock (OUT, 2);
			print OUT "$User\n";
			print OUT "1\n";
			print OUT "@{[&dirty($data{'charter'})]}\n";
			print OUT "@{[&dirty($data{'history'})]}\n";
			print OUT "@{[&dirty($data{'message'})]}\n";
			print OUT "$User\n";
			print OUT "$data{'name'}\n";
			close (OUT);
			chmod (0777, "$MainPath/clans/@CountryData[1]/@CountryData[1].$i");

			open (OUT, ">$MainPath/clans/@CountryData[1]");
			flock (OUT, 2);
			print OUT $Count++;
			close (OUT);

			$Message = qq!Your Sub-Faction has been successfully created.!;
			$MFlag = 1;
			@CountryData[38] = $i;
		 } else {
			$Message = qq!There are too many sub-factions.  You must join an existing one.!;
		}
	} else {$Message = qq!You must fill out <B>ALL</b> fields to be accepted!; }
}
print "Content-type: text/html\n\n";
&StatLine;

print qq—
<html>
<head><Title>ASH - Clan Menu</title></HEAD>
<body bgcolor=black text=white background=$BGPic alink=$FColourOne link=$FColourOne vlink=$FColourOne>$Font<BR><BR>
<a name=top>
<center>

$BannerCode

</center><table border=0 width=100% cellspacing=0>



$LinkLine

</table>
<center>
<BR><BR>$Message
—;

if ($MFlag == 0) {
print qq—

<BR><BR>$Font<center><B>WARNING: Sub-Factions that are racist, sexist, or otherwise discriminatory/hurtful will be deleted, and members will be subject to punitive action.</B></center>
<HR size=1 width=98%>
<form METHOD=POST action=Runner2.pl?$User&$Pword&11>
<table width=100% cellspacing=0 cellpadding=0 border=0>
<TR><TD>$NewFont1 Faction Name</TD></TR>
<TR><TD>$NewFont1<center><input type=text name=name maxsize=18 size=20></TD></TR>
<TR><TD>$NewFont1 Message Of The Day</TD></TR>
<TR><TD>$NewFont1<center><textarea name=message rows=5 cols=50 wrap=virtual></textarea></TD></TR>
<TR><TD>$NewFont1 Faction Charter</TD></TR>
<TR><TD>$NewFont1<center><textarea name=charter rows=5 cols=50 wrap=virtual></textarea></TD></TR>
<TR><TD>$NewFont1 Faction History</TD></TR>
<TR><TD>$NewFont1<center><textarea name=history rows=5 cols=50 wrap=virtual></textarea><BR><BR><input type=submit value="  Create Sub-Faction  " name=submit></TD></TR>
</table>
</form>
—;
}

sub dirty {
	foreach $text (@_) {
		$text =~ s/\cM//g;
		$text =~ s/\n\n/<p>/g;
		$text =~ s/\n/<br>/g;
		$text =~ s/&lt;/</g; 
		$text =~ s/&gt;/>/g; 
		$text =~ s/&quot;/"/g;
	}
	return @_;
}
