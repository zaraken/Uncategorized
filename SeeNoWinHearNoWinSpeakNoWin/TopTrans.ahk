;#InstallKeybdHook
#SingleInstance ignore

; ref https://autohotkey.com/docs/commands/WinSet.htm

currWindow := {}
currWindow.ID := ""
; TODO: save other attributes (inital state) of currentWindow, not just ID
; would be pointless if the script is restarted

OnExit, Exit

#WheelUp::  ; Win+WheelUp to increase transparency
    currentWindow := currWindow.ID
    if (currentWindow="")
    {
        currentWindow := init()
    }
    WinGet, curtrans, Transparent, ahk_id %currentWindow%
    if ! curtrans
        curtrans = 255
    newtrans := curtrans + 10
    if (newtrans > 0 and newtrans < 256)
    {
        WinSet, Transparent, %newtrans%, ahk_id %currentWindow%
        WinSet, ExStyle, +0x20, ahk_id %currentWindow% ; clickthrough
        WinSet, Alwaysontop, ON, ahk_id %currentWindow%
    }
    else
    {
        reset()
    }
return

#WheelDown::  ; Win+WheelDown to decrease transparency
    currentWindow := currWindow.ID
    if (currentWindow="")
    {
        currentWindow := init()
    }
    WinGet, curtrans, Transparent, ahk_id %currentWindow%
    if ! curtrans
        curtrans = 255
    newtrans := curtrans - 10
    if newtrans < 10
        newtrans = 10
    WinSet, Transparent, %newtrans%, ahk_id %currentWindow%
    WinSet, ExStyle, +0x20, ahk_id %currentWindow%
    WinSet, Alwaysontop, ON, ahk_id %currentWindow%
return

#o::  ; Win+O to reset the last saved window
    currentWindow := currWindow.ID
    if (currentWindow!="")
    {
        reset()
    } 
return

#g::  ; Win+G to show tooltip with stats
    DetectHiddenWindows, on
    currentWindow := currWindow.ID
    ;MouseGetPos,,, underMouseWindow ; does not work for clickthrough windows
    WinGet, transp, Transparent, ahk_id %currentWindow%
    WinGet, exstyle, ExStyle, ahk_id %currentWindow%
    clickthrough := exstyle&0x20
    ontop := exstyle&0x8
    ToolTip ID: %currentWindow% `n Translucency:`t%transp%`n  ClickThrough: `t%clickthrough%`n  Alwaysontop: `t%ontop%`n
	Sleep 2000
	ToolTip
return

; Retrieve the id of the currently active window
init(){
    DetectHiddenWindows, on
    global currWindow
    WinGet, currentWindow, ID, A
    ;currentWindow := WinExist("A")
    currWindow.ID := currentWindow
    ToolTip ID: %currentWindow% `n init
    Sleep 500
    ToolTip
    return currentWindow
}

reset(){
    global currWindow
    if (currWindow.ID!="")
    {
        currentWindow := currWindow.ID
        ToolTip ID: %currentWindow% `n resetting ...
        Sleep 500
        ToolTip
        WinSet, Transparent, 255, ahk_id %currentWindow%
        WinSet, Transparent, OFF, ahk_id %currentWindow%
        WinSet, ExStyle, -0x20, ahk_id %currentWindow% 
        WinSet, Alwaysontop, OFF, ahk_id %currentWindow%
        currWindow.ID := ""
    }
}

Exit:
    reset()
    ExitApp
return