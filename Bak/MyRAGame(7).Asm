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
    
    Invoke WinMain, hInstance, NULL, CommandLine, SW_SHOWDEFAULT
    ;Invoke WinUserName, hInstance, NULL, CommandLine, SW_SHOWDEFAULT
    Invoke ExitProcess, eax

;-------------------------------------------------------------------------------------
; WinMain
;-------------------------------------------------------------------------------------
WinMain proc hInst:HINSTANCE,hPrevInst:HINSTANCE,CmdLine:LPSTR,CmdShow:DWORD
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
    Invoke CreateDialogParam, hInstance, IDD_DIALOG, NULL, addr WndProc, NULL
    ;Invoke CreateDialogParam, hInstance, IDD_GETUSERNAME, NULL, addr WndUserNameProc, NULL
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
; WinUserName
;-------------------------------------------------------------------------------------
;WinUserName proc hInst:HINSTANCE,hPrevInst:HINSTANCE,CmdLine:LPSTR,CmdShow:DWORD
;    LOCAL   wc:WNDCLASSEX
;    LOCAL   msg:MSG
;
;    mov     wc.cbSize, sizeof WNDCLASSEX
;    mov     wc.style, 0 ; not including CS_HREDRAW or CS_VREDRAW which helps prevent flickering
;    mov     wc.lpfnWndProc, offset WndProc
;    mov     wc.cbClsExtra, NULL
;    mov     wc.cbWndExtra, DLGWINDOWEXTRA
;    push    hInst
;    pop     wc.hInstance
;    mov     wc.hbrBackground, COLOR_BTNFACE+1 ; COLOR_WINDOW+1
;    mov     wc.lpszClassName, offset ClassName
;    ;Invoke LoadIcon, NULL, IDI_APPLICATION
;    Invoke LoadIcon, hInstance, ICO_LOGO_2048 ; resource icon for main application icon, in this case we use the example system icon
;    
;    mov     wc.hIcon, eax
;    mov     wc.hIconSm, eax
;    mov     hIconLogo2048, eax
;    
;    
;    Invoke LoadCursor, NULL, IDC_ARROW
;    mov     wc.hCursor,eax
;    Invoke RegisterClassEx, addr wc
;    ;Invoke CreateDialogParam, hInstance, IDD_DIALOG, NULL, addr WndProc, NULL
;    Invoke CreateDialogParam, hInstance, IDD_GETUSERNAME, NULL, addr WndUserNameProc, NULL
;    ;Invoke ShowWindow, hWnd, SW_SHOWNORMAL
;    Invoke UpdateWindow, hWnd
;    .WHILE TRUE
;        invoke GetMessage, addr msg, NULL, 0, 0
;      .BREAK .if !eax
;        Invoke TranslateMessage, addr msg
;        Invoke DispatchMessage, addr msg
;    .ENDW
;    mov eax, msg.wParam
;    ret
;WinUserName endp

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
		mov BLOCK[edx], 0
		inc i
	.endw
	
	mov num_score, 0
	mov num_highest_score, 0
	
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
    invoke CreateSolidBrush, 00A9B3B8h
    mov @color, eax
    
    invoke GetWindowDC, hWnd
    mov @hdc, eax
   
	invoke GetClientRect, hWnd, addr @rrt
	
	invoke BeginPaint, hWnd, addr @rrt
	
	invoke SetRect, addr @rrt, x1, y1, x2, y2
    invoke FillRect, @hdc, addr @rrt, @color
    
    invoke EndPaint,hWnd,addr @rrt
    
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
		invoke DrawIconEx,hdc,x1,y1,hIconLogo2048 ,block_width ,block_width ,0, NULL, DI_NORMAL
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
;-------------------------------------------------------------------------------------

