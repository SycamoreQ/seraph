	.build_version macos, 26, 0	sdk_version 26, 4
	.section	__TEXT,__text,regular,pure_instructions
	.globl	_softmax                        ; -- Begin function softmax
	.p2align	2
_softmax:                               ; @softmax
	.cfi_startproc
; %bb.0:
	cmp	w1, #1
	b.lt	LBB0_24
; %bb.1:
	sub	sp, sp, #304
	stp	d9, d8, [sp, #208]              ; 16-byte Folded Spill
	stp	x28, x27, [sp, #224]            ; 16-byte Folded Spill
	stp	x24, x23, [sp, #240]            ; 16-byte Folded Spill
	stp	x22, x21, [sp, #256]            ; 16-byte Folded Spill
	stp	x20, x19, [sp, #272]            ; 16-byte Folded Spill
	stp	x29, x30, [sp, #288]            ; 16-byte Folded Spill
	add	x29, sp, #288
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
	.cfi_offset w21, -40
	.cfi_offset w22, -48
	.cfi_offset w23, -56
	.cfi_offset w24, -64
	.cfi_offset w27, -72
	.cfi_offset w28, -80
	.cfi_offset b8, -88
	.cfi_offset b9, -96
	mov	x20, x1
	mov	x19, x0
	mov	w21, w1
	mov	w8, #-8388608                   ; =0xff800000
	fmov	s1, w8
	mov	x8, x21
	mov	x9, x0
LBB0_2:                                 ; =>This Inner Loop Header: Depth=1
	ldr	s0, [x9], #4
	fcmp	s0, s1
	fcsel	s1, s0, s1, gt
	subs	x8, x8, #1
	b.ne	LBB0_2
; %bb.3:
	cmp	w20, #8
	b.hs	LBB0_5
; %bb.4:
	mov	x22, #0                         ; =0x0
	movi.2d	v5, #0000000000000000
	b	LBB0_8
LBB0_5:
	and	x22, x21, #0x7ffffff8
	stur	q1, [x29, #-112]                ; 16-byte Folded Spill
	dup.2s	v8, v1[0]
	add	x23, x19, #16
	movi.2d	v5, #0000000000000000
	mov	x24, x22
LBB0_6:                                 ; =>This Inner Loop Header: Depth=1
	stur	q5, [x29, #-96]                 ; 16-byte Folded Spill
	ldp	d0, d1, [x23, #-16]
	ldp	d2, d3, [x23]
	fsub.2s	v4, v0, v8
	fsub.2s	v0, v1, v8
	str	q0, [sp, #96]                   ; 16-byte Folded Spill
	fsub.2s	v0, v2, v8
	stp	q0, q4, [sp, #112]              ; 32-byte Folded Spill
	fsub.2s	v0, v3, v8
	str	q0, [sp, #144]                  ; 16-byte Folded Spill
	mov	s0, v4[1]
	bl	_expf
                                        ; kill: def $s0 killed $s0 def $q0
	stur	q0, [x29, #-128]                ; 16-byte Folded Spill
	ldr	q0, [sp, #128]                  ; 16-byte Folded Reload
                                        ; kill: def $s0 killed $s0 killed $q0
	bl	_expf
                                        ; kill: def $s0 killed $s0 def $q0
	str	q0, [sp, #64]                   ; 16-byte Folded Spill
	mov.16b	v1, v0
	ldur	q0, [x29, #-128]                ; 16-byte Folded Reload
	mov.s	v1[1], v0[0]
	str	q1, [sp, #80]                   ; 16-byte Folded Spill
	ldr	q0, [sp, #96]                   ; 16-byte Folded Reload
	mov	s0, v0[1]
	bl	_expf
                                        ; kill: def $s0 killed $s0 def $q0
	str	q0, [sp, #128]                  ; 16-byte Folded Spill
	ldr	q0, [sp, #96]                   ; 16-byte Folded Reload
                                        ; kill: def $s0 killed $s0 killed $q0
	bl	_expf
                                        ; kill: def $s0 killed $s0 def $q0
	str	q0, [sp, #32]                   ; 16-byte Folded Spill
	mov.16b	v1, v0
	ldp	q0, q2, [sp, #112]              ; 32-byte Folded Reload
	mov.s	v1[1], v2[0]
	str	q1, [sp, #48]                   ; 16-byte Folded Spill
	mov	s0, v0[1]
	bl	_expf
                                        ; kill: def $s0 killed $s0 def $q0
	str	q0, [sp, #96]                   ; 16-byte Folded Spill
	ldr	q0, [sp, #112]                  ; 16-byte Folded Reload
                                        ; kill: def $s0 killed $s0 killed $q0
	bl	_expf
                                        ; kill: def $s0 killed $s0 def $q0
	str	q0, [sp, #16]                   ; 16-byte Folded Spill
	mov.16b	v1, v0
	ldr	q0, [sp, #96]                   ; 16-byte Folded Reload
	mov.s	v1[1], v0[0]
	str	q1, [sp, #112]                  ; 16-byte Folded Spill
	ldr	q0, [sp, #144]                  ; 16-byte Folded Reload
	mov	s0, v0[1]
	bl	_expf
                                        ; kill: def $s0 killed $s0 def $q0
	str	q0, [sp]                        ; 16-byte Folded Spill
	ldr	q0, [sp, #144]                  ; 16-byte Folded Reload
                                        ; kill: def $s0 killed $s0 killed $q0
	bl	_expf
                                        ; kill: def $s0 killed $s0 def $q0
	ldur	q1, [x29, #-96]                 ; 16-byte Folded Reload
	ldr	q2, [sp, #64]                   ; 16-byte Folded Reload
	fadd	s1, s1, s2
	ldur	q2, [x29, #-128]                ; 16-byte Folded Reload
	fadd	s1, s1, s2
	ldr	q2, [sp, #32]                   ; 16-byte Folded Reload
	fadd	s1, s1, s2
	ldr	q2, [sp, #128]                  ; 16-byte Folded Reload
	fadd	s1, s1, s2
	ldp	q3, q2, [sp]                    ; 32-byte Folded Reload
	fadd	s1, s1, s2
	ldp	q5, q4, [sp, #80]               ; 32-byte Folded Reload
	fadd	s1, s1, s4
	fadd	s1, s1, s0
	mov.s	v0[1], v3[0]
	ldr	q2, [sp, #48]                   ; 16-byte Folded Reload
	stp	d5, d2, [x23, #-16]
	ldr	q2, [sp, #112]                  ; 16-byte Folded Reload
	stp	d2, d0, [x23], #32
	fadd	s5, s1, s3
	subs	x24, x24, #8
	b.ne	LBB0_6
; %bb.7:
	cmp	x22, x21
	ldur	q1, [x29, #-112]                ; 16-byte Folded Reload
	b.eq	LBB0_10
LBB0_8:
	add	x23, x19, x22, lsl #2
	sub	x22, x21, x22
LBB0_9:                                 ; =>This Inner Loop Header: Depth=1
	stp	q1, q5, [x29, #-112]            ; 32-byte Folded Spill
	ldr	s0, [x23]
	fsub	s0, s0, s1
	bl	_expf
	ldp	q1, q5, [x29, #-112]            ; 32-byte Folded Reload
	str	s0, [x23], #4
	fadd	s5, s5, s0
	subs	x22, x22, #1
	b.ne	LBB0_9
LBB0_10:
	cmp	w20, #3
	b.hi	LBB0_12
; %bb.11:
	mov	x8, #0                          ; =0x0
	b	LBB0_21
LBB0_12:
	cmp	w20, #16
	b.hs	LBB0_14
; %bb.13:
	mov	x8, #0                          ; =0x0
	b	LBB0_18
LBB0_14:
	and	x8, x21, #0x7ffffff0
	dup.4s	v0, v5[0]
	add	x9, x19, #32
	mov	x10, x8
LBB0_15:                                ; =>This Inner Loop Header: Depth=1
	ldp	q1, q2, [x9, #-32]
	ldp	q3, q4, [x9]
	fdiv.4s	v1, v1, v0
	fdiv.4s	v2, v2, v0
	fdiv.4s	v3, v3, v0
	fdiv.4s	v4, v4, v0
	stp	q1, q2, [x9, #-32]
	stp	q3, q4, [x9], #64
	subs	x10, x10, #16
	b.ne	LBB0_15
; %bb.16:
	cmp	x8, x21
	b.eq	LBB0_23
; %bb.17:
	tst	x21, #0xc
	b.eq	LBB0_21
LBB0_18:
	mov	x10, x8
	and	x8, x21, #0x7ffffffc
	dup.4s	v0, v5[0]
	sub	x9, x10, x8
	add	x10, x19, x10, lsl #2
LBB0_19:                                ; =>This Inner Loop Header: Depth=1
	ldr	q1, [x10]
	fdiv.4s	v1, v1, v0
	str	q1, [x10], #16
	adds	x9, x9, #4
	b.ne	LBB0_19
; %bb.20:
	cmp	x8, x21
	b.eq	LBB0_23
LBB0_21:
	add	x9, x19, x8, lsl #2
	sub	x8, x21, x8
LBB0_22:                                ; =>This Inner Loop Header: Depth=1
	ldr	s0, [x9]
	fdiv	s0, s0, s5
	str	s0, [x9], #4
	subs	x8, x8, #1
	b.ne	LBB0_22
LBB0_23:
	ldp	x29, x30, [sp, #288]            ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #272]            ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #256]            ; 16-byte Folded Reload
	ldp	x24, x23, [sp, #240]            ; 16-byte Folded Reload
	ldp	x28, x27, [sp, #224]            ; 16-byte Folded Reload
	ldp	d9, d8, [sp, #208]              ; 16-byte Folded Reload
	add	sp, sp, #304
LBB0_24:
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	_softmax_restrict               ; -- Begin function softmax_restrict
	.p2align	2
_softmax_restrict:                      ; @softmax_restrict
	.cfi_startproc
; %bb.0:
	cmp	w2, #1
	b.lt	LBB1_24
; %bb.1:
	sub	sp, sp, #320
	stp	d9, d8, [sp, #208]              ; 16-byte Folded Spill
	stp	x28, x27, [sp, #224]            ; 16-byte Folded Spill
	stp	x26, x25, [sp, #240]            ; 16-byte Folded Spill
	stp	x24, x23, [sp, #256]            ; 16-byte Folded Spill
	stp	x22, x21, [sp, #272]            ; 16-byte Folded Spill
	stp	x20, x19, [sp, #288]            ; 16-byte Folded Spill
	stp	x29, x30, [sp, #304]            ; 16-byte Folded Spill
	add	x29, sp, #304
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
	.cfi_offset w21, -40
	.cfi_offset w22, -48
	.cfi_offset w23, -56
	.cfi_offset w24, -64
	.cfi_offset w25, -72
	.cfi_offset w26, -80
	.cfi_offset w27, -88
	.cfi_offset w28, -96
	.cfi_offset b8, -104
	.cfi_offset b9, -112
	mov	x20, x2
	mov	x19, x1
	mov	w21, w2
	mov	w8, #-8388608                   ; =0xff800000
	fmov	s1, w8
	mov	x8, x21
	mov	x9, x0
LBB1_2:                                 ; =>This Inner Loop Header: Depth=1
	ldr	s0, [x9], #4
	fcmp	s0, s1
	fcsel	s1, s0, s1, gt
	subs	x8, x8, #1
	b.ne	LBB1_2
; %bb.3:
	cmp	w20, #8
	b.hs	LBB1_5
; %bb.4:
	mov	x22, #0                         ; =0x0
	movi.2d	v5, #0000000000000000
	b	LBB1_8
LBB1_5:
	and	x22, x21, #0x7ffffff8
	stur	q1, [x29, #-128]                ; 16-byte Folded Spill
	dup.2s	v8, v1[0]
	mov	x23, x0
	add	x24, x0, #16
	add	x25, x19, #16
	movi.2d	v5, #0000000000000000
	mov	x26, x22
LBB1_6:                                 ; =>This Inner Loop Header: Depth=1
	stur	q5, [x29, #-112]                ; 16-byte Folded Spill
	ldp	d0, d1, [x24, #-16]
	ldp	d2, d3, [x24], #32
	fsub.2s	v4, v0, v8
	fsub.2s	v0, v1, v8
	str	q0, [sp, #96]                   ; 16-byte Folded Spill
	fsub.2s	v0, v2, v8
	stp	q0, q4, [sp, #112]              ; 32-byte Folded Spill
	fsub.2s	v0, v3, v8
	str	q0, [sp, #144]                  ; 16-byte Folded Spill
	mov	s0, v4[1]
	bl	_expf
                                        ; kill: def $s0 killed $s0 def $q0
	stur	q0, [x29, #-144]                ; 16-byte Folded Spill
	ldr	q0, [sp, #128]                  ; 16-byte Folded Reload
                                        ; kill: def $s0 killed $s0 killed $q0
	bl	_expf
                                        ; kill: def $s0 killed $s0 def $q0
	str	q0, [sp, #64]                   ; 16-byte Folded Spill
	mov.16b	v1, v0
	ldur	q0, [x29, #-144]                ; 16-byte Folded Reload
	mov.s	v1[1], v0[0]
	str	q1, [sp, #80]                   ; 16-byte Folded Spill
	ldr	q0, [sp, #96]                   ; 16-byte Folded Reload
	mov	s0, v0[1]
	bl	_expf
                                        ; kill: def $s0 killed $s0 def $q0
	str	q0, [sp, #128]                  ; 16-byte Folded Spill
	ldr	q0, [sp, #96]                   ; 16-byte Folded Reload
                                        ; kill: def $s0 killed $s0 killed $q0
	bl	_expf
                                        ; kill: def $s0 killed $s0 def $q0
	str	q0, [sp, #32]                   ; 16-byte Folded Spill
	mov.16b	v1, v0
	ldp	q0, q2, [sp, #112]              ; 32-byte Folded Reload
	mov.s	v1[1], v2[0]
	str	q1, [sp, #48]                   ; 16-byte Folded Spill
	mov	s0, v0[1]
	bl	_expf
                                        ; kill: def $s0 killed $s0 def $q0
	str	q0, [sp, #96]                   ; 16-byte Folded Spill
	ldr	q0, [sp, #112]                  ; 16-byte Folded Reload
                                        ; kill: def $s0 killed $s0 killed $q0
	bl	_expf
                                        ; kill: def $s0 killed $s0 def $q0
	str	q0, [sp, #16]                   ; 16-byte Folded Spill
	mov.16b	v1, v0
	ldr	q0, [sp, #96]                   ; 16-byte Folded Reload
	mov.s	v1[1], v0[0]
	str	q1, [sp, #112]                  ; 16-byte Folded Spill
	ldr	q0, [sp, #144]                  ; 16-byte Folded Reload
	mov	s0, v0[1]
	bl	_expf
                                        ; kill: def $s0 killed $s0 def $q0
	str	q0, [sp]                        ; 16-byte Folded Spill
	ldr	q0, [sp, #144]                  ; 16-byte Folded Reload
                                        ; kill: def $s0 killed $s0 killed $q0
	bl	_expf
                                        ; kill: def $s0 killed $s0 def $q0
	ldur	q1, [x29, #-112]                ; 16-byte Folded Reload
	ldr	q2, [sp, #64]                   ; 16-byte Folded Reload
	fadd	s1, s1, s2
	ldur	q2, [x29, #-144]                ; 16-byte Folded Reload
	fadd	s1, s1, s2
	ldr	q2, [sp, #32]                   ; 16-byte Folded Reload
	fadd	s1, s1, s2
	ldr	q2, [sp, #128]                  ; 16-byte Folded Reload
	fadd	s1, s1, s2
	ldp	q3, q2, [sp]                    ; 32-byte Folded Reload
	fadd	s1, s1, s2
	ldp	q5, q4, [sp, #80]               ; 32-byte Folded Reload
	fadd	s1, s1, s4
	fadd	s1, s1, s0
	mov.s	v0[1], v3[0]
	ldr	q2, [sp, #48]                   ; 16-byte Folded Reload
	stp	d5, d2, [x25, #-16]
	ldr	q2, [sp, #112]                  ; 16-byte Folded Reload
	stp	d2, d0, [x25], #32
	fadd	s5, s1, s3
	subs	x26, x26, #8
	b.ne	LBB1_6
; %bb.7:
	cmp	x22, x21
	mov	x0, x23
	ldur	q1, [x29, #-128]                ; 16-byte Folded Reload
	b.eq	LBB1_10
LBB1_8:
	lsl	x8, x22, #2
	add	x23, x19, x8
	add	x24, x0, x8
	sub	x22, x21, x22
LBB1_9:                                 ; =>This Inner Loop Header: Depth=1
	stp	q1, q5, [x29, #-128]            ; 32-byte Folded Spill
	ldr	s0, [x24], #4
	fsub	s0, s0, s1
	bl	_expf
	ldp	q1, q5, [x29, #-128]            ; 32-byte Folded Reload
	str	s0, [x23], #4
	fadd	s5, s5, s0
	subs	x22, x22, #1
	b.ne	LBB1_9
LBB1_10:
	cmp	w20, #3
	b.hi	LBB1_12
; %bb.11:
	mov	x8, #0                          ; =0x0
	b	LBB1_21
LBB1_12:
	cmp	w20, #16
	b.hs	LBB1_14
; %bb.13:
	mov	x8, #0                          ; =0x0
	b	LBB1_18
LBB1_14:
	and	x8, x21, #0x7ffffff0
	dup.4s	v0, v5[0]
	add	x9, x19, #32
	mov	x10, x8
LBB1_15:                                ; =>This Inner Loop Header: Depth=1
	ldp	q1, q2, [x9, #-32]
	ldp	q3, q4, [x9]
	fdiv.4s	v1, v1, v0
	fdiv.4s	v2, v2, v0
	fdiv.4s	v3, v3, v0
	fdiv.4s	v4, v4, v0
	stp	q1, q2, [x9, #-32]
	stp	q3, q4, [x9], #64
	subs	x10, x10, #16
	b.ne	LBB1_15
; %bb.16:
	cmp	x8, x21
	b.eq	LBB1_23
; %bb.17:
	tst	x21, #0xc
	b.eq	LBB1_21
LBB1_18:
	mov	x10, x8
	and	x8, x21, #0x7ffffffc
	dup.4s	v0, v5[0]
	sub	x9, x10, x8
	add	x10, x19, x10, lsl #2
LBB1_19:                                ; =>This Inner Loop Header: Depth=1
	ldr	q1, [x10]
	fdiv.4s	v1, v1, v0
	str	q1, [x10], #16
	adds	x9, x9, #4
	b.ne	LBB1_19
; %bb.20:
	cmp	x8, x21
	b.eq	LBB1_23
LBB1_21:
	add	x9, x19, x8, lsl #2
	sub	x8, x21, x8
LBB1_22:                                ; =>This Inner Loop Header: Depth=1
	ldr	s0, [x9]
	fdiv	s0, s0, s5
	str	s0, [x9], #4
	subs	x8, x8, #1
	b.ne	LBB1_22
LBB1_23:
	ldp	x29, x30, [sp, #304]            ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #288]            ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #272]            ; 16-byte Folded Reload
	ldp	x24, x23, [sp, #256]            ; 16-byte Folded Reload
	ldp	x26, x25, [sp, #240]            ; 16-byte Folded Reload
	ldp	x28, x27, [sp, #224]            ; 16-byte Folded Reload
	ldp	d9, d8, [sp, #208]              ; 16-byte Folded Reload
	add	sp, sp, #320
LBB1_24:
	ret
	.cfi_endproc
                                        ; -- End function
.subsections_via_symbols
