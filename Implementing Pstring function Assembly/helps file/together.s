	.file	"main.c"
	.section	.rodata
.formatScanf:
	.string	"%d"
.formatScanf2:
	.string	"%s"
.format9:
	.string	"length: %s"
	.text                  #the beginnig of the code
	.globl 	main
	.type	main, @function
main:
    movq %rsp, %rbp #for correct debugging
       pushq	   %rbp
       movq	   %rsp, %rbp
       
       subq    $4,%rsp
       xorl	   %eax, %eax
       leaq	   4(%rsp), %rax
       movq	   %rax, %rsi
       movl	   $.formatScanf, %edi
       movl	   $0, %eax              #initilize the register
	 call	   scanf
       /*movl	4(%rsp), %eax 
       #movb	%al, 4(%rsp)
       movq     %rax,%rsi
       movl	   $.format9, %edi
       movl	$0, %eax
       call     printf*/
       movl	4(%rsp), %eax
       movl %eax,%r8d
      #leaq	(%rax), %rax
      subq    %rax,%rsp
      leaq	   4(%rsp), %rax
      movq	   %rax, %rsi
      movl	   $.formatScanf2, %edi
       movl	   $0, %eax              #initilize the register
	 call	   scanf
movl	4(%rsp), %eax 
       #movb	%al, 4(%rsp)
       movq     %rax,%rsi
       movl	   $.format9, %edi
       movl	$0, %eax
       call     printf
	
       
       leave
       ret   
	/*pushq	%rbp
	movq	%rsp, %rbp
	subq	$544, %rsp
	#movq	%fs:40, %rax
	#movq	%rax, -8(%rbp)
	xorl	%eax, %eax            #initilize the register
	leaq	-536(%rbp), %rax
	movq	%rax, %rsi            #
	movl	$.formatScanf, %edi   
	movl	$0, %eax              #initilize the register
	call	scanf                 # get len1 from user
	leaq	-528(%rbp), %rax
	addq	$1, %rax
	movq	%rax, %rsi
	movl	$.formatScanf2, %edi
	movl	$0, %eax
	call	scanf                 # get str1 from user

	movl	-536(%rbp), %eax      
	movb	%al, -528(%rbp)       #take the len to p1->len
	leaq	-536(%rbp), %rax
	movq	%rax, %rsi
	movl	$.formatScanf, %edi
	movl	$0, %eax
	call	scanf

	leaq	-272(%rbp), %rax
	addq	$1, %rax
	movq	%rax, %rsi
	movl	$.formatScanf2, %edi
	movl	$0, %eax
	call	scanf

	movl	-536(%rbp), %eax      #opt
	movb	%al, -272(%rbp)
	leaq	-532(%rbp), %rax
	movq	%rax, %rsi
	movl	$.formatScanf, %edi
	movl	$0, %eax
	call	scanf

	movl	-532(%rbp), %eax  #opt
	leaq	-272(%rbp), %rdx  #p2
	leaq	-528(%rbp), %rcx  #p1
	movq	%rcx, %rsi        #p1
	movl	%eax, %edi        #opt
	call	run_func
	movl	$0, %eax
	#movq	-8(%rbp), %rcx
	#xorq	%fs:40, %rcx
	#je	.L3
	#call	__stack_chk_fail
.L3:
	leave
	ret*/




	.file	"func_select.c"
	.section	.rodata	#read only data section
	.align 8
.pstrlenStr:
	.string	"first pstring length: %d, second pstring length: %d\n"

.scanf1:
	.string	"\n%c %c"
	.align 8

.format2:
	.string	"old char: %c, new char: %c, first string: %s, second string: %s\n"

.scanf2:
	.string	"%d"

.format3:
	.string	"invalid input!"

.format4:
	.string	"length: %d, string: %s\n"

.formatError:
	.string	"invalid option!"

