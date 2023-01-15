; This scripts main function is SwitchToWindow(). All other functions below are
; only wrappers of this function.

; GLOBAL VARS AND AUTOEXECUTE
;{-----------------------------------------------
;
; #WinActivateForce
;-----------------------------------------------

; SUBROUTINES
;{-----------------------------------------------
;

;-----------------------------------------------
; Command that maximizes certain window with exe given by WinExistCommand if window exists, but is minimized. If window not
; exists it runs the RunCommand. Both commands have to be given seperate as it is not easily possible to guess the RunCommand from the given ahk_exe or ahk_class.
SwitchToWindow(WinExistCommand, RunCommand, NeedsAdmin:=False)
{
    windowHandleId := WinExist(WinExistCommand)
    windowExistsAlready := windowHandleId > 0

    ; If the Windows Terminal is already open, determine if we should put it in focus or minimize it.
    if (windowExistsAlready = true)
    {
        activeWindowHandleId := WinExist("A")
        windowIsAlreadyActive := activeWindowHandleId == windowHandleId

        if (windowIsAlreadyActive)
        {
            ; Minimize/close the window.
            WinMinimize, "ahk_id %windowHandleId%"
        }
        else
        {
            ; Put the window in focus.
            WinShow, "ahk_id %windowHandleId%"
            WinActivate, "ahk_id %windowHandleId%"
        }
    }
    ; Else it's not already open, so launch it.
    else
    {
        if !NeedsAdmin
            Run, %RunCommand%
        else{
            Run *RunAs %RunCommand%
        }
    }
}

;-----------------------------------------------

; BELOW ARE WRAPPERS OF SwitchToWindow()

;-----------------------------------------------



; EnvGet, vHomeDrive, HOMEDRIVE
; EnvGet, vHomePath, HOMEPATH
EnvGet, HomeDir, USERPROFILE

; HomeDir := vUserProfile

AppsPath := HomeDir . "\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\"

ScoopPath := AppsPath . "Scoop Apps\"

;-----------------------------------------------
SwitchToWindowsTerminal()
{
    SwitchToWindow("ahk_exe WindowsTerminal.exe", "wt")
}

;-----------------------------------------------
SwitchToApp(AppName, Applnk:=False, Scoop:=False)
{
    global User, AppsPath, ScoopPath
    AppDir = %AppsPath%
    if not Applnk
    {
        Applnk = %AppName%
    }
    if Scoop
    {
        AppDir = %ScoopPath%
    }
    else
    {
        if Applnk not contains \,/
        {
            StringUpper, ApplnkCapitalized, Applnk, T
            Applnk .= "\" . ApplnkCapitalized
        }
    }
    SwitchToWindow("ahk_exe " .  AppName . ".exe", AppDir . Applnk . ".lnk")
}

;-----------------------------------------------
SwitchToScoopApp(AppName, Applnk:=False)
{
    SwitchToApp(AppName, Applnk, True)
}



;-----------------------------------------------
;-----------------------------------------------
;-----------------------------------------------
;-----------------------------------------------
;-----------------------------------------------


;-----------------------------------------------
SwitchToEditor(editor:="code")
{
    SwitchToWindow("ahk_exe" . editor . ".exe", editor)
}

;-----------------------------------------------
SwitchToExplorer()
{
    SwitchToWindow("ahk_class CabinetWClass", "explorer")
}


;-----------------------------------------------
SwitchToReferenceManager(manager:="Zotero")
{
    SwitchToScoopApp(manager)
}

;-----------------------------------------------
SwitchToMessenger()
{
    SwitchToApp("teams", "Microsoft Teams")
}

;-----------------------------------------------
SwitchToBrowser(browser:="firefox")
{
    if browser not contains .exe
    {
        browser .= ".exe"
    }
    SwitchToWindow("ahk_exe" . browser, browser)
}

;-----------------------------------------------
SwitchToPasswordManager(manager:="KeePass")
{
    SwitchToScoopApp(manager)
}
