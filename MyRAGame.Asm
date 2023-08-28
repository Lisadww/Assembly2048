;.386
.686
.MMX
.XMM
.model flat,stdcall
option casemap:none
; To get unicode support
;include \masm32\macros\macros.asm

;DEBUG32 EQU 1
;
;IFDEF DEBUG32
;    PRESERVEXMMREGS equ 1
;    includelib M:\Masm32\lib\Debug32.lib
;    DBG32LIB equ 1
;    DEBUGEXE textequ <'M:\Masm32\DbgWin.exe'>
;    include M:\Masm32\include\debug32.inc
;ENDIF

include MyRAGame.inc

.data
sztest db 'test', 0
szSave	db	'Save successfully!', 0
szSaveTitle	db	'Save', 0

.code

start:

    Invoke GetModuleHandle,NULL
    mov hInstance, eax
    Invoke GetCommandLine
    mov CommandLine, eax
    Invoke InitCommonControls
    mov icc.dwSize, sizeof INITCOMMONCONTROLSEX
    mov icc.dwICC, ICC_COOL_CLASSES or ICC_STANDARD_CLASSES or ICC_WIN95_CLASSES
    Invoke InitCommonControlsEx, offset icc
    
    invoke initDataBase
    ;TODO: can only createTable before.
    ;invoke createTable
   
    ;Invoke WinUserName, hInstance, NULL, CommandLine, SW_SHOWDEFAULT
    Invoke WinMain, hInstance, NULL, CommandLine, SW_SHOWDEFAULT
    
    Invoke ExitProcess, eax


;-------------------------------------------------------------------------------------
; WinUserName
;-------------------------------------------------------------------------------------

WinUserName proc hInst:HINSTANCE,hPrevInst:HINSTANCE,CmdLine:LPSTR,CmdShow:DWORD
    LOCAL   wc:WNDCLASSEX
    LOCAL   msg:MSG

    mov     wc.cbSize, sizeof WNDCLASSEX
    mov     wc.style, 0 ; not including CS_HREDRAW or CS_VREDRAW which helps prevent flickering
    mov     wc.lpfnWndProc, offset WndProc
    mov     wc.cbClsExtra, NULL
    mov     wc.cbWndExtra, DLGWINDOWEXTRA
    push    hInst
    pop     wc.hInstance
    mov     wc.hbrBackground, COLOR_BTNFACE+1 ; COLOR_WINDOW+1
    mov     wc.lpszMenuName, IDM_MENU
    mov     wc.lpszClassName, offset ClassName
    ;Invoke LoadIcon, NULL, IDI_APPLICATION
    Invoke LoadIcon, hInstance, ICO_LOGO_2048 ; resource icon for main application icon, in this case we use the example system icon
    
    mov     wc.hIcon, eax
    mov     wc.hIconSm, eax
    mov     hIconLogo2048, eax
    
    
    Invoke LoadCursor, NULL, IDC_ARROW
    mov     wc.hCursor,eax
    Invoke RegisterClassEx, addr wc

    ;TS
    Invoke CreateDialogParam, hInstance, IDD_GET_USER_NAME, NULL, addr WndUserNameProc, NULL

    
    Invoke ShowWindow, hWnd, SW_SHOWNORMAL
    Invoke UpdateWindow, hWnd
    .WHILE TRUE
        invoke GetMessage, addr msg, NULL, 0, 0
      .BREAK .if !eax
        Invoke TranslateMessage, addr msg
        Invoke DispatchMessage, addr msg
    .ENDW
    mov eax, msg.wParam
    ret
WinUserName endp

;-------------------------------------------------------------------------------------
; WinUserName
;-------------------------------------------------------------------------------------

WinRank proc hInst:HINSTANCE,hPrevInst:HINSTANCE,CmdLine:LPSTR,CmdShow:DWORD
    LOCAL   wc:WNDCLASSEX
    LOCAL   msg:MSG

    mov     wc.cbSize, sizeof WNDCLASSEX
    mov     wc.style, 0 ; not including CS_HREDRAW or CS_VREDRAW which helps prevent flickering
    mov     wc.lpfnWndProc, offset WndProc
    mov     wc.cbClsExtra, NULL
    mov     wc.cbWndExtra, DLGWINDOWEXTRA
    push    hInst
    pop     wc.hInstance
    mov     wc.hbrBackground, COLOR_BTNFACE+1 ; COLOR_WINDOW+1
    mov     wc.lpszMenuName, IDM_MENU
    mov     wc.lpszClassName, offset ClassName
    ;Invoke LoadIcon, NULL, IDI_APPLICATION
    Invoke LoadIcon, hInstance, ICO_LOGO_2048 ; resource icon for main application icon, in this case we use the example system icon
    
    mov     wc.hIcon, eax
    mov     wc.hIconSm, eax
    mov     hIconLogo2048, eax
    
    
    Invoke LoadCursor, NULL, IDC_ARROW
    mov     wc.hCursor,eax
    Invoke RegisterClassEx, addr wc

    ;TS
    Invoke CreateDialogParam, hInstance, IDD_RANK, NULL, addr WndRankProc, NULL

    
    Invoke ShowWindow, hWnd, SW_SHOWNORMAL
    Invoke UpdateWindow, hWnd
    .WHILE TRUE
        invoke GetMessage, addr msg, NULL, 0, 0
      .BREAK .if !eax
        Invoke TranslateMessage, addr msg
        Invoke DispatchMessage, addr msg
    .ENDW
    mov eax, msg.wParam
    ret
WinRank endp
;-------------------------------------------------------------------------------------
; WinMain
;-------------------------------------------------------------------------------------
WinMain proc hInst:HINSTANCE,hPrevInst:HINSTANCE,CmdLine:LPSTR,CmdShow:DWORD
    LOCAL   wc:WNDCLASSEX
    LOCAL   msg:MSG
    ;LOCAL   pare:HWND 
    mov     wc.cbSize, sizeof WNDCLASSEX
    mov     wc.style, 0 ; not including CS_HREDRAW or CS_VREDRAW which helps prevent flickering
    mov     wc.lpfnWndProc, offset WndProc
    mov     wc.cbClsExtra, NULL
    mov     wc.cbWndExtra, DLGWINDOWEXTRA
    push    hInst
    pop     wc.hInstance
    mov     wc.hbrBackground, COLOR_BTNFACE+1 ; COLOR_WINDOW+1
    mov     wc.lpszMenuName, IDM_MENU
    mov     wc.lpszClassName, offset ClassName
    ;Invoke LoadIcon, NULL, IDI_APPLICATION
    Invoke LoadIcon, hInstance, ICO_LOGO_2048 ; resource icon for main application icon, in this case we use the example system icon
    
    mov     wc.hIcon, eax
    mov     wc.hIconSm, eax
    mov     hIconLogo2048, eax
    
    
    Invoke LoadCursor, NULL, IDC_ARROW
    mov     wc.hCursor,eax
    Invoke RegisterClassEx, addr wc

    ;TS
    ;Invoke CreateDialogParam, hInstance, IDD_GET_USER_NAME, NULL, addr WndUserNameProc, NULL

    Invoke CreateDialogParam, hInstance, IDD_DIALOG, NULL, addr WndProc, NULL
    
    
    Invoke ShowWindow, hWnd, SW_SHOWNORMAL
    Invoke UpdateWindow, hWnd
    .WHILE TRUE
        invoke GetMessage, addr msg, NULL, 0, 0
      .BREAK .if !eax
        Invoke TranslateMessage, addr msg
        Invoke DispatchMessage, addr msg
    .ENDW
    mov eax, msg.wParam
    ret
