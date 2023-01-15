; GLOBAL VARS AND AUTOEXECUTE
;{-----------------------------------------------
;

;-----------------------------------------------
EnvGet, HomeDir, USERPROFILE
TheFileDir := HomeDir . "\.config\better-coding\"
If !FileExist(TheFileDir)
    FileCreateDir, %TheFileDir%
TheFilename := "quick-command-snippets.txt"
PathAndFilename := TheFileDir . TheFilename
If !FileExist(PathAndFilename)
    FileAppend, , %PathAndFilename%
Snippet_Entered = False
Snippets_Edited = 0
Edit_Window_Id = ""
QuickCommandWindowExists = 0
Prefix_Separator = ","
Body_Separator = ";;;"
RefreshSnippetsList()

#Include, utils\parse-engine.ahk

; SUBROUTINES
;{-----------------------------------------------
;

;-----------------------------------------------

CallQuickCommandWindow(){
    global QuickCommand, QuickCommandWindowExists
    if !QuickCommandWindowExists
    {
        Gui, Color, d0c060, 4444444
        Gui, Font, s14 cffff00 bold Tahoma
        Gui, Add, Edit, vQuickCommand
        Gui, Font, s8s cffff00 TAhoma
        Gui, Add, Button, default, OK ; Das ButtonOK-Label (falls vorhanden) wird ausgeführt, wenn die Schaltfläche gedrückt wird.
        Gui, Margin,5,-50
        Gui, Color, EEAA99
        Gui +LastFound ; Macht das GUI-Fenster zum zuletzt gefundenen Fenster für die Zeile darunter.
        WinSet, TransColor, EEAA99
        QuickCommandWindowExists = 1
    }
    GuiControl, , QuickCommand,
    Gui, Show,x-20 y990, QuickCommandWindow
    Gui, Show,, QuickCommandWindow
    WinSet, Style, -0xC00000, A,
    return ; Ende des automatischen Ausführungsbereichs. Das Skript ist solange im Leerlauf, bis der Benutzer irgendetwas macht.

    GuiClose:
    ButtonOK:
        Gui, Submit ; Speichert die Benutzereingaben in die entsprechenden Steuerelementvariablen.
    return
    GuiEscape:
        QuickCommand = 0
        Gui, Hide
    return
}

;-----------------------------------------------

RefreshSnippetsList(){
    global SnippetsList, Edit_Window_Id, Snippets_Edited
    ; <-- Stores the snippets in to Snippetslist
    If Snippets_Edited
    {
        if !WinExist("ahk_id %Edit_Window_Id%")
        {
            Snippets_Edited = 0
        }
    }
    Snippets = % StrReplace(OpensnippetFile(), "`r`n", A_Space)
    SnippetsList = % StrSplit(Snippets, [A_Tab,A_Space,"`n","`r","`r`n"], "`n")
}

;-----------------------------------------------

OpensnippetFile(){
    global PathAndFilename
    ; <-- Subroutine to load the snippets
    if !FileExist(PathAndFilename)
    {
        MsgBox, 52, Error when opening QuickCommand Snippets, There is no "quick-command-snippets.txt" file in the current working directory. Do you want to create one?
        IfMsgBox, Yes
        {
            FileAppend, , %PathAndFilename%
            MsgBox, 36, Snippet file created, A Snippet file has been created. Its full path is %PathAndFilename%. Do you want to open and edit the file?
            IfMsgBox, Yes
            Run, Edit "%PathAndFilename%"
        }
        IfMsgBox, No
        MsgBox, 52, Warning, Snippets can not be used in this session
    }
    else
    {
        FileRead, OutputVar, %PathAndFilename%
        return OutputVar
    }
}

;-----------------------------------------------

Add_New_Snippet(){
    global PathAndFilename
    ; <-- Adds a new snippet to the snippetlist given by the entries of two new input boxes
    InputBox, snippet, Enter Snippet, , , 200, 100
    If !ErrorLevel
    {
        InputBox, command, String stored under the given Snipped, , , 200, 100
        if !ErrorLevel
            FileAppend, `r`n%snippet% %command%, %PathAndFilename%
        Else
            MsgBox, , Message, No Entry was added.,
    }
    Else
        MsgBox, , Message, No Entry was added.
}

;-----------------------------------------------

Is_Snippet(Entry){
    global SnippetsList, Snippet_Entered
    Pos = % ObjIndexOf(SnippetsList, Entry)
    if Pos
    {
        Snippet_Entered = True
        return SnippetsList[Pos + 1]
    }
    else
        Snippet_Entered = False
    return Entry
}

;-----------------------------------------------

ObjIndexOf(obj, item, case_sensitive:=false)
{
    for i, val in obj {
        if (case_sensitive ? (val == item) : (val = item))
            return i
    }
}

;-----------------------------------------------

RunQuickCommand(browser="firefox", SearchEngine:="google", GoSearch:=False){
    global PathAndFilename, Snippets_Edited, Edit_Window_Id, QuickCommand, Snippet_Entered
    ; <-- Google Search Using Highlighted Text
    Save_Clipboard := ClipboardAll
    Clipboard := ""
    Send ^c
    ClipWait, 0.1
    if !ErrorLevel && GoSearch
    {
        Query := Clipboard
        Gosub Search
        return
    }
    else { ; no text selected - bring up popup
        ; InputBox, Query, Google Search, , , 200, 100
        CallQuickCommandWindow()
        WinWaitClose, QuickCommandWindow, ,15 , ,
        if ErrorLevel
        {
            GuiControl, , QuickCommand,
            Gui, Hide
            QuickCommand = 0
            return
        }
        Query=% QuickCommand
        If !Query ;ErrorLevel
            Search_Canceled = 1
        Else
            Search_Canceled = 0
    }
    if !Search_Canceled
        Gosub Search
    Clipboard := Save_Clipboard
    Save_Clipboard := ""
    return
    ; Subroutine for searching
    Search:
        if browser not contains .exe
        {
            browser .= ".exe"
        }
        SearchEngine := ParseEngine(SearchEngine)
        Query := StrReplace(Query, "`r`n", A_Space) ; prepare the string according to the selected or typed Query. Remarks: `r`n ist the character for a new line in windows
        Query := StrReplace(Query, A_Space, "`%20") ; replace space by %20 according to requirements of URL's
        Query := StrReplace(Query, "#", "`%23") ; # <-> %23
        ; Query := StrReplace(Query, "%", "")
        Query := Trim(Query) ; Trim removes Spaces at the end and the beginnig of 'Query'
        ; If Snippets_Edited
        ;     RefreshSnippetsList()
        RefreshSnippetsList()
        Query = % Is_Snippet(Query)
        ; if Snippet_Entered
        ; {
        ;     Run, %Query%
        ;     return
        ; }
        if GetKeyState("Shift")
        {
            Query = %Query%"&btnI=3564"
        }
        if Query in :Add:,:add:,:a:,:add,:Add,:a,a:
        {
            Add_New_Snippet()
            RefreshSnippetsList()
        }
        else if Query in :Edit:,:edit:,:e:,:edit,:Edit,:e,e:
        {
            Snippets_Edited = 1
            If !WinExist("ahk_class Notepad", "quick-command-snippets" )
            {
                Run, Edit %PathAndFilename%
                WinWait, "ahk_class Notepad", "quick-command-snippets",1
                Edit_Window_Id := WinExist("ahk_class Notepad", "quick-command-snippets" )
            }
            Else
            {
                WinActivate
            }
        }
        ;https://stackoverflow.com/search?q=
        else if Query contains +,..,@
            Run, %browser% %SearchEngine%%Query%
        else if Query not contains .de,.com,www.
            Run, %browser% %SearchEngine%%Query%
        else
            Run, %browser% %Query%
        WinShow, ahk_exe %browser%, , ,
        WinActivate, ahk_exe %browser%, , ,
    return
}