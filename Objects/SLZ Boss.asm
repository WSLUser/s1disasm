; ---------------------------------------------------------------------------
; Object 7A - Eggman (SLZ)
; ---------------------------------------------------------------------------

		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	Obj7A_Index(pc,d0.w),d1
		jmp	Obj7A_Index(pc,d1.w)
; ===========================================================================
Obj7A_Index:	index *,,2
		ptr Obj7A_Main
		ptr Obj7A_ShipMain
		ptr Obj7A_FaceMain
		ptr Obj7A_FlameMain
		ptr Obj7A_TubeMain

Obj7A_ObjData:	dc.b 2,	0, 4		; routine number, animation, priority
		dc.b 4,	1, 4
		dc.b 6,	7, 4
		dc.b 8,	0, 3
; ===========================================================================

Obj7A_Main:
		move.w	#$2188,ost_x_pos(a0)
		move.w	#$228,ost_y_pos(a0)
		move.w	ost_x_pos(a0),$30(a0)
		move.w	ost_y_pos(a0),$38(a0)
		move.b	#$F,ost_col_type(a0)
		move.b	#8,ost_col_property(a0) ; set number of hits to 8
		lea	Obj7A_ObjData(pc),a2
		movea.l	a0,a1
		moveq	#3,d1
		bra.s	Obj7A_LoadBoss
; ===========================================================================

Obj7A_Loop:
		jsr	(FindNextFreeObj).l
		bne.s	loc_1895C
		move.b	#id_BossStarLight,0(a1)
		move.w	ost_x_pos(a0),ost_x_pos(a1)
		move.w	ost_y_pos(a0),ost_y_pos(a1)

Obj7A_LoadBoss:
		bclr	#0,ost_status(a0)
		clr.b	ost_routine2(a1)
		move.b	(a2)+,ost_routine(a1)
		move.b	(a2)+,ost_anim(a1)
		move.b	(a2)+,ost_priority(a1)
		move.l	#Map_Eggman,ost_mappings(a1)
		move.w	#tile_Nem_Eggman,ost_tile(a1)
		move.b	#render_rel,ost_render(a1)
		move.b	#$20,ost_actwidth(a1)
		move.l	a0,$34(a1)
		dbf	d1,Obj7A_Loop	; repeat sequence 3 more times

loc_1895C:
		lea	(v_objspace+$40).w,a1
		lea	$2A(a0),a2
		moveq	#$5E,d0
		moveq	#$3E,d1

loc_18968:
		cmp.b	(a1),d0
		bne.s	loc_18974
		tst.b	ost_subtype(a1)
		beq.s	loc_18974
		move.w	a1,(a2)+

loc_18974:
		adda.w	#$40,a1
		dbf	d1,loc_18968

Obj7A_ShipMain:	; Routine 2
		moveq	#0,d0
		move.b	ost_routine2(a0),d0
		move.w	Obj7A_ShipIndex(pc,d0.w),d0
		jsr	Obj7A_ShipIndex(pc,d0.w)
		lea	(Ani_Eggman).l,a1
		jsr	(AnimateSprite).l
		moveq	#3,d0
		and.b	ost_status(a0),d0
		andi.b	#$FC,ost_render(a0)
		or.b	d0,ost_render(a0)
		jmp	(DisplaySprite).l
; ===========================================================================
Obj7A_ShipIndex:index *
		ptr loc_189B8
		ptr loc_18A5E
		ptr Obj7A_MakeBall
		ptr loc_18B48
		ptr loc_18B80
		ptr loc_18BC6
; ===========================================================================

loc_189B8:
		move.w	#-$100,ost_x_vel(a0)
		cmpi.w	#$2120,$30(a0)
		bcc.s	loc_189CA
		addq.b	#2,ost_routine2(a0)

loc_189CA:
		bsr.w	BossMove
		move.b	$3F(a0),d0
		addq.b	#2,$3F(a0)
		jsr	(CalcSine).l
		asr.w	#6,d0
		add.w	$38(a0),d0
		move.w	d0,ost_y_pos(a0)
		move.w	$30(a0),ost_x_pos(a0)
		bra.s	loc_189FE
; ===========================================================================

loc_189EE:
		bsr.w	BossMove
		move.w	$38(a0),ost_y_pos(a0)
		move.w	$30(a0),ost_x_pos(a0)

