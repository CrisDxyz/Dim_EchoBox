#Requires AutoHotkey v2.0
;#SingleInstance Force ; This should be written on main script if needed, probably.
Persistent(False)
;#Warn All

/*
===============================================================
Dim Echo Box - Because log debugging with prints is cool, i guess
===============================================================
Version: 0.9.0
Created by: CrisDxyz
Date: Today
License: MIT License

===============================================================
Description & Usage:
This script generates a black edit box that logs any Variable on the 
script when you call the function Echo(var) or LEcho("var name", var);
Echo is basically an improved version of MsgBox, while LEcho (Lasting Echo)
logs that variable permanently as long as the script runs, keeping track
of any value change of that variable along the way. 

Just "#include" this script into yours, and call Echo or LEcho when needed.
Check https://www.autohotkey.com/docs/v2/lib/_Include.htm#ExFile 

===============================================================
Credits and Acknowledgments:
- Concept and Development: CrisDxyz (Me)
- Credits of black windows frame to u/plankoe

===============================================================
Disclaimer:
This tool is provided "as is," without warranty of any kind. 

===============================================================
*/

; Initialize the Echo window GUI
global EchoBox := EchoInit()
global LastTimestamp := ""
global OriginalContent := ""  ; Store original content for search filtering
global SearchContext := Map()  ; Store context for filtered items
global enclose := 0

; Function to initialize the Echo GUI
EchoInit() {
	
    echoGUI := Gui("+Resize", "Dim Echo Box")

    echoGUI.MarginX := 10
    echoGUI.MarginY := 10
	
	; return:
    echoBox := echoGUI.Add("Edit", "Background404040 R20 W800 ReadOnly +VScroll +HScroll")
	
    echoGUI.BackColor := "101010"
    echoGUI.SetFont("s10", "Consolas")
    echoBox.SetFont("s10 cWhite", "Consolas")
    
    ; Add Clear and Export buttons
    clearBtn := echoGUI.Add("Button", "x100 yp w65 h25", "Clear")
    exportBtn := echoGUI.Add("Button", "x-50 yp w65 h25", "Export")

    ; Add Search edit controls
    searchEdit := echoGUI.Add("Edit", "x+20 yp w150 h30", "")
    searchEdit.SetFont("s10", "Segoe UI")
    searchEdit.Opt("+Background202020 +cWhite")

    ; Add search checkboxes
    highlightCb := echoGUI.Add("Checkbox", "x+10 yp+5 cWhite", "Highlight")
    filterCb := echoGUI.Add("Checkbox", "x+10 yp cWhite", "Filter")
    autoSearchCb := echoGUI.Add("Checkbox", "x+10 yp cWhite Checked", "Auto")
    
    ; Add search button
    searchBtn := echoGUI.Add("Button", "x+10 yp-5 w80 h30", "Search")
	
	SetDarkWindowFrame(echoGUI)
    
    ; Events
    clearBtn.OnEvent("Click", ClearEcho)
    exportBtn.OnEvent("Click", ExportLog)
    searchBtn.OnEvent("Click", PerformSearch)
    searchEdit.OnEvent("LoseFocus", AutoSearch)
	searchEdit.OnEvent("Change", AutoSearch)
	highlightCb.OnEvent("Click", AutoSearch)
	filterCb.OnEvent("Click", AutoSearch)

    ; resize handling
    echoGUI.OnEvent("Size", GuiResize)

    ; Store the edit control in the GUI object as property for resize handling
    echoGUI.echoBox := echoBox
    echoGUI.clearBtn := clearBtn
    echoGUI.exportBtn := exportBtn
    echoGUI.searchEdit := searchEdit
    echoGUI.searchBtn := searchBtn
    echoGUI.highlightCb := highlightCb
    echoGUI.filterCb := filterCb
    echoGUI.autoSearchCb := autoSearchCb

	; ==== For debug purposes/known issue/limitation ====
	; Sometimes the GUI generates weird and needs redrawing if the elements are added "too fast" into it or something,
	; that's why there's a sleep and a fat arrow, adjust time as your machine needs
	;Sleep 150
    echoGUI.Show("w900 h450")
	SetTimer(() =>
		echoBox.Redraw()
		clearBtn.Redraw()
		exportBtn.Redraw()
		searchEdit.Redraw()
		highlightCb.Redraw()
		filterCb.Redraw()
		autoSearchCb.Redraw()
		searchBtn.Redraw()
	, -50) ; decrease if Redraw() is not working properly
    
	; What happens when you press the X on the script window, change as you like. Func is at the end.
	echoGUI.OnEvent("Close", CloseScript)
    
	return echoBox
}


