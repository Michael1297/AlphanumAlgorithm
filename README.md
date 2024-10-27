#   The Alphanum Algorithm
Mirror http://www.davekoelle.com/alphanum.html \

People sort strings with numbers differently than software does. Most sorting algorithms compare ASCII values, which produces an ordering that is inconsistent with human logic. Here's how to fix it.

Download the algorithm:
* Java: [AlphanumComparator.java](https://github.com/Michael1297/AlphanumAlgorithm/blob/main/AlphanumComparator.java) \
* C#: [AlphanumComparator.cs](https://github.com/Michael1297/AlphanumAlgorithm/blob/main/AlphanumComparator.cs) \
* C++: [alphanum.cpp](https://github.com/Michael1297/AlphanumAlgorithm/blob/main/alphanum.cpp) \
* C++, not Windows dependent: [alphanum.hpp](https://github.com/Michael1297/AlphanumAlgorithm/blob/main/alphanum.hpp) \
* JavaScript: [alphanum.js](https://github.com/Michael1297/AlphanumAlgorithm/blob/main/alphanum.js) \
* Perl: [alphanum.pl](https://github.com/Michael1297/AlphanumAlgorithm/blob/main/alphanum.pl) \
* Python: [alphanum.py](https://github.com/Michael1297/AlphanumAlgorithm/blob/main/alphanum.py) \
* Python 2.4+: [alphanum.py_v2.4](https://github.com/Michael1297/AlphanumAlgorithm/blob/main/alphanum_v2.4.py) \
* Ruby: [alphanum.rb](https://github.com/Michael1297/AlphanumAlgorithm/blob/main/alphanum.rb) \
* Other: [OCaml](https://github.com/Michael1297/AlphanumAlgorithm/blob/main/alphanum.ocaml), [Lua](https://github.com/Michael1297/AlphanumAlgorithm/blob/main/alphanum.lua), [Groovy](https://github.com/Michael1297/AlphanumAlgorithm/blob/main/alphanum.groovy) \
* PHP: Just use sort(&array;, SORT_STRING);

# The Problem
Look at most sorted list of filenames, product names, or any other text that contains alphanumeric characters - both letters and numbers. Traditional sorting algorithms use ASCII comparisons to sort these items, which means the end-user sees an unfortunately ordered list that does not consider the numeric values within the strings.

For example, in a sorted list of files, "z100.html" is sorted before "z2.html". But obviously, 2 comes before 100!

Sorting algorithms should sort alphanumeric strings in the order that users would expect, especially as software becomes increasingly used by nontechnical people. Besides, it's the 21st Century; software engineers can do better than this.

# The Solution
I created the Alphanum Algorithm to solve this problem. The Alphanum Algorithm sorts strings containing a mix of letters and numbers. Given strings of mixed characters and numbers, it sorts the numbers in value order, while sorting the non-numbers in ASCII order. The end result is a natural sorting order.

Here's a list of sample filenames to illustrate the difference between sorting with the Alphanum algorithm and traditional ASCII sort. On the left is what you live with on a daily basis. On the right is what you could have, if more developers were motivated to sort lists as people would expect. Which list makes more sense to you? Which would be more comfortable to you as you're using an application?

![image](https://github.com/user-attachments/assets/53ad7729-b447-4e0e-8539-ff3a74503011)

# How does it work?
The algorithm breaks strings into chunks, where a chunk contains either all alphabetic characters, or all numeric characters. These chunks are then compared against each other. If both chunks contain numbers, a numerical comparison is used. If either chunk contains characters, the ASCII comparison is used.

There is currently a glitch when it comes to periods/decimal points - specifically, periods are treated only as strings, not as decimal points. The solution to this glitch is to recognize a period surrounded by digits as a decimal point, and continue creating a numeric chunck that includes the decimal point. If a letter exists on either side of the period, or if the period is the first or last character in the string, it should be viewed as an actual period and included in an alphabetic chunk. While I have recently figured this out in theory, I have not yet implemented it into the algorithms. To be truly international, the solution shouldn't just consider periods, but should consider whatever decimal separator is used in the current language.

Currently, the algorithm isn't designed to work with negative signs or numbers expressed in scientific notation, like "5*10e-2". In this case, there are 5 chunks: 5, *, 10, e-, and 2.

The latest version of some of the code (particularly the Java version) compares numbers one at a time if those numbers are in chunks of the same size. For example, when comparing abc123 to abc184, 123 and 184 are the same size, so their values are compared digit-by-digit: 1=1, 2<8. This was done to solve the problem of numeric chunks that are too large to fit in range of values allowed by the programming language for a particular datatype: in Java, an int is limited to 2147483647. The problem with this approach is doesn't properly handle numbers that have leading zeros. For example, 0001 is seem as larger than 1 because it's the longer number. A version that does not compare leading zeros is forthcoming.

# Conclusion
Software development has matured beyond the point where simply sorting strings by their ASCII value is acceptable. It is my hope that the Alphanum Algorithm becomes adopted by all developers so we can work together to create software applications that make sense to users. Feel free to download and share the algorithm, place it in your program free of charge, and help spread the word.
