# Ref: http://www.osdever.net/bkerndev/Docs/isrs.htm

# Service Routines (ISRs)
.global isr0
.global isr1
.global isr2
.global isr3
.global isr4
.global isr5
.global isr6
.global isr7
.global isr8
.global isr9
.global isr10
.global isr11
.global isr12
.global isr13
.global isr14
.global isr15
.global isr16
.global isr17
.global isr18
.global isr19
.global isr20
.global isr21
.global isr22
.global isr23
.global isr24
.global isr25
.global isr26
.global isr27
.global isr28
.global isr29
.global isr30
.global isr31

#  0: Divide By Zero Exception
isr0:
    cli
    pushq 0    # A normal ISR stub that pops a dummy error code to keep a
                   # uniform stack frame
    pushq 0
    jmp isr_common_stub

#  1: Debug Exception
isr1:
    cli
    pushq 0
    pushq 1
    jmp isr_common_stub

#  2: Non Maskable Interrupt Exception
isr2:
    cli
    pushq 0
    pushq 2
    jmp isr_common_stub

#  3: Breakpoint Exception
isr3:
    cli
    pushq 0
    pushq 3
    jmp isr_common_stub

#  4: Into Detected Overflow Exception
isr4:
    cli
    pushq 0
    pushq 4
    jmp isr_common_stub

#  5: Out of Bounds Exception
isr5:
    cli
    pushq 0
    pushq 5
    jmp isr_common_stub

#  6: Invalid Opcode Exception
isr6:
    cli
    pushq 0
    pushq 6
    jmp isr_common_stub

#  7: No Coprocessor Exception
isr7:
    cli
    pushq 0
    pushq 7
    jmp isr_common_stub

#  8: Double Fault Exception (With Error Code!)
isr8:
    cli
    pushq 8        # Note that we DON'T push a value on the stack in this one!
                   # It pushes one already! Use this type of stub for exceptions
                   # that pop error codes!
    jmp isr_common_stub

#  9: Coprocessor Segment Overrun Exception
isr9:
    cli
    pushq 0
    pushq 9
    jmp isr_common_stub

#  10: Bad TSS Exception (With Error Code!)
isr10:
    cli
    pushq 10
    jmp isr_common_stub

#  11: Segment Not Present Exception (With Error Code!)
isr11:
    cli
    pushq 11
    jmp isr_common_stub

#  12: Stack Fault Exception (With Error Code!)
isr12:
    cli
    pushq 12
    jmp isr_common_stub

#  13: General Protection Fault Exception (With Error Code!)
isr13:
    cli
    pushq 13
    jmp isr_common_stub

#  14: Page Fault Exception (With Error Code!)
isr14:
    cli
    pushq 14
    jmp isr_common_stub

#  15: Unknown Interrupt Exception
isr15:
    cli
    pushq 0
    pushq 15
    jmp isr_common_stub

#  16: Coprocessor Fault Exception
isr16:
    cli
    pushq 0
    pushq 16
    jmp isr_common_stub

#  17: Alignment Check Exception (486+)
isr17:
    cli
    pushq 0
    pushq 17
    jmp isr_common_stub

#  18: Machine Check Exception (Pentium/586+)
isr18:
    cli
    pushq 0
    pushq 18
    jmp isr_common_stub

#  19: Reserved Exceptions
isr19:
    cli
    pushq 0
    pushq 19
    jmp isr_common_stub

#  20: Reserved Exceptions
isr20:
    cli
    pushq 0
    pushq 20
    jmp isr_common_stub

#  21: Reserved Exceptions
isr21:
    cli
    pushq 0
    pushq 21
    jmp isr_common_stub

#  22: Reserved Exceptions
isr22:
    cli
    pushq 0
    pushq 22
    jmp isr_common_stub

#  23: Reserved Exceptions
isr23:
    cli
    pushq 0
    pushq 23
    jmp isr_common_stub

#  24: Reserved Exceptions
isr24:
    cli
    pushq 0
    pushq 24
    jmp isr_common_stub

#  25: Reserved Exceptions
isr25:
    cli
    pushq 0
    pushq 25
    jmp isr_common_stub

#  26: Reserved Exceptions
isr26:
    cli
    pushq 0
    pushq 26
    jmp isr_common_stub

#  27: Reserved Exceptions
isr27:
    cli
    pushq 0
    pushq 27
    jmp isr_common_stub

#  28: Reserved Exceptions
isr28:
    cli
    pushq 0
    pushq 28
    jmp isr_common_stub

#  29: Reserved Exceptions
isr29:
    cli
    pushq 0
    pushq 29
    jmp isr_common_stub

#  30: Reserved Exceptions
isr30:
    cli
    pushq 0
    pushq 30
    jmp isr_common_stub

#  31: Reserved Exceptions
isr31:
    cli
    pushq 0
    pushq 31
    jmp isr_common_stub

# We call a C function in here. We need to let the assembler know
# that 'fault_handler' exists in another file
.extern fault_handler

# This is our common ISR stub. It saves the processor state, sets
# up for kernel mode segments, calls the C-level fault handler,
# and finally restores the stack frame.
isr_common_stub:
    movq %rsp, %rdi
    pushq %rax
    pushq %rbx
    pushq %rcx
    pushq %rdx
    pushq %rsp
    pushq %rbp
    pushq %rsi
    pushq %rdi
    movq %es, %rdx
    pushq %rdx
    movq %fs, %rdx
    pushq %rdx
    movq %gs, %rdx
    pushq %rdx
    movq %ds, %rdx
    pushq %rdx
    call reload_gdt
    call fault_handler
    popq %rdx
    movq %rdx, %ds
    popq %rdx
    movq %rdx, %gs
    popq %rdx
    movq %rdx, %fs
    popq %rdx
    movq %rdx, %es
    popq %rdi
    popq %rsi
    popq %rbp
    popq %rsp
    popq %rdx
    popq %rcx
    popq %rbx
    popq %rax
    add %esp, 8     # Cleans up the pushed error code and pushed ISR number
    iret           # pops 5 things at once: CS, EIP, EFLAGS, SS, and ESP!