OnBlockInit proc uses edx ecx
	local @hdc:HDC
	
	invoke GetModuleHandle, NULL
	mov @hdc, eax
	
	invoke OnBlockReset, @hdc
	
    invoke GetOneRandBlock
    mov edx,temp_block_num
	.if block_value == 0
		mov BLOCK[edx],2
		invoke LoadIcon, @hdc, NUM_BLOCK_2
		mov hIconTemp, eax	
	.elseif block_value == 1
		mov BLOCK[edx],4
		invoke LoadIcon, @hdc, NUM_BLOCK_4
		mov hIconTemp, eax	
	.endif
	invoke DetermineBlockHandle
    
    invoke Sleep, 10
    
    invoke GetOneRandBlock
    mov edx, temp_block_num
    .while BLOCK[edx] != 0
		invoke GetOneRandBlock
		mov edx, temp_block_num
	.endw
    .if block_value == 0
		mov BLOCK[edx],2
		invoke LoadIcon, @hdc, NUM_BLOCK_2
		mov hIconTemp, eax	
	.elseif block_value == 1
		mov BLOCK[edx],4
		invoke LoadIcon, @hdc, NUM_BLOCK_4
		mov hIconTemp, eax	
	.endif
	invoke DetermineBlockHandle

        
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
		invoke ChangeBlockResource, BLOCK[edx]
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
; OnKeydown - Handling keystroke messages
;-------------------------------------------------------------------------------------
OnKeydown proc hWin:HWND, message:UINT, wParam:WPARAM, lParam:LPARAM
	
	mov eax, wParam
    .if eax == VK_LEFT
        ;invoke Left
        
    .elseif eax== VK_RIGHT
        ;invoke Right
        
    .elseif eax== VK_DOWN
        ;invoke Down
        
    .elseif eax== VK_UP
        ;invoke Up
        
    .elseif eax == VK_SPACE
        ;invoke RestartGame    
    .endif
    
    ;invoke InvalidateRect, hWnd, addr @rc, TRUE ;redraw
    
P_EXIT:    
    mov eax, 1
    
	ret

OnKeydown endp

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
    
    mov eax, uMsg
    .IF eax == WM_INITDIALOG
        push hWin
        pop hWnd
        
        ; Init Stuff Here
        invoke OnBlockReset, @hdc
        
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
    
    .ELSEIF eax == WM_COMMAND
        mov eax, wParam
        and eax, 0FFFFh
        .IF eax == IDM_FILE_EXIT
            Invoke SendMessage,hWin,WM_CLOSE,0,0
            
        .ELSEIF eax == IDM_HELP_ABOUT
            Invoke ShellAbout,hWin,addr AppName,addr AboutMsg,NULL
        
        .ELSEIF eax == IDM_NEW_GAME
            invoke GetWindowDC, hWin
        	mov @hdc, eax  
            invoke OnBlockInit
            invoke OnScoreUpdate, hWin
            
            Invoke SendMessage,hWin,WM_PAINT,0,0
            
        .ELSEIF eax == IDM_OPEN
            ;TODO
            
            ;*****************************
            ; update block's show example
            ;*****************************
            
            invoke OnBlockUpdate
            Invoke SendMessage,hWin,WM_PAINT,0,0
            
        .ELSEIF eax == IDM_SAVE
            ;TODO
            
            ;*********************
            ; update score example
            ;*********************
            add num_highest_score,2 ; use for test
            invoke OnScoreUpdate,hWin
            Invoke SendMessage,hWin,WM_PAINT,0,0
            
            ;****************************
            ; output game result example
            ;****************************
            ;win 
;            push @hdc
;            invoke GetWindowDC, hWin
;        	mov @hdc, eax
;            invoke SetTextColor, @hdc, 004A5359h
;    		invoke SetBkMode, @hdc, TRANSPARENT
;    		mov ecx, x_num_score
;    		sub ecx, 30
;            mov edx, y_num_score
;            add edx, 50
;            invoke TextOut, @hdc, ecx, edx, addr sz_Text_Win, 35
;            pop @hdc
            ;lose
            push @hdc
            invoke GetWindowDC, hWin
        	mov @hdc, eax
            invoke SetTextColor, @hdc, 004A5359h
    		invoke SetBkMode, @hdc, TRANSPARENT
    		mov ecx, x_num_score
    		sub ecx, 10
            mov edx, y_num_score
            add edx, 50
            invoke TextOut, @hdc, ecx, edx, addr sz_Text_Lose, 37
            pop @hdc
            
        .ELSEIF eax == IDM_RANK
            ;TODO
            
        .ENDIF

	.ELSEIF eax == WM_KEYDOWN
		invoke OnKeydown, hWin, eax, wParam, lParam
		
    .ELSEIF eax == WM_CLOSE
        Invoke DestroyWindow,hWin
        
    .ELSEIF eax == WM_DESTROY
        Invoke PostQuitMessage,NULL
        
    .ELSE
        Invoke DefWindowProc,hWin,uMsg,wParam,lParam
        ret
    .ENDIF
    xor    eax,eax
    ret
WndProc endp

end start
