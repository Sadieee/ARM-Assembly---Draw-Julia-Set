	.data
zx:	.word	0
zy:	.word	0
cX:	.word	0
cY:	.word	0
width:	.word	0
height:	.word	0
num1500: 		.word 1500
num1000:  		.word 1000
num4000000:  	.word 4000000

frame:	.word	0
i:	.word	0
tmp:	.word	0

	.text
	.globl	drawJuliaSet
drawJuliaSet:
	ldr	r4,=cX		@load address of cX to r4
	str	r0,[r4]		@store r0 to cX
	ldr	r4,=cY		@load address of cY to r4
	str	r1,[r4]		@store r1 to cY
	ldr	r4,=width	@load address of width to r4
	str	r2,[r4]		@store r2 to width
	ldr	r4,=height	@load address of height to r4
	str	r3,[r4]		@store r3 to height
	ldr	r4,=frame	@load address of frame to r4
	str	sp,[r4]		@store sp to frame


	stmfd	sp!,{lr,sp}		@push lr sp to stack

	@ r4 = x , r5 = y , r6 = width , r7 = height
	mov	r4,#0			@ x = 0
	mov	r5,#0			@ y = 0
	ldr	r6,=width		@load address of width to r6
	ldr	r6,[r6]			@load value of width to r6
	ldr	r7,=height		@load address of height to r7
	ldr	r7,[r7]			@load value of height to r7

set_yLoop:
	mov	r5,#0 			@ y = 0


yLoop:
	@ ===== zx = 1500 * ( x - ( width >> 1 ) ) / ( width >> 1 ) ===== @
	ldr	r2,=num1500		@ load address of num1500 to r2
	ldr r2,[r2]			@ load value of num1500 to r2
	mov	r1,r6,asr#1		@ r1 = r6( width ) >> 1

	sub	r0,r4,r1		@ r0 = r4( x ) - r1( width >> 1 )
	mul	r0,r2,r0		@ r0 = r2( 1500 ) * r0( x - ( width >> 1 ))
	bl	__aeabi_idiv	@ r0 = r0( 1500 * ( x - ( width >> 1 )) ) / r1( width >>1 )
	ldr	r3,=zx			@ load address of zx to r3
	str	r0,[r3]			@ store r0 to zx

	@ ===== zy = 1000 * ( y - ( height >> 1 ) ) / ( height >> 1 ) ===== @

	ldr	r2,=num1000		@ load address of num1000 to r2
	ldr r2,[r2]			@ load value of num1000 to r2
	mov	r1,r7,asr#1		@ r1 = r7( height ) >> 1
	sub	r0,r5,r1		@ r0 = r5( y ) - r1( height >> 1 )
	mul	r0,r2,r0		@ r0 = r2( 1000 ) * r0( y - ( height >> 1 ) )
	bl	__aeabi_idiv	@ r0 = r0( 1000 * ( y - ( height >> 1 ) ) ) / r1( height >> 1 )
	ldr	r3,=zy			@ load address of zy to r3
	str	r0,[r3]			@ store r0 to zy

	@ ===== i = maxIter = 255 ===== @

	mov r0,#255 	@ r0 = maxIter = 255
	ldr	r1,= i		@ load address of i to r1
	str	r0,[r1]		@ store r0( 255 ) to i


