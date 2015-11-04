#!/usr/bin/perl
print "Content-type: text/html\n\n";

opendir (DIR, "$MainPath/users");
@Users = readdir (DIR);
closedir (DIR);

if (-e "$MainPath/clans/@CountryData[1]/@CountryData[38]" && @CountryData[38] ne "") {
	open (IN, "$MainPath/clans/@CountryData[1]/@CountryData[38]");
	flock (IN, 1);
	my @AllyTemp = <IN>;
	close (IN);
	&chopper (@AllyTemp);
	if ($User eq @AllyTemp[0]) {
		if ($data{'secret'} == 1231) {
			@AllyTemp[3] = &dirty($data{'history'});
			@AllyTemp[2] = &dirty($data{'charter'});	
			@AllyTemp[4] = &dirty($data{'message'});	
			@AllyTemp[7] = qq!$data{'w1'},$data{'w2'}!;
			@AllyTemp[8] = qq!$data{'f1'},$data{'f2'}!;

			open (OUT, ">$MainPath/clans/@CountryData[1]/@CountryData[38]");
			flock (OUT, 2);
			foreach $Item (@AllyTemp) {
				print OUT "$Item\n";
			}
			close (OUT);
		}
	}
}

($C[0], $C2[0]) = split (/,/, @CountryData[20]);
($C[1], $C2[1]) = split (/,/, @CountryData[21]);
($C[2], $C2[2]) = split (/,/, @CountryData[22]);
($C[3], $C2[3]) = split (/,/, @CountryData[23]);

#Secure Data
for (my $Counter=0; $Counter < 4; $Counter++) {
	$C[$Counter] =~ s/\D//g;
	$data{$Counter} =~ s/\D//g;
}


if (-e "$MainPath/users/$data{1}" && $data{1} > 1000) { $C[0] = $data{"1"}; $C2[0] = $data{"1b"};}
if (-e "$MainPath/users/$data{2}" && $data{2} > 1000) { $C[1] = $data{"2"}; $C2[1] = $data{"2b"};}
if (-e "$MainPath/users/$data{3}" && $data{3} > 1000) { $C[2] = $data{"3"}; $C2[2] = $data{"3b"};}
if (-e "$MainPath/users/$data{4}" && $data{4} > 1000) { $C[3] = $data{"4"}; $C2[3] = $data{"4b"};}

for ($Counter=0; $Counter < 4; $Counter++) {
	if (-e "$MainPath/users/$C[$Counter]") {
		open (IN, "$MainPath/users/$C[$Counter]");
		flock (IN, 1);
		my @TempData = <IN>;
		close (IN);
		&chopper (@TempData);
		@CName[$Counter] = @TempData[34];
	}
}

for ($Counter = 0; $Counter < 4; $Counter++) {
	if (@C[$Counter] > 1000) {@CountryData[20+$Counter] = qq!@C[$Counter],@C2[$Counter]!;}
}

$Types{'1'} = "Allied";$Types{'2'} = "Friendly";$Types{'3'} = "Hostile";$Types{'4'} = "War";
for (my $i = 0;$i < 4;$i ++) {
	for ($Counter = 0;$Counter < 4; $Counter ++) {
		if ($Counter+1 eq $C2[$i]) {$A = " Selected";} else {$A = "";}
		@List2[$i] .= qq!<option value=@{[$Counter + 1]}$A>$Types{$Counter+1}<\/option>!;
	}
}

@Feel[0] = &Feelings("$C2[0]");
@Feel[1] = &Feelings("$C2[1]");
@Feel[2] = &Feelings("$C2[2]");
@Feel[3] = &Feelings("$C2[3]");

&StatLine;
print qq—
<head><Title>ASH - Diplomacy Menu </title></HEAD>
<body bgcolor=black text=white background=$BGPic alink=$FColourOne link=$FColourOne vlink=$FColourOne>$Font<BR><BR>

<a name=top>
<center>

$BannerCode

</center><table border=0 width=100% cellspacing=0>



