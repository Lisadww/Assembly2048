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

getScore proto :dword
DataBaseInit proto
saveGame proto :dword, :dword, :dword

public getScore
public saveGame
public DataBaseInit
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;SQLite相关函数指针定义
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
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
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

.data
sql_insert2records   db  'insert into Records(name, a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15,score) values', 0

;for debug
states  dword   2,16,0,0,16,0,0,0,2,4,8,16,32,1024,2048,0
sscore   dword   4096
sname    db    'Luna', 0
;---------------------
lq  db  '(', 0
rq  db  ')', 0
sy  db  39, 0
cm  db  ',', 0
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
.data?
str0          db       32 dup(?)
sql           db       500 dup(?)
szStr         db       500 dup(?)

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
;info of sqlite
libName       db       'sqlite3.dll',0
sqlite3_open  db       'sqlite3_open',0
sqlite3_close db       'sqlite3_close',0
sqlite3_exec  db       'sqlite3_exec',0
sqlite3_slct  db       'sqlite3_get_table',0 
fileName      db       'data.db',0  



sql_createTable_Plays   db       'create table if not exists Plays(name varchar(60),best integer)', 0 
sql_createTable_Records db      'create table if not exists Records(id integer primary key autoincrement,name varchar(60), score integer, '
                        db      'a0 integer, a1 integer, a2 integer, a3 integer, a4 integer, a5 integer, a6 integer, a7 integer, a8 integer, a9 integer, a10 integer, a11 integer, a12 integer, a13 integer, a14 integer, a15 integer)', 0
insertData    db       'insert into Plays(name,best) values(',39,'张三',39,','
              db       39,'2048',39,')',0  ; 39='

selectData    db       'select * from Records',0
split         db       ':',0
endline       db       0dh,0ah,0
empty         db       0
