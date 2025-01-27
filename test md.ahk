#Requires AutoHotkey v2.0
#SingleInstance Force

#Include Dim_Echo_Box.ahk

Echo("Testing md examples")

myString := "Hello"
Echo(myString) ; Prints: "Hello"
Echo(["Item1", "Item2", 42, ["Nested1", "Nested2"]]) ; Prints the Nested Array

myVar := "Initial Value"
LEcho("myVar", myVar)
myVar := "Updated Value" ; This change will be detected and echoed

myMap := Map("key", "value")
LEcho("myMap", myMap)
myMap["newKey"] := "newValue" ; Automatically detected