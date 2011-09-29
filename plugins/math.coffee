#This is my first pass at the math plugin. It lets you evaluate simple mathematical expressions with operator precedence, in a safe way
# (i.e. not using eval). It's essentially a very simple implementation of the shunting yard algorithm

class Lex
  constructor: (tks) ->
    # Place spaces between all tokens
    tokens_regex = ///
      [-]?[\d]+[.][\d]+| # floating point digits
      [-]?[\d]+ | # a series of digits
      [a-zA-Z]+ | # a series of alphas (in case I ever implement variables)
      [\]\[!"#$%&'()*+,./:;<=>?@\^_`{|}~-] # punctuation
      ///g

    tks = tks.replace(tokens_regex, (x) -> x + ' ')
    # Then split on spaces and remove empty nodes (e.g. if you have the string "  foo  bar", you'll get the array
    # ['','foo', 'bar']. The filter will remove the first element in array leaving you with the array ['foo', 'bar'], which is what you want.
    @tokens = tks.split(/[\s]+/).filter((x) -> return x)
    @i = 0

  next: () ->
    if @i >= @tokens.length
      throw "LexEnd"
    else
      tk = @tokens[@i]
      @i += 1
      return tk

  peek: () ->
    if @i >= @tokens.length
      return ""
    return @tokens[@i]

class Stack
  constructor: (init="") ->
    @list = []
    if init
      @list.push(init)

  push: (item) ->
    @list.push(item)

  pop: () ->
    @list.pop()

  peek: () ->
    @list[@list.length-1]

class Node
  constructor: (@op, lc, rc) ->
    @children = [lc,rc]

  toString: () ->
    s = ""
    for child in @children
      s += child + " "
    s = s.substr(0, s.length-1)
    return "(#{@children[0]} #{@op} #{@children[1]})"

  eval: () ->
    values = []
    for child in @children
      if child instanceof Node
        values.push(child.eval())
      else
        if not child?
          throw "Input Error!"
        values.push(parseFloat(child))
    if @op is '+'
      val = values.reduce(((p,c) -> return p+c), 0)
    else if @op is '-'
      val = values.reduce(((p,c) -> return p-c), 0)
    else if @op is '*'
      val = values.reduce(((p,c) -> return p*c), 0)
    else if @op is '/'
      val = values.reduce(((p,c) -> return p/c), 0)
    else if @op is '^'
      #Assuming there is only one power
      val = Math.pow(values[0], values[1])
    return val


# Setup the precedence table
precedence = {
  begin: 0,
  '(': 0,
  '+': 10,
  '-': 10,
  '*': 20,
  '/': 20,
  '^': 30
}

operator_stack = new Stack('begin')
operand_stack = new Stack()

parse = (tokens) ->
  try
    tk = tokens.next()
    while true
      # digit literals
      # just push on the operand stack
      if tk.match(/\d/)
        operand_stack.push(tk)
      # push this on the operator stack
      # we'll use it as a marker for ')'
      else if tk == '('
        operator_stack.push(tk)
      # now traverse the stack backwards
      # until you find '('
      # this can essentially be considered the
      # end marker of a sub expression (i.e.
      # it's exactly what we'll do at the end of
      # this whole expression)
      else if tk == ')'
        tk = operator_stack.pop()
        while tk != '('
          if tk is 'begin'
            throw "Mismatched parens!"
          op = operand_stack.pop()
          op2 = operand_stack.pop()
          operand_stack.push(new Node(tk, op2, op))
          tk = operator_stack.pop()
      # We have a binary operator (+, -, *, /, ^)
      else
        pk = operator_stack.peek()
        # while it has a lower precedence
        # pop the previous operators and their operands off
        # and make nodes of them
        while precedence[pk] > precedence[tk]
          op = operand_stack.pop()
          op2 = operand_stack.pop()
          operand_stack.push( new Node(operator_stack.pop(), op2, op))
          pk = operator_stack.peek()
        # and now push the operator on the stack
        operator_stack.push(tk)
      tk = tokens.next()
  catch er
    if er == "LexEnd"
      pk = operator_stack.peek()
      # now we have reached the end of our input
      # so we need to traverse the stack backwards
      # matching each operator with its two operands
      while pk != 'begin'
        operat = operator_stack.pop()
        op = operand_stack.pop()
        op2 = operand_stack.pop()
        operand_stack.push(new Node(operat, op2, op))
        pk = operator_stack.peek()
      # all that remains is a single node that contains
      # the top most operand (or literal if there are no
      # operands)
      final = operand_stack.pop()
      if final instanceof Node
        # if it's a node, evaluate it, but it may be an error node
        try
          return final.eval()
        catch er
          return er
      else
        # Otherwise it should just be an int literal, so just return it (though it will be in string form)
        return final
    else
      # if the error isn't a lexend, just return the error
      return er


math = {
  action: 'command'
  reaction: (from, to, command, message) ->
    if command == "eval"
      this.say(to, "#{from}: #{parse(new Lex(message))}")
}

exports.events = [math]
