#NoEnv  ;Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ;Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ;Ensures a consistent starting directory.
#SingleInstance Force ;Makes it so only one script instance is running at any time and skips prompt.
;#Warn  ;Enable warnings to assist with detecting common errors.


; Remove all the windows default language switch hotkeys from Input Lamguage Hot key Settings first. 

!+1::
    KeyWait, Alt
    KeyWait, 1
	languageId := "4409"
    SetKeyboardLanguage(languageId)
    SetCapsLockState, Off  ; In case the Caps Lock key is turned on for any reason.
    return

!+2::
    KeyWait, Alt
    KeyWait, 2
    languageId := "2052"
    SetKeyboardLanguage(languageId)
    SetCapsLockState, Off  ; In case the Caps Lock key is turned on for any reason.
    return
    
!+3::
    KeyWait, Alt
    KeyWait, 3
    languageId := "1041"
    SetKeyboardLanguage(languageId)
    Send ^{Capslock}  ; Sets Japanese to Hiragana input by default, though the creators have no idea why it works as well.
    SetCapsLockState, Off  ; In case the Caps Lock key is turned on for any reason.
    return

Shift::  ; In Japanese, converts between Hiragana and English.
    KeyWait, Shift
    languageId := "1041"
    currentLanguageId := GetKeyboardLanguage(WinActive("A"))
    if (currentLanguageId = languageId)
    {
        Send, +{CapsLock}
    }
    return

/*  
; Commented because it is in conflict and fighting over EasyTyper.ahk script.
$Tab::  ; In Japanese, convert typed in Hiragana to Katakana.
    KeyWait, Tab
    languageId := "1041"
    currentLanguageId := GetKeyboardLanguage(WinActive("A"))
    if (currentLanguageId = languageId)
    {
        Send, {F7}
    }
    else if WinActive("ahk_class Notepad")  ; !Special case, to avoid conflict with EasyTyper.ahk.!
    {
        Send, {Space 2}
    }
    else
    {
        Send, {Tab}
    }
    return
*/    

SetKeyboardLanguage(LocaleID)
{
	Static SPI_SETDEFAULTINPUTLANG := 0x005A, SPIF_SENDWININICHANGE := 2	
	Lan := DllCall("LoadKeyboardLayout", "Str", Format("{:08x}", LocaleID), "Int", 0)
	VarSetCapacity(binaryLocaleID, 4, 0)
	NumPut(LocaleID, binaryLocaleID)
	DllCall("SystemParametersInfo", "UInt", SPI_SETDEFAULTINPUTLANG, "UInt", 0, "UPtr", &binaryLocaleID, "UInt", SPIF_SENDWININICHANGE)	
	WinGet, windows, List
	Loop % windows
    {
		PostMessage 0x50, 0, % Lan, , % "ahk_id " windows%A_Index%
	}
}

GetKeyboardLanguage(_hWnd=0)  ; hwnd: handler window
{
	if !_hWnd
		ThreadId=0
	else
		if !ThreadId := DllCall("user32.dll\GetWindowThreadProcessId", "Ptr", _hWnd, "UInt", 0, "UInt")
			return false
	
	if !KBLayout := DllCall("user32.dll\GetKeyboardLayout", "UInt", ThreadId, "UInt")
		return false
	
	return KBLayout & 0xFFFF
}


