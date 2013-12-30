Markup Instructions for Contributors
============================

This file describes and illustrates the TEI markup practices employed in this project. To contribute you must be familiar with the basics of how XML works. For an introduction, see http://www.w3schools.com/xml/xml_whatis.asp. 

This project follows several markup practices. Here are several of the most important ones:

Structure of Lexicon Entries
----------------------------------

Every entry is nested in an `<entry>` element with an id (@n), which should be the Greek lemma, with a pipe `|` separating it from any Strong's numbers. If there are multiple options at the head of the entry, choose the first.

Nested within `<entry>` are several elements: `<note type="occurrencesNT">`, `<form>`, `<gramGrp>`, `<etym>`, `<sense>`, and `<re>`. `<note type="occurrencesNT">` and `<form>` only appear once in each entry. Note that all text in the entry must fall within one of these six elements, not directly under `<entry>`. 

Specific Elements of Each Entry
---------------------------------------

### `<note type="occurrencesNT">`

When we have the data, we like to include occurrence data in the Greek NT for each lemma. See the [word_list.md](https://github.com/translatable-exegetical-tools/Abbott-Smith/blob/master/word_list.md) for this data.

### `<form>` 

Typically this will include all information prior to the first definition. A comma usually separates the form information from sense information. 

### `<gramGrp>`

This element is for gramatical information that does not involve the form of the word. If some grammatical information is given in the entry such as part of speech `<pos>` or some other subcategorization `<subc>`, it would be marked up in this way: 

    <gramGrp><pos>verb</pos>, <subc>intransitive</subc></gramGrp>

### `<etym>`

Etymology concerns the history of a word. Abbott-Smith regularly gives information about the derivation of a word and its use in the Septuagint. This information should fall within `<sense>`. For derivation information (usually marked by a less-than sign and another Greek word), it should be within `<seg type="derivation">`. Information about usage in the Septuagint should be within `<seg type="septuagint">`.
 
### `<sense>`

Anything related to the meaning of a word should occur in this element. Glosses (usually anything in italics) should also be within `<gloss>`. If sense numbers are given, include it in @n in `<sense>` but not in the text as it is written in the lexicon. That can be included later using XSL. Ideally all `<sense>` elements should be nested within a single `<sense>` element.

### `<re>`

At the end of many entries is information about related words. In TEI, this information is placed within  `<re>` for "related entry."

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
 
### `<ref>`

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

* For italics that are not for a definition of the current entry, use `<emph>`.  This includes abbreviations of published sources as well as definitions of related terms.

EXAMPLE MARKUP
=

    <entry n="ἀγαθός|G18">
      <note type="occurrencesNT">102</note>
      <form>
      	<orth>ἀγαθός, -ή, -όν</orth>, 
      </form>
      <etym>
  		<seg class="septuagint">[in LXX chiefly for <foreign xml:lang="heb">טוֹב</foreign> ;]</seg>
	  </etym>
  	  <sense>in general, <gloss>good</gloss>, in physical and in moral sense, used of persons, things, acts, conditions, etc., applied to that which is regarded as "perfect in its kind, so as to produce pleasure and satisfaction, . . . that which, in itself good, is also at once for the good and the advantage of him who comes in contact with it" (Cremer, 3): <foreign xml:lang="grc">γῆ</foreign>, <ref osisRef="Luke.8.8">Lk 8:8</ref>; <foreign xml:lang="grc">δένδρον</foreign>, <ref osisRef="Matt.7.18">Mt 7:18</ref>; <foreign xml:lang="grc">καρδία</foreign>, <ref osisRef="Luke.8.15">Lk 8:15</ref>; <foreign xml:lang="grc">δόσις</foreign>, <ref osisRef="Jas.1.17">Ja 1:17</ref>; <foreign xml:lang="grc">μέρις</foreign>, <ref osisRef="Luke.10.42">Lk 10:42</ref>; <foreign xml:lang="grc">ἔργον</foreign> (freq. in Pl.), <ref osisRef="Phil.1.6">Phl 1:6</ref>; <foreign xml:lang="grc">ἐλπίς</foreign>, <ref osisRef="2Thess.2.16">II Th 2:16</ref>; <foreign xml:lang="grc">θησαυρός</foreign>, <ref osisRef="Mat.12.35">Mt 12:35</ref>; <foreign xml:lang="grc">μνεία</foreign>, <ref osisRef="1Thess.3.6">I Th 3:6</ref> (cf. <ref osisRef="2Macc.7.20">II Mac 7·20</ref>); as subst., <foreign xml:lang="grc">τὸ ἀ</foreign>, that which is morally good, beneficial, acceptable to God, <ref osisRef="Rom.12.2">Ro 12:2</ref>; <foreign xml:lang="grc">ἐργάζεσθαι τὸ ἀ</foreign>, <ref osisRef="Rom.2.10">Ro 2:10</ref>, <ref osisRef="Eph.4.28">Eph 4:28</ref>; <foreign xml:lang="grc">πράσσειν</foreign>, <ref osisRef="Rom.9.11">Ro 9:11</ref>, <ref osisRef="2Cor.5.10">II Co 5:10</ref>; <foreign xml:lang="grc">διώκειν</foreign>, <ref osisRef="1Thess.5.15">I Th 5:15</ref>; <foreign xml:lang="grc">μιμεῖσθαι</foreign>, <ref osisRef="3John.1.11">III Jo 11</ref>; <foreign xml:lang="grc">κολλᾶσθαι τῷ ἀ</foreign>, <ref osisRef="Rom.12.9">Ro 12:9</ref>; <foreign xml:lang="grc">ερωτᾶν περὶ τοῦ ἀ.</foreign>, <ref osisRef="Matt.19.17">Mt 19:17</ref>; <foreign xml:lang="grc">διάκονος εἰς τὸ ἀ.</foreign>, <ref osisRef="Rom.13.4">Ro 13:4</ref>; <foreign xml:lang="grc">τὸ ἀ. σου</foreign>, <gloss>thy favour, benefit</gloss>, <ref osisRef="Phlm.1.14">Phm 14</ref>; pl., <foreign xml:lang="grc">τὸ ἀ.</foreign>, of goods, possessions, <ref osisRef="Luke.12.18">Lk 12:18</ref>; of spiritual benefits, <ref osisRef="Rom.10.15">Ro 10:15</ref>, <ref osisRef="Heb.9.11">He 9:11</ref>, <ref osisRef="Heb.10.1">10:1</ref>. <foreign xml:lang="grc">ἀ</foreign> is opp. to <foreign xml:lang="grc">πονήρος</foreign>, <ref osisRef="Matt.5.45">Mt 5:45</ref>, <ref osisRef="Matt.20.15">20:5</ref>; <foreign xml:lang="grc">κακός</foreign>, <ref osisRef="Rom.7.19">Ro 7:19</ref>; <foreign xml:lang="grc">φαῦλος</foreign>, <ref osisRef="Rom.9.11">Ro 9:11</ref>, <ref osisRef="2Cor.5.10">II Co 5:10</ref> (cf. MM, <emph>VGT</emph>, s.v.).</sense>
      <re>
      	<emph>SYN.</emph>: <foreign xml:lang="grc">καλός, δίκαιος</foreign>. <foreign xml:lang="grc">κ.</foreign> properly refers to <gloss>goodliness</gloss> as manifested in form: <foreign xml:lang="grc">ἀ.</foreign> to inner excellence (cf. the cl. <foreign xml:lang="grc">καλὸς κἀγαθός</foreign> and <foreign xml:lang="grc">ἐν καρδία κ. καὶ ἀ.</foreign>, <ref osisRef="Luke.8.15">Lk 8:15</ref>). In <ref osisRef="Rom.5.7">Ro 5:7</ref>, where it is contrasted with <foreign xml:lang="grc">δ.</foreign>, <foreign xml:lang="grc">ἀ.</foreign> implies a kindliness and attractiveness not necessarily possessed by the <foreign xml:lang="grc">δίκαιος</foreign>, who merely measures up to a high standard of rectitude (cf. <foreign xml:lang="grc">ἀγαθωσύνη</foreign>).
      </re>
    </entry>