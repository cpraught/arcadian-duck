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
<head><title>ASH - View Faction</title></head>
<body bgcolor=black text=white background="http://www.bluewand.com/picture.gif"><font face=arial size=-1 color="#00EE00">
<BR><BR>
<a name=top>
<div align=justify>
<B><font size=+1 color=008800>Charter</font></B><BR><hr size=1 height=1 width=100%><BR>
@FactionData[2]

<BR><BR><BR><BR><BR><BR>
<B><font size=+1 color=008800>History</font></B><BR><hr size=1 height=1 width=100%><BR>
@FactionData[2]!;



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


