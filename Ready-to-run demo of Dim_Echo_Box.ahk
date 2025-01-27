; ===================================================================
;                     EchoBox Debug Tool Showcase
; ===================================================================
; Demonstrates the capabilities of the Echo(var) and LEcho("var", var) 
; functions for real-time monitoring and debugging of variables.
; Designed for clear and concise visualization of script behavior.
; ===================================================================

#Requires AutoHotkey v2.0
#SingleInstance Force

#Include Dim_Echo_Box.ahk

; Echo Init - Increase sleep if your machine is slow/something like 
; your "antivirus" is taking too many resources.

Sleep 100
AppendToEcho("--Demo Starting!`n`n")

; --------------------------------------------------
; Various Echo Examples
; --------------------------------------------------

Echo(1, 2, 3, 4, "Variadic Function Call")  ; Example with multiple parameters
Echo(1)
Echo(["Item1", "Item2", 42, ["Nested1", "Nested2"]]) ; Nested arrays

expression := "1"  ; 1 as a string
Echo(expression)

flavorText := "Simple string debugging"
Echo(flavorText)

AppendToEcho("--------------------------------------------------`n")

; --------------------------------------------------
; Basic Variable Tracking Example
; --------------------------------------------------

word := "hello"
LEcho("word", word)  ; Start tracking the variable
word := "hi"         ; Change detected, echoed automatically
Sleep 5
word := "hey"        ; Another change a bit later, echoed again

AppendToEcho("--------------------------------------------------`n")

; --------------------------------------------------
; Array Tracking Example
; --------------------------------------------------

arr := [1, 2, 3]
LEcho("arr", arr)  ; Start tracking the array
Sleep 10
arr.Push(4)        ; Will be echoed automatically when changed

AppendToEcho("--------------------------------------------------`n")

; --------------------------------------------------
; Map Tracking Example
; --------------------------------------------------

clrs := Map()
clrs["Red"] := "ff0000"
clrs["Green"] := "00ff00"
Echo(clrs)
LEcho("clrs", clrs)  ; Start monitoring the map
Sleep 10
clrs["Blue"] := "0000ff"  ; Change is detected and echoed

AppendToEcho("--------------------------------------------------`n")


; --------------------------------------------------
; Tracking Complex Objects
; --------------------------------------------------

ObjBox := { width: 57, length: 70, height: 12 }
nestedBox := { dimensions: ObjBox, color: "blue", tags: ["large", "heavy"] }

LEcho("ObjBox", ObjBox)
LEcho("nestedBox", nestedBox)

ObjBox.width := 60  ; Changes detected
nestedBox.color := "red"

Sleep 10

AppendToEcho("--------------------------------------------------`n")

; --------------------------------------------------
; Monitoring Variables Over Time
; --------------------------------------------------

myVar := "Hello"
LEcho("myVar", myVar)

Sleep 1000
myVar := "Hi"

Sleep 250
myVar := "Hola"

Sleep 500
myVar := "H"
Sleep 500
myVar := "o"
Sleep 500
myVar := "l"
Sleep 500
myVar := "a"
Sleep 100

AppendToEcho("--------------------------------------------------`n")

; --------------------------------------------------
; Complex Variable Monitoring
; --------------------------------------------------

testMap := Map("key1", "value1", "key2", [1, 2, 3])
testArray := [1, "two", Map("three", 3)]
testObj := { prop1: "value1", prop2: [4, 5, 6] }

LEcho("testMap", testMap)
LEcho("testArray", testArray)
LEcho("testObj", testObj)

testMap["key2"].Push(4)
testArray[2] := "2"
testObj.prop2.Push(7)

Sleep 5 ;style

AppendToEcho("--------------------------------------------------`n")

; --------------------------------------------------
; Performance Test (Tracking Incrementing Value)
; --------------------------------------------------

counter := 0

LEcho("counter", counter)

while (counter < 100) {
    Sleep 1 ;increase sleep if you can't see the 100 numbers
    counter += 1
}

Sleep 5 ;style

AppendToEcho("--------------------------------------------------`n")

; End of Showcase
AppendToEcho("`n`nDemo Ending!--")
