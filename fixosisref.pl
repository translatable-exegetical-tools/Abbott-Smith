# This Perl script cleans up SBL abbreviations in @osisRef to be in line with OSIS requirements.
open (INF, "abbott-smith.tei.xml");
my @data = <INF>;
close (INF);
open (OUTF, ">abbott-smith.tei.2.xml");

my $line;
foreach $line (@data) {	

	$line =~ s/osisRef="([^"]+)">Gen\.([^\.]+)\.([^<]+)</osisRef="$1">Ge $2:$3</g;
	$line =~ s/osisRef="Exo\.([^"]+)">Exo\.([^\.]+)\.([^<]+)</osisRef="Exod\.$1">Ex $2:$3</g;
	$line =~ s/osisRef="([^"]+)">Lev\.([^\.]+)\.([^<]+)</osisRef="$1">Le $2:$3</g;
	$line =~ s/osisRef="([^"]+)">Num\.([^\.]+)\.([^<]+)</osisRef="$1">Nu $2:$3</g;
	$line =~ s/osisRef="Deu\.([^"]+)">Deu\.([^\.]+)\.([^<]+)</osisRef="Deut\.$1">De $2:$3</g;
	$line =~ s/osisRef="Jos\.([^"]+)">Jos\.([^\.]+)\.([^<]+)</osisRef="Josh\.$1">Jos $2:$3</g;	
	$line =~ s/osisRef="Jdg\.([^"]+)">Jdg\.([^\.]+)\.([^<]+)</osisRef="Judg\.$1">Jg $2:$3</g;
	$line =~ s/osisRef="Rth\.([^"]+)">Rth\.([^\.]+)\.([^<]+)</osisRef="Ruth\.$1">Ru $2:$3</g;
	$line =~ s/osisRef="2Ki\.([^"]+)">2Ki\.([^\.]+)\.([^<]+)</osisRef="2Kgs\.$1">IV Ki $2:$3</g;
	$line =~ s/osisRef="1Ki\.([^"]+)">1Ki\.([^\.]+)\.([^<]+)</osisRef="1Kgs\.$1">III Ki $2:$3</g;
	$line =~ s/osisRef="2Sa\.([^"]+)">2Sa\.([^\.]+)\.([^<]+)</osisRef="2Sam\.$1">II Ki $2:$3</g;
	$line =~ s/osisRef="1Sa\.([^"]+)">1Sa\.([^\.]+)\.([^<]+)</osisRef="1Sam\.$1">I Ki $2:$3</g;
	$line =~ s/osisRef="2Ch\.([^"]+)">2Ch\.([^\.]+)\.([^<]+)</osisRef="2Chr\.$1">II Ch $2:$3</g;
	$line =~ s/osisRef="1Ch\.([^"]+)">1Ch\.([^\.]+)\.([^<]+)</osisRef="1Chr\.$1">I Ch $2:$3</g;
	$line =~ s/osisRef="Ezr\.([^"]+)">Ezr\.([^\.]+)\.([^<]+)</osisRef="Ezra\.$1">II Es $2:$3</g;
	$line =~ s/osisRef="([^"]+)">Neh\.([^\.]+)\.([^<]+)</osisRef="$1">Ne $2:$3</g;
	$line =~ s/osisRef="Est\.([^"]+)">Est\.([^\.]+)\.([^<]+)</osisRef="Esth\.$1">Es $2:$3</g;
	$line =~ s/osisRef="([^"]+)">Job\.([^\.]+)\.([^<]+)</osisRef="$1">Jb $2:$3</g;
	$line =~ s/osisRef="Psa\.([^"]+)">Psa\.([^\.]+)\.([^<]+)</osisRef="Ps\.$1">Ps $2:$3</g;
	$line =~ s/osisRef="Pro\.([^"]+)">Pro\.([^\.]+)\.([^<]+)</osisRef="Prov\.$1">Pr $2:$3</g;
	$line =~ s/osisRef="Ecc\.([^"]+)">Ecc\.([^\.]+)\.([^<]+)</osisRef="Eccl\.$1">Ec $2:$3</g;
	$line =~ s/osisRef="Son\.([^"]+)">Son\.([^\.]+)\.([^<]+)</osisRef="Song\.$1">Ca $2:$3</g;
	$line =~ s/osisRef="([^"]+)">Isa\.([^\.]+)\.([^<]+)</osisRef="$1">Is $2:$3</g;
	$line =~ s/osisRef="([^"]+)">Jer\.([^\.]+)\.([^<]+)</osisRef="$1">Je $2:$3</g;
	$line =~ s/osisRef="([^"]+)">Lam\.([^\.]+)\.([^<]+)</osisRef="$1">La $2:$3</g;
	$line =~ s/osisRef="Eze\.([^"]+)">Eze\.([^\.]+)\.([^<]+)</osisRef="Ezek\.$1">Ez $2:$3</g;
	$line =~ s/osisRef="([^"]+)">Dan\.([^\.]+)\.([^<]+)</osisRef="$1">Da $2:$3</g;
	$line =~ s/osisRef="([^"]+)">Hos\.([^\.]+)\.([^<]+)</osisRef="$1">Ho $2:$3</g;
	$line =~ s/osisRef="Joe\.([^"]+)">Joe\.([^\.]+)\.([^<]+)</osisRef="Joel\.$1">Jl $2:$3</g;
	$line =~ s/osisRef="Amo\.([^"]+)">Amo\.([^\.]+)\.([^<]+)</osisRef="Amos\.$1">Am $2:$3</g;
	$line =~ s/osisRef="Oba\.([^"]+)">Oba\.([^\.]+)\.([^<]+)</osisRef="Obad\.$1">Ob $3</g;
	$line =~ s/osisRef="Joh\.([^"]+)">Joh\.([^\.]+)\.([^<]+)</osisRef="Jonah\.$1">Jh $2:$3</g;
	$line =~ s/osisRef="([^"]+)">Mic\.([^\.]+)\.([^<]+)</osisRef="$1">Mi $2:$3</g;
	$line =~ s/osisRef="([^"]+)">Nah\.([^\.]+)\.([^<]+)</osisRef="$1">Na $2:$3</g;
	$line =~ s/osisRef="([^"]+)">Hab\.([^\.]+)\.([^<]+)</osisRef="$1">Hb $2:$3</g;
	$line =~ s/osisRef="Zep\.([^"]+)">Zep\.([^\.]+)\.([^<]+)</osisRef="Zeph\.$1">Ze $2:$3</g;
	$line =~ s/osisRef="([^"]+)">Hag\.([^\.]+)\.([^<]+)</osisRef="$1">Ha $2:$3</g;
	$line =~ s/osisRef="Zec\.([^"]+)">Zec\.([^\.]+)\.([^<]+)</osisRef="Zech\.$1">Za $2:$3</g;
	$line =~ s/osisRef="([^"]+)">Mal\.([^\.]+)\.([^<]+)</osisRef="$1">Ma $2:$3</g;
	
	$line =~ s/osisRef="4Ma\.([^"]+)">4Ma\.([^\.]+)\.([^<]+)</osisRef="4Macc\.$1">IV Mac $2:$3</g;
	$line =~ s/osisRef="3Ma\.([^"]+)">3Ma\.([^\.]+)\.([^<]+)</osisRef="3Macc\.$1">III Mac $2:$3</g;
	$line =~ s/osisRef="2Ma\.([^"]+)">2Ma\.([^\.]+)\.([^<]+)</osisRef="2Macc\.$1">II Mac $2:$3</g;
	$line =~ s/osisRef="1Ma\.([^"]+)">1Ma\.([^\.]+)\.([^<]+)</osisRef="1Macc\.$1">I Mac $2:$3</g;
	$line =~ s/osisRef="1Es\.([^"]+)">1Es\.([^\.]+)\.([^<]+)</osisRef="1Esd\.$1">I Es $2:$3</g;
	$line =~ s/osisRef="([^"]+)">Tob\.([^\.]+)\.([^<]+)</osisRef="$1">To $2:$3</g;
	$line =~ s/osisRef="([^"]+)">Wis\.([^\.]+)\.([^<]+)</osisRef="$1">Wi $2:$3</g;
	$line =~ s/osisRef="([^"]+)">Sir\.([^\.]+)\.([^<]+)</osisRef="$1">Si $2:$3</g;
	$line =~ s/osisRef="([^"]+)">Bar\.([^\.]+)\.([^<]+)</osisRef="$1">Ba $2:$3</g;
	
	$line =~ s/osisRef="Mat\.([^"]+)">Mat\.([^\.]+)\.([^<]+)</osisRef="Matt\.$1">Mt $2:$3</g;
	$line =~ s/osisRef="Mar\.([^"]+)">Mar\.([^\.]+)\.([^<]+)</osisRef="Mark\.$1">Mk $2:$3</g;
	$line =~ s/osisRef="Luk\.([^"]+)">Luk\.([^\.]+)\.([^<]+)</osisRef="Luke\.$1">Lk $2:$3</g;
	$line =~ s/osisRef="Joh\.([^"]+)">Joh\.([^\.]+)\.([^<]+)</osisRef="John\.$1">Jn $2:$3</g;
	$line =~ s/osisRef="Act\.([^"]+)">Act\.([^\.]+)\.([^<]+)</osisRef="Acts\.$1">Ac $2:$3</g;
	$line =~ s/osisRef="([^"]+)">Rom\.([^\.]+)\.([^<]+)</osisRef="$1">Ro $2:$3</g;
	$line =~ s/osisRef="1Co\.([^"]+)">1Co\.([^\.]+)\.([^<]+)</osisRef="1Cor\.$1">I Co $2:$3</g;
	$line =~ s/osisRef="2Co\.([^"]+)">2Co\.([^\.]+)\.([^<]+)</osisRef="2Cor\.$1">II Co $2:$3</g;
	$line =~ s/osisRef="([^"]+)">Gal\.([^\.]+)\.([^<]+)</osisRef="$1">Ga $2:$3</g;
	$line =~ s/osisRef="([^"]+)">Eph\.([^\.]+)\.([^<]+)</osisRef="$1">Eph $2:$3</g;
	$line =~ s/osisRef="Php\.([^"]+)">Php\.([^\.]+)\.([^<]+)</osisRef="Phil\.$1">Phl $2:$3</g;
	$line =~ s/osisRef="([^"]+)">Col\.([^\.]+)\.([^<]+)</osisRef="$1">Col $2:$3</g;
	$line =~ s/osisRef="1Th\.([^"]+)">1Th\.([^\.]+)\.([^<]+)</osisRef="1Thess\.$1">I Th $2:$3</g;
	$line =~ s/osisRef="2Th\.([^"]+)">2Th\.([^\.]+)\.([^<]+)</osisRef="2Thess\.$1">II Th $2:$3</g;
	$line =~ s/osisRef="1Ti\.([^"]+)">1Ti\.([^\.]+)\.([^<]+)</osisRef="1Tim\.$1">I Ti $2:$3</g;
	$line =~ s/osisRef="2Ti\.([^"]+)">2Ti\.([^\.]+)\.([^<]+)</osisRef="2Tim\.$1">II Ti $2:$3</g;
	$line =~ s/osisRef="Tit\.([^"]+)">Tit\.([^\.]+)\.([^<]+)</osisRef="Titus\.$1">Tit $2:$3</g;
	$line =~ s/osisRef="Phm\.([^"]+)">Phm\.([^\.]+)\.([^<]+)</osisRef="Phlm\.$1">Phm $3</g;
	$line =~ s/osisRef="([^"]+)">Heb\.([^\.]+)\.([^<]+)</osisRef="$1">He $2:$3</g;
	$line =~ s/osisRef="([^"]+)">Jas\.([^\.]+)\.([^<]+)</osisRef="$1">Ja $2:$3</g;
	$line =~ s/osisRef="1Jn\.([^"]+)">1Jn\.([^\.]+)\.([^<]+)</osisRef="1John\.$1">Jn $2:$3</g;
	$line =~ s/osisRef="2Jn\.([^"]+)">2Jn\.([^\.]+)\.([^<]+)</osisRef="2John\.$1">Jn $3</g;
	$line =~ s/osisRef="3Jn\.([^"]+)">3Jn\.([^\.]+)\.([^<]+)</osisRef="3John\.$1">Jn $3</g;
	$line =~ s/osisRef="1Pe\.([^"]+)">1Pe\.([^\.]+)\.([^<]+)</osisRef="1Pet\.$1">I Pe $2:$3</g;
	$line =~ s/osisRef="2Pe\.([^"]+)">2Pe\.([^\.]+)\.([^<]+)</osisRef="2Pet\.$1">II Pe $2:$3</g;
	$line =~ s/osisRef="Jud\.([^"]+)">Jud\.([^\.]+)\.([^<]+)</osisRef="Jude\.$1">Ju $3</g;
	$line =~ s/osisRef="([^"]+)">Rev\.([^\.]+)\.([^<]+)</osisRef="$1">Re $2:$3</g;
		
	$line =~ s/osisRef="([^\.]+)\.(\d+)\.(\d+)-(\d+)"/osisRef="$1\.$2\.$3-$1\.$2\.$4"/g; # Fixes verse ranges

	print OUTF "$line";
}
close (OUTF);
