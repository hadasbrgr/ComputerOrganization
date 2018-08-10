	#316590215 hadas berger
#This is a func_select program that send to the match function according to the option
	.section	.rodata		#read only data section
.pstrlenStr:
	.string	"first pstring length: %d, second pstring length: %d\n"

.scanf1:
	.string	"\n%c %c"

.format2:
	.string	"old char: %c, new char: %c, first string: %s, second string: %s\n"

.scanf2:
	.string	"%d"

.format4:
	.string	"length: %d, string: %s\n"

.formatError:
	.string	"invalid option!\n"

	.align 8
switch_case:
	.quad	case50
	.quad	case51
	.quad	case52
	.quad	case53

	##################################
	.text	#the beginning of the code.
	.globl	run_func
	.type	run_func, @function
run_func:
	pushq	%rbp
	movq	%rsp, %rbp

	leal -50(%rdi), %eax		#substract 50 from first parameter
	cmpl	$3, 	%eax    	#compare eax with 3
	ja	caseDefault     	#by default, go to case_default label
	jmp	*switch_case(,%eax,8)	#else jump using jump table

case50:
	push	%r12			#push callee save r12 to stack
      	push 	%r13			#push callee save r13 to stack
      	movq  	%rdx,%r12		#move parameter 3 (pstr2) to r12
	movq	%r12,%rdi
	call	pstrlen			#send to function that return the length
	movsbl	%al, %ebx		#save the return value from the function move to register

      	movq  	%rsi,%r13		#move parameter 2 (pstr1) to r13
	movq	%r13,%rdi		 
	call	pstrlen			#send to function that return the length
	movsbl	%al, %eax		#the return value (char) from the function move to register

	movl	%ebx, %edx		#move pstrlen(p2) to parameter third - to print
	movl	%eax, %esi		#move pstrlen(p1) to parameter second - to print
	movl	$.pstrlenStr, %edi	#move string to parameter first - to print
	movl	$0, %eax		#initalize before get into function 
	call	printf			#print the length
      	pop   	%r13			#restore saved registers:r13,r12
      	pop   	%r12
	jmp	done			#end program

case51:
      	push	%r12			#push callee save r12/r13/r14/r15 to stack
      	push	%r13
	push 	%r14
      	push 	%r15
      	movq  	%rdx,%r12   		#move parameter 3 (pstring2) to r12
      	movq  	%rsi,%r13   		#move parameter 2 (pstring2) to r13
      
      	leaq	-2(%rsp), %rsp          #give place for 2 byte to old and new char
      	movq  	%rsp,%rsi
      	leaq  	1(%rsp),%rdx
      	movl	$.scanf1, %edi
	movl	$0, %eax		#initalize before get into function
	call	scanf

      	movzbl	(%rsp), %r15d		#move the first input to r15
      	movzbl	1(%rsp), %r14d		#move the second input to r14
      	leaq    2(%rsp), %rsp		#reduce the rsp
      	movq 	%r14,%rdx
      	movq 	%r15,%rsi
      	movq	%r12, %rdi		#the pstring p2-move to parameter 1 to the function replaceChar
	call	replaceChar		#send to function that return address to pstring after replace place

      	movq 	%r14,%rdx
      	movq 	%r15,%rsi
      	movq	%r13, %rdi		#the pstring p2-move to parameter 1 to the function replaceChar
	call	replaceChar

       	add 	$1,%r12			#to get the second byte to pstring- the str
       	add  	$1,%r13
       
      	movq  	%r12,%r8		#move the value to the correct register before print
      	movq  	%r13,%rcx
      	movq  	%r14,%rdx
      	movq  	%r15,%rsi
      	movl	$.format2, %edi		#move string to parameter first
	movl	$0, %eax		#initalize before get into function
	call	printf			#print function
      	pop   	%r15			#restore saved registers:r15,r14,r13,r12
      	pop   	%r14
      	pop   	%r13
      	pop   	%r12
	jmp	done			#end program