WinMain endp




;-------------------------------------------------------------------------------------
; OnBlockReset - Reset block data and display
;-------------------------------------------------------------------------------------

OnBlockReset proc uses edx ecx hdc:HDC

	LOCAL x1,y1,x2,y2:dword
    LOCAL @color:HBRUSH
    LOCAL @hdc:HDC
	local @rrt:RECT
	LOCAL i:DWORD
	
	mov i, 0
	.while i < 16
		push i
		pop edx
		mov BLOCK[edx*4], 0
		inc i
	.endw
	
	mov num_score, 0
	;mov num_highest_score, 0
	
	invoke GetModuleHandle, NULL
    invoke LoadIcon, eax, ICO_BROWN_COLOR_BLOCK
    mov hIconBrown, eax
    
    invoke GetModuleHandle, NULL
    invoke LoadIcon, eax, NUM_BLOCK_BASIC
    mov hIconNumNull, eax
    
    invoke GetModuleHandle, NULL
    invoke LoadIcon, eax, NUM_BLOCK_BASIC
    mov hIconBlock1, eax
    
    invoke GetModuleHandle, NULL
    invoke LoadIcon, eax, NUM_BLOCK_BASIC
    mov hIconBlock2, eax
    
    invoke GetModuleHandle, NULL
    invoke LoadIcon, eax, NUM_BLOCK_BASIC
    mov hIconBlock3, eax
    
    invoke GetModuleHandle, NULL
    invoke LoadIcon, eax, NUM_BLOCK_BASIC
    mov hIconBlock4, eax
    
    invoke GetModuleHandle, NULL
    invoke LoadIcon, eax, NUM_BLOCK_BASIC
    mov hIconBlock5, eax
    
    invoke GetModuleHandle, NULL
    invoke LoadIcon, eax, NUM_BLOCK_BASIC
    mov hIconBlock6, eax
    
    invoke GetModuleHandle, NULL
    invoke LoadIcon, eax, NUM_BLOCK_BASIC
    mov hIconBlock7, eax
    
    invoke GetModuleHandle, NULL
    invoke LoadIcon, eax, NUM_BLOCK_BASIC
    mov hIconBlock8, eax
    
    invoke GetModuleHandle, NULL
    invoke LoadIcon, eax, NUM_BLOCK_BASIC
    mov hIconBlock9, eax
    
    invoke GetModuleHandle, NULL
    invoke LoadIcon, eax, NUM_BLOCK_BASIC
    mov hIconBlock10, eax
    
    invoke GetModuleHandle, NULL
    invoke LoadIcon, eax, NUM_BLOCK_BASIC
    mov hIconBlock11, eax
    
    invoke GetModuleHandle, NULL
    invoke LoadIcon, eax, NUM_BLOCK_BASIC
    mov hIconBlock12, eax
    
    invoke GetModuleHandle, NULL
    invoke LoadIcon, eax, NUM_BLOCK_BASIC
    mov hIconBlock13, eax
    
    invoke GetModuleHandle, NULL
    invoke LoadIcon, eax, NUM_BLOCK_BASIC
    mov hIconBlock14, eax
    
    invoke GetModuleHandle, NULL
    invoke LoadIcon, eax, NUM_BLOCK_BASIC
    mov hIconBlock15, eax
    
    invoke GetModuleHandle, NULL
    invoke LoadIcon, eax, NUM_BLOCK_BASIC
    mov hIconBlock16, eax
    
    ;set the cover color
    invoke CreateSolidBrush, 0FBFBFAH
    mov @color, eax
    
    invoke GetWindowDC, hWnd
    mov @hdc, eax
   
	invoke GetClientRect, hWnd, addr @rrt
	
    push x_num_score
    pop x1
    sub x1,30
    
    push y_num_score
    pop y1
	add y1, 50
	
	push x1
	pop x2
	add x2, 280
	
	push y1
	pop y2
	add y2, 16
	
	invoke SetRect, addr @rrt, x1, y1, x2, y2
    invoke FillRect, @hdc, addr @rrt, @color
    
    ret
OnBlockReset endp

;-------------------------------------------------------------------------------------
; OnDraw - painting background
;-------------------------------------------------------------------------------------

