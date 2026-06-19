	.build_version macos, 26, 0	sdk_version 26, 4
	.section	__TEXT,__text,regular,pure_instructions
	.globl	_saxpy                          ; -- Begin function saxpy
	.p2align	2
_saxpy:                                 ; @saxpy
	.cfi_startproc
; %bb.0:
                                        ; kill: def $s0 killed $s0 def $q0
	cmp	w2, #1
	b.lt	LBB0_8
; %bb.1:
	mov	w8, w2
	cmp	w2, #3
	b.ls	LBB0_5
; %bb.2:
	lsl	x9, x8, #2
	add	x10, x1, x9
	add	x9, x0, x9
	cmp	x1, x9
	ccmp	x0, x10, #2, lo
	b.lo	LBB0_5
; %bb.3:
	cmp	w2, #16
	b.hs	LBB0_9
; %bb.4:
	mov	x9, #0                          ; =0x0
	b	LBB0_13
LBB0_5:
	mov	x9, #0                          ; =0x0
LBB0_6:
	lsl	x11, x9, #2
	add	x10, x1, x11
	add	x11, x0, x11
	sub	x8, x8, x9
LBB0_7:                                 ; =>This Inner Loop Header: Depth=1
	ldr	s1, [x11], #4
	ldr	s2, [x10]
	fmadd	s1, s0, s1, s2
	str	s1, [x10], #4
	subs	x8, x8, #1
	b.ne	LBB0_7
LBB0_8:
	ret
LBB0_9:
	and	x9, x8, #0x7ffffff0
	add	x10, x0, #32
	add	x11, x1, #32
	mov	x12, x9
LBB0_10:                                ; =>This Inner Loop Header: Depth=1
	ldp	q1, q2, [x10, #-32]
	ldp	q3, q4, [x10], #64
	ldp	q5, q6, [x11, #-32]
	ldp	q7, q16, [x11]
	fmla.4s	v5, v1, v0[0]
	fmla.4s	v6, v2, v0[0]
	fmla.4s	v7, v3, v0[0]
	fmla.4s	v16, v4, v0[0]
	stp	q5, q6, [x11, #-32]
	stp	q7, q16, [x11], #64
	subs	x12, x12, #16
	b.ne	LBB0_10
; %bb.11:
	cmp	x9, x8
	b.eq	LBB0_8
; %bb.12:
	tst	x8, #0xc
	b.eq	LBB0_6
LBB0_13:
	mov	x11, x9
	and	x9, x8, #0x7ffffffc
	sub	x10, x11, x9
	lsl	x12, x11, #2
	add	x11, x1, x12
	add	x12, x0, x12
LBB0_14:                                ; =>This Inner Loop Header: Depth=1
	ldr	q1, [x12], #16
	ldr	q2, [x11]
	fmla.4s	v2, v1, v0[0]
	str	q2, [x11], #16
	adds	x10, x10, #4
	b.ne	LBB0_14
; %bb.15:
	cmp	x9, x8
	b.ne	LBB0_6
	b	LBB0_8
	.cfi_endproc
                                        ; -- End function
	.globl	_saxpy_restrict                 ; -- Begin function saxpy_restrict
	.p2align	2
_saxpy_restrict:                        ; @saxpy_restrict
	.cfi_startproc
; %bb.0:
                                        ; kill: def $s0 killed $s0 def $q0
	cmp	w2, #1
	b.lt	LBB1_14
; %bb.1:
	mov	w8, w2
	cmp	w2, #3
	b.hi	LBB1_3
; %bb.2:
	mov	x9, #0                          ; =0x0
	b	LBB1_12
LBB1_3:
	cmp	w2, #16
	b.hs	LBB1_5
; %bb.4:
	mov	x9, #0                          ; =0x0
	b	LBB1_9
LBB1_5:
	and	x9, x8, #0x7ffffff0
	add	x10, x0, #32
	add	x11, x1, #32
	mov	x12, x9
LBB1_6:                                 ; =>This Inner Loop Header: Depth=1
	ldp	q1, q2, [x10, #-32]
	ldp	q3, q4, [x10], #64
	ldp	q5, q6, [x11, #-32]
	ldp	q7, q16, [x11]
	fmla.4s	v5, v1, v0[0]
	fmla.4s	v6, v2, v0[0]
	fmla.4s	v7, v3, v0[0]
	fmla.4s	v16, v4, v0[0]
	stp	q5, q6, [x11, #-32]
	stp	q7, q16, [x11], #64
	subs	x12, x12, #16
	b.ne	LBB1_6
; %bb.7:
	cmp	x9, x8
	b.eq	LBB1_14
; %bb.8:
	tst	x8, #0xc
	b.eq	LBB1_12
LBB1_9:
	mov	x11, x9
	and	x9, x8, #0x7ffffffc
	sub	x10, x11, x9
	lsl	x12, x11, #2
	add	x11, x1, x12
	add	x12, x0, x12
LBB1_10:                                ; =>This Inner Loop Header: Depth=1
	ldr	q1, [x12], #16
	ldr	q2, [x11]
	fmla.4s	v2, v1, v0[0]
	str	q2, [x11], #16
	adds	x10, x10, #4
	b.ne	LBB1_10
; %bb.11:
	cmp	x9, x8
	b.eq	LBB1_14
LBB1_12:
	lsl	x11, x9, #2
	add	x10, x1, x11
	add	x11, x0, x11
	sub	x8, x8, x9
LBB1_13:                                ; =>This Inner Loop Header: Depth=1
	ldr	s1, [x11], #4
	ldr	s2, [x10]
	fmadd	s1, s0, s1, s2
	str	s1, [x10], #4
	subs	x8, x8, #1
	b.ne	LBB1_13
LBB1_14:
	ret
	.cfi_endproc
                                        ; -- End function
.subsections_via_symbols