; Dark mode window frame handler
SetDarkWindowFrame(hwnd, boolEnable := 1) {
    hwnd := WinExist(hwnd)
    if VerCompare(A_OSVersion, "10.0.17763") >= 0
        attr := 19
    if VerCompare(A_OSVersion, "10.0.18985") >= 0
        attr := 20
    DllCall("dwmapi\DwmSetWindowAttribute", "ptr", hwnd, "int", attr, "int*", boolEnable, "int", 4)
}


; Handle GUI resize events
GuiResize(GuiObj, MinMax, Width, Height) {
    if (MinMax = -1){  ; Window is minimized
        return
    }
	
    ; GUI paddings
    padding := 10
    buttonAreaHeight := 40

    panelY := Height - buttonAreaHeight - padding + 10
    
    ; Resize the edit control to match the window size with paddings
    GuiObj.echoBox.Move(, , Width - padding * 2, Height - buttonAreaHeight - padding * 2)

    ; Move the button panel and buttons
    GuiObj.clearBtn.Move(padding, panelY)
    GuiObj.exportBtn.Move(padding + 75, panelY)
    GuiObj.searchEdit.Move(padding + 250, panelY)
    GuiObj.highlightCb.Move(padding + 420, panelY + 5)
    GuiObj.filterCb.Move(padding + 520, panelY + 5)
    GuiObj.autoSearchCb.Move(padding + 620, panelY + 5)
    GuiObj.searchBtn.Move(padding + 700, panelY)

}


; Enhanced Echo function with comprehensive type support, timestamps, and variadic input
Echo(params*) {
    global LastTimestamp
    global enclose
	
    /*
    if !params.Length {
        return ; wip- change to something else later
    }
    */

    currentTime := FormatTime(, "HH:mm:ss.ms tt")
    showTimestamp := (currentTime != LastTimestamp)

    if (showTimestamp) {
        if (enclose){
            AppendToEcho("`n└────────────────────────────┘`n")
	    enclose := !enclose
        }
        AppendToEcho("┌─────" . currentTime . "─────┐")
	AppendToEcho("`n")
        LastTimestamp := currentTime
        enclose := !enclose
    } else {
        AppendToEcho(RepeatStr(" ", 0))  ; Padding, 14 to allign on timestamp but breaks identation on arrays, wip
    }

    ; Process each parameter
    for index, param in params { 
        EchoValue(param)
        AppendToEcho("`n")
    }
}