loc_189FE:
		cmpi.b	#6,ost_routine2(a0)
		bcc.s	locret_18A44
		tst.b	ost_status(a0)
		bmi.s	loc_18A46
		tst.b	ost_col_type(a0)
		bne.s	locret_18A44
		tst.b	$3E(a0)
		bne.s	loc_18A28
		move.b	#$20,$3E(a0)
		sfx	sfx_HitBoss,0,0,0	; play boss damage sound

loc_18A28:
		lea	(v_pal_dry+$22).w,a1
		moveq	#0,d0
		tst.w	(a1)
		bne.s	loc_18A36
		move.w	#cWhite,d0

loc_18A36:
		move.w	d0,(a1)
		subq.b	#1,$3E(a0)
		bne.s	locret_18A44
		move.b	#$F,ost_col_type(a0)

locret_18A44:
		rts	
; ===========================================================================

loc_18A46:
		moveq	#100,d0
		bsr.w	AddPoints
		move.b	#6,ost_routine2(a0)
		move.b	#$78,$3C(a0)
		clr.w	ost_x_vel(a0)
		rts	
; ===========================================================================

loc_18A5E:
		move.w	$30(a0),d0
		move.w	#$200,ost_x_vel(a0)
		btst	#0,ost_status(a0)
		bne.s	loc_18A7C
		neg.w	ost_x_vel(a0)
		cmpi.w	#$2008,d0
		bgt.s	loc_18A88
		bra.s	loc_18A82
; ===========================================================================

loc_18A7C:
		cmpi.w	#$2138,d0
		blt.s	loc_18A88

loc_18A82:
		bchg	#0,ost_status(a0)

loc_18A88:
		move.w	8(a0),d0
		moveq	#-1,d1
		moveq	#2,d2
		lea	$2A(a0),a2
		moveq	#$28,d4
		tst.w	ost_x_vel(a0)
		bpl.s	loc_18A9E
		neg.w	d4

loc_18A9E:
		move.w	(a2)+,d1
		movea.l	d1,a3
		btst	#3,ost_status(a3)
		bne.s	loc_18AB4
		move.w	8(a3),d3
		add.w	d4,d3
		sub.w	d0,d3
		beq.s	loc_18AC0

loc_18AB4:
		dbf	d2,loc_18A9E

		move.b	d2,ost_subtype(a0)
		bra.w	loc_189CA
; ===========================================================================

loc_18AC0:
		move.b	d2,ost_subtype(a0)
		addq.b	#2,ost_routine2(a0)
		move.b	#$28,$3C(a0)
		bra.w	loc_189CA
; ===========================================================================

Obj7A_MakeBall:
		cmpi.b	#$28,$3C(a0)
		bne.s	loc_18B36
		moveq	#-1,d0
		move.b	ost_subtype(a0),d0
		ext.w	d0
		bmi.s	loc_18B40
		subq.w	#2,d0
		neg.w	d0
		add.w	d0,d0
		lea	$2A(a0),a1
		move.w	(a1,d0.w),d0
		movea.l	d0,a2
		lea	(v_objspace+$40).w,a1
		moveq	#$3E,d1

loc_18AFA:
		cmp.l	$3C(a1),d0
		beq.s	loc_18B40
		adda.w	#$40,a1
		dbf	d1,loc_18AFA

		move.l	a0,-(sp)
		lea	(a2),a0
		jsr	(FindNextFreeObj).l
		movea.l	(sp)+,a0
		bne.s	loc_18B40
		move.b	#id_BossSpikeball,(a1) ; load spiked ball object
		move.w	ost_x_pos(a0),ost_x_pos(a1)
		move.w	ost_y_pos(a0),ost_y_pos(a1)
		addi.w	#$20,ost_y_pos(a1)
		move.b	ost_status(a2),ost_status(a1)
		move.l	a2,$3C(a1)

loc_18B36:
		subq.b	#1,$3C(a0)
		beq.s	loc_18B40
		bra.w	loc_189FE
; ===========================================================================

loc_18B40:
		subq.b	#2,ost_routine2(a0)
		bra.w	loc_189CA
; ===========================================================================

loc_18B48:
		subq.b	#1,$3C(a0)
		bmi.s	loc_18B52
		bra.w	BossDefeated
; ===========================================================================

loc_18B52:
		addq.b	#2,ost_routine2(a0)
		clr.w	ost_y_vel(a0)
		bset	#0,ost_status(a0)
		bclr	#7,ost_status(a0)
		clr.w	ost_x_vel(a0)
		move.b	#-$18,$3C(a0)
		tst.b	(v_bossstatus).w
		bne.s	loc_18B7C
		move.b	#1,(v_bossstatus).w