OnDraw proc uses edx ecx hWin:HWND, hdc:HDC 

    LOCAL i:dword
    LOCAL x1,y1,x2,y2:dword
    
    LOCAL @color:HBRUSH
	local @rrt:RECT
	
	
	;set the line's color
	invoke CreateSolidBrush, 00A9B3B8h
    mov @color, eax
    
    ;set the text's color 
    invoke SetTextColor, hdc, 0F5F5F5h
    invoke SetBkMode, hdc, TRANSPARENT
	
	;horizontal line
	invoke GetClientRect, hWin, addr @rrt
	
	;set x1
	push @rrt.left
	pop x1
	add x1, 50
	
	;set x2
	mov eax, @rrt.bottom
	sub eax, 220
	.if @rrt.right <= eax
		push @rrt.right
		pop x2
		sub x2, 70
	.else
		push @rrt.bottom
		pop x2
		sub x2, 220
	.endif
	
	xor edx, edx
	mov eax, x2
	sub eax, x1
	mov ebx, 4
	div ebx
	mov block_width, eax
	sub x2, edx
	push x2
	;right_border
	
	;set y1
	push @rrt.top
	pop y1
	add y1, 220
	
	;set y2
	push y1
	pop y2
	add y2,10 
	
	;paint
    mov i, 0
	.while i <= 4
		invoke SetRect, addr @rrt, x1, y1, x2, y2
        invoke FillRect, hdc, addr @rrt, @color
        mov eax, block_width
        add y1, eax
        add y2, eax
        inc i
	.endw
	
	;straight line
	invoke GetClientRect, hWnd, addr @rrt
	
	;x1 dont have change
	
	
	
	;set y1
	push @rrt.top
	pop y1
	add y1, 220
	
	;set y2
	push x2
	pop y2
	mov eax, x1
	sub y2,eax
	mov eax, y1
	add y2, eax
	add y2, 10
	
	;set x2
	push x1
	pop x2
	add x2, 10
	
	;paint
	mov i, 0
	.while i <= 4
		invoke SetRect, addr @rrt, x1, y1, x2, y2
        invoke FillRect, hdc, addr @rrt, @color
        mov eax, block_width
        add x1, eax
        add x2, eax
        inc i
	.endw
	
	;Highest score box
	invoke GetClientRect, hWin, addr @rrt
	
	;set x2
	pop x2
	add x2, 10
	
	;set x1
	push x2
	pop x1
	sub x1, 100
	
	;set y1
	push @rrt.top
	pop y1
	add y1, 100
	
	;set y2
	push y1
	pop y2
	add y2,50
	
	;paint
	invoke SetRect, addr @rrt, x1, y1, x2, y2
    invoke FillRect, hdc, addr @rrt, @color
    
    ;word of 'Highest'
    ;Move to the output coordinates of the text
    add x1, 10
    add y1, 5
    invoke TextOut, hdc, x1, y1, addr sz_Text_Highest, 7
    
    ;record output coordinates for fractional numbers
    push x1
    pop x_num_highest
    add x_num_highest, 5
    push y1
    pop y_num_highest
    add y_num_highest, 20
    
    ;Revert to the output coordinates of the block
    sub x1, 10
    sub y1, 5
    
    ;Current score box
	invoke GetClientRect, hWin, addr @rrt
	
	;set x2
	push x1
	pop x2
	sub x2, 15
	
	;set x1
	push x2
	pop x1
	sub x1, 100
	
	;set y1
	push @rrt.top
	pop y1
	add y1, 100
	
	;set y2
	push y1
	pop y2
	add y2,50
	
	;paint
	invoke SetRect, addr @rrt, x1, y1, x2, y2
    invoke FillRect, hdc, addr @rrt, @color
    
    ;word of 'Score'
    ;Move to the output coordinates of the text
    add x1, 10
    add y1, 5
    invoke TextOut, hdc, x1, y1, addr sz_Text_Score, 5
    
    ;record output coordinates for fractional numbers
    push x1
    pop x_num_score
    add x_num_score, 5
    push y1
    pop y_num_score
    add y_num_score, 20
    
    invoke GetClientRect, hWin, addr @rrt
    push x1
    pop x2
    
	;set x1
	push @rrt.left
	pop x1
	add x1, 70
	
	;set y1
	push @rrt.top
	pop y1
	add y1, 90
	
	mov eax, x1
	sub x2, eax
	mov ebx, block_width
    .if x2 > ebx
    	;draw the icon of 2048
	;invoke DrawIconEx,hdc,x1,y1,hIconLogo2048 ,block_width ,block_width ,0, NULL, DI_NORMAL
    .endif
    
    
    
	;invoke DeleteObject, @color
	
	;set the place of blocks
	invoke GetClientRect, hWin, addr @rrt
	
	;set x1
	push @rrt.left
	pop x1
	add x1, 50
	
	;set y1
	push @rrt.top
	pop y1
	add y1, 220
	
	;;------The number of the game block------
    ;	1	2	3	4
    ;	5	6	7	8
    ;	9	10	11	12
    ;	13	14	15	16
    ;----------------------------------------
    ; The following are the corresponding coordinates
    
    
    add x1, 5
    push x1
    add y1, 5
    invoke DrawIconEx,hdc,x1,y1,hIconBlock1,block_width ,block_width ,0, NULL, DI_NORMAL ;1
    mov eax, block_width
    add x1, eax
    invoke DrawIconEx,hdc,x1,y1,hIconBlock2,block_width ,block_width ,0, NULL, DI_NORMAL
    mov eax, block_width
    add x1, eax
    invoke DrawIconEx,hdc,x1,y1,hIconBlock3,block_width ,block_width ,0, NULL, DI_NORMAL
    mov eax, block_width
    add x1, eax
    invoke DrawIconEx,hdc,x1,y1,hIconBlock4,block_width ,block_width ,0, NULL, DI_NORMAL
    
    pop x1
    push x1
    mov eax, block_width
    add y1, eax
    invoke DrawIconEx,hdc,x1,y1,hIconBlock5,block_width ,block_width ,0, NULL, DI_NORMAL
    mov eax, block_width
    add x1, eax
    invoke DrawIconEx,hdc,x1,y1,hIconBlock6,block_width ,block_width ,0, NULL, DI_NORMAL
    mov eax, block_width
    add x1, eax
    invoke DrawIconEx,hdc,x1,y1,hIconBlock7,block_width ,block_width ,0, NULL, DI_NORMAL
    mov eax, block_width
    add x1, eax
    invoke DrawIconEx,hdc,x1,y1,hIconBlock8,block_width ,block_width ,0, NULL, DI_NORMAL
    
    pop x1
    push x1
    mov eax, block_width
    add y1, eax
    invoke DrawIconEx,hdc,x1,y1,hIconBlock9,block_width ,block_width ,0, NULL, DI_NORMAL
    mov eax, block_width
    add x1, eax
    invoke DrawIconEx,hdc,x1,y1,hIconBlock10,block_width ,block_width ,0, NULL, DI_NORMAL
    mov eax, block_width
    add x1, eax
    invoke DrawIconEx,hdc,x1,y1,hIconBlock11,block_width ,block_width ,0, NULL, DI_NORMAL
    mov eax, block_width
    add x1, eax
    invoke DrawIconEx,hdc,x1,y1,hIconBlock12,block_width ,block_width ,0, NULL, DI_NORMAL
    
    pop x1
    mov eax, block_width
    add y1, eax
    invoke DrawIconEx,hdc,x1,y1,hIconBlock13,block_width ,block_width ,0, NULL, DI_NORMAL
    mov eax, block_width
    add x1, eax
    invoke DrawIconEx,hdc,x1,y1,hIconBlock14,block_width ,block_width ,0, NULL, DI_NORMAL
    mov eax, block_width
    add x1, eax
    invoke DrawIconEx,hdc,x1,y1,hIconBlock15,block_width ,block_width ,0, NULL, DI_NORMAL
    mov eax, block_width
    add x1, eax
    invoke DrawIconEx,hdc,x1,y1,hIconBlock16,block_width ,block_width ,0, NULL, DI_NORMAL
    
    
    
	ret
OnDraw endp


;-------------------------------------------------------------------------------------
; GetOneRandBlock - Randomly generate 2 or 4 blocks at undefined locations
;-------------------------------------------------------------------------------------

