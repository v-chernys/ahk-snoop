; Copyright (c) 2018-2024 Vladislav Chernyshev
; Copyright (c) 2018-2024 Владислав Чернышев
; --------------------------------------------------------------------------------------------------
; 2018-12-10, author Vladislav Chernyshev
; 2018-12-10, автор Владислав Чернышев
; --------------------------------------------------------------------------------------------------
; SNOOP
; Fixing keyboard layout errors / Исправление ошибок переключения раскладок клавиатуры
; https://github.com/v-chernys/ahk-snoop
; ==================================================================================================
; оригинальная реализация - в утилите "Опечатка by Dr. Golomin"
; утилитой пользовался примерно 18 лет (2001-2018), за что очень благодарен автору, Евгению Голомину
; ---------------------------------------------------------------------------------------
; Все операции - над  выделенным текстом.
; Break - сменить раскладку
; ScrollLock = Ctrl-Shift-PgUp - сменить регистр
; NumpadAdd = Win-PgUp - все в верхний регистр
; NumpadSub = Win-PgDn - все в нижний регистр
; NumpadDiv = Alt-Shift-\ = Ctrl-Shift-\ - слеш-бэкслеш
; NumpadMult= Alt-Shift-] - убрать все квадратные скобки (очистка SQL)
; Ctrl-Shift-Space = текст из VK-Teams > очистка 2023-07-12
; Ctrl-Shift-` = подставить гласные с ударениями
; ---------------------------------------------------------------------------------------
; 2022-01-30 - публикация на github
; 2024-03-19 = ^Delete / ^Backspace - перекодировка для ноута с Win 11
; 2024-05-12 > две кнопки мыши = {LWin}{Shift}S для Win 11

#SingleInstance force
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
StringCaseSense, On

; 2024-05-12 > две кнопки мыши = {LWin}{Shift}S для Win 11
~LButton & RButton:: 
~RButton & LButton:: 
	if (A_USERNAME <> "v253323") 
		exit
	SendInput {LWin Down}{LShift Down}s{LWin Up}{LShift Up}
	return

^+Space::		; 2023-07-12 = текст из VK-Teams > очистка
{
;   If WinActive("ahk_class NOTES")
;		Отправить2Альта("TYN","TYЧ")	; выбрать стиль "[None]"/"Чат"

	TempClipboard := ClipboardAll		; push
   Clipboard =
   Отправить_Contol_C()
   StringReplace, Clipboard, Clipboard, :`r`n, :`t, All
   Loop
   { 
	    StringReplace, Clipboard, Clipboard, `r`n`r`n, `r`n, UseErrorLevel
		if (ErrorLevel = 0)  ; No more replacements needed.
        break
   }
   Отправить_Contol_V()
   Clipboard := TempClipboard 			; pop
   EXIT
}