; Internal function to process and echo variables
; @params: "message" The value to be echoed, "indentLevel" Optional parameter for recursive formatting (default: 0)
EchoValue(message, indentLevel := 0) {
    indent := RepeatStr("  ", indentLevel)
    
    try {
        if !IsSet(message) {
            AppendToEcho(indent . "Undefined Variable")
            return
        }
        
        if (message == "") {
            AppendToEcho(indent . "Null Variable")
            return
        }

        ; Get object address if applicable
        address := ""
        if IsObject(message) {
            try {
                address := Format("0x{:X}", ObjPtrAddRef(message))
                ObjRelease(ObjPtr(message))
            }
        }
        
        if message is String {
            AppendToEcho(indent . "String: " . message)
        }
        else if IsFloat(message) {
            AppendToEcho(indent . "Float: " . message)
        }
        else if IsInteger(message) {
            AppendToEcho(indent . "Integer: " . message)
        }
        else if message is Map {
            AppendToEcho(indent . "Map: {" . (address ? " [Address: " . address . "]" : "") . "`n")
            for key, value in message {
                if IsObject(value) {
                    AppendToEcho(indent . "  [" . key . "] => `n")
                    EchoValue(value, indentLevel + 2)
                    AppendToEcho("`n")
                }
                else {
                    AppendToEcho(indent . "  [" . key . "] => ")
                    EchoValue(value, 0)
                    AppendToEcho("`n")
                }
            }
            AppendToEcho(indent . "}")
        }
        else if message is Array {
            AppendToEcho(indent . "Array: [" . (address ? " [Address: " . address . "]" : "") . "`n")
            for index, value in message {
                if IsObject(value) {
                    AppendToEcho(indent . "  [" . index . "] ")
                    EchoValue(value, indentLevel + 1)
                    AppendToEcho("`n")
                }
                else {
                    AppendToEcho(indent . "  [" . index . "] ")
                    EchoValue(value, 0)
                    AppendToEcho("`n")
                }
            }
            AppendToEcho(indent . "]")
        }
        else if IsObject(message) {
            AppendToEcho(indent . "Object: {" . (address ? " [Address: " . address . "]" : "") . "`n")
            for prop in message.OwnProps() {
                if IsObject(message.%prop%) {
                    AppendToEcho(indent . "  ." . prop . " => `n")
                    EchoValue(message.%prop%, indentLevel + 2)
                    AppendToEcho("`n")
                }
                else {
                    AppendToEcho(indent . "  ." . prop . " => ")
                    EchoValue(message.%prop%, 0)
                    AppendToEcho("`n")
                }
            }
            AppendToEcho(indent . "}")
        }
        else {
            AppendToEcho(indent . "Unknown/Unsupported Type: " . Type(message))
        }
    }
    catch Error as err {
        AppendToEcho(indent . "Error: Something went very wrong: " . err.Message)
        return
    }
}


; Helper function to append text to the Echo box
AppendToEcho(text) {
    global EchoBox
    EchoBox.Value .= text
    ;EchoBox.Value := EchoBox.Value  ; Trigger refresh and auto-scroll
}


; Helper function to repeat a string n times
; @param "str" The string to repeat, "count" Number of times to repeat, @returns The repeated string
RepeatStr(str, count) {
    result := ""
    loop count {
        result .= str
    }
    return result
}


; Clear the Echo box content
ClearEcho(*) {
    global EchoBox, OriginalContent
    EchoBox.Value := ""
    OriginalContent := ""
    SearchContext := Map()
    EchoBox.Gui.searchEdit.Value := ""
}

; Export current (in case filters are on) logs to "date.txt" file
ExportLog(ctrl, info) {
    global EchoBox
    
    try {
        ; Get the current timestamp for the filename
        timestamp := FormatTime(, "yyyy-MM-dd_HH.mm.ss")
        filename := "echo_log_" . timestamp . ".txt"
        
        ; Try to write the file - overwrite prompt will likely never happen unless you change the name of the file above.
        if FileExist(filename) {
            result := MsgBox("File already exists. Overwrite?",, "YesNo")
            if result = "No"
                return
        }
        
        ; Write the content
        FileAppend EchoBox.Value . "`n", filename
        
        MsgBox("Log successfully exported to: " . filename,, "0x40")  ; 0x40 = Info icon
    }
    catch Error as err {
        MsgBox("Error exporting log: " . err.Message,, "0x10")  ; 0x10 = Error icon
    }
}


; Find the context (parent structure) of a line in the original content
; @params: "lines" Array of content lines, "targetIndex" Index of the target line
; @returns: "context" Array of context (parent) lines
FindContext(lines, targetIndex) {
    context := [lines[targetIndex]]
    
    ; Look backward for context
    currentIndex := targetIndex - 1
    indentLevel := GetIndentLevel(lines[targetIndex])
    
    while (currentIndex > 0) {
        currentLine := lines[currentIndex]
        currentIndent := GetIndentLevel(currentLine)
        
        ; If we find (regex) a line with less indentation, its a parent structure
        if (currentIndent < indentLevel && RegExMatch(currentLine, "\{|\[|\(")) {
            context.InsertAt(1, currentLine)
            indentLevel := currentIndent
        }
		
        currentIndex--
    }
    
    return context
}


