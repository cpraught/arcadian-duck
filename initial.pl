#!/usr/bin/perl

$Path = "/home/bluewand/data/ash";

print "Content-type: text/html\n\n";

print qq!
<html>
  <body bgcolor=white>
  <font face=arial color=white>

  <table width=70% height=85% border=0>
      <TR>
          <TD valign=middle align=middle>

	<Table border=0 width=598 height=398 cellspacing=0 cellpadding=0 bgcolor=white bordercolor=#B3B5FF>
	<TR><TD valign=top><font face=verdana<BR><BR><div align=justify>
<center>

<BR><img src="http://www.bluewand.com/images/ASHButton2.jpg" border=0><BR><BR>

</center>
<font face=arial size=-1><div align=justify>
The war.... The war has been raging for an eternity.  The armoured boots of
millions have trampled the once-fertile earth into barren nothingness.  The
lands have been scorched by flame, corrupted by death.  All that is old has
been lost.  The once powerful cabal nations which made up the western
hemisphere have been reduced to a squabbling collection of primitive, decaying
city-states.  The East is nothing more than a faded memory, burned into the
minds of the billions by nuclear flames. <BR><BR>

The end of recorded time draws near, as mankind plunges backwards at an
accelerating pace.  Disease runs rampant, plague after plague ending the lives
of countless millions.... And yet, the war rages on, without end in sight.
Every hour, thousands more young men and women are sent to the front, never to
see their familes again.  Factories pour smoke and soot into an already ruined
sky, blocking out the sun for weeks at a time.  Scientists devote their lives
to developing new weapons of destruction, new ways to bring the world to an
end at a faster pace.  In the darkened streets of the city-states, a different
war rages, one not fought by superior numbers, but by technology and skill. The
Can-American ELITE program of the mid 21st century has given birth to a new
breed of soldier, faster, stronger, more powerful than anything before it.
Skilled mercenaries, the remaning ELITEs sell their services to the highest
bidder, waging a war of assassination and sabotage against those who they are
paid to destroy.<BR><BR>

It is into this world which you are born, and it is this world which you must
fight to save.  There is only one way to prevent the destruction of the
planet, and that is through the destruction of the enemy.  Ally yourself under
the banner of one of the remaining Super-Empires, and give hope to
humanity once again.<BR><BR>
<center><a href="http://www.bluewand.com/ash/FactionBackground.html">Faction Descriptions</A><BR><BR>

 <form method=POST action="http://www.bluewand.com/cgi-bin/ash/create.pl">

<table border=0 cellspacing=0 width=80%>
  <TR>
     <TD><font face=verdana size=-1>Country Name</TD>
     <TD><font face=verdana size=-1><input type=text maxsize=20 size=18 name=cname></TD>
  </TR>
  <TR>
     <TD><font face=verdana size=-1>User (login) Name</TD>
     <TD><font face=verdana size=-1><input type=text maxsize=20 size=18 name=uname></TD>
  </TR>
  <TR>
     <TD><font face=verdana size=-1>Leader Name</TD>
     <TD><font face=verdana size=-1><input type=text maxsize=20 size=18 name=lname></TD>
  </TR>
  <TR>
     <TD><font face=verdana size=-1>Alignment</TD>
     <TD><font face=verdana size=-1><select name=alignment><option value=0>Random</option>!;

	$Val = 1;
	while ($Val < 4) {
		open (IN, "$Path/$Val") or print $!;
		flock (IN, 1);
		@Numbers[$Val - 1] = <IN>;
		close (IN);
		$Total += @Numbers[$Val - 1];
		$Val ++;
	}

	$Total ++;
	unless (@Numbers[0] / $Total > 0.35) {print qq!<option value=1>Terran Liberation Army</option>!;}
	unless (@Numbers[1] / $Total > 0.35) {print qq!<option value=2>Free Republic</option>!;}
	unless (@Numbers[2] / $Total > 0.35) {print qq!<option value=3>Socialist Federation</option>!;}

	print "@Numbers<BR>";
	print qq!
	</select></TD>
  </TR>
  <TR>
     <TD><font face=verdana size=-1>Password</TD>
     <TD><font face=verdana size=-1><input type=password maxsize=20 size=18 name=pword1></TD>
  </TR>
  <TR>
     <TD><font face=verdana size=-1>Confirm</TD>
     <TD><font face=verdana size=-1><input type=password maxsize=20 size=18 name=pword2></TD>
  </TR>
  <TR>
     <TD><font face=verdana size=-1>E-mail Address</TD>
     <TD><font face=verdana size=-1><input type=text maxsize=20 size=18 name=email></TD>
  </TR>
</table><BR><BR> <input type=submit name=submit value="Create Account"> </form>

       </TD>
    </tR>
  </table>

	</TD></TR>
	</table>
          </td>
      </TR>
  </table>
  </body>
</html>

!;
