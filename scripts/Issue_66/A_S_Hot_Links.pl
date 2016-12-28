# 
# A_S_Hot_Links.pl
# 

 use utf8;                  # Source code is UTF-8
# use open ':std', ':utf8';  # STDIN,STOUT,STERR is UTF-8.
 use open qw< :std :encoding(UTF-8)>;
 use Encode qw(is_utf8 decode encode);


 
  $XMLIn = shift;
  $last_update_time = (stat($XMLIn))[9];
  my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) =
                                                localtime($last_update_time);
  print "Using $XMLIn\n    last updated on " . ($mon + 1) . "\/$mday\/" . ($year + 1900) . "\n\n"; 
  
  $currentletter = '';
  $firstfound = 0;
  $entrytokennumber = 0;
  open (XMLIN, $XMLIn) or die "Can't open $XMLIn:$!";
  while (<XMLIN>) {
  	chop;
  	$firstfound = 1 if ($_ =~/^\s*\<div\s+type\=\"letter\"\s+n\=/);
  	if ($firstfound) {
	  	if ($_ =~/^\s*\<div\s+type\=\"letter\"\s+n\=/p) {
	  		$letterdiv = 1;
	  		$newletter = 1;
	  		$divremainder = ${^POSTMATCH};
	  		if ($divremainder =~/\".+\">/p) {
	  			$currentletter = ${^MATCH};
	  			chop $currentletter; # remove trailing >
	  			$currentletter =~ s/\"//g;
	  			$divdata{$currentletter} = '';
#	 print "DEBUG Letter is $currentletter\n";
	  		}
	  	} else {
	  		$divdata{$currentletter} .= $_;
	  	}
	  }
  }
  
 	foreach my $key (sort keys %divdata ) {
	  $thisdiv = $divdata{$key};
	  @entrytokens = split(/\<entry\s+n\=/, $thisdiv);
	  foreach $entrytoken (@entrytokens) {
	  	if ($entrytoken =~ /\>/p) {
	  		$entrytokenpieces = ${^PREMATCH};
#	print "DEBUG EntTknPcs $entrytokenpieces\n";
	  		$remainingdata = ${^POSTMATCH};
	  		if ($entrytokenpieces =~ /\|/p) {
	  			$thisentry = substr ${^PREMATCH}, 1, 99; # remove leading quote
	  		} else {
	  			$thisentry = substr $entrytokenpieces, 1, 99; # remove leading quote
	  			chop $thisentry; # remove trailing quote for this format only
	  		}
	  		$entrysdata{$thisentry} = $remainingdata;
	  		@xmltokens = split(/\</, $remainingdata);
#	  		print "DEBUG Entry $thisentry\n@xmltokens\n" ;
	  		foreach $xmltoken (@xmltokens) {
	  			if ($xmltoken =~ /^orth\>/p) {
	  				$thisorth = ${^POSTMATCH};
	  				$thisorth =~ s/\s+//g;
	  				$entrysorth{$thisentry} = $thisorth;
	  				$orthsentry{$thisorth} = $thisentry;
	  			}
	  		}
	  	}
	  }
	}

	for my $thisent (sort keys %entrysdata ) {
		$thisorth = $entrysorth{$thisent};
		$thisdata = $entrysdata{$thisent};
		if ($thisdata =~ /\(\&lt\;\s+/p) {
			$equivplus = ${^POSTMATCH};
			if ($equivplus =~ /\)/p) {
				$equivalence = ${^PREMATCH};
#				print "Ent $thisent Orth $thisorth Equiv $equivalence\n";
				if ($equivalence =~ /\<ref/) {
					&verifyexistingequivalence ($thisent, $thisorth, $equivalence);
				} else {
					&identifyneededequivalencelinks ($thisent, $thisorth, $equivalence);
				}
			}
		}
		if (length($thisent) > 1 ) {
			$thissensedata = &getallsensedata($thisent, $thisorth,$entrysdata{$thisent});
		  if ($thissensedata =~ /\=\s+/) {
		  	&identifyexistingandneededequalities($thisent, $thisorth, $thissensedata);
		  }
			if ($thisdata =~ /SYN\.\<\/emph\>\:/p) {
				$possiblesynonym = ${^POSTMATCH};
				&checkpossiblesyn ($thisent, $thisorth,$possiblesynonym);
			}
		}
	}

  my @sortedtagged =  sort { $a->{key} cmp $b->{key} } @shouldbetagged;	
	print "\nBelow is a list of entries and corresponding Greek words that\n" .
	  "  should be tagged as references or analyzed as described\n\n";
	
	foreach $href ( @sortedtagged) {
		print "    Entry $href->{ent} $href->{typ}";
		if ($href->{anl}) {
			print " - Analyze line with: $href->{rem}\n";
		} else {
			if ($href->{nas}) {
				print " $href->{grk} - Not currently in A-S, modify as needed\n";
			} else {
				print " $href->{grk} - in A-S, tag with <ref>...<\\ref>\n";
			}
		}
	}
  print "\n";
  	
	sub verifyexistingequivalence {
		my ($ent, $orth, $equiv) = @_;

		if ($equiv =~ /\<foreign\s+xml\:lang\=\"grc\"\>/) {
    	@foreignpieces = split(/\<foreign\s+xml\:lang\=\"/,$equiv);
#		  &prarray("\nEnt $ent Orth $orth ",@foreignpieces);
		  $verifynext = 0;
		  $identifynext = 0;
		  foreach $foreignpiece (@foreignpieces) {
		  	$foreignpiece =~ s/\>\,/\>/;
		  	$foreignpiece =~ s/\s*\xe2\x80\xa0\s*//; # dagger
		  	if ($verifynext) {
		  		if ($foreignpiece =~ /^grc/) {
		  			$greekword = &parsegreekword($foreignpiece);
		  			if (!(exists $entrysorth{$greekword})) {
		  				push @shouldbetagged, {
				  				key => &makeentkey($ent),
			  					typ => " < ",
			  					ent => $ent,
			  					grk => $greekword,
			  					nas => 0,
			  					anl => 0
		  				};
		  			}
						if ($foreignpiece =~ /ref\>/p) {
							$trailer = ${^POSTMATCH};
							if (&nonblank ($trailer)) {
								last;
							}
						} else {
		print "DEBUG MAJOR PROBLEM - doesn't have ref> $foreignpiece\n";
						}
		  		$verifynext = 0;
					} else {
						last; # this was a hebrew foreign ref
					}
		  	} elsif (($identifynext) || ($foreignpiece =~ /^grc/)) {
		  		if ($foreignpiece =~ /^grc/) {
		  			$greekword = &parsegreekword($foreignpiece);
		  			if ((exists $entrysorth{$greekword})) {
		  				push @shouldbetagged, {
				  				key => &makeentkey($ent),
			  					typ => " < ",
			  					ent => $ent,
			  					grk => $greekword,
			  					nas => 0,
			  					anl => 0
		  				};
		  			}
						if ($foreignpiece =~ /foreign\>/p) {
							$trailer = ${^POSTMATCH};
							if (&nonblank ($trailer)) {
								last;
							}
						} else {
		print "DEBUG MAJOR PROBLEM - doesn't have foreign> $foreignpiece\n";
						}
			  		$identifynext = 0;
			  	} else {
			  		last; # this was a hebrew foreign ref
			  	}
		  	} else {
		  		if ($foreignpiece =~ /\<ref\>/) {
#	print "DEBUG Verify next \n";
		  			$verifynext = 1;
		  		} elsif ($foreignpiece eq '') {
#	print "DEBUG Identify next \n";
		  			$identifynext = 1;
		  		} else {
		  			$foreignpiece =~ s/\s+//g;
		  			if (length($foreignpiece) gt 1) {
				  				push @shouldbetagged, {
						  				key => &makeentkey($ent),
					  					typ => " < ",
					  					ent => $ent,
					  					rem => $foreignpiece,
					  					nas => 1,
					  					anl => 1
					  			}
#							print "DEBUG Add something brilliant here for $foreignpiece\n";	
#							  &prarray("\nEnt $ent Orth $orth ",@foreignpieces);
						}
		  		}
		  	}
		  }
		}
	}
	
	sub identifyneededequivalencelinks {
		my ($ent, $orth, $equiv) = @_;

		if ($equiv =~ /\<foreign\s+xml\:lang\=\"grc\"\>/) {
    	@foreignpieces = split(/\<foreign\s+xml\:lang\=\"/,$equiv);
#		  &prarray("\nEnt $ent Orth $orth ",@foreignpieces);
		  $verifynext = 0;
		  $identifynext = 0;
		  foreach $foreignpiece (@foreignpieces) {
		  	$foreignpiece =~ s/\>\,/\>/;
		  	$foreignpiece =~ s/\s*\xe2\x80\xa0\s*//; # dagger
		  	if ($verifynext) {
		  		if ($foreignpiece =~ /^grc/) {
		  			$greekword = &parsegreekword($foreignpiece);
		  			if (!(exists $entrysorth{$greekword})) {
		  				push @shouldbetagged, {
				  				key => &makeentkey($ent),
			  					typ => " < ",
			  					ent => $ent,
			  					grk => $greekword,
			  					nas => 1, # tag though not in A-S
			  					anl => 0
		  				};
		  			}
						if ($foreignpiece =~ /ref\>/p) {
							$trailer = ${^POSTMATCH};
							if (&nonblank ($trailer)) {
								last;
							}
						} else {
		print "DEBUG MAJOR PROBLEM - doesn't have ref> $foreignpiece\n";
						}
		  		$verifynext = 0;
					} else {
						last; # this was a hebrew foreign ref
					}
		  	} elsif (($identifynext) || ($foreignpiece =~ /^grc/)) {
		  		if ($foreignpiece =~ /^grc/) {
		  			$greekword = &parsegreekword($foreignpiece);
		  			if ((exists $entrysorth{$greekword})) {
		  				push @shouldbetagged, {
				  				key => &makeentkey($ent),
			  					typ => " < ",
			  					ent => $ent,
			  					grk => $greekword,
			  					nas => 0,
			  					anl => 0
		  				};
		  			}
						if ($foreignpiece =~ /foreign\>/p) {
							$trailer = ${^POSTMATCH};
							if (&nonblank ($trailer)) {
								last;
							}
						} else {
		print "DEBUG MAJOR PROBLEM - doesn't have foreign> $foreignpiece\n";
						}
			  		$identifynext = 0;
			  	} else {
			  		last; # this was a hebrew foreign ref
			  	}
		  	} else {
		  		if ($foreignpiece =~ /\<ref\>/) {
#	print "DEBUG Verify next \n";
		  			$verifynext = 1;
		  		} elsif ($foreignpiece eq '') {
#	print "DEBUG Identify next \n";
		  			$identifynext = 1;
		  		} else {
		  			$foreignpiece =~ s/\s+//g;
		  			if (length($foreignpiece) gt 1) {
				  				push @shouldbetagged, {
						  				key => &makeentkey($ent),
					  					typ => " < ",
					  					ent => $ent,
					  					rem => $foreignpiece,
					  					nas => 1,
					  					anl => 1
					  			}
						}
		  		}
		  	}
		  }
		}
	}
	
  sub getallsensedata {
  	my ($ent, $orth,$entdata) = @_;
  	my ($sensedata) = '';
  	@sensepieces = split(/\<sense/, $entdata);
  	foreach $sensepiece (@sensepieces) {
			if ($sensepiece =~ />/p) {
				$sensepiece = ${^POSTMATCH};
			}  			
  		if ($sensepiece =~ /\<\/sense>/p) {
  			$sensedata .= " " . ${^PREMATCH};
  		}
  	}
  	return $sensedata;
  }


	sub identifyexistingandneededequalities {
		my ($ent, $orth, $sensedata) = @_;
		my ($greekword) = '';

  	  if ($sensedata =~ /\=\s+/p) {
					$possiblegreek = ${^POSTMATCH};
#	print "DEBUG Ent $ent has possible equality\n>$possiblegreek\n";
					if ($possiblegreek =~ /\s*\<foreign xml\:lang\=\"grc\">/p) {
						$checkforexistingref = ${^PREMATCH};
						$greekwordplus = ${^POSTMATCH};
#	print "DEBUG Ent $ent has greek word plus\n>$greekwordplus\n";
						if ($greekwordplus =~ /\<\/foreign/p) {
							$greekword = ${^PREMATCH};
#	print "DEBUG Ent $ent has greek word >$greekword<\n";
						}
						if (substr($checkforexistingref,length($checkforexistingref)-5,5)
								 eq "<ref>") {
			  			if (!(exists $entrysorth{$greekword})) {
			  				push @shouldbetagged, {
					  				key => &makeentkey($ent),
				  					typ => " = ",
				  					ent => $ent,
				  					grk => $greekword,
				  					nas => 1,
				  					anl => 0
			  				};
#	print "DEBUG Ent $ent Grk $greekword Path 1  \n"
			  			} else {
			  			}
						} else { # no preceeding ref, so flag to add
			  			if (exists $entrysorth{$greekword}) {
			  				push @shouldbetagged, {
				  					key => &makeentkey($ent),
				  					typ => " = ",
				  					ent => $ent,
				  					grk => $greekword,
			  					  nas => 0,
				  					anl => 0
			  				};
#	print "DEBUG Ent $ent Grk $greekword Path 3  \n"
			  			} else {
			  			}
						}
					} else {
#	print "DEBUG Ent $ent does not qualify\n>$possiblegreek\n";
					}
			}
	
	}


 sub prarray {
 	my ($hdr,@arr) = @_;
 	my ($ndx) = 0 ;
 	print $hdr . " ";
 	foreach $ele (@arr) {
 		print "$ndx =>" . $ele . "< ";
 		$ndx++;
 	}
 	print "\n";
 }
 
   sub nonblank {
   	my($instr) = @_;
   	my($teststr) = $instr;
   	my($testlen) = 0;
   	$teststr =~ s/\s+//g;
   	$testlen = length($teststr);
#   	print "DEBUG In $instr Test $teststr Len " . int($testlen) . "\n";
   	return (int($testlen) > 0);
   }

   sub parsegreekword {
   	  my($foreignpiece) = @_;
   	  my($grk) = '';
   	  if ($foreignpiece =~ /grc\"\>/p) {
   	  	$grkplus = ${^POSTMATCH};
   	  	if ($grkplus =~ /\<\/foreign\>/p) {
   	  		$grk = ${^PREMATCH};
   	  	}
   	  }
   	  return $grk;
   }
   
	sub checkpossiblesyn {
		my ($ent, $orth,$possiblesynonym) = @_;
			$savepossible = $possiblesynonym;
			@savposssynlist = split(/\<foreign\s+xml\:lang\=\"/,$savepossible);
			$possiblesynonym =~ s/v\.s\.//g;
			$possiblesynonym =~ s/q\.v\.//g;
			$possiblesynonym =~ s/cf//g;
			$possiblesynonym =~ s/and//g;
			$possiblesynonym =~ s/\<\/re\>//g;
			$possiblesynonym =~ s/\<\/entry\>//g;
#			$possiblesynonym =~ s///g;
#			$possiblesynonym =~ s///g;
			$possiblesynonym =~ s/[*.?:~!,();]//g;
			$possiblesynonym =~ s/\s+//g;
			@posssynlist = split (/\<foreignxmllang\=\"/, $possiblesynonym);
			$indx = -1;
			foreach $posssyn (@posssynlist) {
				$indx++;
				if ($posssyn =~ /^grc\"\>/p) {
					$grksynplus =  ${^POSTMATCH};
					if ($grksynplus =~ /\<\/foreign\>/p) {
						$greekword  =  ${^PREMATCH};
						$remainder = ${^POSTMATCH};
		  			if (exists $entrysorth{$greekword}) {
		  				push @shouldbetagged, {
				  				key => &makeentkey($ent),
			  					typ => "SYN",
			  					ent => $ent,
			  					grk => $greekword,
			  					nas => 0,
			  					anl => 0
		  				};
		  			} else {  # not in A-S
		  				push @shouldbetagged, {
				  				key => &makeentkey($ent),
			  					typ => "SYN",
			  					ent => $ent,
			  					grk => $greekword,
			  					nas => 1,
			  					anl => 0
		  				};
		  			}
		  			if (length($remainder) > 0) {
#							$savposs =$savposssynlist[$indx];
#							if ($savposs =~ /\<\/foreign\>/p) {
#								$savremainder = ${^POSTMATCH};
#								if (length($savremainder) > 0) {
#				  				push @possiblesyntaggedent, $ent;
#				  				push @possiblesyntaggedrem, $savremainder;
#				  				push @shouldbetagged, {
#						  				key => &makeentkey($ent),
#					  					typ => "SYN",
#					  					ent => $ent,
#					  					rem => $savremainder,
#					  					nas => 1,
#					  					anl => 1
#				  				};
#									last ;
#								}
#							}
						}
					}
					
				}
			}
  }
  
  sub makeentkey {
  	my ($ent) = @_;
  	my ($retkey) = $ent;
	

    $retkey =~ s/\N{GREEK SMALL LETTER ALPHA WITH PSILI}/\N{GREEK SMALL LETTER ALPHA}/g;
    $retkey =~ s/\N{GREEK SMALL LETTER ALPHA WITH DASIA}/\N{GREEK SMALL LETTER ALPHA}/g;
    $retkey =~ s/\N{GREEK SMALL LETTER ALPHA WITH PSILI AND VARIA}/\N{GREEK SMALL LETTER ALPHA}/g;
    $retkey =~ s/\N{GREEK SMALL LETTER ALPHA WITH DASIA AND VARIA}/\N{GREEK SMALL LETTER ALPHA}/g;
    $retkey =~ s/\N{GREEK SMALL LETTER ALPHA WITH PSILI AND OXIA}/\N{GREEK SMALL LETTER ALPHA}/g;
    $retkey =~ s/\N{GREEK SMALL LETTER ALPHA WITH DASIA AND OXIA}/\N{GREEK SMALL LETTER ALPHA}/g;
    $retkey =~ s/\N{GREEK SMALL LETTER ALPHA WITH PSILI AND PERISPOMENI}/\N{GREEK SMALL LETTER ALPHA}/g;
    $retkey =~ s/\N{GREEK SMALL LETTER ALPHA WITH DASIA AND PERISPOMENI}/\N{GREEK SMALL LETTER ALPHA}/g;
    $retkey =~ s/\N{GREEK SMALL LETTER ALPHA WITH VARIA}/\N{GREEK SMALL LETTER ALPHA}/g;
    $retkey =~ s/\N{GREEK SMALL LETTER ALPHA WITH OXIA}/\N{GREEK SMALL LETTER ALPHA}/g;
    $retkey =~ s/\N{GREEK SMALL LETTER ALPHA WITH TONOS}/\N{GREEK SMALL LETTER ALPHA}/g;
    $retkey =~ s/\N{GREEK SMALL LETTER ALPHA WITH PSILI AND YPOGEGRAMMENI}/\N{GREEK SMALL LETTER ALPHA}/g;
    $retkey =~ s/\N{GREEK SMALL LETTER ALPHA WITH DASIA AND YPOGEGRAMMENI}/\N{GREEK SMALL LETTER ALPHA}/g;
    $retkey =~ s/\N{GREEK SMALL LETTER ALPHA WITH PSILI AND VARIA AND YPOGEGRAMMENI}/\N{GREEK SMALL LETTER ALPHA}/g;
    $retkey =~ s/\N{GREEK SMALL LETTER ALPHA WITH DASIA AND VARIA AND YPOGEGRAMMENI}/\N{GREEK SMALL LETTER ALPHA}/g;
    $retkey =~ s/\N{GREEK SMALL LETTER ALPHA WITH PSILI AND OXIA AND YPOGEGRAMMENI}/\N{GREEK SMALL LETTER ALPHA}/g;
    $retkey =~ s/\N{GREEK SMALL LETTER ALPHA WITH DASIA AND OXIA AND YPOGEGRAMMENI}/\N{GREEK SMALL LETTER ALPHA}/g;
    $retkey =~ s/\N{GREEK SMALL LETTER ALPHA WITH PSILI AND PERISPOMENI AND YPOGEGRAMMENI}/\N{GREEK SMALL LETTER ALPHA}/g;
    $retkey =~ s/\N{GREEK SMALL LETTER ALPHA WITH DASIA AND PERISPOMENI AND YPOGEGRAMMENI}/\N{GREEK SMALL LETTER ALPHA}/g;
    $retkey =~ s/\N{GREEK SMALL LETTER ALPHA WITH VRACHY}/\N{GREEK SMALL LETTER ALPHA}/g;
    $retkey =~ s/\N{GREEK SMALL LETTER ALPHA WITH MACRON}/\N{GREEK SMALL LETTER ALPHA}/g;
    $retkey =~ s/\N{GREEK SMALL LETTER ALPHA WITH VARIA AND YPOGEGRAMMENI}/\N{GREEK SMALL LETTER ALPHA}/g;
    $retkey =~ s/\N{GREEK SMALL LETTER ALPHA WITH YPOGEGRAMMENI}/\N{GREEK SMALL LETTER ALPHA}/g;
    $retkey =~ s/\N{GREEK SMALL LETTER ALPHA WITH OXIA AND YPOGEGRAMMENI}/\N{GREEK SMALL LETTER ALPHA}/g;
    $retkey =~ s/\N{GREEK SMALL LETTER ALPHA WITH PERISPOMENI}/\N{GREEK SMALL LETTER ALPHA}/g;
    $retkey =~ s/\N{GREEK SMALL LETTER ALPHA WITH PERISPOMENI AND YPOGEGRAMMENI}/\N{GREEK SMALL LETTER ALPHA}/g;

    $retkey =~ s/\N{GREEK SMALL LETTER EPSILON WITH PSILI}/\N{GREEK SMALL LETTER EPSILON}/g;
    $retkey =~ s/\N{GREEK SMALL LETTER EPSILON WITH DASIA}/\N{GREEK SMALL LETTER EPSILON}/g;
    $retkey =~ s/\N{GREEK SMALL LETTER EPSILON WITH PSILI AND VARIA}/\N{GREEK SMALL LETTER EPSILON}/g;
    $retkey =~ s/\N{GREEK SMALL LETTER EPSILON WITH DASIA AND VARIA}/\N{GREEK SMALL LETTER EPSILON}/g;
    $retkey =~ s/\N{GREEK SMALL LETTER EPSILON WITH PSILI AND OXIA}/\N{GREEK SMALL LETTER EPSILON}/g;
    $retkey =~ s/\N{GREEK SMALL LETTER EPSILON WITH DASIA AND OXIA}/\N{GREEK SMALL LETTER EPSILON}/g;
    $retkey =~ s/\N{GREEK SMALL LETTER EPSILON WITH VARIA}/\N{GREEK SMALL LETTER EPSILON}/g;
    $retkey =~ s/\N{GREEK SMALL LETTER EPSILON WITH OXIA}/\N{GREEK SMALL LETTER EPSILON}/g;
    $retkey =~ s/\N{GREEK SMALL LETTER EPSILON WITH TONOS}/\N{GREEK SMALL LETTER EPSILON}/g;

    $retkey =~ s/\N{GREEK SMALL LETTER ETA WITH PSILI}/\N{GREEK SMALL LETTER ETA}/g;
    $retkey =~ s/\N{GREEK SMALL LETTER ETA WITH DASIA}/\N{GREEK SMALL LETTER ETA}/g;
    $retkey =~ s/\N{GREEK SMALL LETTER ETA WITH PSILI AND VARIA}/\N{GREEK SMALL LETTER ETA}/g;
    $retkey =~ s/\N{GREEK SMALL LETTER ETA WITH DASIA AND VARIA}/\N{GREEK SMALL LETTER ETA}/g;
    $retkey =~ s/\N{GREEK SMALL LETTER ETA WITH PSILI AND OXIA}/\N{GREEK SMALL LETTER ETA}/g;
    $retkey =~ s/\N{GREEK SMALL LETTER ETA WITH DASIA AND OXIA}/\N{GREEK SMALL LETTER ETA}/g;
    $retkey =~ s/\N{GREEK SMALL LETTER ETA WITH PSILI AND PERISPOMENI}/\N{GREEK SMALL LETTER ETA}/g;
    $retkey =~ s/\N{GREEK SMALL LETTER ETA WITH DASIA AND PERISPOMENI}/\N{GREEK SMALL LETTER ETA}/g;
    $retkey =~ s/\N{GREEK SMALL LETTER ETA WITH VARIA}/\N{GREEK SMALL LETTER ETA}/g;
    $retkey =~ s/\N{GREEK SMALL LETTER ETA WITH OXIA}/\N{GREEK SMALL LETTER ETA}/g;
    $retkey =~ s/\N{GREEK SMALL LETTER ETA WITH TONOS}/\N{GREEK SMALL LETTER ETA}/g;
    $retkey =~ s/\N{GREEK SMALL LETTER ETA WITH PSILI AND YPOGEGRAMMENI}/\N{GREEK SMALL LETTER ETA}/g;
    $retkey =~ s/\N{GREEK SMALL LETTER ETA WITH DASIA AND YPOGEGRAMMENI}/\N{GREEK SMALL LETTER ETA}/g;
    $retkey =~ s/\N{GREEK SMALL LETTER ETA WITH PSILI AND VARIA AND YPOGEGRAMMENI}/\N{GREEK SMALL LETTER ETA}/g;
    $retkey =~ s/\N{GREEK SMALL LETTER ETA WITH DASIA AND VARIA AND YPOGEGRAMMENI}/\N{GREEK SMALL LETTER ETA}/g;
    $retkey =~ s/\N{GREEK SMALL LETTER ETA WITH PSILI AND OXIA AND YPOGEGRAMMENI}/\N{GREEK SMALL LETTER ETA}/g;
    $retkey =~ s/\N{GREEK SMALL LETTER ETA WITH DASIA AND OXIA AND YPOGEGRAMMENI}/\N{GREEK SMALL LETTER ETA}/g;
    $retkey =~ s/\N{GREEK SMALL LETTER ETA WITH PSILI AND PERISPOMENI AND YPOGEGRAMMENI}/\N{GREEK SMALL LETTER ETA}/g;
    $retkey =~ s/\N{GREEK SMALL LETTER ETA WITH DASIA AND PERISPOMENI AND YPOGEGRAMMENI}/\N{GREEK SMALL LETTER ETA}/g;
    $retkey =~ s/\N{GREEK SMALL LETTER ETA WITH VARIA AND YPOGEGRAMMENI}/\N{GREEK SMALL LETTER ETA}/g;
    $retkey =~ s/\N{GREEK SMALL LETTER ETA WITH YPOGEGRAMMENI}/\N{GREEK SMALL LETTER ETA}/g;
    $retkey =~ s/\N{GREEK SMALL LETTER ETA WITH OXIA AND YPOGEGRAMMENI}/\N{GREEK SMALL LETTER ETA}/g;
    $retkey =~ s/\N{GREEK SMALL LETTER ETA WITH PERISPOMENI}/\N{GREEK SMALL LETTER ETA}/g;
    $retkey =~ s/\N{GREEK SMALL LETTER ETA WITH PERISPOMENI AND YPOGEGRAMMENI}/\N{GREEK SMALL LETTER ETA}/g;

    $retkey =~ s/\N{GREEK SMALL LETTER IOTA WITH PSILI}/\N{GREEK SMALL LETTER IOTA}/g;
    $retkey =~ s/\N{GREEK SMALL LETTER IOTA WITH DASIA}/\N{GREEK SMALL LETTER IOTA}/g;
    $retkey =~ s/\N{GREEK SMALL LETTER IOTA WITH PSILI AND VARIA}/\N{GREEK SMALL LETTER IOTA}/g;
    $retkey =~ s/\N{GREEK SMALL LETTER IOTA WITH DASIA AND VARIA}/\N{GREEK SMALL LETTER IOTA}/g;
    $retkey =~ s/\N{GREEK SMALL LETTER IOTA WITH PSILI AND OXIA}/\N{GREEK SMALL LETTER IOTA}/g;
    $retkey =~ s/\N{GREEK SMALL LETTER IOTA WITH DASIA AND OXIA}/\N{GREEK SMALL LETTER IOTA}/g;
    $retkey =~ s/\N{GREEK SMALL LETTER IOTA WITH PSILI AND PERISPOMENI}/\N{GREEK SMALL LETTER IOTA}/g;
    $retkey =~ s/\N{GREEK SMALL LETTER IOTA WITH DASIA AND PERISPOMENI}/\N{GREEK SMALL LETTER IOTA}/g;
    $retkey =~ s/\N{GREEK SMALL LETTER IOTA WITH VARIA}/\N{GREEK SMALL LETTER IOTA}/g;
    $retkey =~ s/\N{GREEK SMALL LETTER IOTA WITH OXIA}/\N{GREEK SMALL LETTER IOTA}/g;
    $retkey =~ s/\N{GREEK SMALL LETTER IOTA WITH DIALYTIKA AND TONOS}/\N{GREEK SMALL LETTER IOTA}/g;
    $retkey =~ s/\N{GREEK SMALL LETTER IOTA WITH TONOS}/\N{GREEK SMALL LETTER IOTA}/g;
    $retkey =~ s/\N{GREEK SMALL LETTER IOTA WITH VRACHY}/\N{GREEK SMALL LETTER IOTA}/g;
    $retkey =~ s/\N{GREEK SMALL LETTER IOTA WITH MACRON}/\N{GREEK SMALL LETTER IOTA}/g;
    $retkey =~ s/\N{GREEK SMALL LETTER IOTA WITH DIALYTIKA AND VARIA}/\N{GREEK SMALL LETTER IOTA}/g;
    $retkey =~ s/\N{GREEK SMALL LETTER IOTA WITH DIALYTIKA AND OXIA}/\N{GREEK SMALL LETTER IOTA}/g;
    $retkey =~ s/\N{GREEK SMALL LETTER IOTA WITH PERISPOMENI}/\N{GREEK SMALL LETTER IOTA}/g;
    $retkey =~ s/\N{GREEK SMALL LETTER IOTA WITH DIALYTIKA AND PERISPOMENI}/\N{GREEK SMALL LETTER IOTA}/g;
    $retkey =~ s/\N{GREEK SMALL LETTER IOTA WITH DIALYTIKA}/\N{GREEK SMALL LETTER IOTA}/g;


    $retkey =~ s/\N{GREEK SMALL LETTER OMICRON WITH PSILI}/\N{GREEK SMALL LETTER OMICRON}/g;
    $retkey =~ s/\N{GREEK SMALL LETTER OMICRON WITH DASIA}/\N{GREEK SMALL LETTER OMICRON}/g;
    $retkey =~ s/\N{GREEK SMALL LETTER OMICRON WITH PSILI AND VARIA}/\N{GREEK SMALL LETTER OMICRON}/g;
    $retkey =~ s/\N{GREEK SMALL LETTER OMICRON WITH DASIA AND VARIA}/\N{GREEK SMALL LETTER OMICRON}/g;
    $retkey =~ s/\N{GREEK SMALL LETTER OMICRON WITH PSILI AND OXIA}/\N{GREEK SMALL LETTER OMICRON}/g;
    $retkey =~ s/\N{GREEK SMALL LETTER OMICRON WITH DASIA AND OXIA}/\N{GREEK SMALL LETTER OMICRON}/g;
    $retkey =~ s/\N{GREEK SMALL LETTER OMICRON WITH VARIA}/\N{GREEK SMALL LETTER OMICRON}/g;
    $retkey =~ s/\N{GREEK SMALL LETTER OMICRON WITH OXIA}/\N{GREEK SMALL LETTER OMICRON}/g;
    $retkey =~ s/\N{GREEK SMALL LETTER OMICRON WITH TONOS}/\N{GREEK SMALL LETTER OMICRON}/g;

    $retkey =~ s/\N{GREEK SMALL LETTER UPSILON WITH PSILI}/\N{GREEK SMALL LETTER UPSILON}/g;
    $retkey =~ s/\N{GREEK SMALL LETTER UPSILON WITH DASIA}/\N{GREEK SMALL LETTER UPSILON}/g;
    $retkey =~ s/\N{GREEK SMALL LETTER UPSILON WITH PSILI AND VARIA}/\N{GREEK SMALL LETTER UPSILON}/g;
    $retkey =~ s/\N{GREEK SMALL LETTER UPSILON WITH DASIA AND VARIA}/\N{GREEK SMALL LETTER UPSILON}/g;
    $retkey =~ s/\N{GREEK SMALL LETTER UPSILON WITH PSILI AND OXIA}/\N{GREEK SMALL LETTER UPSILON}/g;
    $retkey =~ s/\N{GREEK SMALL LETTER UPSILON WITH DASIA AND OXIA}/\N{GREEK SMALL LETTER UPSILON}/g;
    $retkey =~ s/\N{GREEK SMALL LETTER UPSILON WITH PSILI AND PERISPOMENI}/\N{GREEK SMALL LETTER UPSILON}/g;
    $retkey =~ s/\N{GREEK SMALL LETTER UPSILON WITH DASIA AND PERISPOMENI}/\N{GREEK SMALL LETTER UPSILON}/g;
    $retkey =~ s/\N{GREEK SMALL LETTER UPSILON WITH VARIA}/\N{GREEK SMALL LETTER UPSILON}/g;
    $retkey =~ s/\N{GREEK SMALL LETTER UPSILON WITH OXIA}/\N{GREEK SMALL LETTER UPSILON}/g;
    $retkey =~ s/\N{GREEK SMALL LETTER UPSILON WITH DIALYTIKA AND TONOS}/\N{GREEK SMALL LETTER UPSILON}/g;
    $retkey =~ s/\N{GREEK SMALL LETTER UPSILON WITH DIALYTIKA}/\N{GREEK SMALL LETTER UPSILON}/g;
    $retkey =~ s/\N{GREEK SMALL LETTER UPSILON WITH TONOS}/\N{GREEK SMALL LETTER UPSILON}/g;
    $retkey =~ s/\N{GREEK SMALL LETTER UPSILON WITH VRACHY}/\N{GREEK SMALL LETTER UPSILON}/g;
    $retkey =~ s/\N{GREEK SMALL LETTER UPSILON WITH MACRON}/\N{GREEK SMALL LETTER UPSILON}/g;
    $retkey =~ s/\N{GREEK SMALL LETTER UPSILON WITH DIALYTIKA AND VARIA}/\N{GREEK SMALL LETTER UPSILON}/g;
    $retkey =~ s/\N{GREEK SMALL LETTER UPSILON WITH DIALYTIKA AND OXIA}/\N{GREEK SMALL LETTER UPSILON}/g;
    $retkey =~ s/\N{GREEK SMALL LETTER UPSILON WITH PERISPOMENI}/\N{GREEK SMALL LETTER UPSILON}/g;
    $retkey =~ s/\N{GREEK SMALL LETTER UPSILON WITH DIALYTIKA AND PERISPOMENI}/\N{GREEK SMALL LETTER UPSILON}/g;

    $retkey =~ s/\N{GREEK SMALL LETTER OMEGA WITH PSILI}/\N{GREEK SMALL LETTER OMEGA}/g;
    $retkey =~ s/\N{GREEK SMALL LETTER OMEGA WITH DASIA}/\N{GREEK SMALL LETTER OMEGA}/g;
    $retkey =~ s/\N{GREEK SMALL LETTER OMEGA WITH PSILI AND VARIA}/\N{GREEK SMALL LETTER OMEGA}/g;
    $retkey =~ s/\N{GREEK SMALL LETTER OMEGA WITH DASIA AND VARIA}/\N{GREEK SMALL LETTER OMEGA}/g;
    $retkey =~ s/\N{GREEK SMALL LETTER OMEGA WITH PSILI AND OXIA}/\N{GREEK SMALL LETTER OMEGA}/g;
    $retkey =~ s/\N{GREEK SMALL LETTER OMEGA WITH DASIA AND OXIA}/\N{GREEK SMALL LETTER OMEGA}/g;
    $retkey =~ s/\N{GREEK SMALL LETTER OMEGA WITH PSILI AND PERISPOMENI}/\N{GREEK SMALL LETTER OMEGA}/g;
    $retkey =~ s/\N{GREEK SMALL LETTER OMEGA WITH DASIA AND PERISPOMENI}/\N{GREEK SMALL LETTER OMEGA}/g;
    $retkey =~ s/\N{GREEK SMALL LETTER OMEGA WITH VARIA}/\N{GREEK SMALL LETTER OMEGA}/g;
    $retkey =~ s/\N{GREEK SMALL LETTER OMEGA WITH OXIA}/\N{GREEK SMALL LETTER OMEGA}/g;
    $retkey =~ s/\N{GREEK SMALL LETTER OMEGA WITH TONOS}/\N{GREEK SMALL LETTER OMEGA}/g;
    $retkey =~ s/\N{GREEK SMALL LETTER OMEGA WITH PSILI AND YPOGEGRAMMENI}/\N{GREEK SMALL LETTER OMEGA}/g;
    $retkey =~ s/\N{GREEK SMALL LETTER OMEGA WITH DASIA AND YPOGEGRAMMENI}/\N{GREEK SMALL LETTER OMEGA}/g;
    $retkey =~ s/\N{GREEK SMALL LETTER OMEGA WITH PSILI AND VARIA AND YPOGEGRAMMENI}/\N{GREEK SMALL LETTER OMEGA}/g;
    $retkey =~ s/\N{GREEK SMALL LETTER OMEGA WITH DASIA AND VARIA AND YPOGEGRAMMENI}/\N{GREEK SMALL LETTER OMEGA}/g;
    $retkey =~ s/\N{GREEK SMALL LETTER OMEGA WITH PSILI AND OXIA AND YPOGEGRAMMENI}/\N{GREEK SMALL LETTER OMEGA}/g;
    $retkey =~ s/\N{GREEK SMALL LETTER OMEGA WITH DASIA AND OXIA AND YPOGEGRAMMENI}/\N{GREEK SMALL LETTER OMEGA}/g;
    $retkey =~ s/\N{GREEK SMALL LETTER OMEGA WITH PSILI AND PERISPOMENI AND YPOGEGRAMMENI}/\N{GREEK SMALL LETTER OMEGA}/g;
    $retkey =~ s/\N{GREEK SMALL LETTER OMEGA WITH DASIA AND PERISPOMENI AND YPOGEGRAMMENI}/\N{GREEK SMALL LETTER OMEGA}/g;
    $retkey =~ s/\N{GREEK SMALL LETTER OMEGA WITH VARIA AND YPOGEGRAMMENI}/\N{GREEK SMALL LETTER OMEGA}/g;
    $retkey =~ s/\N{GREEK SMALL LETTER OMEGA WITH YPOGEGRAMMENI}/\N{GREEK SMALL LETTER OMEGA}/g;
    $retkey =~ s/\N{GREEK SMALL LETTER OMEGA WITH OXIA AND YPOGEGRAMMENI}/\N{GREEK SMALL LETTER OMEGA}/g;
    $retkey =~ s/\N{GREEK SMALL LETTER OMEGA WITH PERISPOMENI}/\N{GREEK SMALL LETTER OMEGA}/g;
    $retkey =~ s/\N{GREEK SMALL LETTER OMEGA WITH PERISPOMENI AND YPOGEGRAMMENI}/\N{GREEK SMALL LETTER OMEGA}/g;

    $retkey =~ s/\N{GREEK CAPITAL LETTER ALPHA}/\N{GREEK SMALL LETTER ALPHA}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER ALPHA WITH DASIA}/\N{GREEK SMALL LETTER ALPHA}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER ALPHA WITH DASIA AND OXIA}/\N{GREEK SMALL LETTER ALPHA}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER ALPHA WITH DASIA AND OXIA AND PROSGEGRAMMENI}/\N{GREEK SMALL LETTER ALPHA}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER ALPHA WITH DASIA AND PERISPOMENI}/\N{GREEK SMALL LETTER ALPHA}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER ALPHA WITH DASIA AND PERISPOMENI AND PROSGEGRAMMENI}/\N{GREEK SMALL LETTER ALPHA}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER ALPHA WITH DASIA AND PROSGEGRAMMENI}/\N{GREEK SMALL LETTER ALPHA}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER ALPHA WITH DASIA AND VARIA}/\N{GREEK SMALL LETTER ALPHA}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER ALPHA WITH DASIA AND VARIA AND PROSGEGRAMMENI}/\N{GREEK SMALL LETTER ALPHA}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER ALPHA WITH MACRON}/\N{GREEK SMALL LETTER ALPHA}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER ALPHA WITH OXIA}/\N{GREEK SMALL LETTER ALPHA}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER ALPHA WITH PROSGEGRAMMENI}/\N{GREEK SMALL LETTER ALPHA}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER ALPHA WITH PSILI}/\N{GREEK SMALL LETTER ALPHA}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER ALPHA WITH PSILI AND OXIA}/\N{GREEK SMALL LETTER ALPHA}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER ALPHA WITH PSILI AND OXIA AND PROSGEGRAMMENI}/\N{GREEK SMALL LETTER ALPHA}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER ALPHA WITH PSILI AND PERISPOMENI}/\N{GREEK SMALL LETTER ALPHA}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER ALPHA WITH PSILI AND PERISPOMENI AND PROSGEGRAMMENI}/\N{GREEK SMALL LETTER ALPHA}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER ALPHA WITH PSILI AND PROSGEGRAMMENI}/\N{GREEK SMALL LETTER ALPHA}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER ALPHA WITH PSILI AND VARIA}/\N{GREEK SMALL LETTER ALPHA}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER ALPHA WITH PSILI AND VARIA AND PROSGEGRAMMENI}/\N{GREEK SMALL LETTER ALPHA}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER ALPHA WITH TONOS}/\N{GREEK SMALL LETTER ALPHA}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER ALPHA WITH VARIA}/\N{GREEK SMALL LETTER ALPHA}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER ALPHA WITH VRACHY}/\N{GREEK SMALL LETTER ALPHA}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER BETA}/\N{GREEK SMALL LETTER BETA}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER CHI}/\N{GREEK SMALL LETTER CHI}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER DELTA}/\N{GREEK SMALL LETTER DELTA}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER EPSILON}/\N{GREEK SMALL LETTER EPSILON}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER EPSILON WITH DASIA}/\N{GREEK SMALL LETTER EPSILON}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER EPSILON WITH DASIA AND OXIA}/\N{GREEK SMALL LETTER EPSILON}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER EPSILON WITH DASIA AND VARIA}/\N{GREEK SMALL LETTER EPSILON}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER EPSILON WITH OXIA}/\N{GREEK SMALL LETTER EPSILON}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER EPSILON WITH PSILI}/\N{GREEK SMALL LETTER EPSILON}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER EPSILON WITH PSILI AND OXIA}/\N{GREEK SMALL LETTER EPSILON}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER EPSILON WITH PSILI AND VARIA}/\N{GREEK SMALL LETTER EPSILON}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER EPSILON WITH TONOS}/\N{GREEK SMALL LETTER EPSILON}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER EPSILON WITH VARIA}/\N{GREEK SMALL LETTER EPSILON}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER ETA}/\N{GREEK SMALL LETTER ETA}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER ETA WITH DASIA}/\N{GREEK SMALL LETTER ETA}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER ETA WITH DASIA AND OXIA}/\N{GREEK SMALL LETTER ETA}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER ETA WITH DASIA AND OXIA AND PROSGEGRAMMENI}/\N{GREEK SMALL LETTER ETA}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER ETA WITH DASIA AND PERISPOMENI}/\N{GREEK SMALL LETTER ETA}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER ETA WITH DASIA AND PERISPOMENI AND PROSGEGRAMMENI}/\N{GREEK SMALL LETTER ETA}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER ETA WITH DASIA AND PROSGEGRAMMENI}/\N{GREEK SMALL LETTER ETA}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER ETA WITH DASIA AND VARIA}/\N{GREEK SMALL LETTER ETA}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER ETA WITH DASIA AND VARIA AND PROSGEGRAMMENI}/\N{GREEK SMALL LETTER ETA}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER ETA WITH OXIA}/\N{GREEK SMALL LETTER ETA}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER ETA WITH PROSGEGRAMMENI}/\N{GREEK SMALL LETTER ETA}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER ETA WITH PSILI}/\N{GREEK SMALL LETTER ETA}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER ETA WITH PSILI AND OXIA}/\N{GREEK SMALL LETTER ETA}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER ETA WITH PSILI AND OXIA AND PROSGEGRAMMENI}/\N{GREEK SMALL LETTER ETA}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER ETA WITH PSILI AND PERISPOMENI}/\N{GREEK SMALL LETTER ETA}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER ETA WITH PSILI AND PERISPOMENI AND PROSGEGRAMMENI}/\N{GREEK SMALL LETTER ETA}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER ETA WITH PSILI AND PROSGEGRAMMENI}/\N{GREEK SMALL LETTER ETA}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER ETA WITH PSILI AND VARIA}/\N{GREEK SMALL LETTER ETA}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER ETA WITH PSILI AND VARIA AND PROSGEGRAMMENI}/\N{GREEK SMALL LETTER ETA}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER ETA WITH TONOS}/\N{GREEK SMALL LETTER ETA}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER ETA WITH VARIA}/\N{GREEK SMALL LETTER ETA}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER GAMMA}/\N{GREEK SMALL LETTER GAMMA}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER IOTA}/\N{GREEK SMALL LETTER IOTA}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER IOTA WITH DASIA}/\N{GREEK SMALL LETTER IOTA}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER IOTA WITH DASIA AND OXIA}/\N{GREEK SMALL LETTER IOTA}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER IOTA WITH DASIA AND PERISPOMENI}/\N{GREEK SMALL LETTER IOTA}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER IOTA WITH DASIA AND VARIA}/\N{GREEK SMALL LETTER IOTA}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER IOTA WITH DIALYTIKA}/\N{GREEK SMALL LETTER IOTA}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER IOTA WITH MACRON}/\N{GREEK SMALL LETTER IOTA}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER IOTA WITH OXIA}/\N{GREEK SMALL LETTER IOTA}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER IOTA WITH PSILI}/\N{GREEK SMALL LETTER IOTA}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER IOTA WITH PSILI AND OXIA}/\N{GREEK SMALL LETTER IOTA}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER IOTA WITH PSILI AND PERISPOMENI}/\N{GREEK SMALL LETTER IOTA}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER IOTA WITH PSILI AND VARIA}/\N{GREEK SMALL LETTER IOTA}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER IOTA WITH TONOS}/\N{GREEK SMALL LETTER IOTA}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER IOTA WITH VARIA}/\N{GREEK SMALL LETTER IOTA}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER IOTA WITH VRACHY}/\N{GREEK SMALL LETTER IOTA}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER KAPPA}/\N{GREEK SMALL LETTER KAPPA}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER LAMDA}/\N{GREEK SMALL LETTER LAMDA}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER MU}/\N{GREEK SMALL LETTER MU}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER NU}/\N{GREEK SMALL LETTER NU}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER OMEGA}/\N{GREEK SMALL LETTER OMEGA}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER OMEGA WITH DASIA}/\N{GREEK SMALL LETTER OMEGA}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER OMEGA WITH DASIA AND OXIA}/\N{GREEK SMALL LETTER OMEGA}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER OMEGA WITH DASIA AND OXIA AND PROSGEGRAMMENI}/\N{GREEK SMALL LETTER OMEGA}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER OMEGA WITH DASIA AND PERISPOMENI}/\N{GREEK SMALL LETTER OMEGA}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER OMEGA WITH DASIA AND PERISPOMENI AND PROSGEGRAMMENI}/\N{GREEK SMALL LETTER OMEGA}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER OMEGA WITH DASIA AND PROSGEGRAMMENI}/\N{GREEK SMALL LETTER OMEGA}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER OMEGA WITH DASIA AND VARIA}/\N{GREEK SMALL LETTER OMEGA}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER OMEGA WITH DASIA AND VARIA AND PROSGEGRAMMENI}/\N{GREEK SMALL LETTER OMEGA}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER OMEGA WITH OXIA}/\N{GREEK SMALL LETTER OMEGA}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER OMEGA WITH PROSGEGRAMMENI}/\N{GREEK SMALL LETTER OMEGA}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER OMEGA WITH PSILI}/\N{GREEK SMALL LETTER OMEGA}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER OMEGA WITH PSILI AND OXIA}/\N{GREEK SMALL LETTER OMEGA}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER OMEGA WITH PSILI AND OXIA AND PROSGEGRAMMENI}/\N{GREEK SMALL LETTER OMEGA}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER OMEGA WITH PSILI AND PERISPOMENI}/\N{GREEK SMALL LETTER OMEGA}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER OMEGA WITH PSILI AND PERISPOMENI AND PROSGEGRAMMENI}/\N{GREEK SMALL LETTER OMEGA}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER OMEGA WITH PSILI AND PROSGEGRAMMENI}/\N{GREEK SMALL LETTER OMEGA}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER OMEGA WITH PSILI AND VARIA}/\N{GREEK SMALL LETTER OMEGA}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER OMEGA WITH PSILI AND VARIA AND PROSGEGRAMMENI}/\N{GREEK SMALL LETTER OMEGA}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER OMEGA WITH TONOS}/\N{GREEK SMALL LETTER OMEGA}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER OMEGA WITH VARIA}/\N{GREEK SMALL LETTER OMEGA}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER OMICRON}/\N{GREEK SMALL LETTER OMICRON}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER OMICRON WITH DASIA}/\N{GREEK SMALL LETTER OMICRON}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER OMICRON WITH DASIA AND OXIA}/\N{GREEK SMALL LETTER OMICRON}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER OMICRON WITH DASIA AND VARIA}/\N{GREEK SMALL LETTER OMICRON}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER OMICRON WITH OXIA}/\N{GREEK SMALL LETTER OMICRON}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER OMICRON WITH PSILI}/\N{GREEK SMALL LETTER OMICRON}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER OMICRON WITH PSILI AND OXIA}/\N{GREEK SMALL LETTER OMICRON}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER OMICRON WITH PSILI AND VARIA}/\N{GREEK SMALL LETTER OMICRON}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER OMICRON WITH TONOS}/\N{GREEK SMALL LETTER OMICRON}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER OMICRON WITH VARIA}/\N{GREEK SMALL LETTER OMICRON}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER PHI}/\N{GREEK SMALL LETTER PHI}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER PI}/\N{GREEK SMALL LETTER PI}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER PSI}/\N{GREEK SMALL LETTER PSI}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER RHO}/\N{GREEK SMALL LETTER RHO}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER RHO WITH DASIA}/\N{GREEK SMALL LETTER RHO}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER SIGMA}/\N{GREEK SMALL LETTER SIGMA}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER TAU}/\N{GREEK SMALL LETTER TAU}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER THETA}/\N{GREEK SMALL LETTER THETA}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER UPSILON}/\N{GREEK SMALL LETTER UPSILON}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER UPSILON WITH DASIA}/\N{GREEK SMALL LETTER UPSILON}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER UPSILON WITH DASIA AND OXIA}/\N{GREEK SMALL LETTER UPSILON}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER UPSILON WITH DASIA AND PERISPOMENI}/\N{GREEK SMALL LETTER UPSILON}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER UPSILON WITH DASIA AND VARIA}/\N{GREEK SMALL LETTER UPSILON}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER UPSILON WITH DIALYTIKA}/\N{GREEK SMALL LETTER UPSILON}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER UPSILON WITH MACRON}/\N{GREEK SMALL LETTER UPSILON}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER UPSILON WITH OXIA}/\N{GREEK SMALL LETTER UPSILON}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER UPSILON WITH TONOS}/\N{GREEK SMALL LETTER UPSILON}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER UPSILON WITH VARIA}/\N{GREEK SMALL LETTER UPSILON}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER UPSILON WITH VRACHY}/\N{GREEK SMALL LETTER UPSILON}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER XI}/\N{GREEK SMALL LETTER XI}/g;
    $retkey =~ s/\N{GREEK CAPITAL LETTER ZETA}/\N{GREEK SMALL LETTER ZETA}/g;

  	return $retkey;
  }