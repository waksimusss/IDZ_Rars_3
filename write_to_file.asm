.include "macro-syscalls.asm"

.global write_to_file
write_to_file:

.eqv    TEXT_SIZE 512     # Size of the text buffer

.data
strbuf:         .space  TEXT_SIZE       # Buffer for the read text
reversedstr:    .space	TEXT_SIZE
tempstr:        .space	TEXT_SIZE
.text 
    push(ra)
    push(s0)           # Save the return address and the values of s registers
    push(s1)   
    # Save the result to a file
    open(WRITE_ONLY)
    li      s1 -1          # Check for correct file opening
    beq     a0 s1 er_name  # File opening error
    mv      s0 a0          # Save the file descriptor
    # Write information to the open file
    mv	    s3, a2
loop:
    lw	 t1 (s3)
    bltz t1 break_loop
    mv	a1, t1
    la	a0, reversedstr
    la  a2, tempstr
    jal int_to_string
    
    li a7 64
    mv a0 s0
    mv a1 a2
    li a2 TEXT_SIZE  
    addi s3 s3 4
           
    ecall
    
    j loop
break_loop:
    pop(s1)
    pop(s0)                # Restore the return address and the values of s registers
    pop(ra)   
    ret
er_name:
    # Message about incorrect file name
    print_imm_str("Incorrect file name\n")
    # And program termination
    exit
er_read:
    # Message about incorrect reading
    print_imm_str("Incorrect read operation\n")
    # And program termination
    exit
