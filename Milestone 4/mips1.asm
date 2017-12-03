# Final output
# ========== DATA ==========
.data
x: .word 1
y: .word 3
s: .asciiz "and"
a: .float 1.1
b: .float 2.2
# ========== TEXT ==========
.text
# Set register id=x register=$t0

lw $t0, x
# Set register id=y register=$t1

lw $t1, y
# Set register id=i register=$t2
.text
add $t2, $t0, $t1
# print INT name=i
li $v0, 1
move $a0, $t2
syscall

# PRINT STRING name=s
li $v0, 4
la $a0, s
syscall

# Set register id=a register=$f0
l.s $f0 a
# Set register id=b register=$f2
l.s $f2 b
# Set register id=f register=$f4
.text
add.s $f4, $f0, $f2
# PRINT FLOAT name=f
li $v0, 2
mov.s $f12, $f4
syscall
