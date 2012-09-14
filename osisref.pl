# This Perl script adds <ref> elements to Scripture references once they have been cleaned up.
open (INF, "in.xml");
my @data = <INF>;
close (INF);
open (OUTF, ">temp1.xml");

my $line;
foreach $line (@data) {	

	$line =~ s/ Ge (\d+):(\d+)/ <ref osisRef=\"Gen\.$1\.$2\">Ge $1:$2<\/ref>/g;
	$line =~ s/ Ex (\d+):(\d+)/ <ref osisRef=\"Exod\.$1\.$2\">Ex $1:$2<\/ref>/g;
	$line =~ s/ Le (\d+):(\d+)/ <ref osisRef=\"Lev\.$1\.$2\">Le $1:$2<\/ref>/g;
	$line =~ s/ Nu (\d+):(\d+)/ <ref osisRef=\"Num\.$1\.$2\">Nu $1:$2<\/ref>/g;
	$line =~ s/ De (\d+):(\d+)/ <ref osisRef=\"Deut\.$1\.$2\">De $1:$2<\/ref>/g;
	$line =~ s/ Jos (\d+):(\d+)/ <ref osisRef=\"Josh\.$1\.$2\">Jos $1:$2<\/ref>/g;
	$line =~ s/ Jg (\d+):(\d+)/ <ref osisRef=\"Judg\.$1\.$2\">Jg $1:$2<\/ref>/g;
	$line =~ s/ Ru (\d+):(\d+)/ <ref osisRef=\"Ruth\.$1\.$2\">Ru $1:$2<\/ref>/g;
	$line =~ s/ IV Ki (\d+):(\d+)/ <ref osisRef=\"2Kgs\.$1\.$2\">IV Ki $1:$2<\/ref>/g;
	$line =~ s/ III Ki (\d+):(\d+)/ <ref osisRef=\"1Kgs\.$1\.$2\">III Ki $1:$2<\/ref>/g;
	$line =~ s/ II Ki (\d+):(\d+)/ <ref osisRef=\"2Sam\.$1\.$2\">II Ki $1:$2<\/ref>/g;
	$line =~ s/ I Ki (\d+):(\d+)/ <ref osisRef=\"1Sam\.$1\.$2\">I Ki $1:$2<\/ref>/g;
	$line =~ s/ II Ch (\d+):(\d+)/ <ref osisRef=\"2Chr\.$1\.$2\">II Ch $1:$2<\/ref>/g;
	$line =~ s/ I Ch (\d+):(\d+)/ <ref osisRef=\"1Chr\.$1\.$2\">I Ch $1:$2<\/ref>/g;
	$line =~ s/ II Es (\d+):(\d+)/ <ref osisRef=\"Ezra\.$1\.$2\">II Es $1:$2<\/ref>/g;
	$line =~ s/ Ne (\d+):(\d+)/ <ref osisRef=\"Neh\.$1\.$2\">Ne $1:$2<\/ref>/g;
	$line =~ s/ Es (\d+):(\d+)/ <ref osisRef=\"Esth\.$1\.$2\">Es $1:$2<\/ref>/g;
	$line =~ s/ Jb (\d+):(\d+)/ <ref osisRef=\"Job\.$1\.$2\">Jb $1:$2<\/ref>/g;
	$line =~ s/ Ps (\d+):(\d+)/ <ref osisRef=\"Ps\.$1\.$2\">Ps $1:$2<\/ref>/g;
	$line =~ s/ Pr (\d+):(\d+)/ <ref osisRef=\"Prov\.$1\.$2\">Pr $1:$2<\/ref>/g;
	$line =~ s/ Ec (\d+):(\d+)/ <ref osisRef=\"Eccl\.$1\.$2\">Ec $1:$2<\/ref>/g;
	$line =~ s/ Ca (\d+):(\d+)/ <ref osisRef=\"Song\.$1\.$2\">Ca $1:$2<\/ref>/g;
	$line =~ s/ Is (\d+):(\d+)/ <ref osisRef=\"Isa\.$1\.$2\">Is $1:$2<\/ref>/g;
	$line =~ s/ Je (\d+):(\d+)/ <ref osisRef=\"Jer\.$1\.$2\">Je $1:$2<\/ref>/g;
	$line =~ s/ La (\d+):(\d+)/ <ref osisRef=\"Lam\.$1\.$2\">La $1:$2<\/ref>/g;
	$line =~ s/ Ez (\d+):(\d+)/ <ref osisRef=\"Ezek\.$1\.$2\">Ez $1:$2<\/ref>/g;
	$line =~ s/ Da (\d+):(\d+)/ <ref osisRef=\"Dan\.$1\.$2\">Da $1:$2<\/ref>/g;
	$line =~ s/ Ho (\d+):(\d+)/ <ref osisRef=\"Hos\.$1\.$2\">Ho $1:$2<\/ref>/g;
	$line =~ s/ Jl (\d+):(\d+)/ <ref osisRef=\"Joel\.$1\.$2\">Jl $1:$2<\/ref>/g;
	$line =~ s/ Am (\d+):(\d+)/ <ref osisRef=\"Amos\.$1\.$2\">Am $1:$2<\/ref>/g;
	$line =~ s/ Ob (\d+):(\d+)/ <ref osisRef=\"Obad\.$1\.$2\">Ob $1:$2<\/ref>/g;
	$line =~ s/ Jh (\d+):(\d+)/ <ref osisRef=\"Jonah\.$1\.$2\">Jh $1:$2<\/ref>/g;
	$line =~ s/ Mi (\d+):(\d+)/ <ref osisRef=\"Mic\.$1\.$2\">Mi $1:$2<\/ref>/g;
	$line =~ s/ Na (\d+):(\d+)/ <ref osisRef=\"Nah\.$1\.$2\">Na $1:$2<\/ref>/g;
	$line =~ s/ Hb (\d+):(\d+)/ <ref osisRef=\"Hab\.$1\.$2\">Hb $1:$2<\/ref>/g;
	$line =~ s/ Ze (\d+):(\d+)/ <ref osisRef=\"Zeph\.$1\.$2\">Ze $1:$2<\/ref>/g;
	$line =~ s/ Hg (\d+):(\d+)/ <ref osisRef=\"Hag\.$1\.$2\">Hg $1:$2<\/ref>/g;
	$line =~ s/ Za (\d+):(\d+)/ <ref osisRef=\"Zech\.$1\.$2\">Za $1:$2<\/ref>/g;
	$line =~ s/ Ma (\d+):(\d+)/ <ref osisRef=\"Mal\.$1\.$2\">Ma $1:$2<\/ref>/g;
	$line =~ s/ I Es (\d+):(\d+)/ <ref osisRef=\"1Esd\.$1\.$2\">I Es $1:$2<\/ref>/g;
	$line =~ s/ To (\d+):(\d+)/ <ref osisRef=\"Tob\.$1\.$2\">To $1:$2<\/ref>/g;
	$line =~ s/ Jth (\d+):(\d+)/ <ref osisRef=\"Jdt\.$1\.$2\">Jth $1:$2<\/ref>/g;
	$line =~ s/ Wi (\d+):(\d+)/ <ref osisRef=\"Wis\.$1\.$2\">Wi $1:$2<\/ref>/g;
	$line =~ s/ Si (\d+):(\d+)/ <ref osisRef=\"Sir\.$1\.$2\">Si $1:$2<\/ref>/g;
	$line =~ s/ Ba (\d+):(\d+)/ <ref osisRef=\"Bar\.$1\.$2\">Ba $1:$2<\/ref>/g;
	$line =~ s/ DaSu (\d+):(\d+)/ <ref osisRef=\"Sus\.$1\.$2\">DaSu $1:$2<\/ref>/g;
	$line =~ s/ Da Bel (\d+):(\d+)/ <ref osisRef=\"Bel\.$1\.$2\">Da $1:$2<\/ref>/g;
	$line =~ s/ Pr Ma (\d+):(\d+)/ <ref osisRef=\"PrMan\.$1\.$2\">Pr $1:$2<\/ref>/g;
	$line =~ s/ IV Mac (\d+):(\d+)/ <ref osisRef=\"4Macc\.$1\.$2\">IV Mac $1:$2<\/ref>/g;
	$line =~ s/ III Mac (\d+):(\d+)/ <ref osisRef=\"3Macc\.$1\.$2\">III Mac $1:$2<\/ref>/g;
	$line =~ s/ II Mac (\d+):(\d+)/ <ref osisRef=\"2Macc\.$1\.$2\">II Mac $1:$2<\/ref>/g;
	$line =~ s/ I Mac (\d+):(\d+)/ <ref osisRef=\"1Macc\.$1\.$2\">I Mac $1:$2<\/ref>/g;

	$line =~ s/ Mt (\d+):(\d+)/ <ref osisRef=\"Matt\.$1\.$2\">Mt $1:$2<\/ref>/g;
	$line =~ s/ Mk (\d+):(\d+)/ <ref osisRef=\"Mark\.$1\.$2\">Mk $1:$2<\/ref>/g;
	$line =~ s/ Lk (\d+):(\d+)/ <ref osisRef=\"Luke\.$1\.$2\">Lk $1:$2<\/ref>/g;
	$line =~ s/([^I]) Jo (\d+):(\d+)/$1 <ref osisRef=\"John\.$2\.$3\">Jo $2:$3<\/ref>/g;
	$line =~ s/ Ac (\d+):(\d+)/ <ref osisRef=\"Acts\.$1\.$2\">Ac $1:$2<\/ref>/g;
	$line =~ s/ Ro (\d+):(\d+)/ <ref osisRef=\"Rom\.$1\.$2\">Ro $1:$2<\/ref>/g;

	$line =~ s/ II Co (\d+):(\d+)/ <ref osisRef=\"2Cor\.$1\.$2\">II Co $1:$2<\/ref>/g;
	$line =~ s/ I Co (\d+):(\d+)/ <ref osisRef=\"1Cor\.$1\.$2\">I Co $1:$2<\/ref>/g;

	$line =~ s/ Ga (\d+):(\d+)/ <ref osisRef=\"Gal\.$1\.$2\">Ga $1:$2<\/ref>/g;
	$line =~ s/ Eph (\d+):(\d+)/ <ref osisRef=\"Eph\.$1\.$2\">Eph $1:$2<\/ref>/g;
	$line =~ s/ Phl (\d+):(\d+)/ <ref osisRef=\"Phil\.$1\.$2\">Phl $1:$2<\/ref>/g;
	$line =~ s/ Col (\d+):(\d+)/ <ref osisRef=\"Col\.$1\.$2\">Col $1:$2<\/ref>/g;

	$line =~ s/ II Th (\d+):(\d+)/ <ref osisRef=\"2Thess\.$1\.$2\">II Th $1:$2<\/ref>/g;
	$line =~ s/ I Th (\d+):(\d+)/ <ref osisRef=\"1Thess\.$1\.$2\">I Th $1:$2<\/ref>/g;

	$line =~ s/ II Ti (\d+):(\d+)/ <ref osisRef=\"2Tim\.$1\.$2\">II Ti $1:$2<\/ref>/g;
	$line =~ s/ I Ti (\d+):(\d+)/ <ref osisRef=\"1Tim\.$1\.$2\">I Ti $1:$2<\/ref>/g;

	$line =~ s/ Tit (\d+):(\d+)/ <ref osisRef=\"Titus\.$1\.$2\">Tit $1:$2<\/ref>/g;
	$line =~ s/ Phm (\d+):(\d+)/ <ref osisRef=\"Phlm\.$1\.$2\">Phm $1:$2<\/ref>/g;
	$line =~ s/ He (\d+):(\d+)/ <ref osisRef=\"Heb\.$1\.$2\">He $1:$2<\/ref>/g;
	$line =~ s/ Ja (\d+):(\d+)/ <ref osisRef=\"Jas\.$1\.$2\">Ja $1:$2<\/ref>/g;

	$line =~ s/ II Pe (\d+):(\d+)/ <ref osisRef=\"2Pet\.$1\.$2\">II Pe $1:$2<\/ref>/g;
	$line =~ s/ I Pe (\d+):(\d+)/ <ref osisRef=\"1Pet\.$1\.$2\">I Pe $1:$2<\/ref>/g;

	$line =~ s/ III Jo (\d+)/ <ref osisRef=\"3John\.1\.$1\">III Jo $1<\/ref>/g;
	$line =~ s/ II Jo (\d+)/ <ref osisRef=\"2John\.1\.$1\">II Jo $1<\/ref>/g;
	$line =~ s/ I Jo (\d+):(\d+)/ <ref osisRef=\"1John\.$1\.$2\">I Jo $1:$2<\/ref>/g;

	$line =~ s/ Ju (\d+)/ <ref osisRef=\"Jude\.1\.$1\">Ju $1<\/ref>/g;
	$line =~ s/ Re (\d+):(\d+)/ <ref osisRef=\"Rev\.$1\.$2\">Re $1:$2<\/ref>/g;

	print OUTF "$line";
}
close (OUTF);

open (INF, "temp1.xml");
my @data = <INF>;
close (INF);
open (OUTF, ">temp2.xml");

my $line;
foreach $line (@data) {	

	$line =~ s/<ref osisRef=\"([^\.]+)\.(\d+)\.(\d+)\">([^<]+)<\/ref> (\d+):(\d+)/<ref osisRef=\"$1\.$2\.$3\">$4<\/ref>  <ref osisRef=\"$1\.$5\.$6\">$5:$6<\/ref>/g;

	$line =~ s/<ref osisRef=\"([^\.]+)\.(\d+)\.(\d+)\">([^<]+)<\/ref>, (\d+),/<ref osisRef=\"$1\.$2\.$3\">$4<\/ref>,  <ref osisRef=\"$1\.$2\.$5\">$5<\/ref>/g;

	print OUTF "$line";
}
close (OUTF);

open (INF, "temp2.xml");
my @data = <INF>;
close (INF);
open (OUTF, ">out.xml");

my $line;
foreach $line (@data) {	

	$line =~ s/<ref/\n<ref/g;
	$line =~ s/<\/ref>/<\/ref>\n/g;

	print OUTF "$line";
}
close (OUTF);


@filelist = ("temp1.xml","temp2.xml");

unlink @filelist;