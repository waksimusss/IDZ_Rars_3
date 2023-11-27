.global int_to_string
int_to_string:
    mv t0, a0              # Save the pointer to the buffer for the reversed string
    mv t1, a1              # Save the pointer to the number
    mv t6, a2              # Save the pointer to the buffer for the result string
    li t3, 10              # Base for division (decimal system)
    li t2, 0               # Counter for the number of characters in the string

int_to_string_loop:
    bltz t1 end
    addi t2, t2, 1
    remu t4, t1, t3        # Remainder of the division
    addi t4, t4, '0'        # Convert to ASCII
    sb t4, (t0)             # Save the character in the buffer
    divu t1, t1, t3        # Divide by the base
    addi t0, t0, 1          # Move to the next character in the buffer
    bnez t1, int_to_string_loop      # Repeat if the number is not yet zero
    
reverse_loop:
    addi t2, t2, -1
    addi t0, t0, -1
    lb t4, (t0)             # Load the character
    sb t4, (t6)             # Load the character into the result buffer
    addi t6, t6, 1          # Move further along the result buffer
    bnez t2, reverse_loop   # Repeat if the string is not finished
    
end:
    sb zero, (t6)           # Null-terminator
    ret                     # Return from the function
