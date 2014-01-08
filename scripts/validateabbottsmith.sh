#/bin/bash

# This validates the TEI file against the schema. 
xmllint --valid --noout ../abbott-smith.tei.xml --schema http://www.crosswire.org/OSIS/teiP5osis.2.5.0.xsd
 
