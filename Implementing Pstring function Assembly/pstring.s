	#316590215 hadas berger	
	#This is a pstring.s that contain functions
	.section	.rodata		#read only data section
.errormsg:
        #.align 8
	.string	"invalid input!\n"

	.text
	.globl	pstrlen
	.type	pstrlen, @function

pstrlen:				#this function gets pstring and return his length
	movq	%rdi, %rax		#put parameter from stack to %rax
	movzbl	(%rax), %eax		#get lowest byte pointed by %rax and put it to eax
	ret				#return the length


	.globl	replaceChar
	.type	replaceChar, @function

replaceChar:				#this function gets pstring and two parameters and replace their tav from old char to new char
	pushq	%rbp			#save the old frame pointer
	movq	%rsp, %rbp		#create the new frame pointer
	movb	%sil, %r10b  		#move from the parameter to register (old char)
	movb	%dl, %r9b    		#move from the parameter to register (new char)
	movl	$0, %r8d     		#initialize i=0
	jmp	.forLoop
.inLoop:
	movq	%rdi, %rdx    		#pstr to rdx
	movl	%r8d, %eax    		#save i to regisrte rax
	movzbl	1(%rdx,%rax), %eax  	#pstr->str[i]- update
	cmpb	%r10b, %al    		#compare old char to pstr->str[i]
	jne	.incqLoop		#if not equal
	movq	%rdi, %rdx   		#if are equal
	movl	%r8d, %eax    		#save i to regisrte rax
	movl	%r9d, %ecx   		#take str[i]-the first byte
	movb	%cl, 1(%rdx,%rax) 	#put the new char at the correct place[i]-replace the byte
.incqLoop:
	incq	%r8           		#i++
.forLoop:
	movq	%rdi, %rax      	#pstr to rax
	movzbl	(%rax), %eax    	#take the len from pstr
	cmpl	%r8d, %eax    		#if i< pstr->len
	jg	.inLoop       		#true  
	movq	%rdi, %rax    		#else
	popq	%rbp
	ret				#return the address to pstring



	.globl	pstrijcpy
	.type	pstrijcpy, @function
pstrijcpy:				#this function gets two pstring and two parameters and replace their tav from index1 to index2
	pushq	%rbp			#save the old frame pointer
	movq	%rsp, %rbp		#create the new frame pointer
	movq	%rdi, %r9   		#move from the parameter to register (dst pstring)
	movq  	%rdi, %r14
	movq	%rsi, %r10   		#move from the parameter to register (src pstring)
	jmp	.condition		#check if the indexs are in the limits
.condition:
	cmpb	$0,%dl			#check negetive number
      	jl    	.error			#if negetive- go to error
      	cmpb  	$0,%cl			#check negetive number
      	jl    	.error			#if negetive- go to error
      	cmpb  	%cl,(%rsi)		#check if bigger then the len sring
     	jl    	.error			#if negetive- go to error
     	cmpb	%cl,(%rdi)		#check if bigger then the len sring
    	jl    	.error			#if not- go to error
     	cmpb  	%dl,(%rsi)		#check if bigger then the len sring
     	jl    	.error			#if not- go to error
      	cmpb  	%dl,(%rdi)		#check if bigger then the len sring
     	jl    	.error			#if not- go to error
      	jmp   	.goodInput		#if the indexs are in the limit-continue to the function
.error:
      	movq	$.errormsg, %rdi	#print error msg
	movq	$0, %rax
	call	printf
      	movq	%r14, %rax     		#return the pstring without change
	popq	%rbp
      	ret				#return the address to pstring
.goodInput:
      	movq 	$0,%rsi			#initialize register rsi
	movb	%dl, %sil    		#move from the parameter to register (index1)
	movb	%cl, %r11b    		#move from the parameter to register (index2)
	movl 	%esi, %eax   		#move index1 to eax
	movl	%eax, %r8d    		#initilize i with index1
	jmp	.conditionLoop
.loopPstrijcpy:
	movq	%r10, %rdx		#move src to rdx
	movl	%r8d, %eax		#save i to register rax
	movzbl	1(%rdx,%rax), %ecx	#update i
	movq	%r9, %rdx		#move dst to rdx
	movl	%r8d, %eax		#save i to register rax
	movb	%cl, 1(%rdx,%rax)	#replace between htr bytes
      	incq 	%r8             		#i++
.conditionLoop:
	movsbl	%r11b, %eax     	#move the first byte-index2 to eax
	cmpl	%r8d, %eax      	#compare index2 to i
	jge	.loopPstrijcpy      	#if i<=index2
	movq	%r9, %rax     		#else, move dst to rax
	popq	%rbp
	ret				#return the address to dst



	.globl	swapCase
	.type	swapCase, @function
swapCase:				#this function gets  pstring and replace their tav from uppercase to lowercase and thr opposite
	pushq	%rbp			#save the old frame pointer
	movq	%rsp, %rbp		#create the new frame pointer
	movl	$0, %r9d          	#initilize i=0
	jmp	.forCondition
.intoLoopSwapCase:
	movl	%r9d, %eax		#move i to rax
	movzbl	1(%rdi,%rax), %eax	#add one to the address
	cmpb	$96, %al              	#ascii value-if'96'<=pstr->str[i]- check if it lowerCase
	jle	.upperCase
	movq	%rdi, %rdx		#pstring to rdx
	movl	%r9d, %eax		#move i to rax
	movzbl	1(%rdi,%rax), %eax	#add one to the address
	cmpb	$122, %al             	#ascii value-if'122'<=pstr->str[i] - check if it lowerCase-limit
	jg	.upperCase
	movl	%r9d, %eax		#move i to rax
	movzbl	1(%rdi,%rax), %eax	#add one to the address
	subl	$32, %eax             	#the opposite option-upperCase -32
	movl	%eax, %ecx
	movl	%r9d, %eax
	movb	%cl, 1(%rdi,%rax)	#replace the char-from upperCase to lowerCase
	jmp	.incqLoopSwapCase
.upperCase:
	movl	%r9d, %eax		#move i to rax
	movzbl	1(%rdi,%rax), %eax	#add one to the address
	cmpb	$64, %al              	#ascii value-if'64'<=pstr->str[i]-check if it upperCase
	jle	.incqLoopSwapCase	#if not
	movl	%r9d, %eax		#move i to rax
	movzbl	1(%rdi,%rax), %eax	#add one to the address
	cmpb	$90, %al              	#ascii value-if'90'<=pstr->str[i] -check if it upperCase-limit
	jg	.incqLoopSwapCase	#if not
	movl	%r9d, %eax		#move i to rax
	movzbl	1(%rdi,%rax), %eax	#add one to the address
	addl	$32, %eax             	#the opposite option lowerCase +32
	movl	%eax, %ecx
	movl	%r9d, %eax
	movb	%cl, 1(%rdi,%rax)	#replace the char-from lowerCase to upperCase
.incqLoopSwapCase:
	incl	%r9d			#i++
.forCondition:
	movzbl	(%rdi), %eax        	#take the len from the pstring
	cmpl	%r9d, %eax      	#compare between the bytes i to pstring->len
	jg	.intoLoopSwapCase   	#if i< pstr->len

	movq	%rdi, %rax
	popq	%rbp
	ret				#return the address to pstring
