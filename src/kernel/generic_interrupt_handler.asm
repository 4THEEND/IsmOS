extern exception_handler

%macro link_interrupt_err 1
isr_%+ %1:
    cli
    push %1
    call exception_handler
    iretq
%endmacro

%macro link_interrupt_no_err 1
isr_%+ %1:
    cli
    push 0
    push %1
    call exception_handler
    iretq
%endmacro


link_interrupt_no_err 0
link_interrupt_no_err 1
link_interrupt_no_err 2
link_interrupt_no_err 3
link_interrupt_no_err 4
link_interrupt_no_err 5
link_interrupt_no_err 6
link_interrupt_no_err 7
link_interrupt_err 8
link_interrupt_no_err 9
link_interrupt_err 10
link_interrupt_err 11
link_interrupt_err 12
link_interrupt_err 13
link_interrupt_err 14
link_interrupt_no_err 15
link_interrupt_no_err 16
link_interrupt_no_err 17
link_interrupt_no_err 18
link_interrupt_no_err 19
link_interrupt_no_err 20
link_interrupt_no_err 21
link_interrupt_no_err 22
link_interrupt_no_err 23
link_interrupt_no_err 24
link_interrupt_no_err 25
link_interrupt_no_err 26
link_interrupt_no_err 27
link_interrupt_no_err 28
link_interrupt_no_err 29
link_interrupt_no_err 30
link_interrupt_no_err 31


global isr_table
isr_table:
%assign i 0
%rep 32
    dq isr_%+ i
%assign i i+1
%endrep
