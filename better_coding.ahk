; Install autohotkey.
; Then create shortcut to this file under: C:\Users\<YOURUSERNAME>\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup
; or doubleklick this file
;
; # Win (Windows logo key)
; ! Alt
; ^ Control
; + Shift
; & An ampersand may be used between any two keys or mouse buttons to combine them into a custom hotkey.
; Version: 1.9

#Warn ; Enable warnings to assist with detecting common errors.
#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir% ; Ensures a consistent starting directory.
#installkeybdhook
#SingleInstance, force
SetCapsLockState, AlwaysOff
#Include, utils\load-settings.ahk
#Include, utils\quick-command.ahk
#Include, utils\window-switch.ahk
#Include, utils\display-image.ahk

; GLOBAL VARS AND AUTOEXECUTE
;{-----------------------------------------------
;
; #WinActivateForce
; Config := GetConfigDictionary(ConfigPath)
; Browser:= Config["Browser"]
; SearchEngine:= Config["SearchEngine"]
; ReferenceManager:= GetPath(Config["ReferenceManager"])
; PasswordManager:= GetPath(Config["PasswordManager"])
; Editor:= Config["Editor"]
; Messenger:= GetPath(Config["Messenger"])
; SpaceLayer:= Config["SpaceLayer"]
; AltLayer:= Config["AltLayer"]
; CapsLayer:= Config["CapsLayer"]
LoadConfig()
;-----------------------------------------------

;<::Shift
;#::Enter

;toggle pause key to suspends and restart script
Pause::
Suspend
Pause,,1
return

; With following lines the key # will also printed, when no further key is pressed
; Example:
; Mentioned in the hotkeys docs for UP:
;    In einem SC028hnlichen Zusammenhang besteht eine SC028hnliche Technik wie oben darin, einen Hotkey in einen PrSC028fixschlSC01Assel zu
;    verwandeln. Der Vorteil ist, dass der Hotkey zwar beim Loslassen ausgelSC027st wird, dies jedoch nur, wenn Sie keine andere Taste
;    gedrSC01Ackt haben, wSC028hrend er gedrSC01Ackt gehalten wurde. Zum Beispiel:
; LControl & F1::return  ; Make left-control a prefix by using it in front of "&" at least once.
; LControl::MsgBox You released LControl without having used it to modify any other key.

; # & F1::Return ; Mentioned in the hotkeys docs for UP
; *#::Send {Blind}{#}

; AHK implementing layer CapsLock Part1
; https://www.autohotkey.com/boards/viewtopic.php?f=7&t=20661&p=119764

#if CapsLayer = 1
    SC028 & F1::Return ; Mentioned in the hotkeys docs for UP
    SC028::Send, ä
    +SC028::Send, Ä
#if
; $#::
;     KeyWait, #
; return

#if (CapsLayer = 1)
    CapsLock::
        KeyWait, CapsLock
    ;	If (A_PriorKey="CapsLock")
    ;		SetCapsLockState, % GetKeyState("CapsLock","T") ? "Off" : "On"
    Return
#if

; AHK implementing layer Space


#if (SpaceLayer = 1)
    Space & <:: RunQuickCommand(Browser, SearchEngine, True)
    Space & F1::Return ; Mentioned in the hotkeys docs for UP
    *Space::Send {Blind}{Space} ; Send it explicitly when no other key is pressed before letting go, including any modifiers being  held

    ; Send Ctrl+Space
    ^SPACE:: Send ^{space}

    ~#Space::return

    ; Task switching
    ;Space & Tab::AltTab
    ;Space & q::Send, {Alt Down}{Tab}{Alt Up}
    ;Space & w::Send, {Ctrl Down}{Tab}{Ctrl Up}
    ; New, Refresh
    ;Space & r::Send, {F5}
    Space & s:: send, {blind}{left}
    Space & e:: send, {blind}{Up}
    Space & d:: send, {blind}{Down}
    Space & f:: send, {blind}{Right}
    Space & a:: send, {blind}{Home}
    Space & r:: send, {blind}{Del}
    Space & g:: send, {blind}{End}
    Space & w::Send, {Backspace}
    Space & Tab::
    Space & q::Send, ^+{Left}{Del}
    Space & t::Send, ^+{Right}{Del}}
    ;Space & q::Send, {PgUp}
    ;Space & t::Send, {PgDn}
    ; Select all, Space, Find
    ;Space & a::Send, {Ctrl Down}a{Ctrl Up}
    ;Space & s::Send, {Space}
    ;Space & f::Send, {Ctrl Down}f{Ctrl Up}
    ; Undo, Cut, Copy and Paste
    Space & b::Send, {Ctrl Down}z{Ctrl Up}
    Space & x::Send, {Ctrl Down}x{Ctrl Up}
    Space & c::
    If WinActive("ahk_exe mintty.exe") {
        Send {Ctrl Down}{Insert}{Ctrl Up}
    } Else If WinActive("ahk_exe WindowsTerminal.exe") {
        Send {Ctrl Down}{Insert}{Ctrl Up}
    } Else {
        Send, {Ctrl Down}c{Ctrl Up}
    }
    Return
    Space & v::
    If WinActive("ahk_exe ConEmu64.exe") {
        Send {LShift Down}{Insert}{LShift Up}
    } Else If WinActive("ahk_exe mintty.exe") {
        Send {LShift Down}{Insert}{LShift Up}
    } Else If WinActive("ahk_exe WindowsTerminal.exe") {
        Send {LShift Down}{Insert}{LShift Up}
    } Else {
        Send, {Ctrl Down}v{Ctrl Up}
    }
    Return
    Space & y:: Send, {Esc}
    Space & z::Send, {,}
    Space & h::Send, 0
    Space & m::Send, 1
    Space & ,::Send, 2
    Space & .::Send, 3
    Space & j::Send, 4
    Space & k::Send, 5
    Space & l::Send, 6
    Space & u::Send, 7
    Space & i::Send, 8
    Space & o::Send, 9
    Space & p::Send, {+}
    Space & -::Send, {-}
    Space & SC027::Send, {*}
    ;Space & 7::Send, {/}
    Space & SC028::Send, {/}
    Space & SC01A::Send, {^}
    Space & n::Send, {.}
    ;   Space & SC028::Send, {SPACE}
    Space & ALT::Send, {SPACE}
    Space & 1::Send, {F1}
    Space & 2::Send, {F2}
    Space & 3::Send, {F3}
    Space & 4::Send, {F4}
    Space & 5::Send, {F5}
    Space & 6::Send, {F6}
    Space & 7::Send, {F7}
    Space & 8::Send, {F8}
    Space & 9::Send, {F9}
    Space & 0::Send, {F10}
    Space & SC00C::Send, {F11}
    Space & SC00D::Send, {F12}
    Space & F12::DisplayInfo("images\space-layer-short.png", "F12")
    Space::
        Send, {Space}
    Return
