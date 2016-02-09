#/bin/bash

### Bundles source xml file and conf file.
zip abbott-smith.tei-current.zip abbott-smith.tei-simple.xml mods.d/abbottsmith.conf

### Compiles the lexicon.
tei2mod modules/lexdict/zld/abbottsmithstrongs/ abbott-smith.tei-simple.xml -z
#tei2mod modules/lexdict/zld/abbottsmith/ abbott-smith.tei-simple.xml

### Bundles the module.
zip sword.zip ./mods.d/abbottsmith.conf ./modules/lexdict/zld/abbottsmith/*

#rm abbott-smith.tei-simple.xml 
#rm abbott-smith.tei-current.xml
