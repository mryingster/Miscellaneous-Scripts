#!/usr/bin/env python
import sys

def readText(File):
    dict = {}
    with open(File, "rb") as fileIn:
        fileIn.seek(0, 0)
        for word in fileIn.readlines():
            #word = word.decode('latin-1')
            word = word.strip()
            dorw = "".join(sorted(word))

            if dorw in dict:
                anagram = dict[dorw]
                anagram.append(word)
                dict.update({dorw : anagram})
            else:
                dict.update({dorw : [word]})

    return dict

# Read in dictionary and group into anagrams
words = "/usr/share/dict/words"
anagram_dict = readText(words)

# Sort dictionary into sizes
sorted_dict = {}
for dorw in anagram_dict:
    # Skip anything that isn't an anagram
    if len(anagram_dict[dorw]) > 1:
        words = []
        for word in anagram_dict[dorw]:
            words.append(word)

        size = len(dorw)
        if size in sorted_dict:
            newwords = sorted_dict[size]
            newwords.append(words)
            # Sort entries by number of anagrams, fewest first
            newwords.sort(key=len)
            sorted_dict.update({size : newwords})
        else:
            sorted_dict.update({size : [words]})

# Print final dictionary of anagrams
longest=0
most=0
count=0
for size in sorted_dict:
    print("%d:" % size)
    longest=size
    for anagrams in sorted_dict[size]:
        count += 1
        if len(anagrams) > most: most=len(anagrams)
        for word in anagrams:
            print(word),
        print("")

# Print Stats
print("\nLongest Anagram: %d\nMost anagrams: %d\nTotal anagrams: %d\n" % (longest, most, count))