GetOneRandBlock proc uses edx ecx 
    
    
    LOCAL @stTime:SYSTEMTIME
    invoke GetLocalTime, addr @stTime
    movzx eax, @stTime.wMilliseconds
    invoke crt_srand,eax
    invoke crt_rand ; rand() % 2
    xor edx,edx
    mov ebx,2
    div ebx
    mov block_value,edx
    
    invoke GetLocalTime, addr @stTime
    movzx eax, @stTime.wMilliseconds
    invoke crt_srand,eax
    invoke crt_rand ; rand() % 16
    xor edx,edx
    mov ebx,16
    div ebx
    
    mov temp_block_num, edx
    
    
	ret
	
GetOneRandBlock endp

;-------------------------------------------------------------------------------------
; OnBlockInit - Initialization after clicking on new game
;TS: fix the bug->you should use BLOCK[edx*4] instead of BLOCK[edx], because the type of BLOCK is dword.
;-------------------------------------------------------------------------------------

OnBlockInit proc uses edx ecx

	local @hdc:HDC
	
	invoke GetModuleHandle, NULL
	mov @hdc, eax
	
	invoke OnBlockReset, @hdc
	
;    invoke GetOneRandBlock
;    mov edx,temp_block_num
;	.if block_value == 0
;		mov BLOCK[edx*4],2
;		invoke LoadIcon, @hdc, NUM_BLOCK_2
;		mov hIconTemp, eax	
;	.elseif block_value == 1
;		mov BLOCK[edx*4],4
;		invoke LoadIcon, @hdc, NUM_BLOCK_4
;		mov hIconTemp, eax	
;	.endif
;	invoke DetermineBlockHandle
    invoke PlaceOneRandBlock
    
    invoke Sleep, 10
    
    invoke PlaceOneRandBlock
;    invoke GetOneRandBlock
;    mov edx, temp_block_num
;    .while BLOCK[edx*4] != 0
;		invoke GetOneRandBlock
;		mov edx, temp_block_num
;	.endw
;    .if block_value == 0
;		mov BLOCK[edx*4],2
;		invoke LoadIcon, @hdc, NUM_BLOCK_2
;		mov hIconTemp, eax	
;	.elseif block_value == 1
;		mov BLOCK[edx*4],4
;		invoke LoadIcon, @hdc, NUM_BLOCK_4
;		mov hIconTemp, eax	
;	.endif
;	invoke DetermineBlockHandle

        
    ret
OnBlockInit endp


;-------------------------------------------------------------------------------------
; OnBlockUpdate - Display update after moving blocks

;-------------------------------------------------------------------------------------

OnBlockUpdate proc uses edx ecx

	LOCAL i:DWORD
	
	;mov BLOCK[4], 2048
	
	mov i, 0
	.while i<16
		mov edx, i
		mov temp_block_num, edx
		invoke ChangeBlockResource, BLOCK[edx*4]
		;invoke crt_printf, offset sz_Test, BLOCK[edx]
		invoke DetermineBlockHandle
		
		inc i
	.endw

        
    ret
OnBlockUpdate endp

;-------------------------------------------------------------------------------------
; ChangeBlockResource - Change the icon of a block
;-------------------------------------------------------------------------------------

ChangeBlockResource proc value:DWORD

	local @hdc:HDC
	
	invoke GetModuleHandle, NULL
	mov @hdc, eax
	
	;mov edx,block_num
	.if value == 0
		invoke LoadIcon, @hdc, NUM_BLOCK_BASIC
		mov hIconTemp, eax
	.elseif value == 2
		invoke LoadIcon, @hdc, NUM_BLOCK_2
		mov hIconTemp, eax
	.elseif value == 4
		invoke LoadIcon, @hdc, NUM_BLOCK_4
		mov hIconTemp, eax
	.elseif value == 8
		invoke LoadIcon, @hdc, NUM_BLOCK_8
		mov hIconTemp, eax
	.elseif value == 16
		invoke LoadIcon, @hdc, NUM_BLOCK_16
		mov hIconTemp, eax
	.elseif value == 32
		invoke LoadIcon, @hdc, NUM_BLOCK_32
		mov hIconTemp, eax
	.elseif value == 64
		invoke LoadIcon, @hdc, NUM_BLOCK_64
		mov hIconTemp, eax
	.elseif value == 128
		invoke LoadIcon, @hdc, NUM_BLOCK_128
		mov hIconTemp, eax
	.elseif value == 256
		invoke LoadIcon, @hdc, NUM_BLOCK_256
		mov hIconTemp, eax
	.elseif value == 512
		invoke LoadIcon, @hdc, NUM_BLOCK_512
		mov hIconTemp, eax
	.elseif value == 1024
		invoke LoadIcon, @hdc, NUM_BLOCK_1024
		mov hIconTemp, eax
	.elseif value == 2048
		invoke LoadIcon, @hdc, NUM_BLOCK_2048
		mov hIconTemp, eax
	.else
		invoke LoadIcon, @hdc, NUM_BLOCK_BASIC		
		mov hIconTemp, eax									
	.endif
	

	
	;pop ebx
	;push eax
	;push ebx
	
    ret
ChangeBlockResource endp

;-------------------------------------------------------------------------------------
; DetermineBlockHandle - Determine the handle of the block to be changed
;-------------------------------------------------------------------------------------

DetermineBlockHandle proc 

	;local @hdc:HDC
	
	;invoke GetModuleHandle, NULL
	;mov @hdc, eax
	
	;mov edx,block_num
	;pop ecx
	;mov ecx, hIconTemp 
	
	.if temp_block_num == 0
		mov ecx, hIconTemp 
    	mov hIconBlock1, ecx
    	
    .elseif temp_block_num == 1
    	mov ecx, hIconTemp 
    	mov hIconBlock2, ecx
    	
    .elseif temp_block_num == 2
    	mov ecx, hIconTemp 
    	mov hIconBlock3, ecx
    	
    .elseif temp_block_num == 3
    	mov ecx, hIconTemp 
    	mov hIconBlock4, ecx
    .elseif temp_block_num == 4
    	mov ecx, hIconTemp
    	mov hIconBlock5, ecx
    	
    .elseif temp_block_num == 5
    	mov ecx, hIconTemp 
    	mov hIconBlock6, ecx
    	
    .elseif temp_block_num == 6
    	mov ecx, hIconTemp 
    	mov hIconBlock7, ecx
    	
    .elseif temp_block_num == 7
    	mov ecx, hIconTemp 
    	mov hIconBlock8, ecx
    	
    .elseif temp_block_num == 8
    	mov ecx, hIconTemp 
    	mov hIconBlock9, ecx
    	
    .elseif temp_block_num == 9
    	mov ecx, hIconTemp 
    	mov hIconBlock10, ecx
    	
    .elseif temp_block_num == 10
    	mov ecx, hIconTemp 
    	mov hIconBlock11, ecx
    	
    .elseif temp_block_num == 11
    	mov ecx, hIconTemp
    	mov hIconBlock12, ecx
    	
    .elseif temp_block_num == 12
    	mov ecx, hIconTemp 
    	mov hIconBlock13, ecx
    	
    .elseif temp_block_num == 13
    	mov ecx, hIconTemp 
    	mov hIconBlock14, ecx
    	
    .elseif temp_block_num == 14
    	mov ecx, hIconTemp 
    	mov hIconBlock15, ecx
    	
    .elseif temp_block_num == 15
    	mov ecx, hIconTemp 
    	mov hIconBlock16, ecx
    	
    .endif
	
    ret
