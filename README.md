# Dim Echo Box - A log Debugging Tool for AutoHotkey v2

## Overview

Dim Echo Box is a debugging utility for AutoHotkey v2 scripts that provides a dynamic, console-like window to monitor variable changes. With its dark-themed interface, Dim Echo Box helps developers to easily identify variable values by displaying formatted data outputs and automatic value tracking.

---

## Features

- **Supports Various Data Types** - Strings, numbers, arrays, maps, and objects are handled with clear categorization and display.
- **Real-Time Logs** - Automatically logs variable changes without manual intervention with `LEcho()` (Lasting Echo) function.
- **Output Filter** - Flexible logging styles for easier readability.
- **Export data** - Press "Export" and everything on the Echo Box will be exported into a "log_date.txt" file.
- **Examples of real usage included!** - Check Ready to run demos to see it in action (and see examples, the logs are included as well) :)
- **Simple and Lightweight** - Minimal impact on script performance, with an intuitive interface.

---

## How It Works - A Few Examples (Check Ready to Run Files For More!)

### Basic Echo

```ahk
myString := "Hello"
Echo(myString) ; Prints: "Hello"
Echo(["Item1", "Item2", 42, ["Nested1", "Nested2"]]) ; Prints the Nested Array
```

### Tracking Changes Automatically

```ahk
myVar := "Initial Value"
LEcho("myVar", myVar)
myVar := "Updated Value" ; This change will be detected and echoed
```

### Monitoring Complex Structures

```ahk
myMap := Map("key", "value")
LEcho("myMap", myMap)
myMap["newKey"] := "newValue" ; This change will be detected and echoed
```

---

## Installation

1. Install [AutoHotkey v2](https://www.autohotkey.com/download/).
2. Download "Dim_Echo_Box.ahk" file. Optional: also get the ready to run examples to check them out.
3. Include the script in your AHK project using #Include:
   ```ahk
   #Include Dim_Echo_Box.ahk
   ```
4. Call `Echo(your_var)` or `LEcho("your_var", your_var)`.

---

## Demo of Dim Echo Box & Examples

### Ready to Run Demo .gif

![](https://github.com/CrisDxyz/Dim_Echo_Box/blob/main/img/DimEchoBox_ReadtToRunDemo.gif)

### Highlight of ".py" files on dynamic GUI for Python scripts

![](https://github.com/CrisDxyz/Dim_Echo_Box/blob/main/img/dim_Echo_box%20dynamic%20python%20GUI%20example.png)

### Filter of "Integer" Variables on Ready to Run Demo

![](https://github.com/CrisDxyz/Dim_Echo_Box/blob/main/img/Dim%20Echo%20box%20integer%20filter%20(work%20in%20progress).png)

### Listed examples of use on "How It Works"

![](https://github.com/CrisDxyz/Dim_Echo_Box/blob/main/img/Showcase_Echo_md_Examples.png)

---

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

