'''
Consumes a file output by find_foreign.py and wraps each matched string
in <foreig xml:lang="whatever"> ... </foreign>.
'''
import re
import pdb

greek_reg = re.compile(u'''(
  -?
  [\u0370-\u03ff\u1d26-\u1ffe\u2019]+
  (?:
    (?:[\u0370-\u03ff\u1d26-\u1ffe1\.,\-\s\u2019]+)?
    [\u0370-\u03ff\u1d26-\u1ffe\.\-\u2019]+)?
)''', re.X)
hebrew_reg = re.compile(u'((?:[\u0591-\u05f4]|[\ufb1d-\ufb4f])+)')


splitter = lambda x: x.split('\t')
flitter = lambda x: x[2] != 'head' and x[2] != 'parent'
fourth = lambda x: x[3]

def get_fixmes(fh):
    lines = map(lambda x: x.strip(), fh.readlines())
    fixmes1 = map(fourth, filter(flitter, map(splitter, lines)))
    fixmes2 = map(lambda x: x.replace('<', '&lt;'), fixmes1)
    return map(lambda x: x.decode('utf-8'), fixmes2)

def apply_fixmes(fixmes, unfixed, fixed):
    if len(fixmes) == 0:
        return fixed + unfixed
    fixme = fixmes[0]
    start = unfixed.find(fixme)
    end = start + len(fixme)
    if start == -1:
        pdb.set_trace()
        raise Exception
    seen = unfixed[:start]
    newly_fixed = hebrew_reg.sub(r'<foreign xml:lang="heb">\1</foreign>', unfixed[start:end])
    return apply_fixmes(fixmes[1:], unfixed[end:], fixed + seen + newly_fixed)


if __name__ == '__main__':
    doc_string = open('abbott-smith.tei.xml').read().decode('utf-8')
    fixmes = get_fixmes(open('fixmes.tsv'))
    fixed_doc = apply_fixmes(fixmes, doc_string, '')
    ofh = open('abbott-smith.tei.xml', 'w')
    ofh.write(fixed_doc.encode('utf-8'))
    ofh.close()