DetermineBlockHandle endp

;-------------------------------------------------------------------------------------
; OnScoreUpdate - Update the displayed current score and highest
;-------------------------------------------------------------------------------------

OnScoreUpdate proc hWin:HWND

	LOCAL @hdc:HDC
	local @rrt:RECT
	
	;invoke GetClientRect, hWin, addr @rrt
	;mov @rrt.top, 50
	
	;set the text's color 
    	invoke SetTextColor, @hdc, 0F5F5F5h
    	invoke SetBkMode, @hdc, 00A9B3B8h
    
    	invoke crt_sprintf, addr text_score, addr sz_Num_to_text, num_score
    	invoke crt_strlen, addr text_score
   	mov text_score_len, eax
    
	invoke crt_sprintf, addr text_highest_score, addr sz_Num_to_text, num_highest_score
    	invoke crt_strlen, addr text_highest_score
    	mov text_highest_len, eax
        
    	ret
OnScoreUpdate endp

;-------------------------------------------------------------------------------------
; PlaceOneRandBlock - Handling keystroke messages
;-------------------------------------------------------------------------------------
PlaceOneRandBlock proc
	local @hdc:HDC
	invoke GetModuleHandle, NULL
	mov @hdc, eax
	invoke GetOneRandBlock
	mov edx, temp_block_num
    .while BLOCK[edx*4] != 0
		invoke GetOneRandBlock
		mov edx, temp_block_num
	.endw
	mov edx,temp_block_num
	.if block_value == 0
		mov BLOCK[edx*4],2
		invoke LoadIcon, @hdc, NUM_BLOCK_2
		mov hIconTemp, eax	
	.elseif block_value == 1
		mov BLOCK[edx*4],4
		invoke LoadIcon, @hdc, NUM_BLOCK_4
		mov hIconTemp, eax	
	.endif
	invoke DetermineBlockHandle
    
	ret

PlaceOneRandBlock endp

;-------------------------------------------------------------------------------------
; OnKeydown - Handling keystroke messages
;-------------------------------------------------------------------------------------
OnKeydown proc hWin:HWND, message:UINT, wParam:WPARAM, lParam:LPARAM
	local @hdc:HDC
	LOCAL @i:DWORD
	

	mov @i, 0
    .while @i < 16
        mov eax, @i
        push BLOCK[eax*4]
        pop OldBlock[eax*4]
        inc @i
    .endw	
    
    mov eax, wParam
    .if eax == VK_LEFT
        ;invoke Left       
        invoke MergerLeft
	invoke OnBlockUpdate
;       Invoke SendMessage,hWin,WM_PAINT,0,0
;        .while @i<16
;        	mov ebx, @i
;        	invoke  MessageBox,NULL,BLOCK[ebx],offset sz_Text_Highest,MB_OK
;        inc @i
;        .endw
    .elseif eax== VK_RIGHT
        ;invoke Right
        invoke MergerRight
        invoke OnBlockUpdate
        ;invoke  MessageBox,NULL,offset sz_Text_Win,offset sz_Text_Highest,MB_OK
    .elseif eax== VK_DOWN
        ;invoke Down
        invoke MergerDown
        invoke OnBlockUpdate
        ;invoke  MessageBox,NULL,offset sz_Text_Win,offset sz_Text_Highest,MB_OK
    .elseif eax== VK_UP
        ;invoke Up
        invoke MergerUp
        invoke OnBlockUpdate
        ;invoke  MessageBox,NULL,offset sz_Text_Win,offset sz_Text_Highest,MB_OK
        
    .elseif eax == VK_SPACE
        ;invoke RestartGame    
    .endif
    
    mov @i, 0
    mov flag, 0 
    .while @i < 16
        mov eax, @i  
        mov ebx, BLOCK[eax*4]    
        .if ebx != OldBlock[eax*4]
        	mov flag, 1
        .endif
        inc @i
    .endw
    
    mov win_flag, 0
    mov lose_flag, 0
    
    
    .if flag == 1

    	invoke getscore
    	 mov ecx,num_highest_score
   		.if num_score > ecx
   			push num_score
   			pop num_highest_score
   		.endif
    	invoke PlaceOneRandBlock
    	
    	

	
	invoke OnBlockUpdate
    	invoke OnScoreUpdate, hWin
    	

    .endif
    
    invoke gameEnd
    Invoke SendMessage,hWin,WM_PAINT,0,0
    .if win_flag == 1
    		invoke  messageBox,offset sz_Text_Win,offset sz_Text_Highest

    		invoke prepareRankInfo
		invoke DialogBoxParam, hInstance, IDD_RANK, hWin, addr WndRankProc, NULL	
		invoke SetForegroundWindow, hWin
    	.elseif lose_flag == 1
    		invoke  messageBox,offset sz_Text_Lose,offset sz_Text_Highest
    		invoke prepareRankInfo
		invoke DialogBoxParam, hInstance, IDD_RANK, hWin, addr WndRankProc, NULL	
		invoke SetForegroundWindow, hWin
    	.endif
    
    
    
    invoke SetForegroundWindow, hWin
    
    
;    invoke GetWindowDC, hWin
;	mov @hdc, eax  
;    invoke OnBlockReset,@hdc
;    invoke loadGame, offset user_name
    
    ;invoke InvalidateRect, hWnd, addr @rc, TRUE ;redraw
    
P_EXIT:    
    mov eax, 1
    
	ret

OnKeydown endp

IsMerge proc
    local @i:dword
    local @j:dword
    local @iOffset:dword
    LOCAL @blockij:dword
    LOCAL @blockijj:dword
    
    mov @i, 0
    .while @i<4
        ;@iOffset = i*4
		xor edx, edx
		mov eax, @i
		mov ebx, 4
		mul ebx
		mov @iOffset, eax

        mov @j, 0
        .while @j < 3
            ;eax = @iOffset + @j 
        	mov eax, @iOffset
        	add eax, @j
        	mov @blockij, eax        	
        	
        	;eax = @iOffset + @j + 1
        	mov eax, @iOffset
        	add eax, @j
        	add eax, 1
        	mov @blockijj, eax
        	
        	
            mov eax, @blockij
            mov ebx, @blockijj
            mov ecx, BLOCK[eax*4]
            mov edx, BLOCK[ebx*4]
            .if ecx == edx
                mov merge_flag, 1
            .endif
            inc @j
        .endw
        inc @i
    .endw
    ret
