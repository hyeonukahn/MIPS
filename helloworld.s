.data
	mymessage: .asciiz "hellowolrd\n"
	newChar: .byte "s"
	
.text
	li $v0, 4
	la $a0, mymessage
	syscall
	li $v0, 4
	la $a0 newChar
	syscall
	