Break::
^Delete::
^Backspace::
;2020-04-08 #Break::	; 2020-04-03
;2020-04-08 ^+Backspace::   ; 2020-04-03
{
;	SendMode InputThenPlay
   TempClipboard := ClipboardAll		; push
   Clipboard =
   Отправить_Contol_C()
   новый := ""
   Loop, parse, clipboard
   { 
	з:=eng_rus(A_LoopField)
	новый:= новый з
   }
; если нет выделенного текста, то просто сменить раскладку  
; MsgBox % новый
  if !StrLen(новый) then
  {
		поменять_раскладку()
		Clipboard := TempClipboard 			; pop
		exit 
  }
		
	
;  переключить в нужную раскладку по первому символу	
   кириллица := "йцукенгшщзхъфывапролджэячсмитьбюё№"
   первый := SubStr(новый,1,1)
   место := InStr(кириллица, первый, CaseSensitive := false)
   if место then 
	SendMessage, 0x50,, 0x4190419,, A	; RU-RU
   if !место then 
	SendMessage, 0x50,, 0x4090409,, A	; EN-EN
   Sleep, 200

;  Send,%новый% ; так почему-то не подменяет № на #
;  заменяю 
	Clipboard := новый
   Отправить_Contol_V()
   Clipboard := TempClipboard 			; pop
   EXIT

}
ScrollLock::	; 2019-01-18
^+PgUp::	; 2020-04-03
{

	TempClipboard := ClipboardAll		; push
	Clipboard =
	Отправить_Contol_C()
	новый := ""
	Loop, parse, clipboard
	{ 
		з:=сменить_регистр(A_LoopField)
		новый:= новый з
	}
;	переключить_КАПС_ЛОК()
	Clipboard := новый
	Отправить_Contol_V()
	Clipboard := TempClipboard 		; pop
	return
}
NumpadAdd::
#PgUp::
{

	TempClipboard := ClipboardAll		; push
	Clipboard =
	Отправить_Contol_C()
	новый := ""
	Loop, parse, clipboard
	{ 
		з:=верхний_регистр(A_LoopField)
		новый:= новый з
	}
	Clipboard := новый
	Отправить_Contol_V()
	Clipboard := TempClipboard 		; pop
;	MsgBox, 1
	установить_КАПС_ЛОК(True)
	return
}
NumpadSub::
#PgDn::
{

	TempClipboard := ClipboardAll		; push
	Clipboard =
	Отправить_Contol_C()
	новый := ""
	Loop, parse, clipboard
	{ 
		з:=нижний_регистр(A_LoopField)
		новый:= новый з
	}
	Clipboard := новый
	Отправить_Contol_V()
	Clipboard := TempClipboard 		; pop
;	MsgBox, 0
	установить_КАПС_ЛОК(False)

	return
}
NumpadDiv::
!+sc02B:: ; AltShift\ при любой раскладке 2019-09-09
;^+sc02B:: ; CtrlShift\ при любой раскладке 2019-09-09
{
	TempClipboard := ClipboardAll		; push
	Clipboard =
	Отправить_Contol_C()
	новый := ""
	Loop, parse, clipboard
	{ 
		з:=слеш_бэкслеш(A_LoopField)
		новый:= новый з
	}
	Clipboard := новый
	Отправить_Contol_V()
	Clipboard := TempClipboard 		; pop
	return
}
NumpadMult::
!+sc01B:: ; AltShift] при любой раскладке 2019-09-09
;^+sc01B:: ; CtrlShift] при любой раскладке 2019-09-09
{
	TempClipboard := ClipboardAll		; push
	Clipboard =
	Отправить_Contol_C()
	новый := ""
	Loop, parse, clipboard
	{ 
		з:=убрать_квадратные_скобки(A_LoopField)
		новый:= новый з
	}
	Clipboard := новый
	Отправить_Contol_V()
	Clipboard := TempClipboard 		; pop
	return
}

; >>> подставить знак ударения
#sc021:: ; Alt-a' при любой раскладке 2024-01-25
{
	
;	SendInput, {Alt Down}{Numpad0}{Numpad7}{Numpad6}{Numpad9}{Alt Up}
;	SendInput, {Alt Down}{Numpad0}{Numpad9}{Alt Up}
	SendInput, {Alt Down}{Numpad0}{Numpad2}{Numpad2}{Numpad5}{Alt Up} ; a
	return
}

eng_rus(символ)
{

static f := "QWERTYUIOP{}ASDFGHJKL:""|ZXCVBNM<>?qwertyuiop[]asdfghjkl;'\zxcvbnm,./``~!@#$`%^&‘”“"
static g := "ЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭ/ЯЧСМИТЬБЮ,йцукенгшщзхъфывапролджэ\ячсмитьбю.ёЁ!""№;`%:?эЭЭ"
ff = %f%%g%
gg = %g%%f%
место := InStr(ff, символ, CaseSensitive := true)
if место then
{
;возврат := SubStr(gg,место,1)
;MsgBox %место% %возврат% 
	return % SubStr(gg,место,1)
}
return символ
}

сменить_регистр(символ)
{
static f := "йцукенгшщзхъфывапролджэячсмитьбюёqwertyuiopasdfghjklzxcvbnm"
static g := "ЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮЁQWERTYUIOPASDFGHJKLZXCVBNM"
ff = %f%%g%
gg = %g%%f%
место := InStr(ff, символ, CaseSensitive := true)
if место then
	return % SubStr(gg,место,1)
return символ
}