IsMerge endp



gameEnd proc
    local @i:dword
    mov zero_flag, 0
    mov lose_flag, 0
    mov win_flag,0
    mov @i, 0  ; TS
    .while @i<16
        mov eax, @i
        .if BLOCK[eax*4] == 2048
            mov win_flag, 1
        .endif
        inc @i
    .endw
    mov @i, 0  ; TS
    .if win_flag == 0
	    .while @i<16
	        mov eax, @i
	        .if BLOCK[eax*4] == 0
	            mov zero_flag, 1
	        .endif
	        inc @i
	    .endw
	    mov merge_flag, 0
	    .if zero_flag == 0
	        invoke IsMerge
	
	        invoke RotateMatrix   
	        invoke RotateMatrix
	        invoke RotateMatrix
	        invoke IsMerge
	        invoke RotateMatrix
	    .endif
	    .if zero_flag == 0 && merge_flag == 0
	        mov lose_flag, 1
	    .endif
    
    .endif  
    ret
gameEnd endp

;-------------------------------------------------------------------------------------
; getscore - get the game score 
;-------------------------------------------------------------------------------------
getscore proc
 
 push ecx
 push edx
 
 mov ecx,0
 xor eax,eax
 mov num_score,0
 
cul_score:
 mov edx,BLOCK[ecx*4]
 mov eax,num_score
 .if edx==0
 .elseif edx==2
  
 .elseif edx==4
  add eax,4
 .elseif edx==8
  add eax,16
 .elseif edx==16
  add eax,48
 .elseif edx==32
  add eax,128
 .elseif edx==64
  add eax,320
 .elseif edx==128
  add eax,768
 .elseif edx==256
  add eax,1792
 .elseif edx==512
  add eax,4096
 .elseif edx==1024
  add eax,9216
 .elseif edx==2048
  add eax,20480
 .else
  add eax,45036
 .endif
 mov num_score,eax
 inc ecx
 cmp ecx,16
 jb cul_score
 
 
 ;gameIsWin
 pop edx
 pop ecx
 
 ret

getscore endp

;-------------------------------------------------------------------------------------
; Compact - put all block number on the left side 
;-------------------------------------------------------------------------------------
Compact proc  row:dword
	LOCAL @i:dword
	LOCAL @j:dword
	LOCAL @Blockij:dword
	LOCAL @RowOffset:dword
	mov @i, 0
	mov @j, 0
	;@RowOffset = row*4
	xor edx, edx
	mov eax, row
	mov ebx, 4
	mul ebx
	mov @RowOffset, eax
	
	.while @i<4
		;eax = @RowOffset + @i		
		mov eax, @RowOffset
		add eax, @i
		push BLOCK[eax*4] ;[row][i]
		pop @Blockij	
		
		
		.if @Blockij != 0
			push @Blockij
			;eax = @RowOffset + @j	
			mov eax, @RowOffset
			add eax, @j
			pop BLOCK[eax*4];[row][j]=[row][i]
			inc @j
		.endif
		inc @i
	.endw
	
	.while @j<4
		mov eax, @RowOffset
		add eax, @j
		mov BLOCK[eax*4], 0 ;[row][j]=0
		inc @j
	.endw
	
	ret
	
Compact endp

;-------------------------------------------------------------------------------------
; MergerLeft - merge the same block leftward 
;-------------------------------------------------------------------------------------
MergerLeft proc uses eax ebx edx
    Local @i:dword
    Local @j:dword
    LOCAL @blockij:dword
    LOCAL @blockijj:dword
    LOCAL @iOffset:dword
    mov @i, 0
    .while @i < 4
        ;mov row, @i
        invoke Compact, @i
        ;@iOffset = i*4
		xor edx, edx
		mov eax, @i
		mov ebx, 4
		mul ebx
		mov @iOffset, eax
		
        mov @j, 0
        .while @j < 3
        	;eax = @iOffset + @j 
        	mov eax, @iOffset
        	add eax, @j
        	mov @blockij, eax
        	
        	
        	;eax = @iOffset + @j + 1
        	mov eax, @iOffset
        	add eax, @j
        	add eax, 1
        	mov @blockijj, eax
        	
        	
            mov eax, @blockij
            mov ebx, @blockijj
            mov ecx, BLOCK[eax*4]
            mov edx, BLOCK[ebx*4]
            .if ecx == edx
            	mov eax, @blockij
            	mov ebx, @blockijj
                mov edx, BLOCK[eax*4]
                shl edx, 1
                mov BLOCK[eax*4], edx
                mov BLOCK[ebx*4], 0
                invoke Compact, @i
            .endif         
            inc @j
        .endw
        inc @i
    .endw

	ret

MergerLeft endp

;-------------------------------------------------------------------------------------
; RotateMatrix - rotate the block matrix
;-------------------------------------------------------------------------------------
RotateMatrix proc uses eax

    Local @i:dword
    mov @i,0
    .while @i<16
    	mov eax, @i
        mov temp[eax*4], 0
        inc @i
    .endw
    mov @i, 0
    .while @i < 16
        mov eax, @i
        push BLOCK[eax*4]
        pop temp[eax*4]
        inc @i
    .endw
    
    ;0  1  2  3           12  8  4  0
    ;4  5  6  7      ->   13  9  5  1
    ;8  9  10 11          14  10 6  2
    ;12 13 14 15          15  11 7  3
    
    push temp[12*4]
    pop BLOCK[0*4]
    push temp[8*4]
    pop BLOCK[1*4]
    push temp[4*4]
    pop BLOCK[2*4]
    push temp[0*4]
    pop BLOCK[3*4]
    push temp[13*4]
    pop BLOCK[4*4]
    push temp[9*4]
    pop BLOCK[5*4]
    push temp[5*4]
    pop BLOCK[6*4]
    push temp[1*4]
    pop BLOCK[7*4]
    push temp[14*4]
    pop BLOCK[8*4]
    push temp[10*4]
    pop BLOCK[9*4]
    push temp[6*4]
    pop BLOCK[10*4]
    push temp[2*4]
    pop BLOCK[11*4]
    push temp[15*4]
    pop BLOCK[12*4]
    push temp[11*4]
    pop BLOCK[13*4]
    push temp[7*4]
    pop BLOCK[14*4]
    push temp[3*4]
    pop BLOCK[15*4]
    
		
	ret

