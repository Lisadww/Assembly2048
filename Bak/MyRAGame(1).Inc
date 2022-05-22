include windows.inc
include user32.inc
include kernel32.inc
include gdi32.inc
include shell32.inc
include comctl32.inc
include comdlg32.inc
include masm32.inc
include msvcrt.inc

includelib user32.lib
includelib kernel32.lib
includelib gdi32.lib
includelib shell32.lib
includelib comctl32.lib
includelib comdlg32.lib
includelib masm32.lib
includelib msvcrt.lib


;-----------------------------------------------------------------------------------------
; Prototypes
;-----------------------------------------------------------------------------------------
WinMain                 PROTO :DWORD,:DWORD,:DWORD,:DWORD
WndProc                 PROTO :DWORD,:DWORD,:DWORD,:DWORD
OnBlockReset            PROTO
OnDraw					PROTO :HWND,:HDC
PutOneBlockIntoArrayAndShow PROTO :DWORD
GetOneRandBlock         PROTO
OnBlockInit				PROTO 
OnBlockUpdate			PROTO 
ChangeBlockResource		PROTO :DWORD
DetermineBlockHandle	PROTO
OnScoreUpdate			PROTO :HWND
OnKeydown				PROTO :HWND,:UINT,:WPARAM,:LPARAM
MessageBoxW			PROTO :DWORD,:DWORD,:DWORD,:DWORD




.CONST
;-----------------------------------------------------------------------------------------
; Constants
;-----------------------------------------------------------------------------------------

MessageBox 				EQU <MessageBoxW>

PNG_CHART               EQU 100
PNG_CHART_GREY          EQU 101
ICO_BROWN_COLOR_BLOCK	EQU 102

NUM_BLOCK_BASIC			EQU 110
NUM_BLOCK_2				EQU 111
NUM_BLOCK_4				EQU 112
NUM_BLOCK_8				EQU 113
NUM_BLOCK_16			EQU 114
NUM_BLOCK_32			EQU 115
NUM_BLOCK_64			EQU 116
NUM_BLOCK_128			EQU 117
NUM_BLOCK_256			EQU 118
NUM_BLOCK_512			EQU 119
NUM_BLOCK_1024			EQU 120
NUM_BLOCK_2048			EQU 121

ICO_LOGO_2048			EQU 200

; Main Dialog
IDD_DIALOG              EQU 1000
IDC_CAPTIONBAR          EQU 1001
IDC_BUTTON_START        EQU 1002
IDC_TEXTRSHEADER        EQU 1003

; Main Menu 
IDM_MENU                EQU 10000
IDM_NEW_GAME          	EQU 10001
IDM_OPEN	          	EQU 10002
IDM_SAVE	          	EQU 10003
IDM_FILE_EXIT           EQU 10010
IDM_HELP_ABOUT          EQU 10101
IDM_RANK				EQU 11000

;-----------------------------------------------------------------------------------------
; Game parameters
;-----------------------------------------------------------------------------------------

GAME_LINE_x_LEFT      EQU 20
GAME_LINE_x_RIGHT     EQU 360
GAME_LINE_y_TOP       EQU 220
GAME_LINE_y_BUTTOM    EQU 560

GAME_LINE_ROW_HEIGHT  EQU 85
GAME_LINE_COLUMN_WIDTH EQU 85

GAME_BOX_HEIGHT       EQU 40
GAME_BOX_WIDTH        EQU 85


.DATA
;-----------------------------------------------------------------------------------------
; Initialized Data
;-----------------------------------------------------------------------------------------
ClassName               DB 'DLGCLASS',0
AppName                 DB 'MyRAGame',0
AboutMsg                DB 'Lisa',13,10,'Copyright © fearless 2022',0
							
sz_Button_Start_Text    DB 'Start',0
sz_Text_Score			DB 'Score',0
sz_Text_Highest			DB 'Highest',0
;szNotifyText            DB '23',0





sz_MessageBox_Title		DD 'Me',

sz_Num_to_text			DB '%d',0

text_score				DB 'DF',0
text_highest_score		DB 'DF',0

num_score				DD 0
num_highest_score		DD 0

BLOCK  					DD 16 DUP(0)

temp_block_num			DD 0

.DATA?
;-----------------------------------------------------------------------------------------
; Uninitialized Data
;-----------------------------------------------------------------------------------------
icc                     INITCOMMONCONTROLSEX <>
hInstance               DD ? 
CommandLine             DD ?
hWnd                    DD ?
hCaptionBar             DD ?
hLine                  	DD ?
hBtn1                   DD ?
hBtn2                   DD ?
hBtn3                   DD ?

hIconLogo2048 			HICON ?
hIconBrown 				HICON ?
hIconNumNull 			HICON ?    
hIconBlock1	 			HICON ?
hIconBlock2	 			HICON ?
hIconBlock3	 			HICON ?
hIconBlock4	 			HICON ?
hIconBlock5	 			HICON ?
hIconBlock6	 			HICON ?
hIconBlock7	 			HICON ?
hIconBlock8	 			HICON ?
hIconBlock9	 			HICON ?
hIconBlock10	 		HICON ?
hIconBlock11	 		HICON ?
hIconBlock12	 		HICON ?
hIconBlock13	 		HICON ?
hIconBlock14	 		HICON ?
hIconBlock15	 		HICON ?
hIconBlock16	 		HICON ?

hIconTemp				HICON ?

block_width				DD ?
right_border			DD ?

x_num_score				DD ?
y_num_score				DD ?
x_num_highest			DD ?
y_num_highest			DD ?

text_score_len			DD ?
text_highest_len		DD ?

hMUITextScore        	DD ?
hMUITextHighest         DD ?

block_value  			DD ?


GameStruct struct
    m_nRows word GAME_ROWS
    m_nCols word GAME_COLS
    m_x byte ?
    m_y byte ?
    m_nType byte ?             
    m_nRotate byte ?      
    
    m_nNextType byte ?    
    m_nNextRotate byte ?  
    m_nScore Dword 0      
    m_nState byte ?       
GameStruct ends 




