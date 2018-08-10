The method check if the computer run on big\little endian.
I will take a number with variable "long" that have 4 bytes. we want to check the value of the first byte- we find him by casting to "char" (char is 1 byte).
if "c" is 1- we return 1 - "little endian". else, we return 0-"big endian".
