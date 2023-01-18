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


; EnvGet, vHomeDrive, HOMEDRIVE
; EnvGet, vHomePath, HOMEPATH
EnvGet, HomeDir, USERPROFILE

; HomeDir := vUserProfile

AppsPath := HomeDir . "\AppData\Roaming\Microsoft\Windows\Start Menu\Programs"

SystemToolsPath := AppsPath . "\System Tools"

ScoopPath := AppsPath . "\Scoop Apps"

DefaultPathArray := [AppsPath, ScoopPath, SystemToolsPath]

GetDirectories(AppName)
; Returns an array of all directories that contain the given filename
; Used to avoid recursive search
{
    global DefaultPathArray
    result := DefaultPathArray
    for _, Path in DefaultPathArray
    {
        Loop, Files, % Path "\*", D
        {
            ; MsgBox, % InStr(A_LoopFilename, AppName)
            if InStr(A_LoopFilename, AppName)
            {
                entry := A_LoopFileFullPath
                ; MsgBox, %entry%
                result.Push(entry)
                ; return entry
            }
        }
    }
    Return result
}

;-----------------------------------------------
GetPath(AppName)
; Tries to find the given file, at several common directories
; Returns the path, if the file was found
{
    if FileExist(AppName)
    {
        Return AppName
    }
    Paths := GetDirectories(AppName)
    for _, Path in Paths
    {
        Loop, Files, % Path "\*", F
        {
            query := AppName . ".lnk"
            if A_LoopFileName = %query%
            ; if StrCompare(A_LoopFileName, query) == 0
            {
                Return A_LoopFileFullPath
            }
        }
        Loop, Files, % Path "\*", F
        {
            query := AppName . ".lnk"
            if InStr(A_LoopFileName, AppName)
            ; if StrCompare(A_LoopFileName, query) == 0
            {
                Return A_LoopFileFullPath
            }
        }
    }
    FailMessage := "No File containing '" . AppName . "' was found"
    MsgBox, %FailMessage%
}


;-----------------------------------------------
GetFilenameFromPath(Path)
; Returns the filename from a given path
{
    ; Check if file at path exists
    if !FileExist(Path)
    {
        Return Path
    }
    ; Get filename from path
    Parents := StrSplit(Path, ["\"])
    Filename := Parents[Parents.Length()]
    If InStr(Filename, ".lnk")
    {
        Filename := StrSplit(Filename, ["."])[1]
        Return Filename
    }

}


;-----------------------------------------------

; BELOW ARE WRAPPERS OF SwitchToWindow()

;-----------------------------------------------




;-----------------------------------------------
SwitchToWindowsTerminal()
{
    SwitchToWindow("ahk_exe windowsterminal.exe", "wt")
}




;-----------------------------------------------
SwitchToApp(AppName, Applnk:=False, Scoop:=False)
{
    AppName := GetFilenameFromPath(AppName)
    AppPath := GetPath(AppName)
    SwitchToWindow("ahk_exe " .  AppName . ".exe", AppPath)
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
    SwitchToApp(manager)
}

;-----------------------------------------------
SwitchToMessenger()
{
    SwitchToApp("Telegram")
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
    SwitchToApp(manager)
}