#if

; AHK implementing layer CapsLock Part2

#If, (GetKeyState("CapsLock", "P") or GetKeyState("#", "P") or GetKeyState("SC028", "P")) and (CapsLayer = 1) ;Your CapsLock Hotkeys go below

    w::
        7::Send, {/}
    e::
        8::Send, {|}
    r::
        9::Send, {\}

    i::
        Send, {END}{{}{Enter} ;goto end and print semicolon and enter
    return

    o::
        Send, {END}{;}{Enter} ;goto end and print semicolon and enter
    return

    z::
        Send, {END}{Enter} ;goto end and enter
    return

    j::Send, {(}
    k::Send, {{}
        l::Send, {[}
        m::Send, {)}
    ,::Send, {}}
    .::Send, {]}
    h::Send, {<}
    g::Send, {=}
    n::Send, {>}
    b::Send, {=}{>}
    -::Send, {#}
    v::Send, {-}{>}
    SC027::Send, {'}
    s::Send, {*}
    u::Send, {&}
    f::Send, {?}
    q::Send, @
    a::Send, {!}
    t::Send, {~}
    SC028::Send, {"}
    p::Send, {asc 0037} ;percentage %
    d::Send, {$}
    c::Send, {€}
    F12::DisplayInfo("images\capslock-layer.png", "F12")
#If



;-----------------------------------------------|
                                              ; |
; WINDOW SWITCH HOTKEYS                         |
                                              ; |
;-----------------------------------------------|


; Hotkey to AltGr+c to launch/restore the Windows Terminal.
<^>!c::SwitchToWindow("ahk_exe WindowsTerminal.exe", "wt")
; or <^>!c::SwitchToWindowsTerminal()

; Hotkey to AltGr+f to launch/restore the Browser. Default is Firefox.
<^>!f::SwitchToBrowser(Browser)

; Hotkey to AltGr+a to launch/restore Reference Manager. Default is Zotero.
<^>!a::SwitchToApp(ReferenceManager)
; <^>!a::SwitchToReferenceManager(ReferenceManager)

; Hotkey to AltGr+t to launch/restore your chosen Messenger. Default is Telegram Desktop.
<^>!t::SwitchToApp(Messenger)
; <^>!t::SwitchToMessenger()

; Hotkey to AltGr+s to launch/restore Password Manager. Default is KeePass.
<^>!s::SwitchToApp(PasswordManager)
; <^>!s::SwitchToPasswordManager()

; Hotkey to AltGr+d to launch/restore Explorer.
<^>!d::SwitchToExplorer()

; Hotkey to AltGr+v to launch/restore Editor. Default is VSCode.
; <^>!v::SwitchToApp(Editor)
<^>!v::SwitchToEditor(Editor)

; Hotkey to Alt+F12 to show Info.
!F12::DisplayInfo("images/alt-altgr-layer.png", "F12")

; Hotkey to Alt+F12 to show Info.
<^>!F12::DisplayInfo("images/alt-altgr-layer.png", "F12")


;-----------------------------------------------|
                                              ; |
; SOME EXTRA HOTKEYS                            |
                                              ; |
;-----------------------------------------------|
+^F1:: SpaceLayer := Mod(SpaceLayer + 1, 2)
+^F2:: CapsLayer := Mod(CapsLayer + 1, 2)
+^F3:: AltLayer := Mod(AltLayer + 1, 2)
+^F4::
    ToolTip, % ReadFile(ConfigPath)
    KeyWait, F4
    Tooltip
    Return
+^F5::
    ToolTip, % ReadFile(PathAndFilename)
    KeyWait, F5
    Tooltip
    Return
<^>!Space:: RunQuickCommand(Browser, SearchEngine)
<^>!y:: RunQuickCommand(Browser, SearchEngine, True)

#if AltLayer = 1
    !i::Send, {Up}
    !j::Send, {left}
    !k::Send, {down}
    !l::Send, {Right}

    ; #IfWinActive, ahk_exe WindowsTerminal.exe
    ;   ::xl::!{Left}
    ;   ::lx::!{Right}
    ;   :*?:xx::+{Enter}
    ;   :*?:kx::+{Enter}
    ;   :*?:,y::^v
    #IfWinActive, ahk_class CabinetWClass
    ~!u:: Send, {AltDown}{left}{AltDown}
    ~!o:: Send, {AltDown}{right}{AltDown}
    ~!p:: Send, {AltDown}{up}{AltDown}
    #IfWinActive
#if
