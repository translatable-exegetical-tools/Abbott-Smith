
open (INF, "../abbott-smith.tei.xml");
my @data = <INF>;
close (INF);
open (OUTF, ">abbott-smith.v0.16.xml");

my $line;
foreach $line (@data) {	

	$line =~ s/<pb/\n<pb/g;
	$line =~ s/ <!-- typed="([^"]*)" checked="([^"]*)" -->//g;
	$line =~ s/ <!-- checked="([^"]*)" -->//g;
#	$line =~ s/^\s*([^<|\s])(.+)\n//g;
#	$line =~ s/\s*\n\s*\n\s*/\n/g;
#	$line =~ s/^(;|\+|:|t)\n//g;

	print OUTF "$line";
}
close (OUTF);
