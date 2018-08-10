# hadas berger	
	.section	.rodata		# read-only data section
.formatScanf:
	.string	"%d"
.formatScanf2:
	.string	"%s"
	

	.text                  		#the beginnig of the code
	.globl 	main
	.type	main, @function
main:					# the main function:
	pushq	%rbp                	#save the old frame pointer
	movq	%rsp, %rbp		#create the new frame pointer
        
#get and save the pirst pstring
	subq	$4, %rsp              	#save place for 4 byte to len1
	movq	%rsp, %rsi            	#turn place to rsi before the scanf 
	movl	$.formatScanf, %edi   	#save format(%d) to register rdi
	movl	$0, %eax              	#initilize the register
	call	scanf                 	#get len1 from user
      	movq  	$0,%r8                	#initialize the register
      	movzbq	(%rsp),%r8           	#save the result from the scanf
      
      	addq	$3, %rsp               	#delete the place we waste and give to \0 place
    	movb	$0, (%rsp)         	#initialize the rsp register
    	subq	%r8, %rsp         	#save place in size we get from the user
    	decq	%rsp               	#give space to the len
    	movb	%r8b, (%rsp)        	#save the len at the first byte
    	movq	%rsp, %rsi             	#turn place to rsi before the scanf 
    	incq	%rsi               	#skip on the len space
    	movl	$.formatScanf2, %edi    #save format(%c) to register rdi
      	movl	$0, %eax          	#initialize the register
	call	scanf                 	#get str1 from user-to pstring1
      	movq	$0, %r13               	#initialize the register
      	leaq	(%rsp), %r13         	#save the result from the scanf
            
#get and save the second pstring
      	subq	$4, %rsp              	#save place for 4 byte to len2
	movq	%rsp, %rsi            	#turn place to rsi before the scanf 
	movl	$.formatScanf, %edi   	#save format(%d) to register rdi
	movl	$0, %eax              	#initialize the register- to the return value
	call	scanf                 	#get len2 from user-to pstring2
      	movq	$0,%r10               	#initialize the register
      	movzbq	(%rsp),%r10          	#save the result from the scanf
      
      	addq	$3, %rsp              	#delete the place we waste and give to \0 place
    	movb	$0, (%rsp)            	#initialize the rsp register
    	subq	%r10, %rsp            	#save place in size we get from the user
    	decq	%rsp                  	#give space to the len
    	movb	%r10b, (%rsp)         	#save the len at the first byte
    	movq	%rsp, %rsi            	#turn place to rsi before the scanf 
    	incq	%rsi                  	#to skip on the len
    	movl	$.formatScanf2, %edi  	#save format(%c) to register rdi
      	movl	$0, %eax              	#initialize the register
	call	scanf                 	#get str2 from user-to pstring2
      	movq	$0, %r14               	#initialize the register
      	leaq	(%rsp), %r14           	#save the result from the scanf

#get and save the option
	subq	$4, %rsp             	#save place for 4 byte to len
	movq	%rsp, %rsi           	#turn place to rsi before the scanf 
	movl	$.formatScanf, %edi  	#save format(%d) to register rdi
	movl	$0, %eax             	#initialize the register
	call	scanf                	#get option from user
      	movq	$0, %r12             	#initialize the register
      	movzbq	(%rsp), %r12        	#save the result from the scanf
      
#send to run_func finction
	movq	%r14, %rdx          	#pstring 1
	movq	%r13, %rsi          	#pstring 2
	movq	%r12, %rdi         	#the option
	call	run_func           	#send to function- option,pstring1,pstring2
#end  
      leave
      ret				#return to caller function