RotateMatrix endp

;-------------------------------------------------------------------------------------
; MergerRight - merge the same block rightward
;-------------------------------------------------------------------------------------
MergerRight proc 
    invoke RotateMatrix
    invoke RotateMatrix
    invoke MergerLeft
    invoke RotateMatrix
    invoke RotateMatrix

    ret
MergerRight endp

;-------------------------------------------------------------------------------------
; MergerUp - merge the same block upward
;-------------------------------------------------------------------------------------
MergerUp proc 
    invoke RotateMatrix   
    invoke RotateMatrix
    invoke RotateMatrix
    invoke MergerLeft
    invoke RotateMatrix

    ret
MergerUp endp

;-------------------------------------------------------------------------------------
; MergerDown - merge the same block downward
;-------------------------------------------------------------------------------------
MergerDown proc 
    invoke RotateMatrix 
    invoke MergerLeft  
    invoke RotateMatrix
    invoke RotateMatrix
    invoke RotateMatrix

    ret
MergerDown endp


;-------------------------------------------------------------------------------------
; WndProc - Main Window Message Loop
;-------------------------------------------------------------------------------------
WndProc proc hWin:HWND,uMsg:UINT,wParam:WPARAM,lParam:LPARAM

    	local @ps:PAINTSTRUCT
    	local @hdc:HDC
    	local @szBuff[100]:TCHAR
	local @rt:RECT
	local @crText:COLORREF
	local @dwLen:dword
	LOCAL @backgroundColor:HBRUSH
	
	LOCAL @uMsg:dword
    
    mov eax, uMsg
    mov @uMsg, eax
    .IF @uMsg == WM_INITDIALOG
        push hWin
        pop hWnd
        
        ; Init Stuff Here
        invoke OnBlockReset, @hdc
        
    .ELSEIF @uMsg == WM_TIMER
        mov eax, wParam
        .IF eax == hWin
            Invoke KillTimer, hWin, hWin
            
        .ENDIF
        
    ;---------------------------------------------------------------------------------------------------------------
    ; Handle painting of our dialog with our specified background and border color to mimic new Modern style UI feel
    ;---------------------------------------------------------------------------------------------------------------
    .ELSEIF @uMsg == WM_ERASEBKGND
        mov eax, 1
        ret

    .ELSEIF @uMsg == WM_PAINT
        
        ;Draw background
        invoke GetClientRect, hWin, addr @rt
        
       	invoke BeginPaint,hWin,addr @rt
        
        invoke GetWindowDC, hWin
        mov @hdc, eax
          
        invoke CreateSolidBrush, 0FBFBFAH
        mov @backgroundColor, eax
        
        mov @rt.top, 50
        add @rt.bottom, 50
        
        invoke FillRect, @hdc, addr @rt, @backgroundColor
        
        invoke GetWindowDC, hWin
        mov @hdc, eax
          
		invoke OnDraw, hWin, @hdc
		
		invoke TextOut, @hdc, x_num_score, y_num_score, addr text_score, text_score_len
		invoke TextOut, @hdc, x_num_highest, y_num_highest, addr text_highest_score, text_highest_len
		
        invoke EndPaint,hWin,addr @rt
        
        
        mov eax, 0
        ret
    ;---------------------------------------------------------------------------------------------------------------
    
    .ELSEIF @uMsg == WM_COMMAND
        mov eax, wParam
        and eax, 0FFFFh
        .IF eax == IDM_FILE_EXIT
            Invoke SendMessage,hWin,WM_CLOSE,0,0
            
        .ELSEIF eax == IDM_HELP_ABOUT
            Invoke ShellAbout,hWin,addr AppName,addr AboutMsg,NULL
            
        .ELSEIF eax == IDM_NAME
            invoke DialogBoxParam, hInstance, IDD_GET_USER_NAME, hWnd, addr WndUserNameProc, NULL
            invoke SetForegroundWindow, hWin
           

            Invoke SendMessage,hWin,WM_PAINT,0,0
        
        .ELSEIF eax == IDM_NEW_GAME
            invoke GetWindowDC, hWin
        	mov @hdc, eax  
            invoke OnBlockInit
            invoke getBestByName,offset user_name
            mov num_highest_score, eax
            invoke OnScoreUpdate, hWin
            
            Invoke SendMessage,hWin,WM_PAINT,0,0
            
        .ELSEIF eax == IDM_OPEN
            
            
            ;*****************************
            ; update block's show example
            ;*****************************
            
            ; check name != empty first
            .if user_name == 0
            	invoke DialogBoxParam, hInstance, IDD_GET_USER_NAME, hWnd, addr WndUserNameProc, NULL
            	invoke SetForegroundWindow, hWin
            	.if user_name != 0
            		invoke GetWindowDC, hWin
        		mov @hdc, eax  
        		invoke getBestByName, offset user_name
        		.if ebx == 0
        			invoke OnBlockReset,@hdc
            			invoke loadGame, offset user_name
            			invoke OnScoreUpdate, hWin
            			invoke OnBlockUpdate
            			Invoke SendMessage,hWin,WM_PAINT,0,0
        		.else
            			invoke messageBox, offset sz_Text_NewUser, offset sz_Title_NewUser
            		
            			
            			
            		.endif
            	.else
            		invoke messageBox, offset sz_Text_EmptyName_Open, offset sz_Title_EmptyName_Open
            	.endif
            .else
            
            	invoke GetWindowDC, hWin
        		mov @hdc, eax  
        		invoke getBestByName, offset user_name
        		.if ebx == 0
        			invoke OnBlockReset,@hdc
            			invoke loadGame, offset user_name
            			invoke OnScoreUpdate, hWin
            			invoke OnBlockUpdate
            			Invoke SendMessage,hWin,WM_PAINT,0,0
        		.else
            			invoke messageBox, offset sz_Text_NewUser, offset sz_Title_NewUser
            		
            			
            			
            		.endif
            
            .endif
            
        .ELSEIF eax == IDM_SAVE
            .if user_name == 0
            	invoke DialogBoxParam, hInstance, IDD_GET_USER_NAME, hWnd, addr WndUserNameProc, NULL
            	invoke SetForegroundWindow, hWin
            	.if user_name != 0
            		invoke saveGame, offset BLOCK, offset user_name, offset num_score
            	.else
            		invoke messageBox, offset sz_Text_EmptyName_Save, offset sz_Title_EmptyName_Save
            	.endif
            .else
            	invoke saveGame, offset BLOCK, offset user_name, offset num_score
            .endif
            
            
        .ELSEIF eax == IDM_RANK
            
		invoke prepareRankInfo

		invoke DialogBoxParam, hInstance, IDD_RANK, hWin, addr WndRankProc, NULL
		
		invoke SetForegroundWindow, hWin
            
        .ENDIF

	.ELSEIF eax == WM_KEYDOWN
		invoke OnKeydown, hWin, eax, wParam, lParam
		Invoke SendMessage,hWin,WM_PAINT,0,0
		
    .ELSEIF @uMsg == WM_CLOSE
        Invoke DestroyWindow,hWin
        
    .ELSEIF @uMsg == WM_DESTROY
        Invoke PostQuitMessage,NULL
        
    .ELSE
        Invoke DefWindowProc,hWin,uMsg,wParam,lParam
        ret
    .ENDIF
    xor    eax,eax
    ret
