xquery version "3.0";
declare copy-namespaces no-preserve, no-inherit;
declare namespace text="urn:oasis:names:tc:opendocument:xmlns:text:1.0";
declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare option output:method   "xml";
declare option output:indent   "yes";

declare function local:ref($r)
{
  let $o := replace($r//text(),'[_:]','.')
  return <ref osisRef="{$o}">{ $o }</ref>
};

declare function local:spans($para)
{
    for $s in ($para/text() | $para//text:span)
    return
      typeswitch($s)
   	case element(text:span) return
	  if ($s[@text:style-name="T26"])
    	  then local:ref($s)
    	  else $s//text()	   
	case text() return $s
	default return ()
};

declare function local:p($p)
{
  let $s := string($p)
  let $s1 := substring($s, 1, 1)
  return
    if ($s1 eq "(") then
      <derivation>{ local:spans($p) }</derivation>
    else if ($s1 eq "[") then
      <septuagint>{ local:spans($p) }</septuagint>
    else
      <sense>{ local:spans($p) }</sense>
};

<abbott-smith>
 {
   for tumbling window $w in doc('abbott-smith.odt.content.xml')//text:p
   start $s at $spos next $snext 
   when $s[@text:style-name='P3']
   end $e at $epos next $enext 
   when $epos > $spos and $enext[@text:style-name='P3']
   let $pnext := $s/following-sibling::text:p[string(.) != ""][1]
   let $orth := normalize-space($pnext)
   let $lemma := normalize-space(replace($pnext,  '(\*)|(†)', ''))
   let $lexeme := replace(
                if (contains($lemma, ',')) 
                then substring-before($lemma, ',')
                else $lemma,
                "(-)",
                "")
   let $strongs := normalize-space($s/text:span[@text:style-name='T16'])
   return 
    <entry lemma="{ $lexeme }" osisID="{$strongs}">
        <form><orth>{ $orth }</orth></form>
        <window start="{$spos}" end="{$epos}">
        {
           for $p in $w
           where $p >> $pnext
             and exists($p//text())
           return local:p($p)
        }
        </window>
    </entry>
 }
</abbott-smith>