верхний_регистр(символ)
{
static f := "йцукенгшщзхъфывапролджэячсмитьбюёqwertyuiopasdfghjklzxcvbnm"
static g := "ЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮЁQWERTYUIOPASDFGHJKLZXCVBNM"
место := InStr(f, символ, CaseSensitive := true)
if место then 
	return % SubStr(g,место,1)
return символ
}

нижний_регистр(символ)
{
static f := "ЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮЁQWERTYUIOPASDFGHJKLZXCVBNM"
static g := "йцукенгшщзхъфывапролджэячсмитьбюёqwertyuiopasdfghjklzxcvbnm"
место := InStr(f, символ, CaseSensitive := true)
if место then 
	return % SubStr(g,место,1)
return символ
}

слеш_бэкслеш(символ)
{
static f := "\/"
static g := "/\"
место := InStr(f, символ, CaseSensitive := true)
if место then 
	return % SubStr(g,место,1)
return символ
}
убрать_квадратные_скобки(символ)
{
static f := "[]"
static g := ""
место := InStr(f, символ, CaseSensitive := true)
if место then 
	return % SubStr(g,место,1)
return символ
}

переключить_КАПС_ЛОК()	; 2019-02-14
{
	state := GetKeyState("CapsLock", "T")  ; 1 if CapsLock is ON, 0 otherwise.
	if state = False 
		SetCapsLockState, On	
	else 
		SetCapsLockState, Off	
	Sleep, 200
	return
}
установить_КАПС_ЛОК(да)	; 2019-02-14
{
;	SLEEP, 1000

;;;	уже := GetKeyState("CapsLock", "T")  ; 1 if capslock is ON, 0 otherwise.
;	MsgBox, %уже% %да%
;;;	if уже = да 
;;;		RETURN
;;	SetCapsLockState
;;	SetStoreCapsLockMode, On

	if да = 1 
;		MsgBox 1
		SetCapsLockState, On	
	else 
		SetCapsLockState, Off	
	Sleep, 200
	return
}

поменять_раскладку() ; 2021-10-06
{ ; https://forum.script-coding.com/viewtopic.php?id=189
  ;0xF2AFBF7 - что за раскладка?

  SetFormat, Integer, H
  
  Locale1=0x4090409  ; Английский (американский).
  Locale2=0x4190419  ; Русский.
  WinGet, WinID,, A
  ThreadID:=DllCall("GetWindowThreadProcessId", "Int", WinID, "Int", "0")
  InputLocaleID:=DllCall("GetKeyboardLayout", "Int", ThreadID)
 ;  MsgBox, % InputLocaleID

  if(InputLocaleID!=Locale2)
    SendMessage, 0x50,, % Locale2,, A
  else ; if(InputLocaleID=Locale1)
    SendMessage, 0x50,, % Locale1,, A
  return	
}

; ---------------------------------------------------------------------------------------
ОтправитьАльт0(набор="tln") ; 2020-05-04
{
	SendInput {Alt Down}
	sendinput {Raw}%набор%
	SendInput {Alt Up}	
;	exit ; чтобы отправить потом вторую последовательность
}
ОтправитьАльт(набор="tln") ; 2020-04-27
{
	ОтправитьАльт0(набор)	
	exit
}
Отправить2Альта(набор1, набор2) ; 2020-05-04
{
	ОтправитьАльт0(набор1)	
	ОтправитьАльт0(набор2)	
;	exit
}
; ---------------------------------------------------------------------------------------
Отправить_Contol_C()
{
;   SendInput, ^{vk43}				; Ctrl + C
    SendInput, {LCtrl Down}{vk43}{LCtrl Up}
	ClipWait, 1
	Sleep, 200
}	
 
Отправить_Contol_V()
{
 ;   SendInput, ^{vk56}				; Ctrl + v
    SendInput, {LCtrl Down}{vk56}{LCtrl Up}
	ClipWait, 1
	Sleep, 200
}