loc_18B7C:
		bra.w	loc_189FE
; ===========================================================================

loc_18B80:
		addq.b	#1,$3C(a0)
		beq.s	loc_18B90
		bpl.s	loc_18B96
		addi.w	#$18,ost_y_vel(a0)
		bra.s	loc_18BC2
; ===========================================================================

loc_18B90:
		clr.w	ost_y_vel(a0)
		bra.s	loc_18BC2
; ===========================================================================

loc_18B96:
		cmpi.b	#$20,$3C(a0)
		bcs.s	loc_18BAE
		beq.s	loc_18BB4
		cmpi.b	#$2A,$3C(a0)
		bcs.s	loc_18BC2
		addq.b	#2,ost_routine2(a0)
		bra.s	loc_18BC2
; ===========================================================================

loc_18BAE:
		subq.w	#8,ost_y_vel(a0)
		bra.s	loc_18BC2
; ===========================================================================

loc_18BB4:
		clr.w	ost_y_vel(a0)
		music	bgm_SLZ,0,0,0		; play SLZ music

loc_18BC2:
		bra.w	loc_189EE
; ===========================================================================

loc_18BC6:
		move.w	#$400,ost_x_vel(a0)
		move.w	#-$40,ost_y_vel(a0)
		cmpi.w	#$2160,(v_limitright2).w
		bcc.s	loc_18BE0
		addq.w	#2,(v_limitright2).w
		bra.s	loc_18BE8
; ===========================================================================

loc_18BE0:
		tst.b	ost_render(a0)
		bpl.w	Obj7A_Delete

loc_18BE8:
		bsr.w	BossMove
		bra.w	loc_189CA
; ===========================================================================

Obj7A_FaceMain:	; Routine 4
		moveq	#0,d0
		moveq	#1,d1
		movea.l	$34(a0),a1
		move.b	ost_routine2(a1),d0
		cmpi.b	#6,d0
		bmi.s	loc_18C06
		moveq	#$A,d1
		bra.s	loc_18C1A
; ===========================================================================

loc_18C06:
		tst.b	ost_col_type(a1)
		bne.s	loc_18C10
		moveq	#5,d1
		bra.s	loc_18C1A
; ===========================================================================

loc_18C10:
		cmpi.b	#4,(v_player+ost_routine).w
		bcs.s	loc_18C1A
		moveq	#4,d1

loc_18C1A:
		move.b	d1,ost_anim(a0)
		cmpi.b	#$A,d0
		bne.s	loc_18C32
		move.b	#6,ost_anim(a0)
		tst.b	ost_render(a0)
		bpl.w	Obj7A_Delete

loc_18C32:
		bra.s	loc_18C6C
; ===========================================================================

Obj7A_FlameMain:; Routine 6
		move.b	#8,ost_anim(a0)
		movea.l	$34(a0),a1
		cmpi.b	#$A,ost_routine2(a1)
		bne.s	loc_18C56
		tst.b	ost_render(a0)
		bpl.w	Obj7A_Delete
		move.b	#$B,ost_anim(a0)
		bra.s	loc_18C6C
; ===========================================================================

loc_18C56:
		cmpi.b	#8,ost_routine2(a1)
		bgt.s	loc_18C6C
		cmpi.b	#4,ost_routine2(a1)
		blt.s	loc_18C6C
		move.b	#7,ost_anim(a0)

loc_18C6C:
		lea	(Ani_Eggman).l,a1
		jsr	(AnimateSprite).l

loc_18C78:
		movea.l	$34(a0),a1
		move.w	ost_x_pos(a1),ost_x_pos(a0)
		move.w	ost_y_pos(a1),ost_y_pos(a0)
		move.b	ost_status(a1),ost_status(a0)
		moveq	#3,d0
		and.b	ost_status(a0),d0
		andi.b	#$FC,ost_render(a0)
		or.b	d0,ost_render(a0)
		jmp	(DisplaySprite).l
; ===========================================================================

Obj7A_TubeMain:	; Routine 8
		movea.l	$34(a0),a1
		cmpi.b	#$A,ost_routine2(a1)
		bne.s	loc_18CB8
		tst.b	ost_render(a0)
		bpl.w	Obj7A_Delete

loc_18CB8:
		move.l	#Map_BossItems,ost_mappings(a0)
		move.w	#tile_Nem_Weapons+tile_pal2,ost_tile(a0)
		move.b	#3,ost_frame(a0)
		bra.s	loc_18C78