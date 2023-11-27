# Print the contents of the specified register as an integer
.macro print_int(%x)
    li a7, 1
    mv a0, %x
    ecall
.end_macro

# Prints a message in a dialog box and prompts for inputting a string
.macro input_with_message(%message, %buffer, %max_length)
.data
    message: .asciz %message
.text
    push(a0)		# Pushing registers to stack
    push(a1)
    push(a2)
    push(a3)
    la a0 message
    la a1 %buffer
    li a2 %max_length
    li a3 -2
    li a7 54				# Creating Java window
    ecall
    beq a1 a3 end_program_iwm		# If input is wrong, end the program
    str_process(%buffer)	# Trimming string
    j continue_iwm
end_program_iwm:
    exit
continue_iwm:
    pop(a3)			# Popping registers out of stack
    pop(a2)
    pop(a1)
    pop(a0)
.end_macro

# Print an immediate integer value
.macro print_imm_int(%x)
    li a7, 1
    li a0, %x
    ecall
.end_macro

# Print string value
.macro print_str(%x)
	li a7,4
	la a0, %x
	ecall
.end_macro

# Print an immediate string value
.macro print_imm_str(%x)
   .data
str:
   .asciz %x
   .text
   push(a0)
   li a7, 50
   la a0, str
   ecall
   bnez a0 end_program
   j continue_print_str
end_program:
   exit
continue_print_str:
   pop(a0)
.end_macro

# Allocate a block of dynamic memory of a specified size
.macro allocate(%size)
    li a7, 9
    li a0, %size	# Size of the memory block
    ecall
.end_macro

# Print the result to the screen
.macro print_result(%x)
.data
   message_res: .ascii "Result: "
.text
   push(a0)
   push(a1)
   la a0 message_res
   la a1 %x
   li a7, 59			# Creating Java window
   ecall
   pop(a1)
   pop(a0)
.end_macro

# Print a single specified character
.macro print_char(%x)
   li a7, 11
   li a0, %x
   ecall
.end_macro

# Print a newline character
.macro newline
   print_char('\n')
.end_macro

# Read an integer from the console into register a0
.macro read_int_a0
   li a7, 5
   ecall
.end_macro

# Read an integer from the console into the specified register, excluding register a0
.macro read_int(%x)
   push(a0)
   li a7, 5
   ecall
   mv %x, a0
   pop(a0)
.end_macro

# Read a string from the console into the specified buffer and size
.macro read_str(%buf, %size)
    la a0, %buf
    li a1, %size
    li a7, 8
    ecall
.end_macro

# Ask the user whether to display the program result in the console
.macro YN_cases(%x)
.data
    consol_output_buf: .space 2
.text
YN_cases:
    input_with_message("If you want the program result to be displayed in the console, enter 'Y', otherwise 'N':  ", consol_output_buf, 2)
    la a0 consol_output_buf
    lb t0 (a0)
    beqz t0 incorrect_input
    li t2 'Y'
    li t3 'N'
    beq t0 t2 case_Y		# If input = "Y" return 1
    beq t0 t3 case_N		# else return 0
    j incorrect_input
incorrect_input:
    newline
    print_imm_str("You entered incorrect data, please try again")	# Incorrect input warning
    newline
    j YN_cases
case_Y:
    li t0 1
    la a0 %x
    sw t0 (a0)
    j end_YN
case_N:
    li t0 0
    la a0 %x
    sw t0 (a0)
    j end_YN
end_YN:
.end_macro

# Replace newline with null
.macro str_process(%strbuf)
    push(s0)
    push(s1)
    push(s2)
    li	s0 '\n'
    la	s1	%strbuf
next:
    lb	s2  (s1)
    beq s0	s2	replace
    addi s1 s1 1
    b	next
replace:
    sb	zero (s1)
    pop(s2)
    pop(s1)
    pop(s0)
.end_macro

# Open a file for reading, writing, or appending
.eqv READ_ONLY	0	# Open for reading
.eqv WRITE_ONLY	1	# Open for writing
.eqv APPEND	    9	# Open for appending
.macro open(%opt)
    li    a7, 1024     	# System call for opening a file
    li    a1, %opt        	# Open for reading (flag = 0)
    ecall             		# File descriptor in a0 or -1
.end_macro

# Read information from an open file
.macro read(%file_descriptor, %strbuf, %size)
    li   a7, 63       	# System call for reading from a file
    mv   a0, %file_descriptor       # File descriptor
    la   a1, %strbuf   	# Address of the buffer for the read text
    li   a2, %size 		# Size of the read portion
    ecall             	# Reading
.end_macro

# Read information from an open file when the buffer address is in a register
.macro read_addr_reg(%file_descriptor, %reg, %size)
    li   a7, 63       	# System call for reading from a file
    mv   a0, %file_descriptor       # File descriptor
    mv   a1, %reg   	# Address of the buffer for the read text from the register
    li   a2, %size 		# Size of the read portion
    ecall             	# Reading
.end_macro

# Close a file
.macro close(%file_descriptor)
    li   a7, 57       # System call for closing a file
    mv   a0, %file_descriptor  # File descriptor
    ecall             # Closing the file
.end_macro

# Exit the program
.macro exit
    li a7, 10
    ecall
.end_macro

# Save the specified register on the stack
.macro push(%x)
    addi sp, sp, -4
    sw %x, (sp)
.end_macro

# Pop the value from the top of the stack into the register
.macro pop(%x)
    lw %x, (sp)
    addi sp, sp, 4
.end_macro
