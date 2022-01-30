# ahk-snoop
## Замена символов, введенных при другой раскладке клавиатуры.
Иногда программистам приходится активно использовать две раскладки клавиатуры: английскую и русскую. 
При этом часто большой кусок введенного текста оказывается не в той раскладке.
Приведенный скрипт на языке AutoHotKey позволяет быстро исправить раскладку выделенного текста в любом текстовом редакторе.
Для перекодировки достаточно выделить текст и нажать клавишу Break.
Также есть дополнительные опции перекодировки выделенного текста (смена регистра и пр.). Вот полный список преобразований:

| сочетание | действие |
| ----- | ----- |
| Break | заменить все аглийские символы на кириллические, и наоборот |
| Ctrl-Shift-PageUp | сменить регистр каждого символа на противоположный |
| Win-PageUp | все символы - в верхний регистр |
| Win-PageDown | все символы - в верхний регистр |
| Alt-Shift-\\ | в тексте заменить все правые слеши (/) на левые (\\) |
| Alt-Shift-] | в тексте убрать все квадратные скобки (\[ и \]) |