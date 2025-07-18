# nvim

## Feature
This is my all neovim settings.

## Note
### Install
* [Neovim](https://neovim.io/)

### Environment
- OS  
\>\> ArchLinux
  
- Nvim-Version  
\>\> NVIM v0.10.4

### CrossOSPlatForm (COP)
Of course, this is working well at Linux environment, but it can't be guarantee to work completely in other OS.  
* Probably, Windows is OK.  
- Windows Demo  
![windows-test](https://raw.githubusercontent.com/takayamaekawa/branding/refs/heads/master/repo/nvim/windows_test.gif)  
For COP, I write condition like [lua/settings/toggleterm.lua](lua/settings/toggleterm.lua)

## Preview
### LSP
Plugin:  
* [williamboman/mason-lspconfig.nvim](https://github.com/williamboman/mason-lspconfig.nvim) for variety of langs
* [hrsh7th/nvim-cmp](https://github.com/hrsh7th/nvim-cmp) for completion
* [nvim-java/nvim-java](https://github.com/nvim-java/nvim-java) for Java
* [scalameta/nvim-metals](https://github.com/scalameta/nvim-metals) for Scala
  
Install:  
* [lua/plugins/language-server.lua](lua/plugins/language-server.lua)
* [lua/plugins/completion.lua](lua/plugins/completion.lua)
* [lua/plugins/nvim-java.lua](lua/plugins/nvim-java.lua)
* [lua/plugins/metals.lua](lua/plugins/metals.lua)
  
Setting: [lua/settings/lsp/](lua/settings/lsp/)
  
Keymap: [lua/settings/keymaps/lsp.lua](lua/settings/keymaps/lsp.lua)

- Completion  
![completion](https://raw.githubusercontent.com/takayamaekawa/branding/refs/heads/master/repo/nvim/completion.gif)  
- Hover Explanation  
![hover-explanation](https://raw.githubusercontent.com/takayamaekawa/branding/refs/heads/master/repo/nvim/hover_explanation.gif)  
- Jump Definition  
![jump-definition](https://raw.githubusercontent.com/takayamaekawa/branding/refs/heads/master/repo/nvim/jump_definition.gif)  
- Jump Type Referece  
![jump-type-reference](https://raw.githubusercontent.com/takayamaekawa/branding/refs/heads/master/repo/nvim/jump_type_definition.gif)  
- Jump Reference  
![jump-referece](https://raw.githubusercontent.com/takayamaekawa/branding/refs/heads/master/repo/nvim/jump_referece.gif)

### Debugger
This is required for coop with LSP setting in advance  
  
Plugin:  
* [mfussenegger/nvim-dap](https://github.com/mfussenegger/nvim-dap)
* [rcarriga/nvim-dap-ui](https://github.com/rcarriga/nvim-dap-ui)
  
Install: [lua/plugins/dap.lua](lua/plugins/dap.lua)
  
Setting: [lua/settings/dap.lua](lua/settings/dap.lua)
  
Keymap: [lua/settings/keymaps/plugins.lua#L47](lua/settings/keymaps/plugins.lua#L47)
  
![dap-debug](https://raw.githubusercontent.com/takayamaekawa/branding/refs/heads/master/repo/nvim/dap_debug.gif)

### Task Runner
Plugin: [stevearc/overseer.nvim](https://github.com/stevearc/overseer.nvim)
  
Install: [lua/plugins/overseer.lua](lua/plugins/overseer.lua)
  
Setting: [lua/settings/overseer.lua](lua/settings/overseer.lua)
  
Task Definition: [lua/overseer/template/user/](lua/overseer/template/user/)
  
Keymap: [lua/settings/keymaps/plugins.lua#L10](lua/settings/keymaps/plugins.lua#L10)
  
![run-overseer-task](https://raw.githubusercontent.com/takayamaekawa/branding/refs/heads/master/repo/nvim/run_overseer_task.gif)

### Search File Or Text
Plugin: [nvim-telescope/telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)
  
Install: [lua/plugins/finder.lua](lua/plugins/finder.lua)
  
Setting: [lua/settings/nvim-tree.lua](lua/settings/nvim-tree.lua)
  
Keymap: [lua/settings/keymaps/plugins.lua#L32](lua/settings/keymaps/plugins.lua#L32)
  
- Find Files And Jump  
![telescope-find-files](https://raw.githubusercontent.com/takayamaekawa/branding/refs/heads/master/repo/nvim/telescope_find_files.gif)  
- Find Text  
![telescope-search-text](https://raw.githubusercontent.com/takayamaekawa/branding/refs/heads/master/repo/nvim/telescope_search_text.gif)

### System Utility
Here is my [lua/settings/keymaps/system.lua#L14](lua/settings/keymaps/system.lua#L14)  
![system-copy](https://raw.githubusercontent.com/takayamaekawa/branding/refs/heads/master/repo/nvim/system_copy.gif)

## Keymaps
See [lua/settings/keymaps](lua/settings/keymaps/)

## Other Using Plugins
### Notify  
Plugin: [rcarriga/nvim-notify](https://github.com/rcarriga/nvim-notify)
  
Install: [lua/plugins/nvim-notify.lua](lua/plugins/nvim-notify.lua)
  
Setting: [lua/settings/nvim-notify.lua](lua/settings/nvim-notify.lua)

### SessionManager  
Plugin: [Shatur/neovim-session-manager](https://github.com/Shatur/neovim-session-manager)
  
Install: [lua/plugins/session-manager.lua](lua/plugins/session-manager.lua)
  
Setting: [lua/settings/session-manager.lua](lua/settings/session-manager.lua)

### StatusBar  
Plugin: [nvim-lualine/lualine.nvim](https://github.com/nvim-lualine/lualine.nvim)
  
Install: [lua/plugins/lualine.lua](lua/plugins.lualine.lua)
  
Setting: [lua/settings/lualine.lua](lua/settings/lualine.lua)

## Vim Configuration

You can also configure Vim to work as close as possible to this Neovim setup! For more details, see [README_vim.md](README_vim.md).

## Comment
I'm glowing up with Neovim, which is for only myself.  
Wanna be a Vimmer?

## License
[MIT](LICENSE)
