;.386
;.model flat,stdcall
;option casemap:none
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
    Invoke LoadIcon, NULL, IDI_APPLICATION
    ;Invoke LoadIcon, hInstance, ICO_SYSTEM ; resource icon for main application icon, in this case we use the example system icon
    mov     wc.hIcon, eax
    mov     wc.hIconSm, eax
    
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
    
    Invoke LoadCursor, NULL, IDC_ARROW
    mov     wc.hCursor,eax
    Invoke RegisterClassEx, addr wc
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
; OnDrawLine - painting background lines
;-------------------------------------------------------------------------------------

OnDrawLine proc uses edx ecx hdc:HDC 

    LOCAL i,j:dword
	
	;horizontal line in painting
	mov i, GAME_LINE_y_TOP 
	.while i <= GAME_LINE_y_BUTTOM
		mov j, GAME_LINE_x_LEFT
		.while  j <= GAME_LINE_x_RIGHT
			invoke DrawIconEx,hdc,j,i,hIconBrown,10,10,0, NULL, DI_NORMAL
			add j,10
		.endw
		
		add i,GAME_LINE_ROW_HEIGHT
	.endw	
	
	;vertical line in painting
	mov j, GAME_LINE_x_LEFT 
	.while  j <= GAME_LINE_x_RIGHT
		mov i, GAME_LINE_y_TOP
		.while i <= GAME_LINE_y_BUTTOM
			invoke DrawIconEx,hdc,j,i,hIconBrown,10,10,0, NULL, DI_NORMAL
			add i,10
		.endw
		
		add j,GAME_LINE_COLUMN_WIDTH
	.endw	
	
	ret
OnDrawLine endp

;-------------------------------------------------------------------------------------
; OnDrawBox - painting the highest score box and the current score box
;-------------------------------------------------------------------------------------

OnDrawBox proc uses edx ecx hdc:HDC, box_x:DWORD, box_y:DWORD

    LOCAL i,j:dword
	LOCAL box_x_right,box_y_buttom:dword
	
	mov eax, box_x
	mov box_x_right, eax
	mov eax, GAME_BOX_WIDTH
	add box_x_right, eax
	
	mov eax, box_y
	mov box_y_buttom, eax
	mov eax, GAME_BOX_HEIGHT
	add box_y_buttom, eax
	
	;Painting the current score Box
	mov eax, box_x
	mov i, eax
	mov eax, box_x_right
	.while i <= eax
		mov eax, box_y
		mov j, eax
		mov eax, box_y_buttom
		.while  j <= eax
			invoke DrawIconEx,hdc,i,j,hIconBrown,10,10,0, NULL, DI_NORMAL
			add j,10
			mov eax, box_y_buttom
		.endw
		add i,10
		mov eax, box_x_right
	.endw	
	;Painting the highest score box
	ret
OnDrawBox endp

;-------------------------------------------------------------------------------------
; PutOneBlockIntoArrayAndShow - painting the highest score box and the current score box
;-------------------------------------------------------------------------------------

PutOneBlockIntoArrayAndShow proc uses edx ecx, block_num:DWORD
    
	local @hdc:HDC
	invoke GetModuleHandle, NULL
	mov @hdc, eax
	mov edx,block_num
	.if g_2_or_4 == 0
		mov BLOCK[edx],2
		invoke LoadIcon, @hdc, NUM_BLOCK_2

	.elseif g_2_or_4 == 1
		mov BLOCK[edx],4
		invoke LoadIcon, @hdc, NUM_BLOCK_4
		