$LinkLine</table><BR><BR>
<center>
<form method=POST action="Runner2.pl?$User&$Pword&6">
<table width=70% width=1 cellspacing=0 border=0>
<TR><TD colspan=2>$NewFont1 Nation</TD><TD colspan=2>$NewFont1 Relation Type</TD><TD>$NewFont1 Their Attitude</TD></TR>
<TR><TD>$NewFont2 @CName[0]</TD><TD><input type=text name=1 value="$C[0]" size=4></TD><TD>$NewFont2 $Types{$C2}</TD><TD><select name=1b><option value=0>None</option>@List2[0]</selecT></TD><TD>$NewFont2 $Types{@Feel[0]}</TD></TR>
<TR><TD>$NewFont2 @CName[1]</TD><TD><input type=text name=2 value="$C[1]" size=4></TD><TD>$NewFont2 $Types{$Ca2}</TD><TD><select name=2b><option value=0>None</option>@List2[1]</selecT></TD><TD>$NewFont2 $Types{@Feel[1]}</TD></TR>
<TR><TD>$NewFont2 @CName[2]</TD><TD><input type=text name=3 value="$C[2]" size=4></TD><TD>$NewFont2 $Types{$Cb2}</TD><TD><select name=3b><option value=0>None</option>@List2[2]</selecT></TD><TD>$NewFont2 $Types{@Feel[2]}</TD></TR>
<TR><TD>$NewFont2 @CName[3]</TD><TD><input type=text name=4 value="$C[3]" size=4></TD><TD>$NewFont2 $Types{$Cc2}</TD><TD><select name=4b><option value=0>None</option>@List2[3]</selecT></TD><TD>$NewFont2 $Types{@Feel[3]}</TD></TR>
</table><BR><BR>
<center><input type=submit name=submit value="Apply Changes">
</form>
<BR><hr size=1 width=70%><BR><BR></center>—;

