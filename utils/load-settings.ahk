EnvGet, HomeDir, USERPROFILE

ConfigDir := HomeDir . "\.config\better-coding\"
ConfigFilename := "init.txt"
ConfigPath := ConfigDir . ConfigFilename

DefaultConfig := "SpaceLayer 1`nCapsLayer 1`nAltLayer 1`nBrowser firefox`nReferenceManager Zotero`nPasswordManager KeePass`nEditor code`nMessenger teams`nSearchEngine google`nQuickCommandTime 15`nEnableCapslock 0"

If !FileExist(ConfigDir)
    FileCreateDir, %ConfigDir%
If !FileExist(ConfigPath)
    FileAppend,%DefaultConfig%,%ConfigPath%

GetValue(Field)
; Returns the value of a config field
{
    Return StrSplit(Field, A_Space, A_Space)[2]
}

GetKey(Field)
; Returns the key of a config field
{
    Return StrSplit(Field, A_Space, A_Space)[1]
}

GetItem(Field)
; Returns key and value of a config field as an array
{
    Return StrSplit(Field, A_Space, A_Space)
}

GetConfigArray(Path)
; Returns the configuration as an array
{
    Array := []
    Loop, Read, %Path%
    {
        Array.Push(A_LoopReadLine)
    }
    Return Array
}

GetConfigDictionary(Path)
; Returns the configuration as a dictionary
{
    result := []
    ConfigArray := GetConfigArray(Path)
    for index, element in ConfigArray
    {
        Key := GetKey(element)
        Value := GetValue(element)
        result[Key] := Value
    }
    Return result
}

LoadConfig()
; Sets the global vars using the config
{
    global Browser, SearchEngine, ReferenceManager, PasswordManager, Editor, Messenger, SpaceLayer, AltLayer, CapsLayer, ConfigPath, EnableCapslock, QuickCommandTime
    Config := GetConfigDictionary(ConfigPath)
    Browser:= Config["Browser"]
    SearchEngine:= Config["SearchEngine"]
    ReferenceManager:= GetPath(Config["ReferenceManager"])
    PasswordManager:= GetPath(Config["PasswordManager"])
    Editor:= Config["Editor"]
    Messenger:= GetPath(Config["Messenger"])
    SpaceLayer:= Config["SpaceLayer"]
    AltLayer:= Config["AltLayer"]
    CapsLayer:= Config["CapsLayer"]
    EnableCapslock:=Config["EnableCapslock"]
    QuickCommandTime:=Config["QuickCommandTime"]
}
