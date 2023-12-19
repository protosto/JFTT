# module: rules_yacc.py
from rules_lex import tokens, P, P_1

rpn = ""
div_0 = False
non_inv = False
precedence = (
    ('left', 'ADD', 'SUB'),
    ('left', 'MUL', 'DIV'),
    ('right', 'NEG'),
    ('nonassoc', 'POW')
)
tokens = tokens[:-3]

def p_line_expr(p):
    'line : expr NEWLINE'
    global rpn, div_0, non_inv
    print("RPN:", rpn)
    print(f"Wynik: {p[1]}")
    rpn = ""
    div_0 = False
    non_inv = False

def p_line_error(p):
    'line : error NEWLINE'
    global rpn, div_0, non_inv
    if div_0:
        print("Błąd: dzielenie przez 0")
    else:
      if not non_inv:
        print("Błąd: zła składnia")
    rpn = ""
    div_0 = False
    non_inv = False

def p_expr_number(p):
    'expr : number'
    global rpn
    rpn += f"{(p[1] % P)} "
    p[0] = (p[1] % P)

def p_expr_paren(p):
    'expr : LBRC expr RBRC'
    p[0] = (p[2] % P)

def p_expr_neg(p):
    'expr : SUB LBRC expr RBRC %prec NEG'
    global rpn
    rpn += "! "
    p[0] = P - (p[3] % P)

def p_expr_add(p):
    'expr : expr ADD expr'
    global rpn
    rpn += "+ "
    p[0] = (p[1] + p[3]) % P

def p_expr_sub(p):
    'expr : expr SUB expr'
    global rpn
    rpn += "- "
    p[0] = (p[1] - p[3] + P) % P

def p_expr_mul(p):
    'expr : expr MUL expr'
    global rpn
    rpn += "* "
    p[0] = (p[1] * p[3]) % P

def p_expr_pow(p):
    'expr : expr POW exponent'
    global rpn
    rpn += f"^ "
    p[0] = pow(p[1], p[3] % P, P)

def p_expr_div(p):
    'expr : expr DIV expr'
    global rpn
    rpn += "/ "
    if p[3] == 0:
        global div_0
        div_0 = True
        raise SyntaxError
    try:
      p[0] = (p[1] * pow(p[3], -1, P)) % P
    except ValueError:
      global non_inv
      non_inv = True
      p[0] = 1
      print(f"Błąd: {p[3]} nie jest odwracalne modulo {P}")
      raise SyntaxError

def p_number_pos(p):
    'number : NUM'
    p[0] = (p[1] % P)

def p_number_neg(p):
    'number : SUB number %prec NEG'
    p[0] = P - (p[2] % P)

def p_error(p):
    pass



#---------------------------

def p_expr_number_exp(p):
    'exponent : number_exp'
    global rpn
    rpn += f"{(p[1] % P_1)} "
    p[0] = (p[1] % P_1)

def p_expr_paren_exp(p):
    'exponent : LBRC exponent RBRC'
    p[0] = (p[2] % P_1)

def p_expr_neg_exp(p):
    'exponent : SUB LBRC exponent RBRC %prec NEG'
    global rpn
    rpn += "! "
    p[0] = P_1 - (p[3] % P_1)

def p_expr_add_exp(p):
    'exponent : exponent ADD exponent'
    global rpn
    rpn += "+ "
    p[0] = (p[1] + p[3]) % P_1

def p_expr_sub_exp(p):
    'exponent : exponent SUB exponent'
    global rpn
    rpn += "- "
    p[0] = (p[1] - p[3] + P_1) % P_1

def p_expr_mul_exp(p):
    'exponent : exponent MUL exponent'
    global rpn
    rpn += "* "
    p[0] = (p[1] * p[3]) % P_1

def p_expr_div_exp(p):
    'exponent : exponent DIV exponent'
    global rpn
    rpn += "/ "
    if p[3] == 0:
        global div_0
        div_0 = True
        raise SyntaxError
    try:
      p[0] = (p[1] * pow(p[3], -1, P_1)) % P_1
    except ValueError:
      global non_inv
      non_inv = True
      p[0] = 1
      print(f"Błąd: {p[3]} nie jest odwracalne modulo {P_1}")
      raise SyntaxError

def p_number_pos_exp(p):
    'number_exp : NUM'
    p[0] = (p[1] % P_1)

def p_number_neg_exp(p):
    'number_exp : SUB number_exp %prec NEG'
    p[0] = P_1 - (p[2] % P_1)