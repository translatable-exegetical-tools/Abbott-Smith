xquery version "3.0";
declare copy-namespaces no-preserve, no-inherit;
declare namespace text="urn:oasis:names:tc:opendocument:xmlns:text:1.0";
declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare option output:method   "xml";
declare option output:indent   "yes";

<abbott-smith>
{
for tumbling window $w in doc('content.xml')//text:p
start $s at $spos previous $sprev next $snext 
when $s[@text:style-name='P3']
end $e at $epos previous $eprev next $enext when true()
let $p7 := $s/following-sibling::text:p[string(.) != ""][1]
let $strongs := $s/text:span[@text:style-name='T16']
return 
    <entry strongs="{$strongs}">
      {
        $p7//text(),
        <s>{ string($s) }</s>
      }
    </entry>
}
</abbott-smith>

