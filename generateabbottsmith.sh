#/bin/bash

# This validates the TEI file against the schema. 
xmllint --valid --noout abbott-smith.tei.xml --schema ~/Documents/Work/BibleTech/OSIS/osisCore.2.1.1.xsd
 
