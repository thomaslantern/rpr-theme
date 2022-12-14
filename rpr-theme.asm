
	
	org $BFF0
	
	db "NES",$1a	;ID
	db $01			;Rom pages
	db $0
	db %01000010
	db %00000000
	db 0
	db 0,0,0,0,0,0,0
	

vblanked	equ $7F

nmihandler:
	php
	inc vblanked
	plp
	
	; decrement
	ldx $0F 			; Counter for square1 note
	dex
	stx $0F
	ldx $0D 			; Counter for triangle note 
	dex					
	stx $0D
	lda $07
	bne nextSoundFrame
	
irqhandler:
	rti

	
ProgramStart:
	sei
	cld
	
	ldx #$ff
	txs
	
	lda #%10000000
	sta $A001
	
	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;
;ScreenInit

	; Turn the screen on
	lda #%00011110		
	sta $2001			
	
	lda #$80
	sta $2000

	
	;; Note counter
	ldx #0
	stx $0E
	
	ldx #1
	stx $07 		; Stop playing music if disabled
	ldx #0
	stx $0A 		; Extra note jump as part has more than 256 notes
	
	;; Note duration
	ldx #0
	stx $0F

		
	;; Note two counter - pitch
	ldx #0
	stx $0C
	
	;; Note two counter - length
	ldx #0
	stx $08
	
	;; Note two duration
	ldx #0
	stx $0D
	
	;; Turn on instruments
	lda #$0F
	sta $4015
	
	;; Config square 1
	lda #$DF
	sta $4000
	
	;; Setting negate flag for sweep
	lda #$00
	sta $4001
	
	;; Config square 2
	lda #%10110011
	sta $4004
	
	;; Setting negate flag for sweep
	lda #$08
	sta $4005
	
	;; Turn on triangle, disable length counter
	lda %10000001
	sta $4008
	
	
nextSoundFrame:			; Load a new note

;;Square1	
	ldx $0F
	cpx #0
	bne Triangle
	
	
	ldx $0E
	cpx #64
	bne afterExtraJump
	ldx #0
	stx $0E 			; Reset basic counter
	ldx $0A
	inx
	stx $0A
	
afterExtraJump:	
	ldx $0A
	lda extrajump,x		; Get extra amount for correct jump
	cmp #1				; 1 is code for stop music
	bne keepPlaying
	lda $00
	sta $4015
	jmp *
keepPlaying:
	sta $09				; Store jump value
	lda $0E 			; Find actual note counter
	clc 				; Clear the carry,
	adc $09				; add a + x,
	tax					; store in x.
	
	lda notes,x
	sta $4002
	lda notes+1,x
	sta $4003
	
	;; Load duration of note
	lda #8
	
	sta $0F 			; Store duration
	
	ldx $0E
	inx
	inx
	stx $0E 			; Increase note count
	
Triangle:
	ldx $0D
	cpx #0
	bne waitframe
	lda %10000001
	sta $4008
	
	ldx $0C
	lda notes2,x
	cmp #$0004
	bne playNote
skipNote:
	lda %00000000
	sta $4008
	jmp increment2
playNote:
	sta $400A
	lda notes2+1,x
	sta $400B
	;; Load duration of note
increment2:
	inx
	inx
	stx $0C
	
	ldx $08
	lda duration2,x
	cmp #1
	bne keepPlayingTri
	lda #0
	sta $07 		; No more playing notes!
	jmp *
keepPlayingTri:
	sta $0D 		; Store note duration
		
	inx
	stx $08 		; Increase note count - length
	
;;;;;;;;;;;;;;;;;;

waitframe:
	pha
		lda #$00
		sta vblanked	; zero vblanked
waitloop:
		lda vblanked	; wait for the interrupt to change it
		beq waitloop
	pla
	rts


