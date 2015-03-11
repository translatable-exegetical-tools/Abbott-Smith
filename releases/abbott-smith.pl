open (INF, "../abbott-smith.tei.xml");
my @data = <INF>;
close (INF);
open (OUTF, ">abbott-smith.tei-current.xml");

my $line;
foreach $line (@data) {	

	# Why is this here?  
	$line =~ s/<pb/\n<pb/g;
	
	# Remove notes about checked pages (not needed for a release).
	$line =~ s/ <!-- typed="([^"]*)" checked="([^"]*)" -->//g;
	$line =~ s/ <!-- checked="([^"]*)" -->//g;
	
	print OUTF "$line";
}
close (OUTF);
