from ply import lex, yacc

import rules_lex
import rules_yacc

lexer = lex.lex(module=rules_lex)
parser = yacc.yacc(module=rules_yacc)
while True:
  text = ""
  while True:
    try:
      text += input()
    except (EOFError, KeyboardInterrupt):
      exit()
    text += '\n'
    if not text.endswith('\\\n'):
      break
  parser.parse(text, lexer=lexer)

