from __future__ import print_function
import sys
import enchant

d = enchant.Dict("en_US") # or en_UK, de_DE, fr_FR, en_AU on my system
for word in sys.argv[1:]: 
    if d.check(word):
        print(word, 'is OK')
    else:
        print('Suggestions for', word, ':', '\n\t'.join(d.suggest(word)))
