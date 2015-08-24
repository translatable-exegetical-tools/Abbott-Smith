#/bin/bash

### Validates the TEI file against the schema. 
# xmllint --valid --noout ../abbott-smith.tei.xml --schema http://www.crosswire.org/OSIS/teiP5osis.2.5.0.xsd
 
### Removes comments from file that are not needed for a module.
#perl ../releases/abbott-smith.pl
### Removes frontmatter and page breaks
#xsltproc -o abbott-smith.tei-simple.xml abbott-smith-clean_tei.xsl abbott-smith.tei-current.xml

### Bundles source xml file and conf file.
#zip abbott-smith.tei-current.zip abbott-smith.tei-simple.xml mods.d/abbottsmith.conf

### Compiles the lexicon.
tei2mod modules/lexdict/zld/abbottsmith/ abbott-smith.tei-simple.xml -z
#tei2mod modules/lexdict/zld/abbottsmith/ abbott-smith.tei-simple.xml

### Bundles the module.  
#zip abbott-smith.$(date +%Y-%m-%d).zip ./mods.d/abbottsmith.conf ./modules/lexdict/zld/abbottsmith/*

#rm abbott-smith.tei-simple.xml 
#rm abbott-smith.tei-current.xml