switch_case:
	.quad	case50
	.quad	case51
	.quad	case52
	.quad	case53

	##################################
	.text	#the beginning of the code.
	.globl 	run_func
	.type	run_func, @function
run_func:
	pushq	%rbp
	movq	%rsp, %rbp

	pushq	%rbx
	subq	$64, %rsp					#from 56
	movl	%edi, -36(%rbp)		#get 1 parameter -opt
	movq	%rsi, -48(%rbp)		#get 2 parameter -p1
	movq	%rdx, -56(%rbp)		#get 3 parameter -p2
	movq	%fs:40, %rax
	movq	%rax, -24(%rbp)
	xorl	%eax, %eax
	movl	-36(%rbp), %eax

	subl	$50, 	%eax		# substract 50 from first parameter
	cmpl	$3, 	%eax    	# compare eax with 3
	ja	caseDefault     	# by default, goto case_default label
	jmp	*switch_case(,%eax,8)	# else jump using jump table
	#jmp	.L2

	#cmpl	$51, %eax
	#je	case51
	#cmpl	$51, %eax
	#jg	.L4
	#cmpl	$50, %eax
	#je	case50
	#jmp	done
#.L4:
	#cmpl	$52, %eax
	#je	case52
	#cmpl	$53, %eax
	#je	case53
	#jmp	done
case50:
	#movq	-56(%rbp), %rax	#take p2 and move
	#movq	%rax, %rdi
	movq	-56(%rbp),%rdi
	call	pstrlen			#print the length
	movsbl	%al, %ebx		#the return value from the function move to register
	#movq	-48(%rbp), %rax	
	#movq	%rax, %rdi	
	movq	-48(%rbp),%rdi		#take p1 and move to 
	call	pstrlen
	movsbl	%al, %eax		#the return value (char) from the function move to register
	movl	%ebx, %edx		#move pstrlen(p2) to parameter third
	movl	%eax, %esi		#move pstrlen(p1) to parameter second
	movl	$.pstrlenStr, %edi	#move string to parameter first
	movl	$0, %eax		#initalize before get into function 
	call	printf			#print the length
	jmp	done

case51:
	leaq	-28(%rbp), %rdx		#allocate place to char
	leaq	-32(%rbp), %rax		#allocate place to char
	movq	%rax, %rsi
	movl	$.scanf1, %edi
	movl	$0, %eax		#initalize before get into function
	#call	__isoc99_scanf
	call	scanf

	movzbl	-28(%rbp), %eax	#the new char
	movsbl	%al, %edx		#the new char-move to parameter 3 to the function replaceChar
	movzbl	-32(%rbp), %eax	#the old char
	#movsbl	%al, %ecx	#the old char
	movsbl	%al, %esi		#the old char-move to parameter 2 to the function replaceChar
	movq	-56(%rbp), %rax	#the pstring-p2
	#movl	%ecx, %esi		#the old char-move to parameter 2 to the function replaceChar
	movq	%rax, %rdi		#the pstring p2-move to parameter 1 to the function replaceChar
	call	replaceChar

	leaq	1(%rax), %rbx	#move pointer from beginning p2 to p2->str
	movzbl	-28(%rbp), %eax	#the new char
	movsbl	%al, %edx		#the new char-move to parameter 3 to the function replaceChar
	movzbl	-32(%rbp), %eax	#the old char
	#movsbl	%al, %ecx
	movsbl	%al, %esi		#the new char-move to parameter 2 to the function replaceChar
	movq	-48(%rbp), %rax	#the pstring-p1
	#movl	%ecx, %esi
	movq	%rax, %rdi		#the pstring p1-move to parameter 1 to the function replaceChar
	call	replaceChar

	leaq	1(%rax), %rcx	#move pointer from beginning p1 to p1->str-move string to parameter four
	movzbl	-28(%rbp), %eax	#the new char
	movsbl	%al, %edx		#move string to parameter third
	movzbl	-32(%rbp), %eax		#the old char
	#movsbl	%al, %eax
	movsbl	%al, %esi		#move string to parameter second
	movq	%rbx, %r8		#move string to parameter five-p2
	#movl	%eax, %esi		#move string to parameter second
	movl	$.format2, %edi	#move string to parameter first
	movl	$0, %eax		#initalize before get into function
	call	printf			#print function
	jmp	done

