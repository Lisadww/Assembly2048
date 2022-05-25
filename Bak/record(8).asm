.686
.model flat,stdcall
option casemap:none


include       windows.inc
include       user32.inc
includelib    user32.lib
include       kernel32.inc
includelib    kernel32.lib

includelib				msvcrt.lib

include					masm32.inc
includelib				masm32.lib

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

strlen					PROTO C:dword,:vararg
strcat					PROTO C:dword,:dword
strcpy					PROTO C:dword,:dword

prepareRankInfo proto
getBestByName proto :dword
InitDataBase proto
saveGame proto :dword, :dword, :dword
loadGame proto :dword
createTable proto
updateBestByName proto :dword, :dword
dword2str proto :dword, :dword
str2dword proto :dword, :dword


extern BLOCK:dword
extern rank_info1:dword
extern rank_info2:dword
extern rank_info3:dword
extern rank_info4:dword
extern rank_info5:dword


public saveGame
public loadGame
public initDataBase
public createTable
public prepareRankInfo


public libName
public hLib
public hs_open
public hs_close
public hs_exec
public hs_slct
public hDB
public sqlite3_open
public sqlite3_close
public sqlite3_exec
public sqlite3_slct
;--------------------------------------------------
;SQLite相关函数指针定义
;--------------------------------------------------
sql_open  typedef proto :dword,:dword
SQL_Open  typedef ptr   sql_open

sql_close typedef proto :dword
SQL_Close typedef ptr   sql_close

callback  typedef proto :dword,:dword,:dword,:dword
CallBack  typedef ptr   callback

sql_exec  typedef proto :dword,:dword,:CallBack,:dword,:dword
SQL_Exec  typedef ptr   sql_exec

sql_slct  typedef proto :dword,:dword,:dword,:dword,:dword,:dword
SQL_Slct  typedef ptr   sql_slct
;---------------------------------------------------------------------------------

.data
sql_insert2records   db  'insert into Records(name, a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15,score) values', 0
sql_selectByName    db       'select * from Records where name = ',0
sql_deleteByName	db 'delete  from Records where name = ',  0
sql_selectBestByName	db	'select best from Players where name = ',0
sql_selectRank	db	'select * from Players order by best asc limit 5', 0

sql_updateBestByName	db	'update Players set best = ',0
sql_updateBestByName1	db	' where name = ', 0
sql_insertNewPlayer	db	'insert into Players(name, best) values', 0

;info of sqlite
libName       db       'sqlite3.dll',0
sqlite3_open  db       'sqlite3_open',0
sqlite3_close db       'sqlite3_close',0
sqlite3_exec  db       'sqlite3_exec',0
sqlite3_slct  db       'sqlite3_get_table',0 
fileName      db       'data.db',0  




sql_createTable_Plays   db       'create table if not exists Players(name varchar(60),best integer)', 0 
sql_createTable_Records db      'create table if not exists Records(id integer primary key autoincrement,name varchar(60), score integer, '
                        db      'a0 integer, a1 integer, a2 integer, a3 integer, a4 integer, a5 integer, a6 integer, a7 integer, a8 integer, a9 integer, a10 integer, a11 integer, a12 integer, a13 integer, a14 integer, a15 integer)', 0



split         db       ':',0
endline       db       0dh,0ah,0
empty         db       0
pad	db	5 dup(' '),0



;for debug
states  dword   2,16,0,0,16,0,0,0,2,4,8,16,32,1024,2048,0
sscore   dword   4096
sname    db    'Luna', 0
;---------------------
lq  db  '(', 0
rq  db  ')', 0
sy  db  39, 0
cm  db  ',', 0
;------------------------------------------------------------------
.data?
str0          db       32 dup(?)
sql           db       500 dup(?)
szStr         db       600 dup(?)
szStr1         db       500 dup(?)

hInstance1     dd       ?


;info of sqlite
hLib          dd       ?
hDB           dd       ?
errorInfo     dd       ?
hs_open       SQL_Open ?
hs_close      SQL_Close ?
hs_exec       SQL_Exec ?
hs_slct       SQL_Slct ?
                .const



.code
;-------------------------------------------------------------------------------
;prepareRankInfo: prepare the rankinfo1-rankinfo5 
;-------------------------------------------------------------------------------
prepareRankInfo proc uses eax ebx edi esi


