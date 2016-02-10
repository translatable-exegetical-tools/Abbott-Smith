#/bin/bash

### Validates the TEI file against the schema. 
#xmllint --valid --noout ../abbott-smith.tei.xml --schema http://www.crosswire.org/OSIS/teiP5osis.2.5.0.xsd

### Copy current xml file into this directory.
cp ../abbott-smith.tei.xml abbott-smith.tei-current.xml

### Check if XML file is well-formed
xmllint -noout abbott-smith.tei-current.xml
 
### Removes frontmatter, page breaks, notes, headings, and comments
xsltproc  --output abbott-smith.tei-simple.xml abbott-smith-module.xsl abbott-smith.tei-current.xml

# Remove namespace junk
perl -pi -w -e 's/ xmlns=\"\" xmlns:TEI=\"http:\/\/www.crosswire.org\/2013\/TEIOSIS\/namespace\"//g;' abbott-smith.tei-simple.xml

# Change <entry> to <entryFree>
perl -pi -w -e 's/<entry/<entryFree/g;' abbott-smith.tei-simple.xml
perl -pi -w -e 's/entry>/entryFree>/g;' abbott-smith.tei-simple.xml

# Make sure there is a space after the sense number
perl -pi -w -e 's/<sense n=\"([^\"]+)\"/<sense n=\"$1 \"/g;' abbott-smith.tei-simple.xml


# Remove unwanted XMLNS declarations
perl -pi -w -e 's/<foreign xmlns=\"http:\/\/www.crosswire.org\/2013\/TEIOSIS\/namespace\" /<foreign /g;' abbott-smith.tei-simple.xml
perl -pi -w -e 's/<hi xmlns=\"\" xmlns:TEI=\"http:\/\/www.crosswire.org\/2013\/TEIOSIS\/namespace\" /<hi /g;' abbott-smith.tei-simple.xml

# Remove div elements
perl -pi -w -e 's/<\/div>//g;' abbott-smith.tei-simple.xml
perl -pi -w -e 's/<div([^>]+)>//g;' abbott-smith.tei-simple.xml

# Create two files: one for strongs ids and one for original Greek ids
cp abbott-smith.tei-simple.xml abbott-smith.tei-strongs.xml
cp abbott-smith.tei-simple.xml abbott-smith.tei-greek.xml

## Work on Strong's version

# Add 0 padding
perl -pi -w -e 's/(\"|\|)G(\d\d\d\d)(\"|\|)/$1G$2$3/g;' abbott-smith.tei-strongs.xml
perl -pi -w -e 's/(\"|\|)G(\d\d\d)(\"|\|)/$1G0$2$3/g;' abbott-smith.tei-strongs.xml
perl -pi -w -e 's/(\"|\|)G(\d\d)(\"|\|)/$1G00$2$3/g;' abbott-smith.tei-strongs.xml
perl -pi -w -e 's/(\"|\|)G(\d)(\"|\|)/$1G000$2$3/g;' abbott-smith.tei-strongs.xml

# Remove Greek from entry@n
#perl -pi -w -e 's/<entry n=\"([^G]+)G/<entry n=\"G/g;' abbott-smith.tei-strongs.xml
perl -pi -w -e 's/<entryFree n=\"([^G]+)G/<entryFree n=\"G/g;' abbott-smith.tei-strongs.xml

# Replace G with 0
perl -pi -w -e 's/\"G/\"0/g;' abbott-smith.tei-strongs.xml
perl -pi -w -e 's/\|G/\|0/g;' abbott-smith.tei-strongs.xml

# Fix problem case (?)
perl -pi -w -e 's/\|(\d\d\d)\"/\|00$1\"/g;' abbott-smith.tei-strongs.xml
perl -pi -w -e 's/\|(\d\d\d\d)\"/\|0$1\"/g;' abbott-smith.tei-strongs.xml

## Work on Greek version

# Remove Strong's numbers from from entry@n
perl -pi -w -e 's/\|G(\d+)//g;' abbott-smith.tei-greek.xml
