	.build_version macos, 26, 0	sdk_version 26, 4
	.section	__TEXT,__text,regular,pure_instructions
	.globl	_dot_prod                       ; -- Begin function dot_prod
	.p2align	2
_dot_prod:                              ; @dot_prod
	.cfi_startproc
; %bb.0:
	cmp	w2, #1
	b.lt	LBB0_3
; %bb.1:
	mov	w8, w2
	cmp	w2, #3
	b.hi	LBB0_4
; %bb.2:
	mov	x9, #0                          ; =0x0
	movi.2d	v0, #0000000000000000
	b	LBB0_13
LBB0_3:
	movi.2d	v0, #0000000000000000
	ret
LBB0_4:
	cmp	w2, #16
	b.hs	LBB0_6
; %bb.5:
	mov	x9, #0                          ; =0x0
	movi.2d	v0, #0000000000000000
	b	LBB0_10
LBB0_6:
	and	x9, x8, #0x7ffffff0
	add	x10, x0, #32
	add	x11, x1, #32
	movi.2d	v0, #0000000000000000
	mov	x12, x9
LBB0_7:                                 ; =>This Inner Loop Header: Depth=1
	ldp	q1, q2, [x10, #-32]
	ldp	q3, q4, [x10], #64
	ldp	q5, q6, [x11, #-32]
	ldp	q7, q16, [x11], #64
	fmul.4s	v1, v1, v5
	mov	s5, v1[3]
	mov	s17, v1[2]
	mov	s18, v1[1]
	fmul.4s	v2, v2, v6
	mov	s6, v2[3]
	mov	s19, v2[2]
	mov	s20, v2[1]
	fmul.4s	v3, v3, v7
	mov	s7, v3[3]
	mov	s21, v3[2]
	mov	s22, v3[1]
	fmul.4s	v4, v4, v16
	mov	s16, v4[3]
	mov	s23, v4[2]
	mov	s24, v4[1]
	fadd	s0, s0, s1
	fadd	s0, s0, s18
	fadd	s0, s0, s17
	fadd	s0, s0, s5
	fadd	s0, s0, s2
	fadd	s0, s0, s20
	fadd	s0, s0, s19
	fadd	s0, s0, s6
	fadd	s0, s0, s3
	fadd	s0, s0, s22
	fadd	s0, s0, s21
	fadd	s0, s0, s7
	fadd	s0, s0, s4
	fadd	s0, s0, s24
	fadd	s0, s0, s23
	fadd	s0, s0, s16
	subs	x12, x12, #16
	b.ne	LBB0_7
; %bb.8:
	cmp	x9, x8
	b.eq	LBB0_15
; %bb.9:
	tst	x8, #0xc
	b.eq	LBB0_13
LBB0_10:
	mov	x11, x9
	and	x9, x8, #0x7ffffffc
	sub	x10, x11, x9
	lsl	x12, x11, #2
	add	x11, x1, x12
	add	x12, x0, x12
LBB0_11:                                ; =>This Inner Loop Header: Depth=1
	ldr	q1, [x12], #16
	ldr	q2, [x11], #16
	fmul.4s	v1, v1, v2
	mov	s2, v1[3]
	mov	s3, v1[2]
	mov	s4, v1[1]
	fadd	s0, s0, s1
	fadd	s0, s0, s4
	fadd	s0, s0, s3
	fadd	s0, s0, s2
	adds	x10, x10, #4
	b.ne	LBB0_11
; %bb.12:
	cmp	x9, x8
	b.eq	LBB0_15
LBB0_13:
	lsl	x11, x9, #2
	add	x10, x1, x11
	add	x11, x0, x11
	sub	x8, x8, x9
LBB0_14:                                ; =>This Inner Loop Header: Depth=1
	ldr	s1, [x11], #4
	ldr	s2, [x10], #4
	fmadd	s0, s1, s2, s0
	subs	x8, x8, #1
	b.ne	LBB0_14
LBB0_15:
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	_dot_prod_restrict              ; -- Begin function dot_prod_restrict
	.p2align	2
_dot_prod_restrict:                     ; @dot_prod_restrict
	.cfi_startproc
; %bb.0:
	cmp	w2, #1
	b.lt	LBB1_3
; %bb.1:
	mov	w8, w2
	cmp	w2, #3
	b.hi	LBB1_4
; %bb.2:
	mov	x9, #0                          ; =0x0
	movi.2d	v0, #0000000000000000
	b	LBB1_13
LBB1_3:
	movi.2d	v0, #0000000000000000
	ret
LBB1_4:
	cmp	w2, #16
	b.hs	LBB1_6
; %bb.5:
	mov	x9, #0                          ; =0x0
	movi.2d	v0, #0000000000000000
	b	LBB1_10
LBB1_6:
	and	x9, x8, #0x7ffffff0
	add	x10, x0, #32
	add	x11, x1, #32
	movi.2d	v0, #0000000000000000
	mov	x12, x9
LBB1_7:                                 ; =>This Inner Loop Header: Depth=1
	ldp	q1, q2, [x10, #-32]
	ldp	q3, q4, [x10], #64
	ldp	q5, q6, [x11, #-32]
	ldp	q7, q16, [x11], #64
	fmul.4s	v1, v1, v5
	mov	s5, v1[3]
	mov	s17, v1[2]
	mov	s18, v1[1]
	fmul.4s	v2, v2, v6
	mov	s6, v2[3]
	mov	s19, v2[2]
	mov	s20, v2[1]
	fmul.4s	v3, v3, v7
	mov	s7, v3[3]
	mov	s21, v3[2]
	mov	s22, v3[1]
	fmul.4s	v4, v4, v16
	mov	s16, v4[3]
	mov	s23, v4[2]
	mov	s24, v4[1]
	fadd	s0, s0, s1
	fadd	s0, s0, s18
	fadd	s0, s0, s17
	fadd	s0, s0, s5
	fadd	s0, s0, s2
	fadd	s0, s0, s20
	fadd	s0, s0, s19
	fadd	s0, s0, s6
	fadd	s0, s0, s3
	fadd	s0, s0, s22
	fadd	s0, s0, s21
	fadd	s0, s0, s7
	fadd	s0, s0, s4
	fadd	s0, s0, s24
	fadd	s0, s0, s23
	fadd	s0, s0, s16
	subs	x12, x12, #16
	b.ne	LBB1_7
; %bb.8:
	cmp	x9, x8
	b.eq	LBB1_15
; %bb.9:
	tst	x8, #0xc
	b.eq	LBB1_13
LBB1_10:
	mov	x11, x9
	and	x9, x8, #0x7ffffffc
	sub	x10, x11, x9
	lsl	x12, x11, #2
	add	x11, x1, x12
	add	x12, x0, x12
LBB1_11:                                ; =>This Inner Loop Header: Depth=1
	ldr	q1, [x12], #16
	ldr	q2, [x11], #16
	fmul.4s	v1, v1, v2
	mov	s2, v1[3]
	mov	s3, v1[2]
	mov	s4, v1[1]
	fadd	s0, s0, s1
	fadd	s0, s0, s4
	fadd	s0, s0, s3
	fadd	s0, s0, s2
	adds	x10, x10, #4
	b.ne	LBB1_11
; %bb.12:
	cmp	x9, x8
	b.eq	LBB1_15
LBB1_13:
	lsl	x11, x9, #2
	add	x10, x1, x11
	add	x11, x0, x11
	sub	x8, x8, x9
LBB1_14:                                ; =>This Inner Loop Header: Depth=1
	ldr	s1, [x11], #4
	ldr	s2, [x10], #4
	fmadd	s0, s1, s2, s0
	subs	x8, x8, #1
	b.ne	LBB1_14
LBB1_15:
	ret
	.cfi_endproc
                                        ; -- End function
.subsections_via_symbols
