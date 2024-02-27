(call
  item: (ident) @function)
(call
  item: (field field: (ident) @function.method))
(tagged field: (ident) @parameter)
(field field: (ident) @parameter)
(comment) @comment

; CONTROL
(let "let" @keyword.storage.type)
(branch ["if" "else"] @keyword.control.conditional)
(while "while" @keyword.control.repeat)
(for ["for" "in"] @keyword.control.repeat)
(import "import" @keyword.control.import)
(as "as" @keyword.operator)
(include "include" @keyword.control.import)
(show "show" @keyword.control)
(set "set" @keyword.control)
(return "return" @keyword.control)
(flow ["break" "continue"] @keyword.control)

; OPERATOR
(in ["in" "not"] @keyword.operator)
(and "and" @keyword.operator)
(or "or" @keyword.operator)
(not "not" @keyword.operator)
(sign ["+" "-"] @operator)
(add "+" @operator)
(sub "-" @operator)
(mul "*" @operator)
(div "/" @operator)
(cmp ["==" "<=" ">=" "!=" "<" ">"] @operator)
(fraction "/" @operator)
(fac "!" @operator)
(attach ["^" "_"] @operator)
(wildcard) @operator

; VALUE
(raw_blck "```" @text.literal.block) @text.literal
(raw_span "`" @text.literal.block) @text.literal
(raw_blck lang: (ident) @label)
(label) @label
(ref) @text.reference
; (number) @constant.numeric
(string) @string
(content ["[" "]"] @operator)
(bool) @constant.builtin.boolean
(none) @constant.builtin
(auto) @constant.builtin
; (ident) @label
(call
  item: (builtin) @function)
; (builtin) @constant.builtin

; MARKUP
(item "-" @punctuation.list)
(term ["/" ":"] @punctuation.list)
(heading ["="] @text.title.1.marker) @text.title.1
(heading ["=="] @text.title.2.marker) @text.title.2
(heading ["==="] @text.title.3.marker) @text.title.3
(heading ["===="] @text.title.4.marker) @text.title.4
(heading ["====="] @text.title.5.marker) @text.title.5
(url) @tag
(emph) @text.emphasis
(strong) @text.strong
; (symbol) @constant.character
(shorthand) @constant.builtin
(quote) @markup.quote
(align) @operator
(letter) @constant.character
(linebreak) @constant.builtin

(math (formula)) @text.math
"#" @operator
"end" @operator

(escape) @constant.character.escape
["(" ")" "{" "}"] @punctuation.bracket
["," ";" ".." ":" "sep"] @punctuation.delimiter
"assign" @punctuation
(field "." @punctuation)