case52:
	leaq	-32(%rbp), %rax	#allocate place to char- index1
	movq	%rax, %rsi
	movl	$.scanf2, %edi
	movl	$0, %eax
	call	scanf

	leaq	-28(%rbp), %rax	#allocate place to char- index2
	movq	%rax, %rsi
	movl	$.scanf2, %edi
	movl	$0, %eax
	call	scanf
	
	jmp	.condition

.condition:
	movl	-32(%rbp), %eax	#index 1
	testl	%eax, %eax
	js	.conditionFalse	#if index 1 is negetive

	movl	-28(%rbp), %eax	#index 2
	testl	%eax, %eax
	js	.conditionFalse	#if index 2 is negetive


	movq	-48(%rbp), %rax	#the pstring-p1
	movzbl	(%rax), %eax
	movsbl	%al, %edx
	movl	-32(%rbp), %eax	#index 1
	cmpl	%eax, %edx		#if p1->len>index
	jl	.conditionFalse

	movq	-56(%rbp), %rax	#the pstring-p2
	movzbl	(%rax), %eax
	movsbl	%al, %edx
	movl	-32(%rbp), %eax	#index 1
	cmpl	%eax, %edx		#if p2->len>index
	jl	.conditionFalse


	movq	-48(%rbp), %rax
	movzbl	(%rax), %eax
	movsbl	%al, %edx
	movl	-28(%rbp), %eax	#index 2
	cmpl	%eax, %edx		#if p1->len>index
	jl	.conditionFalse

	movq	-56(%rbp), %rax
	movzbl	(%rax), %eax
	movsbl	%al, %edx
	movl	-28(%rbp), %eax	#index 2
	cmpl	%eax, %edx		#if p2->len>index
	jge	.conditionTrue

.conditionFalse:
	movl	$.format3, %edi	#error msg
	call	puts
	movq	-48(%rbp), %rax	#the pstring-p1
	leaq	1(%rax), %rdx	#move pointer from beginning p1 to p1->str
	movq	-48(%rbp), %rax	#the pstring-p1
	movzbl	(%rax), %eax		#p1->len
	movsbl	%al, %eax
	movl	%eax, %esi		#passing the results - the second parameter for printf
	movl	$.format4, %edi	#passing the string the first parameter for printf
	movl	$0, %eax		#initalize before get into function
	call	printf

	movq	-56(%rbp), %rax	#the pstring-p2
	leaq	1(%rax), %rdx	#move pointer from beginning p2 to p2->str
	movq	-56(%rbp), %rax
	movzbl	(%rax), %eax
	movsbl	%al, %eax
	movl	%eax, %esi		#passing the results - the second parameter for printf
	movl	$.format4, %edi	#passing the string the first parameter for printf
	movl	$0, %eax
	call	printf
	jmp	done

.conditionTrue:
	movl	-28(%rbp), %eax	#index2
	movsbl	%al, %ecx		#the index2-move to parameter 4 to the function pstrijcpy
	movl	-32(%rbp), %eax	#index1
	movsbl	%al, %edx		#the index1-move to parameter 3 to the function pstrijcpy
	movq	-56(%rbp), %rsi	#the pstring-p2- move to parameter 2 to the function pstrijcpy
	#movq	-48(%rbp), %rax	#the pstring-p1- move to parameter 1 to the function pstrijcpy
	movq	-48(%rbp), %rdi	#the pstring-p1- move to parameter 1 to the function pstrijcpy
	#movq	%rax, %rdi
	call	pstrijcpy

	leaq	1(%rax), %rdx	#move pointer from beginning p1 to p1->str
	movq	-48(%rbp), %rax
	movzbl	(%rax), %eax
	movsbl	%al, %eax
	movl	%eax, %esi
	movl	$.format4, %edi
	movl	$0, %eax
	call	printf

	movl	-28(%rbp), %eax
	movsbl	%al, %ecx
	movl	-32(%rbp), %eax
	movsbl	%al, %edx
	movq	-48(%rbp), %rsi
	movq	-56(%rbp), %rax
	movq	%rax, %rdi
	call	pstrijcpy

	leaq	1(%rax), %rdx
	movq	-56(%rbp), %rax
	movzbl	(%rax), %eax
	movsbl	%al, %eax
	movl	%eax, %esi
	movl	$.format4, %edi
	movl	$0, %eax
	call	printf
	jmp	done

