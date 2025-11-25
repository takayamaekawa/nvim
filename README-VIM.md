# Vim Configuration - Neovim Settings Ported to Vim

This guide covers how to use Neovim configurations with Vim, providing configurations as close as possible to the original Neovim setup.

## Available Configurations

This repository includes three Vim configuration files:

- `vimrc` - Simple configuration that sources external vimrc (recommended for most users)
- `vim-with-plugins.vimrc` - Full-featured version with plugins
- `vim-minimal.vimrc` - Lightweight minimal version

## 🚀 Quick Start

### 1. Minimal Configuration (Recommended for beginners)

```bash
# Copy the minimal configuration
cp vim-minimal.vimrc ~/.vimrc
```

### 2. Source-based Configuration (Recommended)

```bash
# Copy the source-based configuration
cp vimrc ~/.vimrc

# This will automatically source vim-with-plugins.vimrc
vim
```

### 3. Full Configuration with Plugins

```bash
# Copy the full configuration directly
cp vim-with-plugins.vimrc ~/.vimrc

# Start Vim and install plugins
vim
:PlugInstall
```

## 📋 Feature Overview

### Basic Features (All Configurations)
- **WSL Clipboard Integration** - Seamless clipboard sharing with Windows
- **Smart Indentation** - 2-space tabs with smart indenting
- **Search Configuration** - Case-insensitive search with highlighting
- **Custom Key Mappings** - Intuitive shortcuts for common operations
- **Japanese Support** - Full-width character support (`ambiwidth=double`)

### Plugin Features (vim-with-plugins.vimrc only)
- **🔧 LSP Support** - Language Server Protocol via ALE
- **📁 File Manager** - NERDTree with Git integration
- **🔍 Fuzzy Finder** - FZF for fast file searching
- **🎨 Auto Formatting** - Multiple formatter support
- **🔄 Git Integration** - Fugitive and GitGutter
- **🤖 AI Assistance** - GitHub Copilot support

## 🎯 Key Mappings

### Basic Operations
| Key | Action |
|-----|--------|
| `jj` | Escape from insert mode |
| `<Leader>qq` | Quit all buffers |
| `<S-a>` | Select all |
| `<S-f>` | Format entire file |
| `<S-w>` | Save file |
| `<Leader>hh` | Clear search highlight |

### Navigation
| Key | Action |
|-----|--------|
| `<C-j>/<C-k>` | Navigate buffers |
| `<Alt-Arrow>` | Navigate windows |
| `<C-\\><C-_>` | Navigate tabs |
| `<Leader>tc` | Close tab |

### WSL Clipboard (Automatic)
| Key | Action |
|-----|--------|
| `y` | Copy to Windows clipboard |
| `p` | Paste from Windows clipboard |

### Plugin-Specific (vim-with-plugins.vimrc only)

#### File Manager
| Key | Action |
|-----|--------|
| `<C-n>` | Toggle NERDTree |
| `<Leader>n` | Focus NERDTree |
| `<Leader>f` | Find current file |

#### Search
| Key | Action |
|-----|--------|
| `<C-p>` | File search |
| `<Leader>ff` | File search |
| `<Leader>fg` | Git file search |
| `<Leader>fb` | Buffer search |
| `<Leader>fr` | Text search |

#### LSP Operations
| Key | Action |
|-----|--------|
| `<Leader>gd` | Go to definition |
| `<Leader>gr` | Find references |
| `<Leader>gh` | Show hover info |
| `<Leader>rn` | Rename symbol |
| `<Leader>ca` | Code actions |
| `[d` / `]d` | Navigate diagnostics |

#### Formatting
| Key | Action |
|-----|--------|
| `<Leader>df` | Format with ALE |
| `<Leader>af` | Auto format |

#### Git Operations
| Key | Action |
|-----|--------|
| `<Leader>gs` | Git status |
| `<Leader>gc` | Git commit |
| `<Leader>gp` | Git push |
| `<Leader>gl` | Git log |
| `<Leader>gd` | Git diff |
| `<Leader>gb` | Git blame |

#### GitHub Copilot
| Key | Action |
|-----|--------|
| `<C-J>` | Accept suggestion |
| `<C-]>` | Next suggestion |
| `<C-[>` | Previous suggestion |
| `<C-\\>` | Dismiss suggestion |

## 🛠️ Installation & Setup

### Plugin Installation (vim-with-plugins.vimrc)

1. **Install vim-plug** (automated)
   ```bash
   # vim-plug will be automatically installed when you first run Vim
   vim
   ```

2. **Install plugins**
   ```vim
   :PlugInstall
   ```

3. **Install language servers** (optional)
   ```bash
   # Node.js (JavaScript/TypeScript)
   npm install -g @biomejs/biome

   # Python
   pip install pyright black isort

   # Rust
   rustup component add rust-analyzer rustfmt

   # Go
   go install golang.org/x/tools/gopls@latest
   ```

