#!/usr/bin/env python
# -*- coding: utf8 -*-

#  Copyright (c) 2016 unfoldingWord
#  http://creativecommons.org/licenses/MIT/
#  See LICENSE file for details.
#
#  Contributors:
#  Jesse Griffin <jag3773@gmail.com>
#
# This script removes Hebrew vowels and cantilation.

import codecs

vowels = [u'\u05B0', u'\u05B1', u'\u05B2', u'\u05B3', u'\u05B4', u'\u05B5', u'\u05B6', u'\u05B7', u'\u05B8', u'\u05B9', u'\u05BA', u'\u05BB', u'\u05BC', u'\u05BD', u'\u05BE', u'\u05BF', u'\u05C0', u'\u05C1', u'\u05C2', u'\u05C3', u'\u05C4', u'\u05C5', u'\u05C6', u'\u05C7', u'\u05C8', u'\u05C9', u'\u05CA', u'\u05CB', u'\u05CC', u'\u05CD', u'\u05CE', u'\u05CF']
cant = [u'\u0590', u'\u0591', u'\u0592', u'\u0593', u'\u0594', u'\u0595', u'\u0596', u'\u0597', u'\u0598', u'\u0599', u'\u059A', u'\u059B', u'\u059C', u'\u059D', u'\u059E', u'\u059F',u'\u05A0', u'\u05A1', u'\u05A2', u'\u05A3', u'\u05A4', u'\u05A5', u'\u05A6', u'\u05A7', u'\u05A8', u'\u05A9', u'\u05AA', u'\u05AB', u'\u05AC', u'\u05AD', u'\u05AE', u'\u05AF']


def stripper(data):
    for c in cant:
        data = data.replace(c, '')
    for v in vowels:
        data = data.replace(v, '')
    return data


if __name__ == '__main__':
    f = codecs.open('../abbott-smith.tei.xml', 'r', encoding='utf-8').read()
    out = stripper(f)
    fnew = codecs.open('../abbott-smith.tei.xml', 'w', encoding='utf-8')
    fnew.write(out)
    fnew.close()