case52:
    	push    %r12			#push callee save r12/r13/r14/r15 to stack
    	push    %r13
    	push    %r14
    	push    %r15

    	movq	%rsi, %r13		#move parameter 2 (pstring1) to r13
    	movq	%rdx, %r12		#move parameter 3 (pstring2) to r12
    	leaq    -4(%rsp), %rsp		#allocate place for 4 byte to index1
    	movq    $.scanf2, %rdi
    	movq    %rsp, %rsi		#turn place to rsi before the scanf
    	movq    $0, %rax		#initalize the register
    	call    scanf			#get index1 from user
    	movzbl  (%rsp), %r14d		#move the input to r14

    	leaq    4(%rsp), %rsp		#reduce rsp
    	leaq    -4(%rsp), %rsp		#allocate place for 4 byte to index2
    	movq    $.scanf2, %rdi
    	movq    %rsp, %rsi		#turn place to rsi before the scanf
    	movq    $0, %rax		#initalize the register
    	call    scanf			#get index2 from user
    	movzbl  (%rsp), %r15d      	#move the input to r15
    	leaq    4(%rsp), %rsp		#reduce rsp
     
.conditionTrue:
	movl	%r15d, %eax		
	movsbl	%al, %ecx		#the index2-move to parameter 4 to the function pstrijcpy
	movl	%r14d, %eax		
	movsbl	%al, %edx		#the index1-move to parameter 3 to the function pstrijcpy
	movq	%r12, %rsi		#the pstring-p2- move to parameter 2 to the function pstrijcpy
	movq	%r13, %rdi		#the pstring-p1- move to parameter 1 to the function pstrijcpy
	call	pstrijcpy		#send to function that return an address to pstring after copy the other pstring at the indexes place
 
	leaq	1(%rax), %rdx		#move pointer from beginning p1 to p1->str
	movq	%r13, %rax
	movzbl	(%rax), %eax
	movsbl	%al, %eax
	movl	%eax, %esi		#passing the results - the second parameter for printf
	movl	$.format4, %edi		#passing the string the first parameter for printf
	movl	$0, %eax		#initalize before get into function
	call	printf			#print function

	movq	%r12, %rax		#the pstring-p2
	leaq	1(%rax), %rdx		#move pointer from beginning p2 to p2->str
	movq	%r12, %rax
	movzbl	(%rax), %eax
	movsbl	%al, %eax
	movl	%eax, %esi		#passing the results - the second parameter for printf
	movl	$.format4, %edi		#passing the string the first parameter for printf
	movl	$0, %eax		#initalize before get into function
	call	printf			#print function
	pop   	%r15			#restore saved registers:r15,r14,r13,r12
      	pop   	%r14
      	pop   	%r13
      	pop   	%r12
	jmp	done			#end program

case53:					#the swapCase function
      	push	%r12			#push callee save r12/r13 to stack
      	push 	%r13
      	movq  	%rsi,%r12         	#move parameter 2 (pstring1) to r12
      	movq  	%rdx,%r13           	#move parameter 3 (pstring2) to r13
	movq	%r12, %rdi		#move pstring1 to rdi to send to the function
	call	swapCase		#send to function that return an address to pstring after change the char

	leaq	1(%rax), %rdx		#move pointer from beginning pstring1 to pstring1->str
	movq	%r12, %rax		#get pstring1 to the first parameter to send
	movzbl	(%rax), %eax
	movsbl	%al, %eax
	movl	%eax, %esi		#move the "len" to the second parameter
	movl	$.format4, %edi	#	move string to parameter first
	movl	$0, %eax		#initalize before get into function
	call	printf			#print function

	movq	%r13, %rdi		#move pstring2 to rdi to send to the function
	call	swapCase		#send to function that return an address to pstring after change the char

	leaq	1(%rax), %rdx		#move pointer from beginning pstring2 to pstring2->str - the third paramater
	movq	%r13, %rax	       	#get pstring2 to the first parameter to send
	movzbl	(%rax), %eax		
	movsbl	%al, %eax		
	movl	%eax, %esi		#move the "len" to the second parameter
	movl	$.format4, %edi		#move string to parameter first
	movl	$0, %eax		#initalize before get into function
	call	printf			#print function
      	pop 	%r13			#restore saved registers:r13,r12
      	pop 	%r12
	jmp	done			#end program

caseDefault:				#if the option diffrent from-50/51/52/53
	movl	$.formatError, %edi	#move string to parameter first
	movq	$0, %rax
	call	printf			#print an appropriate message

done:					#finish the program
	popq	%rbp
	ret				#return to caller function