WndProc endp


;-------------------------------------------------------------------------------------
; WndUserNameProc
;-------------------------------------------------------------------------------------

WndUserNameProc proc hWin:HWND,uMsg:UINT,wParam:WPARAM,lParam:LPARAM


	local @ps:PAINTSTRUCT
    	local @hdc:HDC
    	local @szBuff[100]:TCHAR
	local @rt:RECT
	local @crText:COLORREF
	local @dwLen:dword
	LOCAL @backgroundColor:HBRUSH
	
	LOCAL @best
    
    mov eax, uMsg
    .IF eax == WM_INITDIALOG
    	Invoke SetDlgItemText,hWin,IDC_NAME,offset user_name
        ;push hWin
        ;pop hWnd
        
        
    .ELSEIF eax == WM_TIMER
        mov eax, wParam
        .IF eax == hWin
            Invoke KillTimer, hWin, hWin
            
        .ENDIF
        
    ;---------------------------------------------------------------------------------------------------------------
    ; Handle painting of our dialog with our specified background and border color to mimic new Modern style UI feel
    ;---------------------------------------------------------------------------------------------------------------
    .ELSEIF eax == WM_ERASEBKGND
        mov eax, 1
        ret

    .ELSEIF eax == WM_PAINT
        
        ;Draw background
        invoke GetClientRect, hWin, addr @rt  ; get the coordinate of the window
        
       	invoke BeginPaint,hWin,addr @rt
        
        invoke GetWindowDC, hWin
        mov @hdc, eax
          
        invoke CreateSolidBrush, 0FBFBFAH
        mov @backgroundColor, eax
        
        mov @rt.top, 50
        add @rt.bottom, 50
        
        invoke FillRect, @hdc, addr @rt, @backgroundColor
        
        Invoke SetDlgItemText,hWin,IDC_NAME,offset user_name
        
		
        invoke EndPaint,hWin,addr @rt
        
        
        mov eax, 0
        ret
    ;---------------------------------------------------------------------------------------------------------------
    
    .ELSEIF eax == WM_COMMAND
        mov eax, wParam
        and eax, 0FFFFh
        .IF eax == IDC_OK
            
            Invoke GetDlgItemText,hWin,IDC_NAME,offset user_name,sizeof user_name
            ;Invoke SetDlgItemText,hWin,IDC_NAME,offset user_name
            
            invoke getBestByName,offset user_name
            mov num_highest_score, eax
            
            invoke OnScoreUpdate,hWnd
            invoke SendMessage,hWnd,WM_PAINT,0,0
            Invoke SendMessage,hWin,WM_CLOSE,0,0 
            
            

        .ENDIF

	.ELSEIF eax == WM_KEYDOWN
		invoke OnKeydown, hWin, eax, wParam, lParam
		
    .ELSEIF eax == WM_CLOSE
    	invoke GetActiveWindow
        Invoke EndDialog,eax, 0
        
    .ELSEIF eax == WM_DESTROY
        ;Invoke PostQuitMessage,NULL
        
    .ELSE
        Invoke DefWindowProc,hWin,uMsg,wParam,lParam
        ret
    .ENDIF
    xor    eax,eax
    ret

    
WndUserNameProc endp

;-------------------------------------------------------------------------------------
; WndRankProc
;-------------------------------------------------------------------------------------

WndRankProc proc hWin:HWND,uMsg:UINT,wParam:WPARAM,lParam:LPARAM


local @ps:PAINTSTRUCT
    local @hdc:HDC
    local @szBuff[100]:TCHAR
	local @rt:RECT
	local @crText:COLORREF
	local @dwLen:dword
	LOCAL @backgroundColor:HBRUSH
    
    mov eax, uMsg
    .IF eax == WM_INITDIALOG
   		
        ;push hWin
        ;pop hWnd
        
        
    .ELSEIF eax == WM_TIMER
        mov eax, wParam
        .IF eax == hWin
            Invoke KillTimer, hWin, hWin
            
        .ENDIF
        
    ;---------------------------------------------------------------------------------------------------------------
    ; Handle painting of our dialog with our specified background and border color to mimic new Modern style UI feel
    ;---------------------------------------------------------------------------------------------------------------
    .ELSEIF eax == WM_ERASEBKGND
        mov eax, 1
        ret

    .ELSEIF eax == WM_PAINT
    	
        ;Draw background
        invoke GetClientRect, hWin, addr @rt  ; get the coordinate of the window
        
       	invoke BeginPaint,hWin,addr @rt
        
        invoke GetWindowDC, hWin
        mov @hdc, eax
          
        invoke CreateSolidBrush, 0FBFBFAH
        mov @backgroundColor, eax
        
        mov @rt.top, 50
        add @rt.bottom, 50
        
        
        invoke FillRect, @hdc, addr @rt, @backgroundColor
        
		
	Invoke SetDlgItemText,hWin,IDC_RANK,offset sz_Text_Rank
    	Invoke SetDlgItemText,hWin,IDC_STC1,offset rank_info1
	Invoke SetDlgItemText,hWin,IDC_STC2,offset rank_info2
	Invoke SetDlgItemText,hWin,IDC_STC3,offset rank_info3
	Invoke SetDlgItemText,hWin,IDC_STC4,offset rank_info4
	Invoke SetDlgItemText,hWin,IDC_STC5,offset rank_info5
		
        invoke EndPaint,hWin,addr @rt
        
        
        mov eax, 0
        ret
    ;---------------------------------------------------------------------------------------------------------------
    
    .ELSEIF eax == WM_COMMAND
        

    .ELSEIF eax == WM_KEYDOWN
		invoke OnKeydown, hWin, eax, wParam, lParam
		
    .ELSEIF eax == WM_CLOSE
    	invoke GetActiveWindow
        Invoke EndDialog,eax, 0
        
    .ELSEIF eax == WM_DESTROY
        ;Invoke PostQuitMessage,NULL
        
    .ELSE
        Invoke DefWindowProc,hWin,uMsg,wParam,lParam
        ret
    .ENDIF
    xor    eax,eax
    ret

    
WndRankProc endp


end start

