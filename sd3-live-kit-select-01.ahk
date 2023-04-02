#Persistent ; Keeps the script running even when no hotkeys are active

; Get screen size
SysGet, MonitorWorkArea, MonitorWorkArea
x := MonitorWorkAreaLeft
y := MonitorWorkAreaTop + (MonitorWorkAreaBottom - MonitorWorkAreaTop) / 12

; Create the GUI window
Gui, +AlwaysOnTop -Caption +ToolWindow +LastFound +0x40000 ; Set the window to stay on top
Gui, Add, Button, x20 y20 w400 h30 gStopScript, Stop Live Session

; Scan directory for .sd3p files and add buttons for each file found
LiveDir := "C:\Users\tangu\Desktop\Live\" ; Change this to the path of your /LIVE directory
ButtonYPos := 130 ; Set initial y-position for buttons
ButtonCount := 0 ; Initialize button counter
ButtonHeight := 100 ; Set the height of each button
ButtonSpacing := 10 ; Set the vertical spacing between buttons
ButtonXPos := 20 ; Set initial x-position for buttons
ButtonColumnWidth := 420 ; Set the width of each column of buttons
Loop, Files, %LiveDir%\*.*sd3p, FR
{
    SplitPath, A_LoopFileName, name, ext, 1
    Gui, Add, Button, x%ButtonXPos% y%ButtonYPos% w400 h%ButtonHeight% gOpenFile, %name%
    FileButton%A_Index% := "Button" A_Index ; Store button name in a variable
    ButtonCount += 1 ; Increment button counter
    ButtonYPos += ButtonHeight + ButtonSpacing ; Increment y-position for next button
    if (ButtonYPos + ButtonHeight + ButtonSpacing > MonitorWorkAreaBottom && Mod(ButtonCount, 3) = 0) ; If the next button would go off-screen and the button counter is divisible by 3
    {
        ButtonXPos += ButtonColumnWidth ; Start a new column
        ButtonYPos = 130 ; Reset y-position for buttons
    }
}

Gui, Show, x%x% y%y%, Live Drums

Loop
{
    ; Look for a popup window that contains the text "Do you want to save changes"
    IfWinExist, Superior Drummer 3
    {
        Send, {Enter}
    }
    Sleep, 1000
}

StopScript:
ExitApp ; Stop the AutoHotkey script when the button is clicked


OpenFile:
FileCompleteName := SubStr(A_GuiControl, 1) ; Extract the button number from the button name
FilePath := LiveDir . FileCompleteName ; Construct file path based on button number
Run, %FilePath% ; Open the file
Return