whileLoop:
    @ ===== zx * zx + zy * zy < 4000000 ===== @
	ldr	r2,=zx			@ load address of zx to r2
	ldr	r2,[r2]			@ load value of zx to r2
	mul	r3,r2,r2		@ r3 = r2( zx ) * r2( zx )
	ldr	r8,=zy			@ load address of zy to r8
	ldr	r8,[r8]			@ load value of zy to r8
	mul	r9,r8,r8		@ r9 = r8( zy ) * r8( zy )
	add	r10,r3,r9		@ r10 = r3( zx * zx ) + r9( zy * zy )
    ldr r0,=num4000000	@ load address of num4000000 to r0
    ldr r0,[r0]			@ load value of num4000000 to r0
	cmp	r10,r0			@ r10( zx * zx + zy * zy ) - r0( 4000000 )
	bge	process_color			@ if ( r10( zx * zx + zy * zy ) >= r0( 4000000 ) ) go to process_color

	@ ===== i > 0 ===== @
	ldrlt	r0,=i		@ load address of i to r0
	ldrlt	r0,[r0]		@ load value of i to r0
	cmplt	r0,#0		@ r0( i ) - 0
    @ ===== tmp = ( zx * zx - zy * zy ) / 1000 + cX ===== @
	subgt	r0,r3,r9	@ if ( i > 0 ) r0 = r3( zx * zx ) - r9( zy * zy )
	ble	process_color			@ if ( i <= 0 ) go to process_color
	ldr	r1,=num1000		@ load address of num1000 to r1
	ldr r1,[r1]			@ load value of num1000 to r1
	bl	__aeabi_idiv	@ r0 = r0(zx * zx - zy * zy) / r1( 1000 )
	ldr	r3,=cX			@ load address of cX to r3
	ldr	r3,[r3]			@ load value of cX to r3
	add	r0,r0,r3		@ r0 = r0( ( zx * zx - zy * zy ) / 1000 ) + r3( cx )
	ldr	r3,=tmp			@ load address of tmp to r3
	str	r0,[r3]			@ store r0( ( zx * zx - zy * zy ) / 1000 + cX ) to r3( tmp )

	@ ===== zy = ( 2 * zx * zy ) / 1000 + cY ===== @
	ldr	r2,=zx			@ load address of zx to r2
	ldr	r2,[r2]			@ load value of zx to r2
	mul	r0,r2,r8		@ r0 = r2( zx ) * r3( zy )
	mov	r0,r0,lsl#1		@ r0 = 2 * r0( zx * zy )
	bl	__aeabi_idiv	@ r0 = r0( 2 * ( zx * zy ) ) / r1( 1000 )
	ldr	r1,=cY			@ load address of cY to r1
	ldr	r1,[r1]			@ load value of cY to r1
	add	r0,r0,r1		@ r0 = r0( ( 2 * zx * zy ) / 1000 ) + r1( cY )
	ldr	r1,=zy			@ load address of zy to r1
	str	r0,[r1]			@ store r0( ( 2 * zx * zy ) / 1000 + cY ) to r1( zy )

	@ ===== zx = tmp ===== @
	ldr	r0,=zx			@ load address of zx to r0
	ldr	r1,=tmp			@ load address of tmp to r1
	ldr	r1,[r1]			@ load value of tmp to r1
	str	r1,[r0]			@ store r1( tmp ) to r0( zx )

	@ ===== i -- ===== @
	ldr	r0,=i			@ load address of i to r0
	ldr	r1,[r0]			@ load value of i to r1
	sub	r1,#1			@ r1 = r1( i ) - 1
	str	r1,[r0]			@ str r1( i value ) to r0( i )
	b	whileLoop		@ go to whileLoop

process_color:
	@ ===== color = ( ( i & 0xff ) << 8 ) | ( i & 0xff ) ===== @
	ldr	r1,=i	        @ load address of i to r1
	ldr	r1,[r1]	        @ load value of i to r1
	and	r0,r1,#0xff		@ r0 = r1( i ) & 0xff
	orr	r0,r0,r0,lsl#8	@ r0 = r0( i & 0xff ) | r0( i & 0xff ) << 8
	@ ===== color = ( ~ color ) & 0xffff ===== @
	mvn	r0,r0	        @ r0 = ~r0( ( i & 0xff ) | ( i & 0xff ) << 8 )
	mov r2,#0xff        @ r2 = 0xff
	mov r3,#8
	add r2,r2,r2,lsl r3  @ r2 = r2( 0xff ) + r2( 0xff ) << 8 = 0xffff
	and r0,r0,r2        @ r0 = r0( ~ ( ( i & 0xff ) | ( i & 0xff ) << 8 ) ) & r2( 0xffff )
	@ ===== frame[y][x] = color ===== @
	mla	r1,r6,r5,r4	    @ r1 = r6( width ) * r5( y ) + r4( x )
	mov	r1,r1,lsl#1	    @ r1 = 2 * r1( width * y + x )
	ldr	r2,=frame       @ load address of frame to r2
	ldr	r2,[r2]         @ load value of frame to r2
	strh	r0,[r2,r1]	@ frame[y][x] = r0( color )
	@ ===== if ( y < height ) y ++ ===== @
	add	r5,r5,#1	    @ r5( y ) = r5( y ) + 1
	cmp	r5,r7	        @ r5( y ) - r7( height )
	blt	yLoop	        @ if ( r5( y ) < r7( height ) ) go to yLoop
	@ ===== if ( x < width ) x ++ ===== @
	addge	r4,r4,#1	@ r4( x ) = r4( x ) + 1
	cmpge	r4,r6	    @ r4( x ) - r6 ( width )
	blt	set_yLoop	    @ if ( r4( x ) < r6 ( width ) ) go to set_yLoop

endJuliaSet:
	subs	r0,r14,r13  @ r0 = r14 - r13
	mov	r0,#0           @ r0 = 0
	ldmfd	sp!,{lr,sp} @ pop lr sp from stack
	mov	pc,lr           @ pc = lr