if (-e "$MainPath/clans/@CountryData[1]/@CountryData[1].@CountryData[38]" && @CountryData[38] ne "") {
	open (IN, "$MainPath/clans/@CountryData[1]/@CountryData[1].@CountryData[38]");
	flock (IN, 1);
	my @ClanData = <IN>;
	close (IN);
	&chopper (@ClanData);

	my $Name = @ClanData[6];
	$Name =~ tr/_/ /;
	print qq!<form method=POST action="Runner2.pl?$User&$Pword&6"><center>$Font <B>$Name Page</B><BR><BR></center>!;


	if ($User eq @ClanData[0]) {


		#Message Of The Day  ---------------------------------------
		print qq!<center><table border=0 width=70%><TR><TD><B>$NewFont1 Message Of The Day</b></TD></TR><TR><TD>$NewFont1<textarea name=message cols=50 rows=5 wrap=virtual>@{[&clean(@ClanData[4])]}</textarea></TD></TR></table>!;

		#Clan Members  ---------------------------------------
		print qq!<BR><BR><table border=0 width=70% cellspacing=0 cellpadding=0><caption>$NewFont1 <B>Members</b></caption>!;
		my @Members = split (/,/, @ClanData[5]);
		my $Counter = 0;
		foreach $Item (@Members) {
			if ($Counter == 0) {print qq!<TR>!;}
			$Item =~ s/\D//g;
			open (IN, "$MainPath/users/$Item");
			flock (IN, 1);
			my @MemberData = <IN>;
			close (IN);
			&chopper (@MemberData);
			@MemberData[34] =~ tr/_/ /;
			print qq!<TD>$NewFont2 @MemberData[34] (# $Item <A href="Runner2.pl?$User&$Pword&12&$Item,7" style="color:$FColourOne">Boot</a>)</td>!;
			$Counter ++;
			if ($Counter == 4) {print qq!</TR>!;}		
		}
		print qq!</table><BR><BR>!;

		#Clan Applicants  ---------------------------------------
		print qq!<BR><BR><table border=0 width=70% cellspacing=0 cellpadding=0><caption>$NewFont1 <B>Applicants (Click to Accept)</b></caption>!;
		my @PotMembers = split (/,/, @ClanData[6]);
		$Counter = 0;
		foreach $Item (@PotMembers) {
			if ($Counter == 0) {print qq!<TR>!;}
			$Item =~ s/\D//g;
			open (IN, "$MainPath/users/$Item");
			flock (IN, 1);
			my @MemberData = <IN>;
			close (IN);
			&chopper (@MemberData);

			print qq!<TD>$NewFont2 @MemberData[34] (<A href="Runner2.pl?$User&$Pword&12&$Item,2" style="color:$FColourOne">Accept</a>/<A href="Runner2.pl?$User&$Pword&12&$Item,5" style="color:$FColourOne">Reject</a>)</td>!;
			$Counter ++;

			if ($Counter == 4) {print qq!</TR>!;}
		}
		print qq!</table><BR><BR>!;

		#Clan Charter  ---------------------------------------

		print qq!<center><table border=0 width=70%><TR><TD><B>$NewFont1 Charter</b></TD></TR><TR><TD>$NewFont1<textarea name=charter cols=50 rows=5 wrap=virtual>@{[&clean(@ClanData[2])]}</textarea></TD></TR></table>!;

		#Clan History  ---------------------------------------
		print qq!<center><table border=0 width=70%><TR><TD><B>$NewFont1 History</b></TD></TR><TR><TD>$NewFont1<textarea name=history cols=50 rows=5 wrap=virtual>@{[&clean(@ClanData[3])]}</textarea></TD></TR></table>!;

		#Clan Relations  ---------------------------------------

		my ($En1,$En2) = split (',', @ClanData[7]);
		my ($Al1,$Al2) = split (',', @ClanData[8]);

		for ($i = 1; $i < 4; $i++) {
			opendir (DIR, "$MainPath/clans/$i");
			@FactionDir = readdir (DIR);
			closedir (DIR);

			foreach $FacItem (@FactionDir) {
				if ($i == @CountryData[1]) {
					if ($FacItem ne @CountryData[39]) {
						if ($FacItem ne "." && $FacItem ne "..") {
							$FacItem2 = $FacItem;
							$FacItem2 =~ tr/_/ /;
							$FacItem2 = substr($FacItem2, 0, 20);
							if ($Al1 eq $FacItem) {$A = "SELECTED";} else {$A = "";}
							if ($Al2 eq $FacItem) {$B = "SELECTED";} else {$B = "";}

							open (IN, "$MainPath/clans/$i/$FacItem");
							flock (IN, 1);
							my @inData = <IN>;
							close (IN);
							&chopper (@inData);

							$StringOfAllies .= qq!<option value="$FacItem" $A>@inData[6]</option>!;
							$StringOfAllies2 .= qq!<option value="$FacItem" $B>@inData[6]</option>!;
						}
					}
				} else {
					if ($FacItem ne "." && $FacItem ne "..") {
						$FacItem2 = $FacItem;
						$FacItem2 =~ tr/_/ /;
						$FacItem2 = substr($FacItem2, 0, 20);
						if ($En1 eq $FacItem) {$A = "SELECTED";} else {$A = "";}
						if ($En2 eq $FacItem) {$B = "SELECTED";} else {$B = "";}

						open (IN, "$MainPath/clans/$i/$FacItem");
						flock (IN, 1);
						my @inData = <IN>;
						close (IN);
						&chopper (@inData);

						$StringOfEnemies .= qq!<option value="$FacItem" $A>@inData[6]</option>!;
						$StringOfEnemies2 .= qq!<option value="$FacItem" $B>@inData[6]</option>!;
					}
				}
			}
		}

		print qq!<BR><BR>
		<table border=0 width=70% cellspacing=0 cellpadding=0>
		  <TR>
		    <TD>$NewFont1 Hostile Status</TD><TD>$NewFont1 Friendly Status</TD>
		  </TR>
		  <TR>
		    <TD>$NewFont2 Enemy 1 - <select name=w1><option value="None">None</option>$StringOfEnemies</select></TD><TD>$NewFont2 Friendly 1 - <select name=f1><option value=0>None</option>$StringOfAllies</select></TD>
		  </TR>
		  <TR>
		    <TD>$NewFont2 Enemy 2 - <select name=w2><option value="None">None</option>$StringOfEnemies2</select></TD><TD>$NewFont2 Friendly 2 - <select name=f2><option value=0>None</option>$StringOfAllies2</select></TD>
		  </TR>
		</table><BR><BR><input type=hidden name=secret value="1231">!;

		print qq!<center><input type=submit value="  Make Changes  " name=submit>!;

	} else {

		#Message Of The Day  ---------------------------------------
		print qq!<table border=0 width=70%><TR><TD><B>$NewFont1 Message Of The Day</b></TD></TR><TR><TD>$NewFont2 @ClanData[4]</TD></TR></table>!;

		#List Members  ---------------------------------------

		print qq!<BR><BR><table border=0 width=70% cellspacing=0 cellpadding=0><caption>$NewFont1 <B>Members</b></caption>!;
		my @Members = split (/,/, @ClanData[5]);
		my $Counter = 0;
		foreach $Item (@Members) {
			if ($Counter == 0) {print qq!<TR>!;}
			$Item =~ s/\D//g;
			open (IN, "$MainPath/users/$Item");
			flock (IN, 1);
			my @MemberData = <IN>;
			close (IN);
			&chopper (@MemberData);
			@MemberData[34] =~ tr/_/ /;
			print qq!<TD>$Font @MemberData[34] (# $Item)</td>!;
			$Counter ++;
			if ($Counter == 4) {print qq!</TR>!;}		
		}
		print qq!</table><BR><BR>!;

		#Clan Charter  ---------------------------------------

		print qq!<BR><BR><table border=0 width=70%><TR><TD><B><hr size=1 width=100%>$NewFont1 Charter</b></TD></TR><TR><TD>$NewFont2 @ClanData[2]</TD></TR></table>!;


		#Clan History  ---------------------------------------

		print qq!<BR><BR><table border=0 width=70%><TR><TD><B><hr size=1 width=100%>$NewFont1 History</b></TD></TR><TR><TD>$NewFont2 @ClanData[3]</TD></TR></table>!;

		#Clan Relations  ---------------------------------------

		@ClanData[7] =~ tr/_/ /;
		@ClanData[8] =~ tr/_/ /;

		my ($En1,$En2) = split (',', @ClanData[7]);
		my ($Al1,$Al2) = split (',', @ClanData[8]);

		print qq!<BR><BR>
		<table border=0 width=70% cellspacing=0 cellpadding=0>
		  <TR>
		    <TD>$NewFont1 Hostile Status</TD><TD>$NewFont1 Friendly Status</TD>
		  </TR>
		  <TR>
		    <TD>$NewFont2 Enemy 1 - <B><font color=red>$En1</TD><TD>$NewFont2 Friendly 1 - <B><font color=blue>$Al1</TD>
		  </TR>
		  <TR>
		    <TD>$NewFont2 Enemy 2 - <B><font color=red>$En2</TD><TD>$NewFont2 Friendly 2 - <B><font color=blue>$Al2</TD>
		  </TR>
		</table><BR><BR>

		<Center><A href="Runner2.pl?$User&$Pword&12&$User,6" style="color:$FColourOne">Click to withdraw from Sub-Faction</a>

		!;



	}

} else {
	if (@CountryData[39] eq "" || !(-e "$MainPath/clans/@CountryData[1]/@CountryData[1].@CountryData[39]")) {
		print qq!$Font Sub-faction Listing!;
		opendir (DIR, "$MainPath/clans/@CountryData[1]") or print "Error Opening Faction List($!)<BR>";
		@SubFac = readdir (DIR);
		closedir (DIR);

		print qq!<table border=0 width=70%><TR><TD>$NewFont1 Sub-Faction Name</TD><TD>$NewFont1 Sub-Faction Founder</TD><TD>$NewFont1 Number of Members</TD><TD></TD></TR>!;
	
		foreach $Item (@SubFac) {
			if (-f "$MainPath/clans/@CountryData[1]/$Item") {
				open (IN, "$MainPath/clans/@CountryData[1]/$Item");
				flock (IN, 1);
				my @ClanInfo = <IN>;
				@MemberCount = split(/,/, @ClanInfo[5]);

				open (IN, "$MainPath/users/@ClanInfo[0]");
				flock (IN, 1);
				my @LeaderData = <IN>;
				close (IN);
				&chopper (@LeaderData);

				my $Temp = @CountryData[34];
				$Temp =~ tr/ /_/;
				my $Item2 = $Item;
				$Item2 =~ tr/_/ /;

				$Members = scalar(@MemberCount);

				if ($Members < 10) {
					print qq!<TR><TD>$NewFont2 $Item2</TD><TD>$NewFont2 @LeaderData[34]</TD><TD>$NewFont2 $Members</TD><TD><a href="Runner2.pl?$User&$Pword&12&$Item,4" alt="Click to apply">$NewFont2 Apply</a></TD><TD><a href="ViewFaction.pl?@CountryData[1]&$Item" alt="Click to View">$NewFont2 View</a></TD></TR>!;
				} else {
					print qq!<TR><TD>$NewFont2 $Item2</TD><TD>$NewFont2 @LeaderData[34]</TD><TD>$NewFont2 $Members</TD><TD>$NewFont2 This Sub-Faction is full</TD><TD><a href="ViewFaction.pl?@CountryData[1]&$Item" alt="Click to View">$NewFont2 View</a></TD></TR>!;
				}
				$Counter++;
			}
		}
		if ($Counter < 1) {
			print qq!<TR><TD colspan=3>$NewFont1 No Sub-Factions Available</TD></TR>!;
		}
		print qq!</table><BR><BR><center><a href="Runner2.pl?$User&$Pword&11" style="color:$FColorOne">Click to Create Sub-Faction</a></center>!;
	} elsif (-e "$MainPath/clans/@CountryData[1]/@CountryData[39]") {
		@CountryData[39] =~ tr/_/ /;
		print qq!<Center>$NewFont1 You have applied to <I><B>@CountryData[39]</b></i><BR><BR>!;
		@CountryData[39] =~ tr/ /_/;		
		print qq!<A href="Runner2.pl?$User&$Pword&12&@CountryData[39],3" style="color:$FColourOne">Click to revoke application</a></center>!;
		@CountryData[39] =~ tr/ /_/;
	}
}

sub Feelings
{
	my $One = @_[0];
	open (IN, "$MainPath/users/$One");
	flock (IN, 1);
	my @InData = <IN>;
	close (IN);
	&chopper(@InData);
	for (my $i = 20;$i <24;$i++) {
		if (@InData[$i] =~ /$User/) {
			my ($a, $b) = split(/,/, (@InData[$i]));
			return $b;
		}
	}
}
