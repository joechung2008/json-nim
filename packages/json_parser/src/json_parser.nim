import strutils, tables, sequtils

type
  JsonNodeKind* = enum
    JNull,
    JBool,
    JNumber,
    JString,
    JArray,
    JObject

  JsonNode* = ref object
    case kind*: JsonNodeKind
    of JNull: nil
    of JBool: bval*: bool
    of JNumber: numberValue*: float
    of JString: strValue*: string
    of JArray: arrayValue*: seq[JsonNode]
    of JObject: objValue*: Table[string, JsonNode]

proc parseJson*(s: string): JsonNode =
  ## Parse a JSON string into a JsonNode
  var pos = 0
  let input = s.strip()

  proc skipWhitespace() =
    while pos < input.len and input[pos] in {' ', '\t', '\n', '\r'}:
      inc pos

  proc parseValue(): JsonNode

  proc parseString(): JsonNode =
    if pos >= input.len or input[pos] != '"':
      raise newException(ValueError, "Expected '\"' at position " & $pos)
    inc pos # skip opening quote

    var strResult = ""
    while pos < input.len and input[pos] != '"':
      if input[pos] == '\\':
        inc pos
        if pos >= input.len:
          raise newException(ValueError, "Unterminated string escape")
        case input[pos]:
        of '"': strResult.add('"')
        of '\\': strResult.add('\\')
        of '/': strResult.add('/')
        of 'b': strResult.add('\b')
        of 'f': strResult.add('\f')
        of 'n': strResult.add('\n')
        of 'r': strResult.add('\r')
        of 't': strResult.add('\t')
        of 'u':
          if pos + 4 >= input.len:
            raise newException(ValueError, "Invalid unicode escape")
          let hexStr = input[pos+1..pos+4]
          try:
            let codePoint = parseHexInt(hexStr)
            strResult.add(chr(codePoint))
          except:
            raise newException(ValueError, "Invalid unicode escape: \\u" & hexStr)
          pos += 4
        else:
          raise newException(ValueError, "Invalid escape sequence: \\" & input[pos])
        inc pos
      else:
        # Check for unescaped control characters (0-31)
        let ch = input[pos]
        if ord(ch) < 32:
          raise newException(ValueError,
              "Unescaped control character in string: " & $ord(ch))
        strResult.add(ch)
        inc pos

    if pos >= input.len:
      raise newException(ValueError, "Unterminated string")
    inc pos # skip closing quote

    return JsonNode(kind: JString, strValue: strResult)

  proc parseNumber(): JsonNode =
    var numStr = ""
    let startPos = pos

    # Handle negative sign
    if pos < input.len and input[pos] == '-':
      numStr.add('-')
      inc pos

    # Parse integer part
    if pos >= input.len or not (input[pos] in {'0'..'9'}):
      raise newException(ValueError, "Invalid number at position " & $startPos)

    if input[pos] == '0':
      numStr.add('0')
      inc pos
    else:
      while pos < input.len and input[pos] in {'0'..'9'}:
        numStr.add(input[pos])
        inc pos

    # Check for decimal part
    var isFloat = false
    if pos < input.len and input[pos] == '.':
      isFloat = true
      numStr.add('.')
      inc pos

      if pos >= input.len or not (input[pos] in {'0'..'9'}):
        raise newException(ValueError, "Invalid decimal number")

      while pos < input.len and input[pos] in {'0'..'9'}:
        numStr.add(input[pos])
        inc pos

    # Check for exponent
    if pos < input.len and input[pos] in {'e', 'E'}:
      isFloat = true
      numStr.add(input[pos])
      inc pos

      if pos < input.len and input[pos] in {'+', '-'}:
        numStr.add(input[pos])
        inc pos

      if pos >= input.len or not (input[pos] in {'0'..'9'}):
        raise newException(ValueError, "Invalid exponent")

      while pos < input.len and input[pos] in {'0'..'9'}:
        numStr.add(input[pos])
        inc pos

    # Always parse as float since JSON doesn't distinguish between int and float
    return JsonNode(kind: JNumber, numberValue: parseFloat(numStr))

  proc parseArray(): JsonNode =
    if pos >= input.len or input[pos] != '[':
      raise newException(ValueError, "Expected '[' at position " & $pos)
    inc pos # skip '['

    var elements: seq[JsonNode] = @[]
    skipWhitespace()

    # Handle empty array
    if pos < input.len and input[pos] == ']':
      inc pos
      return JsonNode(kind: JArray, arrayValue: elements)

    while true:
      skipWhitespace()
      elements.add(parseValue())
      skipWhitespace()

      if pos >= input.len:
        raise newException(ValueError, "Unterminated array")

      if input[pos] == ']':
        inc pos
        break
      elif input[pos] == ',':
        inc pos
        skipWhitespace()
      else:
        raise newException(ValueError, "Expected ',' or ']' in array")

    return JsonNode(kind: JArray, arrayValue: elements)

  proc parseObject(): JsonNode =
    if pos >= input.len or input[pos] != '{':
      raise newException(ValueError, "Expected '{' at position " & $pos)
    inc pos # skip '{'

    var fields = initTable[string, JsonNode]()
    skipWhitespace()

    # Handle empty object
    if pos < input.len and input[pos] == '}':
      inc pos
      return JsonNode(kind: JObject, objValue: fields)

    while true:
      skipWhitespace()

      # Parse key (must be string)
      if pos >= input.len or input[pos] != '"':
        raise newException(ValueError, "Expected string key in object")
      let keyNode = parseString()
      let key = keyNode.strValue

      skipWhitespace()

      # Expect colon
      if pos >= input.len or input[pos] != ':':
        raise newException(ValueError, "Expected ':' after key in object")
      inc pos

      skipWhitespace()

      # Parse value
      let value = parseValue()
      fields[key] = value

      skipWhitespace()

      if pos >= input.len:
        raise newException(ValueError, "Unterminated object")

      if input[pos] == '}':
        inc pos
        break
      elif input[pos] == ',':
        inc pos
        skipWhitespace()
      else:
        raise newException(ValueError, "Expected ',' or '}' in object")

    return JsonNode(kind: JObject, objValue: fields)

  proc parseValue(): JsonNode =
    skipWhitespace()

    if pos >= input.len:
      raise newException(ValueError, "Unexpected end of input")

    case input[pos]:
    of '"': return parseString()
    of '[': return parseArray()
    of '{': return parseObject()
    of '-', '0'..'9': return parseNumber()
    of 't':
      if pos + 4 <= input.len and input[pos..pos+3] == "true":
        pos += 4
        return JsonNode(kind: JBool, bval: true)
      else:
        raise newException(ValueError, "Invalid literal starting with 't'")
    of 'f':
      if pos + 5 <= input.len and input[pos..pos+4] == "false":
        pos += 5
        return JsonNode(kind: JBool, bval: false)
      else:
        raise newException(ValueError, "Invalid literal starting with 'f'")
    of 'n':
      if pos + 4 <= input.len and input[pos..pos+3] == "null":
        pos += 4
        return JsonNode(kind: JNull)
      else:
        raise newException(ValueError, "Invalid literal starting with 'n'")
    else:
      raise newException(ValueError, "Unexpected character '" & input[pos] &
          "' at position " & $pos)

  if input.len == 0:
    raise newException(ValueError, "Empty JSON input")

  result = parseValue()
  skipWhitespace()

  if pos < input.len:
    raise newException(ValueError, "Unexpected characters after JSON")

  return result

