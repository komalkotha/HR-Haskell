{-
We consider a string consisting of one or more lowercase English alphabetic letters ([a-z]), digits ([0-9]), colons (:), forward slashes (/), and backward slashes (\) to be adorable if the following conditions are satisfied:
The first letter of the string is a lowercase English letter.
Next, it contains a sequence of zero or more of the following characters: lowercase English letters, digits, and colons.
Next, it contains a forward slash.
Next, it contains a sequence of one or more of the following characters: lowercase English letters and digits.
Next, it contains a backward slash.
Next, it contains a sequence of one or more lowercase English letters.
 
Given some string, s, we define the following:
s[i..j] is a substring consisting of all the characters in the inclusive range between index i and index j (i.e., s[i], s[i + 1], s[i + 2], …, s[j]).
Two substrings, s[i1..j1] and s[i2..j2], are said to be distinct if either i1 ≠ i2 or j1 ≠ j2.
 
Complete the adorableCount function in the editor below. It has one parameter: an array of n strings, words. The function must return an array of n positive integers where the value at each index i denotes the total number of distinct, adorable substrings in wordsi.
 
Input Format
Locked stub code in the editor reads the following input from stdin and passes it to the function:
The first line contains an integer, n, denoting the number of elements in words.
Each line i of the n subsequent lines (where 0 ≤ i < n) contains a string describing wordsi.
 
Constraints
1 ≤ n ≤ 50
Each wordsi consists of one or more of the following characters: lowercase English alphabetic letters ([a-z]), digits ([0-9]), colons (:), forward slashes (/), and backward slashes (\) only.
The length of each wordsi is no more than 5 × 105.
 
Output Format
The function must return an array of n positive integers where the integer at each index i denotes the total number of distinct, adorable substrings in wordsi. This is printed to stdout by locked stub code in the editor.
 
Sample Input 0
6
w\\//a/b
w\\//a\b
w\\/a\b
w:://a\b
w::/a\b
w:/a\bc::/12\xyz
 
Sample Output 0
0
0
0
0
1
8
 
Explanation 0
Let's call our return array ret. We fill ret as follows:
word = "w\\//a/b" has no adorable substring, so ret[0] = 0.
word = "w\\//a\b" has no adorable substring, so ret[1] = 0.
word = "w\\/a\b" has no adorable substring, so ret[2] = 0.
word = "w:://a\b" has no adorable substring, so ret[3] = 0.
word = "w::/a\b" has one adorable substring, word[0..6] = "w::/a\b", so ret[4] = 1.
word = "w:/a\bc::/12\xyz" has the following eight adorable substrings:
word[0..5] = w:/a\b
word[0..6] = w:/a\bc
word[5..13] = bc::/12\x
word[5..14] = bc::/12\xy
word[5..15] = bc::/12\xyz
word[6..13] = c::/12\x
word[6..14] = c::/12\xy
word[6..15] = c::/12\xyz
This means ret[5] = 8.
 
We then return ret = [0, 0, 0, 0, 1, 8].


---

Testcase 2: Wrong Answer
Input [Download]
4
a/b\c/d\e:f:/1\g
a/a\a/a\a:a:/a\a
a/a
a/a\a/a\a:b:/t9\xyz
Your Output
4
3
0
7
Expected Output [Download]
4
4
0
8

 -}

import Control.Monad
import Text.Parsec hiding (count)
import Data.Array
import Data.List
import Data.Maybe
import Data.Foldable (toList)
import Control.Applicative hiding ((<|>),many)
import Data.Array.Base (unsafeAt)

type Parser = Parsec String ()

subseqs ls = [t | i <- inits ls, t <- tails i, not $ null t]


adorable :: Parser String
adorable = do
  lower
  many $ lower <|> digit <|> char ':'
  char '/'
  many1 $ lower <|> digit
  char '\\'
  many1 lower

check word = either (const False) (const True) $ parse (adorable <* eof) "" word

count word = length $ nubBy (by word) $ filter check $ subseqs word

by str x y = let
  find x = fromMaybe 0 $ findSubstr str x
  xf = find x
  yf = find y
  x' = (xf,xf -1 + length x)
  y' = (yf,yf -1 + length y)
  in x' == y'

findSubstr :: Eq a => [a] -> [a] -> Maybe Int
findSubstr str x = findIndex (isPrefixOf x) (tails str)

adorableCount words = map (show . count) words
  

