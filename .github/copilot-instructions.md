# GitHub Copilot Instructions for json-nim

This document provides specific guidance for GitHub Copilot when working on the json-nim monorepo project.

## Project Overview

This is a Nim monorepo containing:

- `packages/json_parser/` - Core JSON parsing library
- `packages/cli/` - CLI tool for JSON processing
- Comprehensive test suite with 97+ tests ported from TypeScript

## Key Project Guidelines

### 🧹 Test Executable Cleanup

**CRITICAL**: Always clean up test executables after running tests!

- Nim compiles test files to executables (e.g., `test_numbers`, `test_strings`)
- These executables accumulate in test directories and clutter the workspace
- **Always run `nimble clean` after testing to remove build artifacts**
- Consider using `nimble build_and_test` which includes cleanup
- Never commit test executables to git

### JSON Parser Architecture

The JSON parser follows JSON specification precisely:

- **Numbers**: All numeric values are stored as `JNumber` with `numberValue: float`
  - JSON doesn't distinguish between int and float types
  - The `$` operator outputs clean integers (e.g., `42.0` becomes `"42"`)
  - Use accessor methods: `getNumber()`, `getInt()`, `getFloat()`
- **Types**: `JNull`, `JBool`, `JNumber`, `JString`, `JArray`, `JObject`
- **Parsing**: Recursive descent parser with proper error handling

### Development Workflow

#### Available Nimble Tasks

```bash
nimble tasks                 # List all available tasks
nimble format               # Format all Nim files with nimpretty
nimble build_all            # Build all packages
nimble test                 # Run all tests (includes cleanup)
nimble build_and_test       # Build and test in one command
nimble clean                # Clean build artifacts
nimble docs                 # Generate documentation
nimble install_deps         # Install dependencies
```

#### Testing Strategy

- **Integration tests**: `tests/test_all.nim` (basic functionality)
- **Comprehensive tests**: `packages/json_parser/tests/` (97 tests)
- **Test organization**: 6 test files by JSON component type
- Always run the full test suite before committing changes

### Code Style & Standards

#### Nim Conventions

- Use `snake_case` for variables and functions
- Use `PascalCase` for types
- Use `camelCase` for enum values (e.g., `JNumber`, `JString`)
- Run `nimble format` before committing

#### Dependencies

- **Core library**: Minimal dependencies (strutils, tables, sequtils)
- **Tests**: unittest framework
- **Version requirements**: Nim 2.2.0+, Nimble v0.20.0+

### Common Pitfalls to Avoid

1. **Don't create separate int/float JSON types** - JSON has only one number type
2. **Don't leave test executables** - Always clean up after testing
3. **Don't skip formatting** - Use `nimble format` consistently
4. **Don't break backward compatibility** - Maintain accessor method APIs
5. **Don't assume integer input means integer storage** - All numbers are floats internally

### File Structure Best Practices

```
json-nim/
├── packages/
│   ├── json_parser/         # Core library
│   │   ├── src/
│   │   ├── tests/           # Comprehensive test suite
│   │   └── json_parser.nimble
│   └── cli/                 # CLI tool
├── tests/                   # Integration tests
├── .github/                 # GitHub configuration
└── json_nim_workspace.nimble # Workspace configuration
```

### Debugging & Troubleshooting

#### Common Issues

- **Task parsing problems**: Ensure nimble v0.20.0+ (older versions had bugs)
- **Unicode errors in tests**: Check string parsing implementation
- **Build failures**: Run `nimble clean` and rebuild
- **Import errors**: Verify package structure and nimble configuration

#### Useful Commands

```bash
nim --version               # Check Nim version
nimble --version           # Check nimble version
nimble list --installed   # Show installed packages
find . -name "test_*" -type f -executable  # Find test executables
```

### Version Control

#### Git Workflow

- Format code before committing: `nimble format`
- Run tests before pushing: `nimble test`
- Clean artifacts: `nimble clean`
- Use descriptive commit messages following conventional commits

#### .gitignore Considerations

- Test executables are ignored
- nimcache directories are ignored
- Build artifacts in `build/` are ignored

### Performance Notes

- JSON parsing uses recursive descent for clarity
- Number parsing always uses `parseFloat` for consistency
- String operations are optimized for common cases
- Memory management relies on Nim's ARC/ORC

### Documentation Standards

- Use `##` for public API documentation
- Include usage examples in docstrings
- Generate docs with `nimble docs`
- Keep README.md updated with nimble task instructions

---

## Quick Reference

**Before any commit:**

1. `nimble format` - Format code
2. `nimble test` - Run all tests
3. `nimble clean` - Clean artifacts
4. Check for test executables: `find . -name "test_*" -type f -executable`

**When adding features:**

1. Update tests first (TDD approach)
2. Maintain JSON specification compliance
3. Add documentation
4. Verify backward compatibility

**When debugging:**

1. Check nimble/Nim versions
2. Clean and rebuild
3. Run individual test files
4. Use `--verbose` for detailed output
