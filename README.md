# json-nim

## License

MIT

## Reference

[json.org](https://www.json.org/json-en.html)

## Getting Started

### Prerequisites

- Nim 2.2.0 or higher
- Nimble 0.20.0 or higher (for Linux)

### Building the Monorepo

1. **Clone and navigate to the repository:**

```bash
cd json-nim
```

2. **Build all packages:**

```bash
# Linux
nimble build_all
```

```powershell
# Windows
.\bin\build_all
```

3. **Install dependencies:**

```bash
# Linux
nimble install_deps
```

```powershell
# Windows
.\bin\install_deps
```

4. **Run tests:**

```bash
# Linux
nimble test
```

```powershell
# Windows
.\bin\test
```

5. **Build and test in one command:**

```bash
# Linux
nimble build_and_test
```

```powershell
# Windows
.\bin\build_and_test
```

6. Generate documentation

```bash
# Linux
nimble docs
```

```powershell
# Windows
.\bin\docs
```

### Code Formatting

This project uses `nimpretty` to maintain consistent code style across all Nim files.

```bash
# Linux
nimble format
```

```bash
# Windows
.\bin\format
```

## Building Static Executables & Docker Usage

### Why Static Builds?

Static binaries are required for Docker images based on `scratch` or minimal base images, as these containers do not include system libraries needed for dynamically linked executables. By building a static version of the CLI, you ensure the binary can run in any container environment without missing dependencies.

### How to Build Static Binaries

#### Linux (recommended)

```bash
nimble build_static
```

This will produce static binaries in the `build/` directory:

- `json_parser_static`
- `json_cli_static`

#### Windows

```cmd
bin\build_static.cmd
```

#### PowerShell

```powershell
bin\build_static.ps1
```

### Using Static Binaries in Docker

The Dockerfile is configured to build and copy the static CLI binary into a minimal container:

```dockerfile
COPY --from=builder /app/build/json_cli_static /app/json_cli
```

This ensures the resulting Docker image is small and portable, with no runtime library dependencies.
