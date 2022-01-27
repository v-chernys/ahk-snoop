; 2018-12-10, ¬.„ернышЄв
; SNOOP
; подмена неправильно введенных символов (если забыл переключить раскладку клавиатуры)
; оригинальна€ реализаци€ - в утилите "ќпечатка by Dr. Golomin"
; утилитой пользовалс€ примерно 18 лет (2001-2018), за что очень благодарен автору, ≈вгению √оломину

#SingleInstance force
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
StringCaseSense, On


Break::
;2020-04-08 #Break::	; 2020-04-03
;2020-04-08 ^+Backspace::   ; 2020-04-03
{
   TempClipboard := ClipboardAll		; push
   Clipboard =
   SendInput, ^{vk43}				; Ctrl + C
   ClipWait, 0
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
		помен€ть_раскладку()
		Clipboard := TempClipboard 			; pop
		exit 
  }
		
	
;  переключить в нужную раскладку по первому символу	
   кириллица := "йцукенгшщзхъфывапролджэ€чсмитьбюЄє"
   первый := SubStr(новый,1,1)
   место := InStr(кириллица, первый, CaseSensitive := false)
   if место then 
	SendMessage, 0x50,, 0x4190419,, A	; RU-RU
   if !место then 
	SendMessage, 0x50,, 0x4090409,, A	; EN-EN
   Sleep, 200

;  Send,%новый% ; так почему-то не подмен€ет є на #
;  замен€ю 
   Clipboard := новый
   SendInput, ^{vk56}				; Ctrl + v
   ClipWait, 0
   Sleep, 200
   Clipboard := TempClipboard 			; pop
   EXIT

}
ScrollLock::	; 2019-01-18
^+PgUp::	; 2020-04-03
{

	TempClipboard := ClipboardAll		; push
	Clipboard =
	SendInput, ^{vk43}			; Ctrl + C
	ClipWait, 0
	новый := ""
	Loop, parse, clipboard
	{ 
		з:=сменить_регистр(A_LoopField)
		новый:= новый з
	}
;	переключить_ јѕ—_Ћќ ()
	Clipboard := новый
	SendInput, ^{vk56}			; Ctrl + v
	ClipWait, 0
   Sleep, 200
	Clipboard := TempClipboard 		; pop
	return
}
NumpadAdd::
#PgUp::
{

	TempClipboard := ClipboardAll		; push
	Clipboard =
	SendInput, ^{vk43}			; Ctrl + C
	ClipWait, 0
	новый := ""
	Loop, parse, clipboard
	{ 
		з:=верхний_регистр(A_LoopField)
		новый:= новый з
	}
	Clipboard := новый
	SendInput, ^{vk56}			; Ctrl + v
	ClipWait, 0
	Sleep, 200
	Clipboard := TempClipboard 		; pop
;	MsgBox, 1
	установить_ јѕ—_Ћќ (True)
	return
}
NumpadSub::
#PgDn::
{

	TempClipboard := ClipboardAll		; push
	Clipboard =
	SendInput, ^{vk43}			; Ctrl + C
	ClipWait, 0
	новый := ""
	Loop, parse, clipboard
	{ 
		з:=нижний_регистр(A_LoopField)
		новый:= новый з
	}
	Clipboard := новый
	SendInput, ^{vk56}			; Ctrl + v
	ClipWait, 0
	Sleep, 200
	Clipboard := TempClipboard 		; pop
;	MsgBox, 0
	установить_ јѕ—_Ћќ (False)

	return
}
NumpadDiv::
!+sc02B:: ; AltShift\ при любой раскладке 2019-09-09
;^+sc02B:: ; CtrlShift\ при любой раскладке 2019-09-09
{
	TempClipboard := ClipboardAll		; push
	Clipboard =
	SendInput, ^{vk43}			; Ctrl + C
	ClipWait, 0
	новый := ""
	Loop, parse, clipboard
	{ 
		з:=слеш_бэкслеш(A_LoopField)
		новый:= новый з
	}
	Clipboard := новый
	SendInput, ^{vk56}			; Ctrl + v
	ClipWait, 0
   Sleep, 200
	Clipboard := TempClipboard 		; pop
	return
}
NumpadMult::
!+sc01B:: ; AltShift] при любой раскладке 2019-09-09
;^+sc01B:: ; CtrlShift] при любой раскладке 2019-09-09
{
	TempClipboard := ClipboardAll		; push
	Clipboard =
	SendInput, ^{vk43}			; Ctrl + C
	ClipWait, 0
	новый := ""
	Loop, parse, clipboard
	{ 
		з:=убрать_квадратные_скобки(A_LoopField)
		новый:= новый з
	}
	Clipboard := новый
	SendInput, ^{vk56}			; Ctrl + v
	ClipWait, 0
   Sleep, 200
	Clipboard := TempClipboard 		; pop
	return
}
eng_rus(символ)
{

static f := "QWERTYUIOP{}ASDFGHJKL:""|ZXCVBNM<>?qwertyuiop[]asdfghjkl;'\zxcvbnm,./``~!@#$`%^&"
static g := "…÷” ≈Ќ√Ўў«’Џ‘џ¬јѕ–ќЋƒ∆Ё/я„—ћ»“№Ѕё,йцукенгшщзхъфывапролджэ\€чсмитьбю.Є®!""є;`%:?"
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
static f := "йцукенгшщзхъфывапролджэ€чсмитьбюЄqwertyuiopasdfghjklzxcvbnm"
static g := "…÷” ≈Ќ√Ўў«’Џ‘џ¬јѕ–ќЋƒ∆Ёя„—ћ»“№Ѕё®QWERTYUIOPASDFGHJKLZXCVBNM"
ff = %f%%g%
gg = %g%%f%
место := InStr(ff, символ, CaseSensitive := true)
if место then
	return % SubStr(gg,место,1)
return символ
}

верхний_регистр(символ)
{
static f := "йцукенгшщзхъфывапролджэ€чсмитьбюЄqwertyuiopasdfghjklzxcvbnm"
static g := "…÷” ≈Ќ√Ўў«’Џ‘џ¬јѕ–ќЋƒ∆Ёя„—ћ»“№Ѕё®QWERTYUIOPASDFGHJKLZXCVBNM"
место := InStr(f, символ, CaseSensitive := true)
if место then 
	return % SubStr(g,место,1)
return символ
}

нижний_регистр(символ)
{
static f := "…÷” ≈Ќ√Ўў«’Џ‘џ¬јѕ–ќЋƒ∆Ёя„—ћ»“№Ѕё®QWERTYUIOPASDFGHJKLZXCVBNM"
static g := "йцукенгшщзхъфывапролджэ€чсмитьбюЄqwertyuiopasdfghjklzxcvbnm"
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
переключить_ јѕ—_Ћќ ()	; 2019-02-14
{
	state := GetKeyState("CapsLock", "T")  ; 1 if CapsLock is ON, 0 otherwise.
	if state = False 
		SetCapsLockState, On	
	else 
		SetCapsLockState, Off	
	Sleep, 200
	return
}
установить_ јѕ—_Ћќ (да)	; 2019-02-14
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

помен€ть_раскладку() ; 2021-10-06
{ ; https://forum.script-coding.com/viewtopic.php?id=189
  ;0xF2AFBF7 - что за раскладка?

  SetFormat, Integer, H
  
  Locale1=0x4090409  ; јнглийский (американский).
  Locale2=0x4190419  ; –усский.
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