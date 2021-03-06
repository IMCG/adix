.extern set_tss

.macro pushReg
pushq %rax
pushq %rbx
pushq %rcx
pushq %rdx
pushq %rdi
pushq %rsi
pushq %rbp
pushq %r8
pushq %r9
pushq %r10
pushq %r11
pushq %r12
pushq %r13
pushq %r14
pushq %r15
.endm

.macro popReg
popq %r15
popq %r14
popq %r13
popq %r12
popq %r11
popq %r10
popq %r9
popq %r8
popq %rbp
popq %rsi
popq %rdi
popq %rdx
popq %rcx
popq %rbx
popq %rax
.endm

.global switchTo
.extern cleanupTerminated

switchTo:
	pushReg
	movq %rsp,%rax
	andq $0xfffffffffffff000,%rax #Get base of the stack
	movq %rsp,0x08(%rax) #save current rsp reg value onto the stack[1]
	movq 0x08(%rdi),%rsp #get sp of new process onto rsp reg
	#If the previous task was terminated remove it from the run queue
	orq $0x0000000000000ff0, %rdi
	call set_tss #Set tss for the new task
	movq $0x28, %rax
	ltr %ax
	call cleanupTerminated 
	popReg
	#Get IP for the next task and return
	sti
	retq