notes:
	dw $023A,$01C4,$017C,$011C,$00E2,$011C,$017C,$01C4
	dw $01DF,$017C,$013F,$00EF,$00BD,$00EF,$013F,$017C
	dw $027F,$01FB,$01AB,$013F,$00FD,$013F,$01AB,$01FB
	dw $021A,$01AB,$0167,$010C,$00D2,$010C,$0167,$01AB
	dw $02CE,$023A,$01DF,$017C,$0167,$017c,$01DF,$023A
	dw $02CE,$023A,$01DF,$017C,$0167,$017c,$01DF,$023A
	dw $02CE,$023A,$01DF,$017C,$0167,$017c,$01DF,$023A
	dw $02CE,$023A,$01DF,$017C,$0167,$017c,$01DF,$023A
	dw $027F,$01FB,$01AB,$013F,$00FD,$013F,$01AB,$01FB
	dw $027F,$01FB,$01AB,$013F,$00FD,$013F,$01AB,$01FB
	dw $027F,$01FB,$01AB,$013F,$00FD,$013F,$01AB,$01FB
	dw $027F,$01FB,$01AB,$013F,$00FD,$013F,$01AB,$01FB
	dw $02CE,$023A,$00EF,$00BD,$00B3,$00C9,$00EF,$023A
	dw $02CE,$023A,$00EF,$00BD,$00B3,$00C9,$00EF,$023A
	dw $02CE,$023A,$00EF,$00BD,$00B3,$00C9,$00EF,$023A
	dw $02CE,$023A,$00EF,$00BD,$00B3,$00C9,$00EF,$023A
	dw $027F,$01FB,$01AB,$013F,$00FD,$013F,$01AB,$01FB
	dw $027F,$01FB,$01AB,$013F,$00FD,$013F,$01AB,$01FB
	dw $027F,$01FB,$01AB,$013F,$00FD,$013F,$01AB,$01FB
	dw $027F,$01FB,$01AB,$013F,$00FD,$013F,$01AB,$01FB
	dw $0000

extrajump:
	db 0,0,0,0,0,0,64,128,64,128,0,0,0,0,1

duration:
	db 4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4
	db 4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4
	db 4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4
	db 4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4
	
	db 4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4
	db 4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4
	db 4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4
	db 4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4
	
	db 4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4
	db 4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4
	db 4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4
	db 4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4
	
	db 4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4
	db 4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4
	db 4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4
	db 4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4
	
	db 4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4
	

notes2:
	dw $0000,$0000,$0000,$0046,$005E,$0000,$006A,$005E,$005E,$0059,$005E,$006A,$0070,$008E,$0000 ;riff1
	dw $0046,$005E,$0000,$0046,$003F,$003F,$003B,$0046,$004F,$0046,$0000,$0000 ;riff2
	dw $0046,$0000,$0046,$003F,$003F,$003B,$0000,$0034,$002F,$0034,$004F ;Eb change
	dw $0000,$0027,$002C,$002F,$0034,$003B ;highwalk
	dw $0000,$0046,$003F,$003F,$003B,$0000,$0034,$002F,$0034,$0027
	dw $0023,$0022,$0023,$0022,$0023,$0022,$0023,$0022,$0023,$0022,$0023,$0022,$0023,$0022,$0023,$0022,$0023,$0022,$0023,$0022,$0023 ;high G climax
	dw $0000,$0000,$0046,$005E,$0000,$006A,$005E,$005E,$0059,$005E,$006A ;almost riff1
	dw $0046,$005E,$0000,$0046,$003F,$003F,$003B,$0046,$004F,$0046,$0000 ;end
	
duration2:	
	db 255,255,2,64,68,24,16,16,8,40,8,8,64,72,120 ;; riff 1
	db 64,70,26,16,16,8,40,8,8,64,72,120 ;; riff2
	db 136,24,16,16,8,24,16,8,8,64,70,58,16,16,16,16,134,26,16,16,8,24,16,8,8
	db 64,192,8,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6 ;; climax
	db 255,129,64,70,26,16,16,8,40,8,8
	db 64,70,26,16,16,8,40,8,8,48,1
	
	
		; Cartridge Footer
	org $FFFA
	dw nmihandler			;FFFA - Interrupt Handler
	dw ProgramStart			;FFFC - Entry point
	dw irqhandler			;FFFF - IRQ handler
	