; Get the indentation level of a line
; @param: "line" String to check
; @returns: Number of leading indent spaces
GetIndentLevel(line) {
    ; Count leading spaces
    spaces := 0
    loop Parse, line {
        if (A_LoopField = " "){
            spaces++
		}
        else if (A_LoopField = "`t"){
            spaces += 4  ; Count tab as 4 spaces
		}
        else{
            break
		}
    }
    return spaces
}


; Perform search with current/selected settings
PerformSearch(*) {
    global EchoBox, OriginalContent, SearchContext
    static lastSearch := ""
	
    ; Get parent GUI object
    guiObj := EchoBox.Gui
    
    ; Get search values
    searchText := guiObj.searchEdit.Value
    highlight := guiObj.highlightCb.Value
    filterOnly := guiObj.filterCb.Value

    ; Store original content 
    if (OriginalContent = ""){
        OriginalContent := EchoBox.Value
	}

    ; If search is empty, restore original content
    if (searchText = "" AND OriginalContent != "") {
        EchoBox.Value := OriginalContent
        return
    }
    
    ; Get content to search from it
    content := OriginalContent
    
    if (filterOnly) {
        ; Split content into lines and filter
        lines := StrSplit(content, "`n")
        filteredLines := []
        SearchContext := Map()  ; Reset context map
        
        ; First pass: find matching lines and their context
        loop lines.Length {
            if InStr(lines[A_Index], searchText) {
                context := FindContext(lines, A_Index)
                for contextLine in context {
                    ;if !HasValue(filteredLines, contextLine) ; This only includes the same filtered lines once, useless when lecho is implemented
                    filteredLines.Push(contextLine)
                }
            }
        }
        
        ; Update display with filtered content
        EchoBox.Value := Join(filteredLines, "`n")
		content := EchoBox.Value
    }
    if (highlight) {
        ; Split into lines to preserve formatting
        lines := StrSplit(content, "`n")
        highlightedLines := []
        
        ; Process each line
        for line in lines {
            ; Skip empty lines
            if (line = "") {
                highlightedLines.Push(line)
                continue
            }
            
            ; Find all occurrences of searchText in the line
            startPos := 1
            newLine := ""
            lastPos := 1
            
            while ((pos := InStr(line, searchText, false, startPos)) > 0) {
                ; Add text before match
                newLine .= SubStr(line, lastPos, pos - lastPos)
                ; Add highlighted match
                newLine .= ">>>" searchText "<<<"
                ; Update positions
                startPos := pos + StrLen(searchText)
                lastPos := startPos
            }
            
            ; Add remaining text after last match
            if (lastPos <= StrLen(line))
                newLine .= SubStr(line, lastPos)
                
            ; If no matches were found, use original line
            highlightedLines.Push(newLine ? newLine : line)
        }
        
        ; Join lines back together
        EchoBox.Value := Join(highlightedLines, "`n")
    }
    else {
        ; Restore original content
        EchoBox.Value := content
    }
    
    lastSearch := searchText
}


; Check if array contains a value
; @params: "arr" Array to check, "needle" Value to find
; @returns "true" if value exists in array
HasValue(arr, needle) {
    for value in arr {
        if (value = needle)
            return true
    }
    return false
}


; AutoSearch every 300 ms on GUI change event, check GUI events on lines 80-+
AutoSearch(ctrl, info) {
    static searchTimer := 0
    
    ; Check if auto-search is enabled
    if (ctrl.Gui.autoSearchCb.Value){
        ; Set new timer for 300ms delay
        searchTimer := SetTimer(PerformSearch, -300)
    }
    else{
		; Clear existing timer if any
		searchTimer := SetTimer(PerformSearch, 0)
    }
}


