import std/[os, strutils]
import ../../json_parser/src/json_parser

proc readAllStdin(): string =
  ## Read all text from stdin
  result = ""
  try:
    var line: string
    while stdin.readLine(line):
      if result.len > 0:
        result.add("\n")
      result.add(line)
  except EOFError:
    # This is expected when stdin is closed
    discard
  except IOError:
    # Handle case where stdin is unavailable
    discard

proc main() =
  ## Main CLI entry point
  # Read all input from stdin
  let input = readAllStdin()

  try:
    if input.len == 0:
      echo "Error: No input provided. Please pipe JSON data to stdin."
      quit(1)

    # Parse the JSON
    let parsed = parseJson(input)

    # Output the parsed result
    echo "Successfully parsed JSON:"
    echo $parsed

  except Exception as e:
    echo "Error parsing JSON: ", e.msg
    echo "Input was: ", input
    quit(1)

when isMainModule:
  main()