case53:				#the swapCase function
	#movq	-48(%rbp), %rax
	#movq	%rax, %rdi
	movq	-48(%rbp),%rdi	#get p1 to the first parameter to send
	call	swapCase

	leaq	1(%rax), %rdx	#move pointer from beginning p1 to p1->str
	movq	-48(%rbp), %rax	#get p1 to the first parameter to send
	movzbl	(%rax), %eax
	movsbl	%al, %eax
	movl	%eax, %esi		#move the "len" to the second parameter
	movl	$.format4, %edi	#move string to parameter first
	movl	$0, %eax		#initalize before get into function
	call	printf			#print function

	#movq	-56(%rbp), %rax
	#movq	%rax, %rdi
	movq	-56(%rbp), %rdi	#get p2 to the first parameter to send
	call	swapCase

	leaq	1(%rax), %rdx	#move pointer from beginning p2 to p2->str - the third paramater
	movq	-56(%rbp), %rax	#get p2 to the first parameter to send
	movzbl	(%rax), %eax		#eax contain pointer to rax
	movsbl	%al, %eax		#go to the place we need
	movl	%eax, %esi		#move the "len" to the second parameter
	movl	$.format4, %edi	#move string to parameter first
	movl	$0, %eax		#initalize before get into function
	call	printf			#print function
	jmp	done

caseDefault:				#if the option diffrent from-50/51/52/53
	movl	$.formatError, %edi#move string to parameter first
	call	puts
	nop

done:
	nop
	movq	-24(%rbp), %rax
	xorq	%fs:40, %rax
	addq	$64, %rsp
	popq	%rbx
	popq	%rbp
	ret


	.file	"pstring.c"
		.text
	.globl	pstrlen
	.type	pstrlen, @function
pstrlen:
	movq	%rdi, %rax
	movzbl	(%rax), %eax
	ret

	.globl	replaceChar
	.type	replaceChar, @function
replaceChar:
	pushq	%rbp
	movq	%rsp, %rbp

	#movq	%rdi, %edi   #pstr
	#movl	%esi, %ecx
	#movl	%edx, %eax
	movb	%sil, %r10b   #old char
	movb	%dl, -32(%rbp)    #new
	movl	$0, %r8d     #initilize i=0
      #xorq  %rcx, %rcx
	jmp	.forLoop
.inLoop:
	movq	%rdi, %rdx
	movl	%r8d, %eax
	#cltq
	movzbl	1(%rdx,%rax), %eax
	cmpb	%r10b, %al    #if not old equal to str[i]
	jne	.incqLoop
	movq	%rdi, %rdx   #if equal
	movl	%r8d, %eax    #
	#cltq
	movzbl	 -32(%rbp), %ecx   #put new at the correct place[i]
	movb	%cl, 1(%rdx,%rax) #take the next tav
.incqLoop:
	incq	%r8           #i++
.forLoop:
	movq	%rdi, %rax   #pstr
	movzbl	(%rax), %eax    #take the len
	#movsbl	    %al, %eax
	cmpl	%r8d, %eax    #if i< pstr->len
	jg	.inLoop         

	movq	%rdi, %rax
	popq	%rbp
	ret


	.globl	pstrijcpy
	.type	pstrijcpy, @function