; Helper func to join array elements with a delimiter
; @param "arr" Array to join, "delimiter" Delimiter to use
; @return "result" Joined string
Join(arr, delimiter) {
    result := ""
    for index, value in arr {
        if (index > 1)
            result .= delimiter
        result .= value
    }
    return result
}

; ===== Lasting Echo =====

global trackedVars := Map()  ; to store variable references and their last known values
global trackedValues := Map()  ; to store serialized versions of complex types

; Lasting Echo Function to start monitoring a variable for changes
; @params: "varName" Variable name identifier, "varValue" Value inside variable to compare later
LEcho(varName, varValue) {
    global trackedVars, trackedValues
    trackedVars[varName] := varValue  ; Store reference
    trackedValues[varName] := SerializeValue(varValue)  ; Store initial serialized state
	AppendToEcho("Now monitoring: " . varName . " = ")
	Echo(varValue) ; Initial value
	AppendToEcho("`n")
    SetTimer(CheckTrackedVars, 1)  ; Check timer, 1ms, can't go lower as far as i know
}

; Function to serialize any value into a comparable string representation
SerializeValue(value, depth := 0) {
    if (depth > 32){ ; Prevent infinite recursion
        return "<<MaxDepthExceeded>>"
    }
    try {
        if !IsSet(value){
            return "<<Undefined>>"
        }
        if (value == ""){
            return "<<Empty>>"
		}
        if value is String{
            return "str:" . value
		}
        if IsFloat(value){
            return "float:" . value
        }
        if IsInteger(value){
            return "int:" . value
        }
        if value is Map {
            result := "map:{"
            for key, val in value
                result .= SerializeValue(key, depth + 1) . ":" . SerializeValue(val, depth + 1) . ","
            return RTrim(result, ",") . "}"
        }
        
        if value is Array {
            result := "array:["
            for val in value
                result .= SerializeValue(val, depth + 1) . ","
            return RTrim(result, ",") . "]"
        }
        
        if IsObject(value) {
            result := "obj:{"
            for prop in value.OwnProps()
                result .= prop . ":" . SerializeValue(value.%prop%, depth + 1) . ","
            return RTrim(result, ",") . "}"
        }
        
        return "Unknown:" . Type(value)
    }
    catch Error as err {
        return "<<Error:" . err.Message . ">>"
    }
}

; Function to compare current values with stored original ones
CheckTrackedVars() {
    global trackedVars, trackedValues
    
    try {
        for varName, varRef in trackedVars {
            currentValue := %varName%  ; %Expr% accesses the corresponding variable. For example, x := &y takes a reference to y and assigns it to x, then %x% := 1 assigns to the variable y and %x% reads its value.
            currentSerialized := SerializeValue(currentValue)
            
            if (currentSerialized != trackedValues[varName]) {
                trackedValues[varName] := currentSerialized  ; Update stored value
                AppendToEcho("Lasting Echo: " . varName . " changed to:`n")
                EchoValue(currentValue)
                AppendToEcho("`n")
				SendMessage(0x115, 7, 0, EchoBox)  ; WM_VSCROLL = 0x115, SB_BOTTOM = 7 Autoscroll after update
            }
        }
    }
    catch Error as err {
		AppendToEcho("`n`nWARNING - Script will be paused.`n`n")
        AppendToEcho("Error in CheckTrackedVars: " . err.Message . "`n`n")
		AppendToEcho("Full indexed list of current tracked variables: `n")
		Echo(trackedVars)
		AppendToEcho("Full indexed list of current tracked values: `n")
		Echo(trackedValues)
		AppendToEcho("`n`n")
		AppendToEcho("`n`nPS: Check examples in ready to run files, just in case.`n`n`n")
		Pause
    }
}


CloseScript(*) {
    ExitApp()
}

; Hot reload functionality (Ctrl+r), should be written on main script if needed.
;^r::Reload