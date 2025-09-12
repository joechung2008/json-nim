# json-nim

## License

MIT

## Reference

[json.org](https://www.json.org/json-en.html)

## Getting Started

### Prerequisites

- Nim 2.2.0 or higher
- Nimble 0.20.0 or higher (required for proper task parsing)

### Building the Monorepo

1. **Clone and navigate to the repository:**

```bash
cd json-nim
```

2. **Build all packages:**

```bash
nimble build_all
```

3. **Install dependencies:**

```bash
nimble install_deps
```

4. **Run tests:**

```bash
nimble test
```

5. **Build and test in one command:**

```bash
nimble build_and_test
```

### Working with Individual Packages

Each package can be built and tested independently:

```bash
# Build json_parser
cd packages/json_parser
nimble build
```

## Package Overview

### json_parser

A JSON parsing library that converts JSON strings into structured data.

**Features:**

- Parse JSON strings into JsonNode objects
- Support for all JSON data types (null, bool, number, string, array, object)
- Convert JsonNode back to string representation

**Usage:**

```nim
import packages/json_parser/src/json_parser

let json = parseJson("""{"hello": "world"}""")
echo json  # Prints the parsed JSON
```

## Development Workflow

### Available Nimble Tasks

The workspace provides several nimble tasks for development workflow:

- `nimble build_all`: Build all packages
- `nimble test`: Run all tests
- `nimble build_and_test`: Build all packages and run tests
- `nimble install_deps`: Install dependencies for all packages
- `nimble clean`: Clean build artifacts
- `nimble docs`: Generate documentation for all packages
- `nimble format`: Format all Nim files using nimpretty

**View all available tasks:**

```bash
nimble tasks
```

### Code Formatting

This project uses `nimpretty` to maintain consistent code style across all Nim files.

**Format all Nim files in the project:**

```bash
nimble format
```
