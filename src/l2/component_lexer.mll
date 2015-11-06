{
open Core.Std
open Component_parser

exception SyntaxError of string
let syntax_error char = raise (SyntaxError ("Unexpected character: " ^ char))
}

let white = [' ' '\t' '\n' '\r']+
let input_var = ['i'] (['0' - '9']+ as input_num)
let output_var = 'r'
let free_var = ['x' 'y' 'z'] ['0' - '9']*
let func = ['A' - 'Z'] ['a' - 'z']*

rule token = parse
       | white                 { token lexbuf } (* Eat whitespace. *)
       | "#t"                  { BOOL true }
       | "#f"                  { BOOL false }
       | '('                   { LPAREN }
       | ')'                   { RPAREN }
       | '['                   { LBRACKET }
       | ']'                   { RBRACKET }
       | 'v'                   { OR }
       | '^'                   { AND }
       | '='                   { EQUALS }
       | "!="                  { NOT_EQUALS }
       | '>'                   { GREATER_THAN }
       | '<'                   { LESS_THAN }
       | ">="                  { GREATER_THAN_OR_EQUALS }
       | "<="                  { LESS_THAN_OR_EQUALS }
       | "⊂"                   { SUBSET }
       | "⊃"                   { SUPERSET }
       | "⊄"                   { NOT_SUBSET }
       | "⊅"                   { NOT_SUPERSET }
       | ','                   { COMMA }
       | "_|_"                 { BOTTOM }
       | '-'?['0'-'9']+ as num { NUM (int_of_string num) }
       | input_var             { INPUT_VAR (Int.of_string input_num) }
       | free_var as id        { FREE_VAR id }
       | output_var            { OUTPUT_VAR }
       | func as id            { FUNC id }
       | eof                   { EOF }
       | _                     { syntax_error (Lexing.lexeme lexbuf) }