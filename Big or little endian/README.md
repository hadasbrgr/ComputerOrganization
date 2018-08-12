The first method check if the computer run on big\little endian.
I will take a number with variable "long" that have 4 bytes. we want to check the value of the first byte- we find him by casting to "char" (char is 1 byte).
if "c" is 1- we return 1 - "little endian". else, we return 0-"big endian".

The second nethod we want to return a word that compose from the ‫‪least‬‬ ‫‪significant‬‬ ‫‪byte‬‬ of y and the other ‫‪bytes‬‬ of x.
If the number is little endian- we take h=the y with "and operator" on 0xFF to get the lsb. in addition we take m= x with "and operator" on ~0xFF to get all the other bytes.
Finally we take "or operator" (h|m) to get the merge number.
If the number is big endian we replace the order and do the same.

In the last method we return x after replacing the i byte with b.
If it is little endian - then do cast to unsigned char to x, and move the pointer i places.
In the result i will put b.
Finally, i will return the value of x.
If it is big endian- then do the same cast but move the pointer (7-i) places (because we want to get to the i places from the end).