local    @result,@nRow,@nCol
              	local    @i,@j,@index
		invoke   hs_open,offset fileName,offset hDB
              	invoke   hs_slct,hDB,offset sql_selectRank,addr @result,addr @nRow,\
                       addr @nCol,NULL
              	invoke  RtlZeroMemory, offset szStr, sizeof szStr

              	mov      edi,@nCol
              	mov      eax,@nRow
              	mov      @i,eax
              	mov      ebx,@result
              	.while   @i
                       	mov    esi,0
                      	.while  esi < @nCol
			      	invoke  strcat,offset szStr,[ebx + esi*4]
                              	invoke  strcat,offset szStr,offset split
                              	invoke  strcat,offset szStr,[ebx + edi*4]
                              	invoke  strcat,offset szStr,offset pad
                              
                              	inc     esi
                              	inc     edi
                      	.endw
                      	;invoke  MessageBox,NULL,offset szStr,offset fileName,MB_OK
                      	.if @i == 1
                      		invoke strcpy, offset rank_info1, offset szStr
                      	.elseif @i == 2
                      		invoke strcpy, offset rank_info2, offset szStr
                     	.elseif @i == 3
                      		invoke strcpy, offset rank_info3, offset szStr
                      	.elseif @i == 4
                      		invoke strcpy, offset rank_info4, offset szStr
                      	.elseif @i == 5
                      		invoke strcpy, offset rank_info5, offset szStr
                      	.endif
                      	invoke  RtlZeroMemory, offset szStr, sizeof szStr
                      	mov    eax,@i
                      	dec    eax
                      	mov    @i,eax
              	.endw
              	;invoke  MessageBox,NULL,offset szStr,offset fileName,MB_OK
              	invoke  RtlZeroMemory, offset szStr, sizeof szStr

	ret
prepareRankInfo endp


;-------------------------------------------------------------------------------
;updateBestByName: [param1:the address of name; param2:the address of score]
;update the best score in Players where name = NAME.
;-------------------------------------------------------------------------------
updateBestByName proc uses ebx ecx address_name:dword, address_score:dword

	invoke getBestByName, address_name
	.if ebx == 1
	    	invoke  RtlZeroMemory, offset sql, sizeof sql
            	invoke strcat, offset sql, offset sql_insertNewPlayer
 	    	invoke strcat, offset sql, offset lq
            	invoke strcat, offset sql, offset sy
            	invoke strcat, offset sql, address_name
            	invoke strcat, offset sql, offset sy
            
            	invoke strcat, offset sql, offset cm
            
            	invoke  RtlZeroMemory, offset str0, sizeof str0
            	invoke dword2str, address_score, offset str0

            	;invoke strcat, offset sql, offset sy
            	invoke strcat, offset sql, offset str0
            	;invoke strcat, offset sql, offset sy

            	invoke strcat, offset sql, offset rq
            
	    	invoke hs_exec, hDB, offset sql, NULL, NULL, NULL
            
        .else
       	    	mov ecx, address_score
            	.if [ecx]>=ebx
            	
            	invoke  RtlZeroMemory, offset sql, sizeof sql
            
            	invoke strcat, offset sql, offset sql_updateBestByName

            
            	invoke  RtlZeroMemory, offset str0, sizeof str0
            	invoke dword2str, address_score, offset str0
            	invoke strcat, offset sql, offset str0
            
            	invoke strcat, offset sql, offset sql_updateBestByName1
            
            	invoke strcat, offset sql, offset sy
            	invoke strcat, offset sql, address_name
            	invoke strcat, offset sql, offset sy
            	invoke   hs_exec,hDB,offset sql,NULL,NULL,NULL
            	.endif
            
            
	.endif
            
	
	
	ret

updateBestByName endp
;------------------------------------------------------------------------
;getBestByName: return the best score and the error code from Players. if there is a record with name = NAME in Players, the error code = 0. Otherwise 1.
;------------------------------------------------------------------------

