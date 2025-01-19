extern interrupt_handler

%macro link_interrupt 1
isr_%+ %1:
    call interrupt_handler
    iretq
%endmacro


link_interrupt 0
link_interrupt 1
link_interrupt 2
link_interrupt 3
link_interrupt 4
link_interrupt 5
link_interrupt 6
link_interrupt 7
link_interrupt 8
link_interrupt 9
link_interrupt 10
link_interrupt 11
link_interrupt 12
link_interrupt 13
link_interrupt 14
link_interrupt 15
link_interrupt 16
link_interrupt 17
link_interrupt 18
link_interrupt 19
link_interrupt 20
link_interrupt 21
link_interrupt 22
link_interrupt 23
link_interrupt 24
link_interrupt 25
link_interrupt 26
link_interrupt 27
link_interrupt 28
link_interrupt 29
link_interrupt 30
link_interrupt 31


global isr_table
isr_table:
%assign i 0
%rep 32
    dq isr_%+ i
%assign i i+1
%endrep