pstrijcpy:
	pushq	%rbp
	movq	%rsp, %rbp

	movq	%rdi, -24(%rbp)   #dst
	movq	%rsi, -32(%rbp)   #src
	#movl	%ecx, %eax        #j
	movb	%dl, -36(%rbp)    #i
	movb	%cl, -40(%rbp)    #j
	movsbl	-36(%rbp), %eax   #move i to eax
	movl	%eax, -4(%rbp)    #initilize index with i
	jmp	.conditionLoop
.loopPstrijcpy:
	movq	-32(%rbp), %rdx
	movl	-4(%rbp), %eax
	#cltq
	movzbl	1(%rdx,%rax), %ecx
	movq	-24(%rbp), %rdx
	movl	-4(%rbp), %eax
	#cltq
	movb	%cl, 1(%rdx,%rax)
	#addl	$1, -4(%rbp)
      incq -4(%rbp)             #i++
.conditionLoop:
	movsbl	-40(%rbp), %eax     #move j to eax
	cmpl	-4(%rbp), %eax      #compare j to index
	jge	.loopPstrijcpy      #if index<=j

	movq	-24(%rbp), %rax     #else
	popq	%rbp
	ret

	.globl	swapCase
	.type	swapCase, @function
swapCase:
	pushq	%rbp
	movq	%rsp, %rbp

	movq	%rdi, -24(%rbp)       #pstr
	movl	$0, -4(%rbp)          #initilize i
	jmp	.forCondition
.intoLoopSwapCase:
	movq	-24(%rbp), %rdx
	movl	-4(%rbp), %eax
	#cltq
	movzbl	1(%rdx,%rax), %eax
	cmpb	$96, %al              #ascii value-if'96'<=pstr->str[i]
	jle	.upperCase
	movq	-24(%rbp), %rdx
	movl	-4(%rbp), %eax
	#cltq
	movzbl	1(%rdx,%rax), %eax
	cmpb	$122, %al             #ascii value-if'122'<=pstr->str[i]
	jg	.upperCase
	movq	-24(%rbp), %rdx
	movl	-4(%rbp), %eax
	#cltq
	movzbl	1(%rdx,%rax), %eax
	subl	$32, %eax             #the opposite option -32
	movl	%eax, %ecx
	movq	-24(%rbp), %rdx
	movl	-4(%rbp), %eax
	#cltq
	movb	%cl, 1(%rdx,%rax)
	jmp	.incqLoopSwapCase
.upperCase:
	movq	-24(%rbp), %rdx
	movl	-4(%rbp), %eax
	#cltq
	movzbl	1(%rdx,%rax), %eax
	cmpb	$64, %al              #ascii value-if'64'<=pstr->str[i]
	jle	.incqLoopSwapCase
	movq	-24(%rbp), %rdx
	movl	-4(%rbp), %eax
	#cltq
	movzbl	1(%rdx,%rax), %eax
	cmpb	$90, %al              #ascii value-if'90'<=pstr->str[i]
	jg	.incqLoopSwapCase
	movq	-24(%rbp), %rdx
	movl	-4(%rbp), %eax
	#cltq
	movzbl	1(%rdx,%rax), %eax
	addl	$32, %eax             #the opposite option +32
	movl	%eax, %ecx
	movq	-24(%rbp), %rdx
	movl	-4(%rbp), %eax
	#cltq
	movb	%cl, 1(%rdx,%rax)
.incqLoopSwapCase:
	addl	$1, -4(%rbp)
.forCondition:
	movq	-24(%rbp), %rax
	movzbl	(%rax), %eax        #take the len
	movsbl	%al, %eax
	cmpl	-4(%rbp), %eax      #if i!=len
	jg	.intoLoopSwapCase   #i< pstr->len

	movq	-24(%rbp), %rax
	popq	%rbp
	ret