getBestByName      proc    uses eax ebx edi esi address_name:dword
        local    @result,@nRow,@nCol
        local    @i,@j,@index
        LOCAL	@best:dword
        local @flag:dword
        mov @best, 0  ; the error code 1
        mov @flag, 0
        invoke  RtlZeroMemory, offset sql, sizeof sql
        invoke strcat, offset sql, offset sql_selectBestByName

        invoke strcat, offset sql, offset sy
        invoke strcat, offset sql, address_name
        invoke strcat, offset sql, offset sy

        mov eax, offset sql
        invoke   hs_slct,hDB,offset sql,addr @result,addr @nRow,\
                       addr @nCol,offset errorInfo
        invoke  RtlZeroMemory, offset szStr, sizeof szStr
        ;mov      @str,eax
        mov      edi,@nCol
        mov      eax,@nRow
        mov      @i,eax
        mov      ebx,@result
        .while   @i
                mov    esi,0
                .while  esi < @nCol
                        mov ecx, offset szStr
                        invoke  strcat,offset szStr,[ebx + edi*4]
                        invoke str2dword, offset szStr, addr @best
                        mov @flag, 1
                        inc     esi
                        inc     edi
                .endw
                mov    eax,@i
                dec    eax
                mov    @i,eax
        .endw
        ;invoke  MessageBox,NULL,offset szStr,offset fileName,MB_OK
        invoke  RtlZeroMemory, offset szStr, sizeof szStr
              
        mov eax, @best
        .if @flag == 1
        	mov ebx, 0
        .else
                mov ebx, 1
        .endif
        ret
getBestByName        endp

str2dword proc uses eax ebx ecx edx address_str:dword, address_num:dword

	local   @n:dword
	LOCAL	@len:dword
	LOCAL	@str:byte
	invoke strlen, address_str
	mov @len, eax
	mov @n, 0
getNum:	 
	mov eax, address_str
	add eax, @n
        mov bl, [eax]
        mov @str, bl
        
     
        mov eax, address_num
        mov ebx, [eax]
        mov eax, 10

        mul ebx ; result in edx:eax
        mov ebx, eax
        
        xor eax, eax
        mov al, @str
        sub al, '0'
        
        add ebx, eax
        mov eax, address_num
        mov [eax], ebx
        
        inc @n
        mov eax, @len
        cmp @n, eax
        jl getNum
	
	
	
	ret

str2dword endp

dword2str   proc    uses eax ebx ecx edx address_num:dword, address_str:dword
            local   @num:dword
            local   @n:dword
            mov @n, 0
            mov eax, address_num
            mov ebx, [eax]
            mov @num, ebx
            
            
divNum:
            
            xor edx, edx
            mov eax, @num
            mov ebx, 10

            div ebx  ; quotient in eax while remainder in edx
 
            push edx  ; remainder
            mov @num, eax  ; update numerator
            inc @n  ; update n
            cmp eax, 0
            jnz divNum

            mov ecx, @n
            mov ebx, 0
getNum:
            pop eax
            add al, '0'
            
            mov ebx, address_str
            mov [ebx], al
            add address_str, 1
            loop getNum

            mov ebx, address_str
            mov byte ptr[ebx], 0
            mov eax, 0
            ret

dword2str   endp

saveGame    proc    uses ebx address_states:dword, address_name:dword, address_score:dword
            local @i:dword
            
            
            invoke   hs_open,offset fileName,offset hDB
            
            invoke  RtlZeroMemory, offset sql, sizeof sql
            invoke strcat, offset sql, offset sql_deleteByName  ; delete first. TODO: more save_file?

            invoke strcat, offset sql, offset sy
            invoke strcat, offset sql, address_name
            invoke strcat, offset sql, offset sy
            
            invoke hs_exec, hDB, offset sql, NULL, NULL, NULL
            
            invoke  RtlZeroMemory, offset sql, sizeof sql
            invoke strcat, offset sql, offset sql_insert2records
            invoke strcat, offset sql, offset lq

            invoke strcat, offset sql, offset sy
            invoke strcat, offset sql, address_name
            invoke strcat, offset sql, offset sy

            invoke strcat, offset sql, offset cm
            
            
writeStates:
            
            mov @i, 0
.while @i<16
            mov ebx, address_states
            
            invoke  RtlZeroMemory, offset str0, sizeof str0
            invoke dword2str, ebx, offset str0
            
            ;mov esi, offset sql
            ;invoke strcat, offset sql, offset sy
            invoke strcat, offset sql, offset str0
            ;invoke strcat, offset sql, offset sy

            invoke strcat, offset sql, offset cm
            add address_states, 4
            inc @i
            ;loop writeStates
.endw
            ;mov esi, offset sql
            invoke  RtlZeroMemory, offset str0, sizeof str0
            invoke dword2str, address_score, offset str0

            ;invoke strcat, offset sql, offset sy
            invoke strcat, offset sql, offset str0
            ;invoke strcat, offset sql, offset sy

            invoke strcat, offset sql, offset rq
            

            invoke hs_exec, hDB, offset sql, NULL, NULL, NULL
            invoke  RtlZeroMemory, offset sql, sizeof sql


            invoke updateBestByName, address_name, address_score

            ret
