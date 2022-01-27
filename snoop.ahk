; 2018-12-10, �.��������
; SNOOP
; ������� ����������� ��������� �������� (���� ����� ����������� ��������� ����������)
; ������������ ���������� - � ������� "�������� by Dr. Golomin"
; �������� ����������� �������� 18 ��� (2001-2018), �� ��� ����� ���������� ������, ������� ��������

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
   ����� := ""
   Loop, parse, clipboard
   { 
	�:=eng_rus(A_LoopField)
	�����:= ����� �
   }
; ���� ��� ����������� ������, �� ������ ������� ���������  
; MsgBox % �����
  if !StrLen(�����) then
  {
		��������_���������()
		Clipboard := TempClipboard 			; pop
		exit 
  }
		
	
;  ����������� � ������ ��������� �� ������� �������	
   ��������� := "����������������������������������"
   ������ := SubStr(�����,1,1)
   ����� := InStr(���������, ������, CaseSensitive := false)
   if ����� then 
	SendMessage, 0x50,, 0x4190419,, A	; RU-RU
   if !����� then 
	SendMessage, 0x50,, 0x4090409,, A	; EN-EN
   Sleep, 200

;  Send,%�����% ; ��� ������-�� �� ��������� � �� #
;  ������� 
   Clipboard := �����
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
	����� := ""
	Loop, parse, clipboard
	{ 
		�:=�������_�������(A_LoopField)
		�����:= ����� �
	}
;	�����������_����_���()
	Clipboard := �����
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
	����� := ""
	Loop, parse, clipboard
	{ 
		�:=�������_�������(A_LoopField)
		�����:= ����� �
	}
	Clipboard := �����
	SendInput, ^{vk56}			; Ctrl + v
	ClipWait, 0
	Sleep, 200
	Clipboard := TempClipboard 		; pop
;	MsgBox, 1
	����������_����_���(True)
	return
}
NumpadSub::
#PgDn::
{

	TempClipboard := ClipboardAll		; push
	Clipboard =
	SendInput, ^{vk43}			; Ctrl + C
	ClipWait, 0
	����� := ""
	Loop, parse, clipboard
	{ 
		�:=������_�������(A_LoopField)
		�����:= ����� �
	}
	Clipboard := �����
	SendInput, ^{vk56}			; Ctrl + v
	ClipWait, 0
	Sleep, 200
	Clipboard := TempClipboard 		; pop
;	MsgBox, 0
	����������_����_���(False)

	return
}
NumpadDiv::
!+sc02B:: ; AltShift\ ��� ����� ��������� 2019-09-09
;^+sc02B:: ; CtrlShift\ ��� ����� ��������� 2019-09-09
{
	TempClipboard := ClipboardAll		; push
	Clipboard =
	SendInput, ^{vk43}			; Ctrl + C
	ClipWait, 0
	����� := ""
	Loop, parse, clipboard
	{ 
		�:=����_�������(A_LoopField)
		�����:= ����� �
	}
	Clipboard := �����
	SendInput, ^{vk56}			; Ctrl + v
	ClipWait, 0
   Sleep, 200
	Clipboard := TempClipboard 		; pop
	return
}
NumpadMult::
!+sc01B:: ; AltShift] ��� ����� ��������� 2019-09-09
;^+sc01B:: ; CtrlShift] ��� ����� ��������� 2019-09-09
{
	TempClipboard := ClipboardAll		; push
	Clipboard =
	SendInput, ^{vk43}			; Ctrl + C
	ClipWait, 0
	����� := ""
	Loop, parse, clipboard
	{ 
		�:=������_����������_������(A_LoopField)
		�����:= ����� �
	}
	Clipboard := �����
	SendInput, ^{vk56}			; Ctrl + v
	ClipWait, 0
   Sleep, 200
	Clipboard := TempClipboard 		; pop
	return
}
eng_rus(������)
{

static f := "QWERTYUIOP{}ASDFGHJKL:""|ZXCVBNM<>?qwertyuiop[]asdfghjkl;'\zxcvbnm,./``~!@#$`%^&"
static g := "�����������������������/���������,�����������������������\���������.��!""�;`%:?"
ff = %f%%g%
gg = %g%%f%
����� := InStr(ff, ������, CaseSensitive := true)
if ����� then
{
;������� := SubStr(gg,�����,1)
;MsgBox %�����% %�������% 
	return % SubStr(gg,�����,1)
}
return ������
}

�������_�������(������)
{
static f := "���������������������������������qwertyuiopasdfghjklzxcvbnm"
static g := "�������������������������������ިQWERTYUIOPASDFGHJKLZXCVBNM"
ff = %f%%g%
gg = %g%%f%
����� := InStr(ff, ������, CaseSensitive := true)
if ����� then
	return % SubStr(gg,�����,1)
return ������
}

�������_�������(������)
{
static f := "���������������������������������qwertyuiopasdfghjklzxcvbnm"
static g := "�������������������������������ިQWERTYUIOPASDFGHJKLZXCVBNM"
����� := InStr(f, ������, CaseSensitive := true)
if ����� then 
	return % SubStr(g,�����,1)
return ������
}

������_�������(������)
{
static f := "�������������������������������ިQWERTYUIOPASDFGHJKLZXCVBNM"
static g := "���������������������������������qwertyuiopasdfghjklzxcvbnm"
����� := InStr(f, ������, CaseSensitive := true)
if ����� then 
	return % SubStr(g,�����,1)
return ������
}

����_�������(������)
{
static f := "\/"
static g := "/\"
����� := InStr(f, ������, CaseSensitive := true)
if ����� then 
	return % SubStr(g,�����,1)
return ������
}
������_����������_������(������)
{
static f := "[]"
static g := ""
����� := InStr(f, ������, CaseSensitive := true)
if ����� then 
	return % SubStr(g,�����,1)
return ������
}
�����������_����_���()	; 2019-02-14
{
	state := GetKeyState("CapsLock", "T")  ; 1 if CapsLock is ON, 0 otherwise.
	if state = False 
		SetCapsLockState, On	
	else 
		SetCapsLockState, Off	
	Sleep, 200
	return
}
����������_����_���(��)	; 2019-02-14
{
;	SLEEP, 1000

;;;	��� := GetKeyState("CapsLock", "T")  ; 1 if capslock is ON, 0 otherwise.
;	MsgBox, %���% %��%
;;;	if ��� = �� 
;;;		RETURN
;;	SetCapsLockState
;;	SetStoreCapsLockMode, On

	if �� = 1 
;		MsgBox 1
		SetCapsLockState, On	
	else 
		SetCapsLockState, Off	
	Sleep, 200
	return
}

��������_���������() ; 2021-10-06
{ ; https://forum.script-coding.com/viewtopic.php?id=189
  ;0xF2AFBF7 - ��� �� ���������?

  SetFormat, Integer, H
  
  Locale1=0x4090409  ; ���������� (������������).
  Locale2=0x4190419  ; �������.
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