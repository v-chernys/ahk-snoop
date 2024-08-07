# Fixing keyboard layout switching errors (snoop)
## Purpose
Sometimes programmers have to simultaneously use two keyboard layouts: English and Russian.
(_I prefer to write comments in Russian. Also, where it is possible, I try to write code in Russian_).
In the case it occures often that a large piece of the entered text has wrong layout.
The above script in the AutoHotKey language saves me a lot of time, because it allows me to quickly fix the layout of the selected text in any text editor.
To convert the text from wrong layout just select the text and press the Break key.
There are also additional options for transcoding the selected text (case change, etc.). Here is the complete list of transformations:

| keyboard shortcut |action |
| ----- | ----- |
| Break | replace all English characters with Cyrillic characters and vice versa; set correct layout |
| Ctrl-Shift-PageUp | change the case of each character to the opposite |
| Win-PageUp | change all characters to uppercase; set CapsLock on |
| Win-PageDown | change all characters to lowercase; set CapsLock off |
| Alt-Shift-\\ | in the text, replace all right slashes (/) with left slashes (\\) |
| Alt-Shift-] | remove all square brackets (\[ and \]) in the text |

## How does it work
Once you find that the entered text is in the wrong encoding, you need to (1) highlight the "wrong" text and (2) press the Break button.
The script will (1) recode all characters and insert them instead of the selected "wrong" text and 
(2) determine the input layout (from the first character) and switch it to an alternative one (if the first character of the selected text was English, then the Russian layout will be activated, and vice versa) .
The selection of proper character is done on the basis of two tables: the first lists all the characters of the English layout in a natural order, the second - in the same order - all the characters of the Russian layout.
The lookup tables are very simple:
```AutoHotkey
static f := "QWERTYUIOP{}ASDFGHJKL:""|ZXCVBNM<>?qwertyuiop[]asdfghjkl;'\zxcvbnm,./``~!@#$`%^&"
static g := "ЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭ/ЯЧСМИТЬБЮ,йцукенгшщзхъфывапролджэ\ячсмитьбю.ёЁ!""№;`%:?"
fg = %f%%g%
gf = %g%%f%
```
1. line `f` contains all the characters of the English keyboard in the order they appear on a simple sequential press, if you start from the upper left corner of the QWERTY and move along the lines towards the lower right corner;
first all uppercase characters are listed, then all lowercase characters;
2. line `g` lists the symbols of the Russian layout in the same order.
3. let us concatenate the first array to the second one (`fg=f+g`) and the second one to the first one (`gf=g+f`), then there will always be antagonist characters in the same places;
therefore for recoding we look for the place of the replaced character in the first array `fg` and, using the obtained index, we get the replacement character from the second array `gf`.

## Story
I have got a peek at the original idea in the "Опечатка by Dr. Golomin" utility. I used this utility for about 18 years (2001-2018), for which I am very grateful to the author, Evgeny Golomin.
His utility was called SNOOP, so I kept the name.

## System requirements and installation
The script requires Windows 7 or 10 and the installed AutoHotkey v1.1 package (I have v1.1.30.03, visit https://autohotkey.com/ to install AHK).
To run using the AutoHotkey environment, place the script in any convenient directory (for example, `C:\UTIL\AHK`) and run it with the command:
```CMD
start "snoop" "C:\UTIL\AHK\snoop.ahk"
```
Аlso I have made an executable EXE file for those who just want to use a working utility and don't want to install AutoHotkey on their system.
EXE file works on both 32-bit and 64-bit Windows systems. It can be launched, for example, with the following command (from a batch BAT file):
```CMD
start "snoop" "C:\UTIL\AHK\snoop.exe"
```
To run at system startup, you need to place a link to the executable BAT or EXE file in the folder `"%userprofile%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup"`.
I have placed a link there to a special batch file `autoexec.BAT`, which contains the above line.

## Encoding restrictions
In the repository the AHK file is laid out in utf-8 encoding.
In the script, all symbols of the national (Russian) layout are listed explicitly, so for the script to be compiled correctly it must be converted to ANSI encoding.
(The github repository requires text files to be converted to utf-8, otherwise they will not display correctly in the Internet browser).
I have cp-1251 encoding as ANSI on my Windows system.
### Option 1. Use iconv utility
For proper download/conversion, you can use the iconv utility (https://mlocati.github.io/articles/gettext-iconv-windows.html).
I have a filter configured for the repository in the `.git\config` file:

```
[filter "wincp1251"]
        clean = iconv -f windows-1251 -t utf-8
        smudge = iconv -f utf-8 -t windows-1251
        required
```
and the usage of the filter in the `.gitattributes` file: 
```
*.ahk filter=wincp1251
```
### Option 2. Use reserved ZIP archive with correct encoding
There is an archive `ahk-snoop.zip` inside the repository, it contains the source script `snoop.ahk` in Windows-1251 encoding.

## Customization options
### Other languages
I suspect that the script with minimal modifications can be used not only for Russian, but also for any other additional language (Ukrainian, French, German, etc.).
For this you need:
1. Before compiling, be sure to convert the script to proper Windows encoding (cp-1251, cp-1252, etc.);
2. fix the corresponding line `g` in the script so that it displays the characters of the national alphabet in correct order
 (_as far as I understand, for Ukrainian and Belarusian Windows uses the same cp-1251, but with a different arrangement of characters on the keyboard)_;
3. replace the parameters in the layout change code with the ones corresponding to the required alphabet (see code lines with `SendMessage, 0x50`).
### Other keyboard shortcuts
Of course, this is easy to do. Look for the right keycodes for AHK. I selected the codes for my convenience.
### Other actions
Using the method described you can make any tabular recoding you need (see examples with case substitution in the code),
as well as some exotic operation of substitution or omission of characters (I often need to replace direct slashes with backslashes in file paths, as well as "cleaning" SQL text from square brackets).

## Author
Vladislav Chernyshev

## License
This project is licensed under the MIT License - see the LICENSE file for details

## Acknowledgments
I am very greatful to Evgeny Golomin for his "Опечатка by Dr. Golomin" utility. His utility was one of the best and lightweight decisions (to fix keyboard layout switching errors) all around 2000-ths and 2010-ths. 
In my script I have used the same approach (highlihting and encoding inside clipboard using static adjustable tables).