saveGame    endp

;-------------------------------------------------------------------------------------------------------------
;loadGame[param1:the address(dword) of name(byte) return 0 when no error occurs.]
;set the value of BLOCK, num_score.
;-------------------------------------------------------------------------------------------------------------
loadGame proc uses eax ebx edi esi address_name:dword
	;LOCAL    @str:byte
	local    @result,@nRow,@nCol
              local    @i,@j,@index
              LOCAL	@iBlock:dword
              
              invoke  RtlZeroMemory, offset sql, sizeof sql
            invoke strcat, offset sql, offset sql_selectByName

            invoke strcat, offset sql, offset sy
            invoke strcat, offset sql, address_name
            invoke strcat, offset sql, offset sy


	invoke   hs_open,offset fileName,offset hDB

              mov eax, offset szStr
              ;invoke  MessageBox,NULL,offset sql,offset fileName,MB_OK
              invoke   hs_slct,hDB,offset sql,addr @result,addr @nRow,\
                       addr @nCol,offset errorInfo
                 ;add eax, '0'
                 ;mov szStr, al
              ;invoke  MessageBox,NULL,offset szStr,offset fileName,MB_OK
              invoke   strcpy,offset szStr, offset empty
              ;mov      @str,eax
              mov      edi,@nCol
              mov      eax,@nRow
              mov      @i,eax
              mov      ebx,@result
              


              .while   @i
                       mov    esi,0
                      .while  esi < @nCol

                              ;invoke  strcat,offset szStr,[ebx + esi*4]
                              ;invoke  strcat,offset szStr,offset split
                              invoke  strcpy,offset szStr,[ebx + edi*4]
                              
                              .if esi == 0  ; id
                              	
                              .elseif esi == 1  ; name
                              	
                              .elseif esi == 2  ; score
                              	
                              .else
                              
                                ;invoke  strcat,offset szStr1,[ebx + edi*4]
                                ;invoke  strcat,offset szStr1,offset endline
                              
                              	mov @iBlock, esi
                              	sub @iBlock, 3
                              	;invoke  RtlZeroMemory, addr BLOCK[@iBlock], sizeof BLOCK[@iBlock]

                                mov ecx, offset BLOCK
                                push eax
                                mov eax, 4
                                mul @iBlock
                  
                                add ecx, eax
                                pop eax
                              	invoke str2dword, offset szStr, ecx
                              	;invoke  MessageBox,NULL,offset szStr,offset fileName,MB_OK
                              	
                              .endif
                              ;invoke  strcat,offset szStr,[ebx + edi*4]
                              ;invoke  strcat,offset szStr,offset endline

                              inc     esi
                              inc     edi
                              invoke  RtlZeroMemory, offset szStr, sizeof szStr
                      .endw
                      mov    eax,@i
                      dec    eax
                      mov    @i,eax
                      .break  ; TODO: can we get more save_file?
              .endw
              ;invoke  MessageBox,NULL,offset szStr1,offset fileName,MB_OK
              ;invoke  RtlZeroMemory, offset szStr1, sizeof szStr1
	
	
	ret

loadGame endp
createTable proc 
	invoke   hs_open,offset fileName,offset hDB
	
	invoke   hs_exec,hDB,offset sql_createTable_Plays,NULL,NULL,NULL
    	invoke   hs_exec,hDB,offset sql_createTable_Records,NULL,NULL,NULL
	
	ret

createTable endp

initDataBase   proc uses eax


              invoke   LoadLibrary,offset libName
              mov      hLib,eax
                invoke   GetProcAddress,hLib,addr sqlite3_open
              mov      hs_open,eax
              invoke   GetProcAddress,hLib,addr sqlite3_close
              mov      hs_close,eax
              invoke   GetProcAddress,hLib,addr sqlite3_exec
              mov      hs_exec,eax
              invoke   GetProcAddress,hLib,addr sqlite3_slct
              mov      hs_slct,eax
              
	;invoke   hs_open,offset fileName,offset hDB
              
    	;invoke   hs_exec,hDB,offset sql_createTable_Plays,NULL,NULL,NULL
    	;invoke   hs_exec,hDB,offset sql_createTable_Records,NULL,NULL,NULL
              ret

initDataBase    endp
end