;	.else
;		invoke LoadIcon, @hdc, NUM_BLOCK_64
	.endif
	
	;invoke LoadIcon, @hdc, NUM_BLOCK_2
	
	mov @hdc, eax
    
    .if block_num == 0
    	mov edx, @hdc
    	mov hIconBlock1, edx
    .elseif block_num == 1
    	mov edx, @hdc
    	mov hIconBlock2, edx
    .elseif block_num == 2
    	mov edx, @hdc
    	mov hIconBlock3, edx
    .elseif block_num == 3
    	mov edx, @hdc
    	mov hIconBlock4, edx
    .elseif block_num == 4
    	mov edx, @hdc
    	mov hIconBlock5, edx
    .elseif block_num == 5
    	mov edx, @hdc
    	mov hIconBlock6, edx
    .elseif block_num == 6
    	mov edx, @hdc
    	mov hIconBlock7, edx
    .elseif block_num == 7
    	mov edx, @hdc
    	mov hIconBlock8, edx
    .elseif block_num == 8
    	mov edx, @hdc
    	mov hIconBlock9, edx
    .elseif block_num == 9
    	mov edx, @hdc
    	mov hIconBlock10, edx
    .elseif block_num == 10
    	mov edx, @hdc
    	mov hIconBlock11, edx
    .elseif block_num == 11
    	mov edx, @hdc
    	mov hIconBlock12, edx
    .elseif block_num == 12
    	mov edx, @hdc
    	mov hIconBlock13, edx
    .elseif block_num == 13
    	mov edx, @hdc
    	mov hIconBlock14, edx
    .elseif block_num == 14
    	mov edx, @hdc
    	mov hIconBlock15, edx
    .elseif block_num == 15
    	mov edx, @hdc
    	mov hIconBlock16, edx
    .endif
    
	ret
	
PutOneBlockIntoArrayAndShow endp

;-------------------------------------------------------------------------------------
; GetOneRandBlock - painting the highest score box and the current score box
;-------------------------------------------------------------------------------------

GetOneRandBlock proc uses edx ecx 
    
    invoke crt_time, NULL
    invoke crt_srand,eax
    invoke crt_rand ; rand() % 16
    ;mov eax,32
    xor edx,edx
    mov ebx,2
    div ebx
    mov g_2_or_4,edx
    
	invoke crt_time, NULL
    invoke crt_srand,eax
    invoke crt_rand ; rand() % 16
    ;mov eax,32
    xor edx,edx
    mov ebx,16
    div ebx
    
    ;mov temp_block_num, edx
    invoke PutOneBlockIntoArrayAndShow, edx
    
;    .if BLOCK[edx] != 0
;    	invoke GetOneRandBlock
;    .else
;    	invoke PutOneBlockIntoArrayAndShow, edx
;    .endif
    
    
    
	ret
	
GetOneRandBlock endp




;-------------------------------------------------------------------------------------
; OnBlockInit - painting the highest score box and the current score box
;-------------------------------------------------------------------------------------

OnBlockInit proc uses edx ecx hdc:HDC
	;;------The number of the game block------
        ;	1	2	3	4
        ;	5	6	7	8
        ;	9	10	11	12
        ;	13	14	15	16
        ;----------------------------------------
        ; The following are the corresponding coordinates
        invoke DrawIconEx,hdc,25,225,hIconBlock1,84,84,0, NULL, DI_NORMAL ;1
        invoke DrawIconEx,hdc,110,225,hIconBlock2,84,84,0, NULL, DI_NORMAL ;2
        invoke DrawIconEx,hdc,195,225,hIconBlock3,84,84,0, NULL, DI_NORMAL ;3
        invoke DrawIconEx,hdc,280,225,hIconBlock4,84,84,0, NULL, DI_NORMAL ;4
        invoke DrawIconEx,hdc,25,310,hIconBlock5,84,84,0, NULL, DI_NORMAL ;5
        invoke DrawIconEx,hdc,110,310,hIconBlock6,84,84,0, NULL, DI_NORMAL ;6
        invoke DrawIconEx,hdc,195,310,hIconBlock7,84,84,0, NULL, DI_NORMAL ;7
        invoke DrawIconEx,hdc,280,310,hIconBlock8,84,84,0, NULL, DI_NORMAL ;8
        invoke DrawIconEx,hdc,25,395,hIconBlock9,84,84,0, NULL, DI_NORMAL ;9
        invoke DrawIconEx,hdc,110,395,hIconBlock10,84,84,0, NULL, DI_NORMAL ;10
        invoke DrawIconEx,hdc,195,395,hIconBlock11,84,84,0, NULL, DI_NORMAL ;11
        invoke DrawIconEx,hdc,280,395,hIconBlock12,84,84,0, NULL, DI_NORMAL ;12
        invoke DrawIconEx,hdc,25,480,hIconBlock13,84,84,0, NULL, DI_NORMAL ;13
        invoke DrawIconEx,hdc,110,480,hIconBlock14,84,84,0, NULL, DI_NORMAL ;14
        invoke DrawIconEx,hdc,195,480,hIconBlock15,84,84,0, NULL, DI_NORMAL ;15
        invoke DrawIconEx,hdc,280,480,hIconBlock16,84,84,0, NULL, DI_NORMAL ;16
        
        invoke GetOneRandBlock
        ;invoke PutOneBlockIntoArrayAndShow, edx
        ;invoke GetOneRandBlock
        
        
        ret
