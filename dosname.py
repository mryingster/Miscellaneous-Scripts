#!/usr/bin/env python

def getFileBaseName(fileName):
    import os
    return os.path.basename(fileName)

def getFileExtension(fileName):
    import re
    if "." not in fileName: return ""
    return re.compile('.*(\.[^\.]{3}).*').sub(r'\1', getFileBaseName(fileName))

def getFileName(fileName):
    import re
    return re.compile('(.*)\.[^\.]*').sub(r'\1', getFileBaseName(fileName))

def uint16(int):
    return int % 2**16

def int32(int):
    int %= 2**32
    if int > 2**31: int -= 2**31
    return int

def uint64(int):
    return int % 2**64

def int64(int):
    int %= 2**64
    if int > 2**63: int -= 2**63
    return int

def checksum(name):
    i = 0
    checksum = 0

    for i in range(len(name)):
        checksum = checksum * 0x25 + ord(name[i])
        checksum = uint16(checksum)

    temp = checksum * 314159269
    temp = int32(temp)
    if temp < 0: temp *= -1

    temp -= uint64(int64(temp * 1152921497) >> 60) * 1000000007
    temp = uint16(temp)

    # reverse nibble order
    checksum = ((temp & 0xf000) >> 12)
    checksum |= ((temp & 0x0f00) >> 4)
    checksum |= ((temp & 0x00f0) << 4)
    checksum |= ((temp & 0x000f) << 12)

    return checksum

def main(*args):
    for arg in args:
        base = getFileName(arg)
        ext = getFileExtension(arg)
        dosName = "%s%X~1%s" % (base[:2].upper(), checksum(arg), ext.upper())
        print(dosName)

if __name__ == '__main__':
    import sys
    sys.argv.pop(0)
    main(*sys.argv)
