#/bin/bash

### Bundles source xml file and conf file.
zip abbottsmithstrongs-current.zip abbott-smith.tei-strongs.xml mods.d/abbottsmithstrongs.conf

### Compiles the lexicon.
tei2mod modules/lexdict/zld/abbottsmithstrongs/ abbott-smith.tei-strongs.xml -z
#tei2mod modules/lexdict/zld/abbottsmith/ abbott-smith.tei-simple.xml

### Bundles the module.
zip sword.zip ./mods.d/abbottsmithstrongs.conf ./modules/lexdict/zld/abbottsmithstrongs/*

#rm abbott-smith.tei-simple.xml 
#rm abbott-smith.tei-current.xml
