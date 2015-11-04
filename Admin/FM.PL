#!/usr/bin/perl

$FacCommand{'1'} = "Terran Liberation Army High Command";
$FacCommand{'2'} = "Free Republic High Command";
$FacCommand{'3'} = "Socialist Federation High Command";


$MainPath = "/home/admin/ash";
print "Content-type: text/html\n\n";

&parse_form;

$Pass = 1;
if ($data{'sender'} != 0) {
	if ($data{'sender'} == 1 && crypt($data{'password'},12312) eq qq!12z9IjFaroKfU!) {$Pass = 1;} #FR
	if ($data{'sender'} == 2 && crypt($data{'password'},12312) eq qq!12z9IjFaroKfU!) {$Pass = 1;} #TLA
	if ($data{'sender'} == 3 && crypt($data{'password'},12312) eq qq!12z9IjFaroKfU!) {$Pass = 1;} #SF


	if ($Pass == 1) {

		my $Value = $data{'sender'} * 2000;

		for ($i = $Value + 1; $i < $Value + 1000; $i ++) {

			if ($MissedCount > 100) {$i = 10000;}
			if (-e "$MainPath/users/$i") {
				open (OUT, ">>$MainPath/messages/$i");
				flock (OUT, 2);

			print OUT qq!1|@{[time()]}|$FacCommand{$data{'sender'}},$Value|@{[&dirty($data{'Message'})]}\n!;
	
			close (OUT);

				$MissedCount = 0;
			} else {$MissedCount ++;}

		}
		$MessageValue = $data{'Message'};
	}
}



print qq!
<html>
<body bgcolor=black text=white>
<font face=arial size=-1>

<form method=POST action="http://www.bluewand.com/cgi-bin/ash/Admin/FM.pl"><BR><BR><center>$MessageValue</center><BR><BR>

<select name=sender><option value=0>Choose Faction Command</option><option value=1>Free Republic</option><option value=2>Terran Liberation Army</option><option value=3>Socialist Federation</option></select>
<input type=password size=10 name=pword><input type=submit value="  Send Message  " name=send><BR>
<textarea name=Message rows=10 cols=60 wrap=virtual></textarea><BR>


</form>

!;


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