OnBlockInit endp

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
	
	;invoke GetClientRect, hWin, addr @rt
    ;mov @rt.left, 0A0h   
    ;mov @rt.top, 0A0h    ;7 * 32
    ;mov @rt.right, 0A0h 
    
    mov eax, uMsg
    .IF eax == WM_INITDIALOG
        push hWin
        pop hWnd
        ; Init Stuff Here

        ;-----------------------------------------------------------------------------------------------------
        ; ModernUI_CaptionBar Example - similar to the other example projects based on this control
        ;-----------------------------------------------------------------------------------------------------
        ; Applies the ModernUI base style to the dialog, turning it into a borderless, caption less form
        ; we set our own caption and system buttons with the ModernUI_CaptionBar control
        Invoke MUIApplyToDialog, hWin, TRUE, TRUE
        
        ; Create CaptionBar control and save handle
        Invoke MUICaptionBarCreate, hWin, Addr AppName, 32, IDC_CAPTIONBAR, MUICS_LEFT or MUICS_REDCLOSEBUTTON
        mov hCaptionBar, eax
        
        ; Set some properties for our CaptionBar control 
        ;Invoke MUICaptionBarSetProperty, hCaptionBar, @CaptionBarBackColor, MUI_RGBCOLOR(27,161,226)
        Invoke MUICaptionBarSetProperty, hCaptionBar, @CaptionBarBackColor, MUI_RGBCOLOR(61,58,51)
        Invoke MUICaptionBarSetProperty, hCaptionBar, @CaptionBarBtnTxtRollColor, MUI_RGBCOLOR(61,61,61)
        ;Invoke MUICaptionBarSetProperty, hCaptionBar, @CaptionBarBtnBckRollColor, MUI_RGBCOLOR(87,193,244)      
        Invoke MUICaptionBarSetProperty, hCaptionBar, @CaptionBarBtnBckRollColor, MUI_RGBCOLOR(214,205,196)   
        
        ; Create a second ModernUI_Button control that will use PNG images (stored as RC_DATA resources)
        ; additional style flags to emulate a button pressed down and up again and a hand when hovering over button
        Invoke MUIButtonCreate, hWin, Addr sz_Button_Start_Text, 40, 40, 110, 38, IDC_BUTTON_START, WS_CHILD or WS_VISIBLE or MUIBS_HAND or MUIBS_PUSHBUTTON
        mov hBtn1, eax
        
        ; Load some images for when user moves mouse over button, or if its selected state changes
        Invoke MUIButtonLoadImages, hBtn1, MUIBIT_PNG, PNG_CHART_GREY, PNG_CHART, PNG_CHART, PNG_CHART, PNG_CHART_GREY
        
        
    .ELSEIF eax == WM_TIMER
        mov eax, wParam
        .IF eax == hWin
            Invoke KillTimer, hWin, hWin
            Invoke MUIButtonNotify, hBtn1, TRUE ; Notify button1 to show our notification text and little colored rectangle
        .ENDIF
        
    ;---------------------------------------------------------------------------------------------------------------
    ; Handle painting of our dialog with our specified background and border color to mimic new Modern style UI feel
    ;---------------------------------------------------------------------------------------------------------------
    .ELSEIF eax == WM_ERASEBKGND
        mov eax, 1
        ret

    .ELSEIF eax == WM_PAINT
        
        invoke MUIPaintBackground, hWin, MUI_RGBCOLOR(251,245,239), MUI_RGBCOLOR(27,161,226)
        ;invoke BeginPaint, hWin, addr @ps
        invoke GetWindowDC, hWin
        mov @hdc, eax  
        ;invoke DrawIconEx,@hdc,20,220,hIconBrown,10,10,0, NULL, DI_NORMAL
        ;invoke DrawIconEx,@hdc,360,220,hIconBrown,10,10,0, NULL, DI_NORMAL
        ;invoke DrawIconEx,@hdc,20,560,hIconBrown,10,10,0, NULL, DI_NORMAL
        ;invoke DrawIconEx,@hdc,360,560,hIconBrown,10,10,0, NULL, DI_NORMAL
        
        
        
        
        ;Used to replace numbers in blocks
        ;invoke GetModuleHandle, NULL
        ;invoke LoadIcon, eax, NUM_BLOCK_512
    	;mov hIconBlock2, eax
    	
        ;Draw color blocks for background lines
        invoke OnDrawLine, @hdc
        
        
        invoke OnDrawBox, @hdc, 180,100
        invoke OnDrawBox, @hdc, 280,100
        
        invoke OnBlockInit, @hdc
        
        invoke GetOneRandBlock

        
        ;invoke SetTextColor, @hdc, 0F8F8FFh
        ;invoke SetBkMode, @hdc, TRANSPARENT
        
        ;-----------------------------------------------------------------------------------------------------
    	; ModernUI_Text: Score
    	;-----------------------------------------------------------------------------------------------------   
    	Invoke MUITextCreate, hWin, offset sz_Text_Score, 190, 105, 50, 30, IDC_TEXTRSHEADER, MUITS_10PT or MUITS_FONT_BOLD or MUITS_FONT_SEGOE 
    	mov hMUITextScore, eax
    	Invoke MUITextSetProperty, hMUITextScore, @TextColor, MUI_RGBCOLOR(245,245,245)
    	Invoke MUITextSetProperty, hMUITextScore, @TextColorAlt, MUI_RGBCOLOR(179,179,179)
    	Invoke MUITextSetProperty, hMUITextScore, @TextBackColor, MUI_RGBCOLOR(187,173,160)
    	Invoke MUITextSetProperty, hMUITextScore, @TextBackColorAlt, MUI_RGBCOLOR(187,173,160)
        
        ;-----------------------------------------------------------------------------------------------------
    	; ModernUI_Text: Highest Score
    	;-----------------------------------------------------------------------------------------------------        
    	Invoke MUITextCreate, hWin, offset sz_Text_Highest, 290, 105, 50, 30, IDC_TEXTRSHEADER, MUITS_10PT or MUITS_FONT_BOLD or MUITS_FONT_SEGOE 
    	mov hMUITextHighest, eax
    	Invoke MUITextSetProperty, hMUITextHighest, @TextColor, MUI_RGBCOLOR(245,245,245)
    	Invoke MUITextSetProperty, hMUITextHighest, @TextColorAlt, MUI_RGBCOLOR(245,245,245)
    	Invoke MUITextSetProperty, hMUITextHighest, @TextBackColor, MUI_RGBCOLOR(187,173,160)
    	Invoke MUITextSetProperty, hMUITextHighest, @TextBackColorAlt, MUI_RGBCOLOR(187,173,160)
        
        ;invoke EndPaint, hWin, addr @ps
        
        
        
        
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
        
        .ELSEIF eax == IDC_BUTTON_START
            ; TODO
            
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
