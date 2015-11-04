#!/usr/bin/perl

my ($Faction1,$Faction) = split(/&/, $ENV{QUERY_STRING});
$MainPath = "/home/admin/ash";

print "Content-type: text/html\n\n";

open (IN, "$MainPath/clans/$Faction1/$Faction");
flock (IN, 1);
@FactionData = <IN>;
close (IN);

&chopper (@FactionData);

print qq!
<html>
<script>window.open("http://www.bluewand.com/cgi-bin/ash/ViewFaction2.pl?$Faction1&$Faction", "VoteWindow","width=500,height=450");history.back();</script>
</html>
!;



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


