from lxml import etree
import re
import pdb

delenda = "{http://www.crosswire.org/2013/TEIOSIS/namespace}"

'''
0591
05f4

fb1d
fb4f
'''

def node_singleton(xpath):
    def func(node):
        res = xpath(node)
        if res is None or len(res) == 0:
            return None
        return res[0]
    return func

def get_text_parent(text_node):
    tp = text_node.getparent()
    if text_node == tp.tail:
        return tp.getparent()
    return tp

greek_re = re.compile(u'[\u0374-\u03ff]')
hebrew_re = re.compile(u'[\u0591-\u05f4]|[\ufb1d-\ufb4f]')

foreign_match = lambda text_node: greek_re.search(text_node) or hebrew_re.search(text_node)

NSMAP = {
  'tei' : "http://www.crosswire.org/2013/TEIOSIS/namespace",
  'xsi' : "http://www.w3.org/2001/XMLSchema-instance",
}

ourdiv_xp = etree.XPath('/tei:TEI/tei:text/tei:body/tei:div[1]', namespaces=NSMAP) 
text_xp = etree.XPath('self::*/descendant::text()[not(parent::tei:foreign)][not(parent::tei:orth)]', namespaces=NSMAP)
parent_xp = etree.XPath('self::node()/parent::*', namespaces=NSMAP)
parent = node_singleton(parent_xp)
ancestor_entry_xp = etree.XPath('ancestor::tei:entry[1]', namespaces=NSMAP)
ancestor_entry = node_singleton(ancestor_entry_xp)
thispage_xp = etree.XPath('preceding::tei:pb[1]/@n', namespaces=NSMAP)


if __name__ == '__main__':
    doco = etree.parse(open('abbott-smith.tei.xml'))
    ourdiv = ourdiv_xp(doco)[0]
    texty = text_xp(ourdiv)
    
    output = []
    
    output.append(['page', 'entry', 'parent', 'data'])
    for text_node in texty:
        if foreign_match(text_node):
            parent_elem = get_text_parent(text_node)
            if parent_elem.tag[:len(delenda)] == delenda:
                parent_elem_tag = parent_elem.tag[len(delenda):]
            else:
                parent_elem_tag = parent_elem.tag
            page_no = thispage_xp(parent_elem)[0]
            entry = ancestor_entry(parent_elem)
            if entry is not None:
                entry_name = ancestor_entry_xp(parent_elem)[0].get('n')
            else:
                entry_name = ''
            output.append([page_no, entry_name, parent_elem_tag, text_node])
    for item in output:
        print '\t'.join(item).encode('utf-8')
