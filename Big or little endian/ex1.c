/*
<<<<<<< HEAD
 *Hadas Berger
=======
 * Hadas Berger
>>>>>>> 1e5a0937aa3c111398ec5c7a0786675cfcd0ad9e
 */

#include "ex1.h"
#include <stdio.h>


/**
 * the method check if the computer run on big\little endian.
 * I will take a number with variable "long" that have 4 bytes. we want to check
 * the value of the first byte- we find him by casting to "char"
 * (char is 1 byte).
 * if "c" is 1- we return 1 - "little endian". else, we return 0-"big endian".
 *
 */
int is_little_endian(){
long hadas=1;
char* c = (char*)&hadas;
if(*c){
	//"little endian"
	return 1;
}else{
	//"big endian"
	return 0;
}
}

/**
 * we want to return a word that compose from the ‫‪least‬‬ ‫‪significant‬‬ ‫‪byte‬‬ of y and
 * the other ‫‪bytes‬‬ of x.
 * if the number is little endian- we take h=the y with "and operator" on 0xFF to get the
 * lsb. in addition we take m= x with "and operator" on ~0xFF to get all the other bytes.
 * finally we take "or operator" (h|m) to get the merge number.
 * if the number is big endian we replace the order and do the same.
 */
unsigned long merge_bytes(unsigned long x, unsigned long int y){
	long h,m;
if(is_little_endian()){
	 //take the lsb of y
	h=(y & 0x00000000000000FF);
	//take the all number without the  lsb of x
	m=(x & 0xFFFFFFFFFFFFFF00);
}else{
	//take the lsb of y
	h=(y & 0xFF00000000000000);
	//take the all number without the  lsb of x
	m=(x & 0x00FFFFFFFFFFFFFF);
}
//return the merge number
return h|m;

}

/**
 * the method return x after replacing the i byte with b.
 * if it is little endian - then do cast to unsigned char to x, and move the pointer i places.
 * in the result i will put b.
 * finally, i will return the value of x.
 * if it is big endian- then do the same cast but move the pointer (7-i) places
 * (because we want to get to the i places from the end).
 */
unsigned long put_byte(unsigned long x, unsigned char b, int i){
	//"little endian"
if(is_little_endian()){
	 *((unsigned char *)&x+i)=b;
	 return x;
}else{
	//"big endian"
int r=7-i;
*((unsigned char*) &x + r) = b;
	return x;
}
}


