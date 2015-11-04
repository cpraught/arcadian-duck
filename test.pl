#!/usr/bin/perl

use Fcntl;
use SDBM_File;


open (DIR, "/cgi-bin/ash/Runner2.pl") or print $!;
@DirFiles = <DIR> or print $!;
close (DIR) or print $!;

print @DirFiles or print $!;

tie (%hash, 'SDBM_File', "../data/ash/hash/Names", O_RDWR|O_CREAT|O_EXCL, 0666) or print "Content-type: text/html\n\n /data/ash/hash/Names ($!)<BR>";;
$hash{"dog"} = "cat";
untie %hash;

