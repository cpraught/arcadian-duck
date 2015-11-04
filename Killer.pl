#!/usr/bin/perl

$Path = "/home/admin/ash";
print "Content-type: text/html\n\n";

opendir (DIR, "$Path/users");
@Users = readdir (DIR);
closedir (DIR);

foreach $Item (@Users) {
	if (int -M "$Path/users/$Item" >= 7) {
		print "$Path/users/$Item Days Old - ", int -M "$Path/users/$Item", "<BR>";
		unlink ("$Path/users/$Item");
		unlink ("$Path/messages/$Item");
	}
}