4. **Setup GitHub Copilot** (optional)
   ```vim
   :Copilot setup
   ```

### WSL Setup

For WSL users, install win32yank for clipboard integration:

```bash
# Download and install win32yank
curl -sLo /tmp/win32yank.zip https://github.com/equalsraf/win32yank/releases/latest/download/win32yank-x64.zip
unzip -p /tmp/win32yank.zip win32yank.exe > /tmp/win32yank.exe
chmod +x /tmp/win32yank.exe
sudo mv /tmp/win32yank.exe /usr/local/bin/
```

## 🔧 Supported Languages

### LSP Support (vim-with-plugins.vimrc)
- JavaScript/TypeScript
- Python
- Rust
- Go
- C/C++
- Java
- Scala
- Lua
- JSON/YAML
- HTML/CSS

### Formatter Support
- JavaScript/TypeScript (Biome)
- Python (Black, isort)
- Rust (rustfmt)
- Go (gofmt)
- C/C++ (clang-format)
- Java (google_java_format)
- Scala (scalafmt)

## 📊 Performance Comparison

| Feature | Neovim | Vim Basic | Vim Minimal | Vim + Plugins |
|---------|--------|-----------|-------------|---------------|
| Startup Time | Slow | Fast | Very Fast | Medium |
| Memory Usage | High | Low | Very Low | Medium |
| LSP Features | Rich | None | None | Basic |
| Completion | Advanced | None | None | Basic |
| File Operations | Advanced | Basic | Basic | Medium |
| Plugin Count | 20+ | 0 | 0 | 15+ |

## 🐛 Troubleshooting

### Common Issues

1. **Clipboard not working**
   - Check if Vim is compiled with clipboard support: `vim --version | grep clipboard`
   - For WSL, ensure win32yank.exe is installed and in PATH

2. **LSP not working**
   - Check if language server is installed
   - Run `:ALEInfo` to check ALE status
   - Run `:LspStatus` to check LSP status

3. **Plugins not loading**
   - Check plugin status with `:PlugStatus`
   - Install missing plugins with `:PlugInstall`
   - Update plugins with `:PlugUpdate`

4. **Completion not working**
   - Check Python3 support: `:echo has('python3')`
   - Verify LSP is running properly
   - Check completion status: `:AsyncompleteInfo`

### Debug Commands

```vim
" Check clipboard content (WSL)
:WSLClipboardTest

" Check ALE status
:ALEInfo

" Check plugin status
:PlugStatus

" Check LSP status
:LspStatus
```

## 🎨 Customization

### Adding Plugins

```vim
" Add between plug#begin() and plug#end()
call plug#begin('~/.vim/plugged')

" Your plugins here
Plug 'tpope/vim-sensible'
Plug 'preservim/nerdcommenter'

call plug#end()
```

### Changing Themes

```vim
" Add to your vimrc
colorscheme desert
colorscheme slate
colorscheme monokai
```

### Custom Key Mappings

```vim
" Example: Open NERDTree with Ctrl-o
nnoremap <C-o> :NERDTreeToggle<CR>
```

## 🔄 Migration from Neovim

### What's Included
- ✅ Basic settings and key mappings
- ✅ WSL clipboard integration
- ✅ File navigation and editing
- ✅ Search and replace functionality
- ✅ Basic LSP support (via ALE)
- ✅ Git integration
- ✅ Auto-formatting
- ✅ GitHub Copilot support

### What's Not Included
- ❌ Lua configuration files
- ❌ Neovim-specific plugins (nvim-tree, toggleterm, etc.)
- ❌ Advanced LSP features (some diagnostics, advanced completion)
- ❌ Lazy.nvim plugin manager
- ❌ Some Neovim-specific UI enhancements

### Alternative Solutions
- **Plugin Manager**: vim-plug (instead of lazy.nvim)
- **File Tree**: NERDTree (instead of nvim-tree)
- **LSP**: ALE (instead of nvim-lspconfig)
- **Terminal**: Vim terminal feature (instead of toggleterm)
- **Completion**: asyncomplete (instead of nvim-cmp)

## 📝 Notes

1. **Backup**: Always backup your existing `~/.vimrc` before using these configurations
2. **Compatibility**: Recommended for Vim 8.0 or later
3. **Customization**: Feel free to modify these configurations to suit your needs
4. **Updates**: Plugin configurations are commented out by default in basic versions

## 🔗 Related Files

- `vimrc` - Simple configuration that sources external vimrc
- `vim-with-plugins.vimrc` - Full-featured configuration with plugins
- `vim-minimal.vimrc` - Lightweight minimal configuration

---

*This configuration aims to provide a Vim experience as close as possible to the original Neovim setup while maintaining compatibility and performance.*