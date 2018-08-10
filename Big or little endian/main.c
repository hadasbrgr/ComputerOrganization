/*
 * main.c
 *
 *  Created on: Nov 6, 2017
 *      Author: hadas
 */


#include <stdio.h>
#include "ex1.h"

int main() {

	printf("%d\n", is_little_endian());

	printf("0x%lx\n", merge_bytes(0x89ABCDEF12893456, 0x76543210ABCDEF19));

	printf("0x%lX\n", put_byte(0x12345678CDEF3456, 0xAB, 2));
	printf("0x%lX\n", put_byte(0x12345678CDEF3456, 0xAB, 0));

	return 0;
}