proc `$`*(node: JsonNode): string =
  ## Convert JsonNode back to string representation
  case node.kind
  of JNull: "null"
  of JBool: $node.bval
  of JNumber:
    # Output clean integers when there's no fractional part
    if node.numberValue == float(int(node.numberValue)):
      $int(node.numberValue)
    else:
      $node.numberValue
  of JString: "\"" & node.strValue & "\""
  of JArray: "[" & node.arrayValue.mapIt($it).join(",") & "]"
  of JObject:
    var pairs: seq[string] = @[]
    for k, v in node.objValue:
      pairs.add("\"" & k & "\":" & $v)
    "{" & pairs.join(",") & "}"

proc newJString*(s: string): JsonNode =
  JsonNode(kind: JString, strValue: s)

proc newJNumber*(n: float): JsonNode =
  JsonNode(kind: JNumber, numberValue: n)

proc newJBool*(b: bool): JsonNode =
  JsonNode(kind: JBool, bval: b)

proc getNumber*(node: JsonNode): float =
  ## Get the numeric value from a number node
  if node.kind != JNumber:
    raise newException(ValueError, "Node is not a number")
  return node.numberValue

proc getInt*(node: JsonNode): int =
  ## Get the numeric value as an integer (convenience method)
  if node.kind != JNumber:
    raise newException(ValueError, "Node is not a number")
  return int(node.numberValue)

proc getFloat*(node: JsonNode): float =
  ## Get the numeric value as a float (convenience method)
  if node.kind != JNumber:
    raise newException(ValueError, "Node is not a number")
  return node.numberValue

when isMainModule:
  let json = parseJson("""{"hello": "world"}""")
  echo "Parsed: ", json
