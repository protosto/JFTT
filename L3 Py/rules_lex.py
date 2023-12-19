# module: rules_lex.py

P = 1234577
P_1 = 1234576

tokens = (
    'NUM',
    'ADD',
    'SUB',
    'MUL',
    'DIV',
    'POW',
    'NEWLINE',
    'LBRC',
    'RBRC',
    'COMMENT',
    'GLUE',
    'ERR',
)


def t_NUM(t):  # t - instance of LexToken (tok.type, tok.value, tok.lineno, tok.lexpos)
    r'\d+'  # \d is equivalent to [0-9]
    t.value = int(t.value)
    # token should be returned or it will be discarded
    return t

def t_COMMENT(t):
  r'^\#.*\n'
  pass
  # token discarded

t_ADD = r'\+'
t_SUB = r'[-]'
t_MUL = r'\*'
t_DIV = r'[/]'
t_POW = r'\^'
t_NEWLINE = r'\n'
t_LBRC = r'\('
t_RBRC = r'\)'
t_ERR = r'.'

t_ignore = ' \t'
t_ignore_GLUE = r'\\\n'


def t_error(t):
    print("err")
    pass
