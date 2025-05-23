# Based on the Perl implementation of Dave Koelle's Alphanum algorithm
# Beau Gunderson <beau@beaugunderson.com>, 2007
# http://www.bylandandsea.org/
# http://www.beaugunderson.com/

#
# Released under the MIT License - https://opensource.org/licenses/MIT
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the "Software"),
# to deal in the Software without restriction, including without limitation
# the rights to use, copy, modify, merge, publish, distribute, sublicense,
# and/or sell copies of the Software, and to permit persons to whom the
# Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included
# in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
# DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
# OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE
# USE OR OTHER DEALINGS IN THE SOFTWARE.
#

test_strings = [ "1000X Radonius Maximus", "10X Radonius", "200X Radonius", "20X Radonius", "20X Radonius Prime", "30X Radonius", "40X Radonius", "Allegia 50 Clasteron", "Allegia 500 Clasteron", "Allegia 51 Clasteron", "Allegia 51B Clasteron", "Allegia 52 Clasteron", "Allegia 60 Clasteron", "Alpha 100", "Alpha 2", "Alpha 200", "Alpha 2A", "Alpha 2A-8000", "Alpha 2A-900", "Callisto Morphamax", "Callisto Morphamax 500", "Callisto Morphamax 5000", "Callisto Morphamax 600", "Callisto Morphamax 700", "Callisto Morphamax 7000", "Callisto Morphamax 7000 SE", "Callisto Morphamax 7000 SE2", "QRS-60 Intrinsia Machine", "QRS-60F Intrinsia Machine", "QRS-62 Intrinsia Machine", "QRS-62F Intrinsia Machine", "Xiph Xlater 10000", "Xiph Xlater 2000", "Xiph Xlater 300", "Xiph Xlater 40", "Xiph Xlater 5", "Xiph Xlater 50", "Xiph Xlater 500", "Xiph Xlater 5000", "Xiph Xlater 58" ]

import re

re_chunk = re.compile("([\D]+|[\d]+)")
re_letters = re.compile("\D+")
re_numbers = re.compile("\d+")

def getchunk(item):
	itemchunk = re_chunk.match(item)

	# Subtract the matched portion from the original string
	# if there was a match, otherwise set it to ""
	item = (item[itemchunk.end():] if itemchunk else "")
	# Don't return the match object, just the text
	itemchunk = (itemchunk.group() if itemchunk else "")

	return (itemchunk, item)

def alphanum(a, b):
	n = 0

	while (n == 0):
		# Get a chunk and the original string with the chunk subtracted
		(ac, a) = getchunk(a)
		(bc, b) = getchunk(b)

		# Both items contain only letters
		if (re_letters.match(ac) and re_letters.match(bc)):
			n = cmp(ac, bc)
		else:
			# Both items contain only numbers
			if (re_numbers.match(ac) and re_numbers.match(bc)):
				n = cmp(int(ac), int(bc))
			# One item has letters and one item has numbers, or one item is empty
			else:
				n = cmp(ac, bc)

				# Prevent deadlocks
				if (n == 0):
					n = 1

	return n

test_strings.sort(cmp=alphanum)

for (v) in test_strings:
	print v