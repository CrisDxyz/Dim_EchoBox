; ===================================================================
;                  EchoBox Debug Tool Showcase In-Use
; ===================================================================
; Demonstrates the capabilities of the Echo(var) and LEcho("var", var) 
; functions for real-time monitoring and debugging of variables.
; Designed for more advanced real use case examples, with the intention
; of the "user" (you) reading the code below.
; ===================================================================

#Requires AutoHotkey v2.0
#SingleInstance Force

#Include Dim_Echo_Box.ahk

; Echo Init - Increase sleep if your machine is slow/something like 
; your "antivirus" is taking too many resources.

Sleep 100
AppendToEcho("--Demo Starting!`n`n")

AppendToEcho("--------------------------------------------------`n")

Echo("")

; --------------------------------------------------
; Function Output Monitoring
; --------------------------------------------------

Sum(a, b) {
    return a + b
}
result := Sum(5, 10)
LEcho("result", result)

result := Sum(20, 30)  ; EchoBox should capture the updated value

AppendToEcho("--------------------------------------------------`n")

; --------------------------------------------------
; Monitoring Environment Variables*
; --------------------------------------------------
; *echo box will get FILLED with the tick count, so uncomment yourself.
/*
LEcho("A_TickCount", A_TickCount) ; Track system uptime in milliseconds

Sleep 3000  ; Wait and observe changes

AppendToEcho("--------------------------------------------------`n")
*/

; --------------------------------------------------
; Monitoring Hotkey States
; --------------------------------------------------

AppendToEcho("`nMonitoring Hotkey States: Press F1 key to see the toggle state updating!`n")

toggle := False
LEcho("toggle", toggle)

F1:: {
    global toggle
    toggle := !toggle
}

AppendToEcho("--------------------------------------------------`n")
Sleep 5000

; --------------------------------------------------
; Simulating User Input Tracking
; --------------------------------------------------

AppendToEcho("`nSimulating User Input Tracking: Press a or b keys!`n")

typedKeys := ""
LEcho("typedKeys", typedKeys)

~a:: {
    global typedKeys
    typedKeys .= "a"
}
~b:: {
    global typedKeys
    typedKeys .= "b"
}

AppendToEcho("--------------------------------------------------`n")
Sleep 5000

; --------------------------------------------------
; File Modification Tracking
; --------------------------------------------------

filePath := A_ScriptDir "\testfile.txt"
FileAppend("Initial content", filePath)
test_file_read := FileRead(filePath)
LEcho("test_file_read", test_file_read)

Sleep 3000
AppendToEcho("Updating file:`n")
FileAppend("`nUpdated content`n", filePath)
test_file_read := FileRead(filePath)

AppendToEcho("--------------------------------------------------`n")
Sleep 200

; --------------------------------------------------
; Random Value Monitoring
; --------------------------------------------------

randomValue := Random(1, 100)
LEcho("randomValue", randomValue)

Sleep 2000
randomValue := Random(1, 100)  ; Should update in EchoBox

AppendToEcho("--------------------------------------------------`n")
Sleep 200

; --------------------------------------------------
; Timer-Based Value Updates
; --------------------------------------------------

SetTimer(UpdateCounter, 5000)

counter := 0
LEcho("counter", counter)

UpdateCounter() {
    global counter
    counter++
}

AppendToEcho("--------------------------------------------------`n")
Sleep 200

; --------------------------------------------------
; Debugging Conditional Values
; --------------------------------------------------

status := "Inactive"
LEcho("status", status)

if (A_TickCount > 5000){
    status := "Active"
    }

AppendToEcho("--------------------------------------------------`n")
Sleep 200
; End of Showcase