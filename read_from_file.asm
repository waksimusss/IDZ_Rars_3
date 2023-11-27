.include "macro-syscalls.asm"

.global read_from_file
read_from_file:

.eqv    TEXT_SIZE 512     # Size of the text buffer

.text
    push(ra)
    push(s0)
    push(s1)
    push(s2)
    push(s3)          # Save the return address and the values of s registers
    push(s4)
    push(s5)
    push(s6)
    open(READ_ONLY)
    li      s1 -1         # Check for correct file opening
    beq     a0 s1 er_name # File opening error
    mv      s0 a0         # Save the file descriptor
    # Allocate initial memory block for the buffer in the heap
    allocate(TEXT_SIZE)    # Result stored in a0
    mv      s3, a0         # Save the heap address in the register
    mv      s5, a0         # Save the mutable heap address in the register
    li      s4, TEXT_SIZE  # Save the constant for processing
    mv      s6, zero       # Set the initial length of the read text
read_loop:
    # Read information from the open file
    read_addr_reg(s0, a6, TEXT_SIZE) # Read the block address from the register
    # Check for correct reading
    beq     a0 s1 er_read   # Read error
    mv      s2 a0            # Save the length of the text
    add     s6, s6, s2       # Increase the size of the text by the read portion
    # If the length of the read text is less than the buffer size,
    # the process must be terminated.
    bne     s2 s4 end_loop
    # Otherwise, expand the buffer and repeat
    allocate(TEXT_SIZE)       # Result is not needed here, but if needed...
    add     s5 s5 s2          # Address for reading shifts by the size of the portion
    b read_loop               # Process the next portion of text from the file
end_loop:
    # Close the file
    close(s0)
    mv      t0 s3             # Address of the buffer in the heap
    add     t0 t0 s6          # Address of the last read character
    addi    t0 t0 1           # Place for null termination
    sb      zero (t0)         # Write null to the end of the text
    mv a2 s3                  # In a6 - the result, i.e., a pointer to the beginning of the string
    pop(s6)
    pop(s5)
    pop(s4)
    pop(s3)                   # Restore the return address and the values of s registers
    pop(s2)
    pop(s1)
    pop(s0)
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
