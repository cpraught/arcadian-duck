#!/usr/bin/perl

print "Content-type: text/html\n\n";


if ($Misc ne "") {$B = $Misc;} else {$B = "";}

if ($data{'target'} ne "none" &&  $data{'target'} ne "")  {
	if ($data{'message'} =~ /\|/) {$Warning = qq!You have attempted to use illegal characters in your message.  Illegal characters include |.  Sorry to cause any inconvenience.<BR>!;} else {
		@SendArray = split (/,/, $data{'target'});
		if (scalar(@SendArray) < 15) { 
			foreach $Sender (@SendArray) {
				$Sender =~ s/\D//g;
				if (-e "$MainPath/users/$Sender") {
					open (OUT, ">>$MainPath/messages/$Sender");
					flock (OUT, 2);
	
					# Type (0 - News / 1 - Message)|Date [time()]|Sender|Content
					print OUT qq!1|@{[time()]}|@CountryData[34],$User|@{[&dirty($data{'message'})]}\n!;
					close (OUT);
				} else {
					$Warning .= qq!You have attempted to send a message to a country (#$Sender) which does not exist.  Please check your numbers and try again.<BR>!;
				}
			}
		} else {
			$Warning .= qq!You have attempted to send a message to too many countries.  Reduce the number of countries you are sending the message to, and try again.!;
		}
	}
}


if (-e "$MainPath/messages/$User") {
	open (IN, "$MainPath/messages/$User");
	flock (IN, 1);
	@Message = <IN>;
	&chopper (@Message);	
	close (IN);	
	
	$Line = 0;
	foreach $Item (@Message) {
		if ($data{$Line} eq "kill") {$Warn = 1;} else {$Warn = 2;push (@NewMessages, "$Item\n");}
		@Mess = split(/\|/, $Item);
		if (@Mess[0] == 1 && $Warn == 2) {
			$Count ++;
			($Sec,$Min,$Hour,$Mday,$Mon,$Year,$Wday,$Yday,$Isdst) = localtime(@Mess[1]);
			$Mon++;
			$Year += 1900;
			if (length($Sec) == 1) {$Sec = "0$Sec"}
			if (length($Min) == 1) {$Min = "0$Min"}
			if (length($Hour) == 1) {$Hour = "0$Hour"}
               	
			my ($Sender1, $Sender2) = split(/,/, @Mess[2]);
			$MesData .= qq!
<tr><TD>$NewFont1 From</TD><TD>$NewFont2 $Sender1 <font size=-2>(#$Sender2)</font></TD><TD>$NewFont1 Time Sent</TD><TD>$NewFont2 $Mon/$Mday/$Year - $Hour:$Min:$Sec</TD></TR>
<TR><TD colspan=6><hr height=1 width=100%<BR>$NewFont2 @Mess[3]<hr height=1 width=100%></TD></TR>
<TR><TD colspan=2>$NewFont1 <A href="Runner2.pl?$User&$Pword&9&$Sender2" style="text-decoration:none;color:$FColorOne">Click to Reply</a></TD><TD>$NewFont1 Delete</TD><TD>$NewFont1 <input type=checkbox name=$Line value=kill></TD></TR>
<TR><TD colspan=6>&nbsp;</TD></TR>			
<TR><TD colspan=6>&nbsp;</TD></TR>!;
		}	
		$Line++;
	}
	unless ($Count < 1) {$MesData .= qq!<TR><TD colspan=6>$Font<input type=submit name=submits value="Delete Messages"></TD></TR>!;}
	open (OUT, ">$MainPath/messages/$User");
	flock (OUT, 2);	
	print OUT @NewMessages;
	close (OUT);
}

&StatLine;
print qq—
<head><Title>ASH - Message Menu</title></HEAD>
<body bgcolor=black text=white background=$BGPic alink=$FColourOne link=$FColourOne vlink=$FColourOne>$Font<BR><BR>
<a name=top>
<center>

$BannerCode

</center><table border=0 width=100% cellspacing=0>

$LinkLine
</table>
<center>
<form method=POST action="Runner2.pl?$User&$Pword&9">
<BR><BR>$Font$Warning<BR><center>

<table width=60% border=0>
<TR><TD>$NewFont1 Message To</TD><TD><input type=text name=target value="$B" size=10 maxsize=4></TD><TD>$NewFont2<input type=submit name=submit value="Send Message"> </TD></TR>
<TR><TD colspan=3>$NewFont1<textarea name=message rows=10 cols=72 wrap=virtual></textarea></TD></TR>
</Table><BR><BR>
</form>
<form method=POST action="Runner2.pl?$User&$Pword&9">
<center><table width=60% border=0 cellspacing=0>
$MesData
</table>
</form>
</body>—;

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
