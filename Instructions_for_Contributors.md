Markup Instructions for Contributors
=

This file describes and illustrates the TEI markup practices employed in this project. To contribute you must be familiar with the basics of how XML works. For an introduction, see http://www.w3schools.com/xml/xml_whatis.asp. 

This project follows several markup practices. Here are several of the most important ones:

Structure of Lexicon Entries
-

Every entry is nested in an `<entry>` element with an id (@n), which should be the Greek lemma, with a pipe `|` separating it from any Strong's numbers. If there are multiple options at the head of the entry, choose the first.

Nested within `<entry>` are several elements: `<note type="occurrencesNT">`, `<form>`, `<gramGrp>`, and `<sense>`. The first two only appear once. The last one may appear multiple times if there are multiple sense numbers. Note that all text in the entry must fall within one of these three elements, not directly under `<entry>`. 

Specific Elements of Each Entry
-

### `<note type="occurrencesNT">`

When we have the data, we like to include occurrence data in the Greek NT for each lemma. See the word_list.md for this data.

### `<form>` 

Typically this will include all information prior to the first definition. A comma usually separates the form information from sense information. 

### `<gramGrp>`

This element is for gramatical information that does not involve the form of the word. If some grammatical information is given in the entry such as part of speech `<pos>` or some other subcategorization `<subc>`, it would be marked up in this way: 

    <gramGrp><pos>verb</pos>, <subc>intransitive</subc></gramGrp>
 
### `<sense>`

Anything related to the meaning of a word should occur in this element. Glosses (usually anything in italics) should also be within `<gloss>`. If sense numbers are given, include it in @n in `<sense>` but not in the text as it is written in the lexicon. That can be included later using XSL. Ideally all `<sense>` elements should be nested within a single `<sense>` element.

Other Elements
-

### `<pb />`

All page breaks are included in the file. After cleaning up a page, add your initials to the commented @typed field after the `<pb>` element. After checking a page, do the same under @checked. This is not valid TEI, so the attributes are commented out outside the `<pb>` element. A completed page should look like this: 

    <pb n="1" /> <!-- typed="ABC" checked="XYZ" -->

### <foreign>

All text is assumed to be English (the analysis language) unless otherwise specified (or in `<orth>`. The `<foreign>` element can be used for this purpose. Examples include: 

* Greek: `<foreign xml:lang="grc">Ἀαρών</foreign>`

* Aramaic: `<foreign xml:lang="arc">אַבָּא</foreign>`

* Hebrew: `<foreign xml:lang="heb">אַהֲרוֹן</foreign>`

* Latin: `<foreign xml:lang="lat">diligo</foreign>`

If you do not know how to type a given language, such as Hebrew, include the following: `<foreign xml:lang="heb">Hebrew</foreign>`. Someone else can add the Hebrew later.
 
### <ref>

Biblical references should be marked up using this element. 

Although Abbott-Smith uses superscript numbers for verses, this project does not. Instead, we use a colon to separate chapter and verse. 

For biblical book names in @osisRef, use SBL abbreviations. See http://www.textonline.org/textstyleguidelines.

Examples include: 

    <ref osisRef="Luke.1.5">Lk 1:5</ref>

    <ref osisRef="Mark.1.14-Mark.1.15">Mk 1:14-15</ref>

    <ref osisRef="1Chr.24.3 1Chr.24.10">I Ch 24:3, 10</ref>

Recurring Text
-

* For a dagger use † (see Preface of the lexicon for the meaning of this symbol)

* For \< use `&lt;`

* For \> use `&rt;`

* For superscript, use: `<hi rend="superscript">`

* For subscript, use: `<hi rend="subscript">`

* For an ampersand use `&amp;`

* For paragraphs use `<p>`, and for line breaks within elements use `<lb />`

* For italics that are not for a definition of the current entry, use `<emph>`.  This includes abbreviations of published sources as well as definitions of related terms. For examples, see `<entry n="Ἀβαδδών">` and `<entry n="ἀγάπη">`.

EXAMPLE MARKUP
=

    <entry n="α"> 
      <form>	<foreign xml:lang="grc">Α, α, ἄλφα</foreign> (q.v.), <foreign xml:lang="grc">τό</foreign>, indecl., </form>
      <sense><gloss>alpha</gloss>, the first letter of the Greek alphabet. As a numeral, <foreign xml:lang="grc">ά</foreign> = 1, <foreign xml:lang="grc">α</foreign> = 1000. As a prefix, it appears to have at least two and perhaps three distinct senses:
        <sense n="1"><foreign xml:lang="grc">ἀ-</foreign> (before a vowel, <foreign xml:lang="grc">ἀν-</foreign>) <gloss>negative</gloss>, as in <foreign xml:lang="grc">ἄ-γνωστος, ἄ-δικος</foreign>. </sense> 
        <sense n="2"><foreign xml:lang="grc">ἀ-, ἁ-</foreign> <gloss>copulative</gloss>, indicating community and fellowship, as in <foreign xml:lang="grc">ἁ-πλοῦς, ἀ-κολουθέω, ἀ-δελφός</foreign>. </sense> 
        <sense n="3">An intensive force (LS, s. <foreign xml:lang="grc">α</foreign>), as in <foreign xml:lang="grc">ἀ-τενίζω</foreign> is sometimes assumed (but v. Boisacq, s.v.).</sense> 
      </sense>
    </entry>
    
    <entry n="Ἀαρών"> 
      <note type="occurrencesNT">5</note>
      <form><foreign xml:lang="grc">Ἀαρών</foreign> (Heb. <foreign xml:lang="heb">אַהֲרוֹן</foreign>), indecl. (in FlJ, <foreign xml:lang="grc">-ῶνος</foreign>), </form>
      <sense><gloss>Aaron</gloss> (<ref osisRef="Exod.4.14">Ex 4:14</ref>, al.): <ref osisRef="Luke.1.5">Lk 1:5</ref>, <ref osisRef="Acts.7.40">Ac 7:40</ref>, <ref osisRef="Heb.5.4">He 5:4</ref>, <ref osisRef="Heb.7.11">7:11</ref>, <ref osisRef="Heb.9.4">9:4</ref>.† </sense>
    </entry> 

    <entry n="ἁγνῶς|G55">
      <note type="occurrencesNT">1</note>
      <form>* <orth>ἁγνῶς</orth> (&lt; <foreign xml:lang="grc">ἁγνός</foreign>), </form>
      <gramGrp><pos>adv.</pos>, </gramGrp>
      <sense><gloss>purely</gloss>, <gloss>with pure motives</gloss>: <ref osisRef="Phil.1.17">Phl 1:17</ref>. †</sense>
    </entry>

ENTRY TEMPLATE
=

    <entry n=""> 
      <form><foreign xml:lang="grc"></foreign></form>
      <gramGrp></gramGrp>
      <sense>
      <gloss></gloss>
      <ref osisRef=""></ref>
      </sense>
      <sense n="1">†</sense> 
    </entry> 