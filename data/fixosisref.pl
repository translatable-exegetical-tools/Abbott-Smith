# This Perl script cleans up SBL abbreviations in @osisRef to be in line with OSIS requirements.
open (INF, "abbott-smith.out.xml");
my @data = <INF>;
close (INF);
open (OUTF, ">abbott-smith.out.2.xml");

my $line;
foreach $line (@data) {	

	$line =~ s/osisRef="Ge\./osisRef=\"Gen\./g;
	$line =~ s/osisRef="Ex\./osisRef=\"Exod\./g;
	$line =~ s/osisRef="Le\./osisRef=\"Lev\./g;
	$line =~ s/osisRef="Nu\./osisRef=\"Num\./g;
	$line =~ s/osisRef="De\./osisRef=\"Deut\./g;
	$line =~ s/osisRef="Jos\./osisRef=\"Josh\./g;
	$line =~ s/osisRef="Jg\./osisRef=\"Judg\./g;
	$line =~ s/osisRef="Ru\./osisRef=\"Ruth\./g;
	$line =~ s/osisRef="IV Ki\./osisRef=\"2Kgs\./g;
	$line =~ s/osisRef="III Ki\./osisRef=\"1Kgs\./g;
	$line =~ s/osisRef="II Ki\./osisRef=\"2Sam\./g;
	$line =~ s/osisRef="I Ki\./osisRef=\"1Sam\./g;
	$line =~ s/osisRef="II Ch\./osisRef=\"2Chr\./g;
	$line =~ s/osisRef="I Ch\./osisRef=\"1Chr\./g;
	$line =~ s/osisRef="II Es\./osisRef=\"Ezra\./g;
	$line =~ s/osisRef="Ne\./osisRef=\"Neh\./g;
	$line =~ s/osisRef="Es\./osisRef=\"Esth\./g;
	$line =~ s/osisRef="Jb\./osisRef=\"Job\./g;
	$line =~ s/osisRef="Ps\./osisRef=\"Ps\./g;
	$line =~ s/osisRef="Pr\./osisRef=\"Prov\./g;
	$line =~ s/osisRef="Ec\./osisRef=\"Eccl\./g;
	$line =~ s/osisRef="Ca\./osisRef=\"Song\./g;
	$line =~ s/osisRef="Is\./osisRef=\"Isa\./g;
	$line =~ s/osisRef="Je\./osisRef=\"Jer\./g;
	$line =~ s/osisRef="La\./osisRef=\"Lam\./g;
	$line =~ s/osisRef="Ez\./osisRef=\"Ezek\./g;
	$line =~ s/osisRef="Da\./osisRef=\"Dan\./g;
	$line =~ s/osisRef="Ho\./osisRef=\"Hos\./g;
	$line =~ s/osisRef="Jl\./osisRef=\"Joel\./g;
	$line =~ s/osisRef="Am\./osisRef=\"Amos\./g;
	$line =~ s/osisRef="Ob\./osisRef=\"Obad\./g;
	$line =~ s/osisRef="Jh\./osisRef=\"Jonah\./g;
	$line =~ s/osisRef="Mi\./osisRef=\"Mic\./g;
	$line =~ s/osisRef="Na\./osisRef=\"Nah\./g;
	$line =~ s/osisRef="Hb\./osisRef=\"Hab\./g;
	$line =~ s/osisRef="Ze\./osisRef=\"Zeph\./g;
	$line =~ s/osisRef="Hg\./osisRef=\"Hag\./g;
	$line =~ s/osisRef="Za\./osisRef=\"Zech\./g;
	$line =~ s/osisRef="Ma\./osisRef=\"Mal\./g;
	$line =~ s/osisRef="I Es\./osisRef=\"1Esd\./g;
	$line =~ s/osisRef="To\./osisRef=\"Tob\./g;
	$line =~ s/osisRef="Jth\./osisRef=\"Jdt\./g;
	$line =~ s/osisRef="Wi\./osisRef=\"Wis\./g;
	$line =~ s/osisRef="Si\./osisRef=\"Sir\./g;
	$line =~ s/osisRef="Ba\./osisRef=\"Bar\./g;
	$line =~ s/osisRef="DaSu\./osisRef=\"Sus\./g;
	$line =~ s/osisRef="Da Bel\./osisRef=\"Bel\./g;
	$line =~ s/osisRef="Pr Ma\./osisRef=\"PrMan\./g;
	$line =~ s/osisRef="IV Mac\./osisRef=\"4Macc\./g;
	$line =~ s/osisRef="III Mac\./osisRef=\"3Macc\./g;
	$line =~ s/osisRef="II Mac\./osisRef=\"2Macc\./g;
	$line =~ s/osisRef="I Mac\./osisRef=\"1Macc\./g;

	print OUTF "$line";
}
close (OUTF);
