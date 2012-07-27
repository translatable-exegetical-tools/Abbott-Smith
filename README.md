Abbott-Smith - Summary
======================

Abbott-Smith is a project to mark up the G. Abbott-Smith's *A Manual Greek Lexicon of the New Testament* (New York: Scribner's, 1922) using TEI. Contributors are welcome. This document records important source information and markup standards.

Source and Copyright
=

The PDF file with a text layer (manualgreeklexic00abborich.pdf) was obtained from http://archive.org/details/manualgreeklexic00abborich. Certain restrictions apply to the use of this file. These are included in the PDF file.

The lexicon (abbott-smith.tei.xml), including the marked up version in this repository, is in the public domain. 

Viewing and Downloading
=

View [the current release](http://www.textonline.org/files/abbott-smith/abbott-smith.current_release.xml) online or download the release from the DOwnloads page.

Contributing
=

All are welcome to contribute to this markup project. Those interested should send an email to editors at textonline dot org (deleting the spaces and replacing "at" and "dot" with the appropriate characters). 

Markup Information
=

All text from the lexicon will be included and marked up using CrossWire.org's iteration of TEI XML, which supports several features of OSIS XML that are relevant to biblical studies (especially biblical references). For helpful documentation on this iteration of TEI, see http://www.crosswire.org/wiki/TEI_Dictionaries. For the schema definition, see http://www.crosswire.org/OSIS/teiP5osis.1.4.xsd.

Note that until markup is complete, the file will not validate because the &lt;body> and &lt;div> elements cannot contain text (only certain elements), but the text layer provides such text. However, a validator can be used to identify other problems in the document and the raw text be deleted if one wishes to work with text that has already been cleaned up.

Changelog
=

2012/07/27 - First Release (v. 0.1): Includes pages iii-3 and entries for words occurring 1,000 times or more in the Greek NT. 

2012/05/10 - Moved markup instructions to PDF file

2012/05/09 - Initial upload with frontmatter and page numbers marked up
