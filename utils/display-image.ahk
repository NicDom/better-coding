DisplayImage(image, options:="")
{
    Gui, Info:New, +HwndInfoGui -Caption -Border,
    Gui, Info:Add, Picture,%options%, %image%
    Gui, Info:Show
}

DisplayInfo(image, key, options:="")
{
    DisplayImage(image, options)
    KeyWait, %key%
    Gui, Info:Hide
    Return
}