#!/usr/bin/perl
print "Content-type: text/html\n\n";

my %Networth, %Winners, %Players;
opendir (DIR, "$MainPath/users") or print "Cannot open user dir $MainPath/users";
my @Users = readdir (DIR);
closedir (DIR);

foreach $Item (@Users) {
	if (-f "$MainPath/users/$Item") {
		open (IN, "$MainPath/users/$Item");
		flock (IN, 1);
		my @Data = <IN>;
		close (IN);
		&chopper(@Data);
	
		$Networth{$Item} = @Data[32]+250;
		$Winners{@Data[1]} += @Data[32]+250;			
		$Players{@Data[1]} ++;
	}
}

my $Count = 0;

$TotalNet = $Winners{1} + $Winners{2} + $Winners{3};

&StatLine;

print qq—
<head><Title>ASH - Game Rankings</title></HEAD>
<body bgcolor=black text=white background=$BGPic alink=$FColourOne link=$FColourOne vlink=$FColourOne>$Font<BR><BR>
<a name=top>
<center>

$BannerCode

</center><table border=0 width=100% cellspacing=0>

$LinkLine
</table><BR><BR><BR><center>

<table border=0 cellspacing=0 width=70%>
<TR><TD>$NewFont1 <font color=green>$Side{1} $Players{1} Members</TD><TD>$NewFont1 <font color=red>$Side{2} $Players{2} Members</TD><TD>$NewFont2 <font color=blue>$Side{3} $Players{3} Members</TD></TR>
<TR><TD colspan=3 valign=bottom>$NewFont1 <center><img src="http://www.bluewand.com/ash/begin.gif" height=24><img src="http://www.bluewand.com/ash/graph1.gif" height=24 width=@{[int($Winners{1}/$TotalNet * 400)]}><img src="http://www.bluewand.com/ash/graph2.gif" width=@{[int($Winners{2}/$TotalNet * 400)]} height=24><img src="http://www.bluewand.com/ash/graph3.gif" width=@{[int($Winners{3}/$TotalNet * 400)]} height=24><img src="http://www.bluewand.com/ash/end.gif" height=24></TD></TR>
</table>
<Table width=70% cellspacing=0 border=0>
<TR><TD>$NewFont1 Number</tD><TD>$NewFont1 Rank</TD><TD>$NewFont1 Country Name</TD><TD>$NewFont1 Faction Name</TD><TD>$NewFont1 Networth</TD></TR>
<TR height=3><TD colspan=5><HR width=100% height=1></TD></TR>
—;

	open (OUT, ">$MainPath/Players.lst");
	flock (OUT, 2);
	unless (-e "$MainPath/hash/PRanks") {
		tie (%UserHash, "SDBM_File", "$MainPath/hash/PRanks", O_RDWR|O_EXCL|O_CREAT, 0644);
		$UserHash{""} = 3000;
		untie %UserHash;
	}
	tie (%UserHash, "SDBM_File", "$MainPath/hash/PRanks", O_RDWR|O_EXCL, 0644) or print "Content-type: text/html\n\n   Cannot Open Scoreboard ($!) $MainPath/hash/PRanks<BR>";

	foreach $User3 (sort {$Networth{$b} <=> $Networth{$a}} keys %Networth) {
		$Count++;
		$User2 = $User3;
		$User2 =~ tr/_/ /;
	
		if ($User3 eq $User) {$BTag = "<B><font color=white>";} else {$BTag = "";}
	
		open (IN, "$MainPath/users/$User3") or print "Cannot open user file (2)";
		flock (IN, 1);
		my @Datas = <IN>;
		close (IN);
		&chopper (@Datas);
		
		print qq!<TR><TD>$NewFont2 $BTag $User3</tD><TD>$NewFont2 $BTag $Count</TD><TD>$NewFont2 $BTag@Datas[34]</TD><TD>$NewFont2 $BTag$Side{@Datas[1]}</TD><TD>$NewFont2 $BTag@{[&Space($Networth{$User3})]}</TD></TR>!;
		if ($Count % 10 == 0) {print qq!<TR height=3><TD colspan=5>$Font <center><HR width=80% height=1></TD></TR>!;}
		print OUT "$User3\n";
		$UserHash{$User3} = $Count;
	}
	close (OUT);
	untie %UserHash;

print qq!</table>!;
