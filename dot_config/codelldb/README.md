# `codelldb` Installation Notes

Download the latest release's `.vsix` file:

```bash
curl -LO "https://github.com/vadimcn/codelldb/releases/latest/download/codelldb-darwin-arm64.vsix"
```

Unzip:

```bash
unzip codelldb-darwin-arm64.vsix
```

Copy the binary to somewhere on your `PATH`:

```bash
cp ~/Downloads/extension/adapter/codelldb ~/.config/codelldb/
```

Ensure this is available on `PATH`:

```bash
which codelldb
# should print out location
```
