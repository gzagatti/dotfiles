local package_root = vim.fn.stdpath('data')..'/site/pack'
local install_path = package_root .. '/packer/start/packer.nvim'
local compile_path = vim.fn.stdpath('config')..'/plugin/packer_compiled.lua'

if vim.fn.isdirectory(install_path) == 0 then
  vim.fn.system({ 'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path })
end

--plugins {{{
local function load_plugins()

require'packer'.startup {function (use)

  -- development plugins
  -- @param path string
  -- @return string
  -- https://github.com/aspeddro/dotfiles/blob/main/.config/nvim/lua/user/packages.lua
  local here = function(path)
    return vim.fn.expand '~/src/' .. path
  end

  ---packer {{{
  -- package management
  use { 'wbthomason/packer.nvim' }
  ---}}}

  ---plenary {{{
  -- lua utilities
  use { 'nvim-lua/plenary.nvim' }
  ---}}}

  ---lualine/tmuxline {{{
  -- lean & mean status for vim that's light as air
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'stevearc/aerial.nvim' },
    config = function ()
      require'lualine'.setup({
        sections = {
          lualine_b = {
            'branch',
            'filename',
          },
          lualine_c = {
            {
              'aerial',
              sep = '  ',
              colored = false,
            },
          },
          lualine_x = {
            {
              'diagnostics',
              symbols = { error = 'E', warn = 'W', info = 'I', hint = 'H'},
            },
            'diff',
          },
          lualine_y = { 'progress' },
          lualine_z = {
            'location',
            'filetype',
          },
        }
      })
    end
  }
  ---}}}

  ---vim-oscyank {{{
  -- copy text through SSH with OSC52
  use {
    'ojroques/vim-oscyank',
    config = function()
      vim.cmd [[
        augroup oscyank
          autocmd TextYankPost * if v:event.operator is 'y' && v:event.regname is '+' | execute 'OSCYankRegister +' | endif
        augroup end
      ]]
    end
  }
  ---}}}

  ---nnn {{{
  use {
    'gzagatti/nnn.nvim',
    branch = 'tweaks',
    config = function()
      local builtin = require'nnn'.builtin
      require'nnn'.setup {
        explorer = {
          cmd = "nnn",
        },
        picker = {
          cmd = "tmux new-session nnn -Pp",
        },
        auto_open = {
          empty = true,
        },
        mappings = {
          {"<C-x>", function (files)
              local nnnwin
              for _, win in pairs(vim.api.nvim_tabpage_list_wins(0)) do
                if vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(win), "filetype") == "nnn" then
                  nnnwin = win
                  break
                end
              end
              for i, file in ipairs(files) do
                if i == 1 and vim.api.nvim_buf_get_name(0) == "" then
                  vim.cmd("edit "..file)
                else
                  vim.cmd("split "..file)
                end
              end
              vim.api.nvim_set_current_win(nnnwin)
            end
          },
          {"<C-v>", function (files)
              local nnnwin
              for _, win in pairs(vim.api.nvim_tabpage_list_wins(0)) do
                if vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(win), "filetype") == "nnn" then
                  nnnwin = win
                  break
                end
              end
              for i, file in ipairs(files) do
                if i == 1 and vim.api.nvim_buf_get_name(0) == "" then
                  vim.cmd("edit "..file)
                else
                  vim.cmd("vsplit "..file)
                end
              end
              vim.api.nvim_set_current_win(nnnwin)
            end
          },
        },
        quitcd = "cd",
      }
      vim.api.nvim_set_keymap(
        "",
        "<f8>",
        ":execute 'NnnExplorer' (expand('%:p') ==? expand('%:.') ? '%:p:h' : '')<cr>",
        { noremap = true, silent = true }
      )
      vim.cmd [[
        augroup nnn
          autocmd FileType * if &ft ==# "nnn" |:tnoremap <buffer> <f8> q| endif
        augroup end
      ]]
    end
  }
  ---}}}

  ---kommentary {{{
  -- easily add comments in source code
  use {
    'b3nj5m1n/kommentary',
    config = function()
      vim.g.kommentary_create_default_mappings = false
      require'kommentary.config'.configure_language("default", { prefer_single_line_comments = true, })
      vim.api.nvim_set_keymap("n", "<leader>cc", "<plug>kommentary_line_default", {})
      vim.api.nvim_set_keymap("n", "<leader>c", "<plug>kommentary_motion_default", {})
      vim.api.nvim_set_keymap("x", "<leader>c", "<plug>kommentary_visual_default", {})
    end
  }
  ---}}}

  ---navigators {{{
    ---kitty-navigator
    use {
      'knubie/vim-kitty-navigator',
      config = function()
        if vim.env.TERM ~= 'xterm-kitty' then
          vim.g['kitty_navigator_no_mappings'] = 1
        end
      end,
    }

    -- tmux-navigator
    -- seamless navigation between tmux panes and vim splits
    use {
      'christoomey/vim-tmux-navigator',
      config = function()
        if not string.match(vim.env.TERM, "tmux-") then
          vim.g['tmux_navigator_no_mappings'] = 1
          vim.g ['tmux_navigator_disable_when_zoomed'] = 1
        end
      end
    }
  ---}}}

  ---slime {{{
  -- multiplexer integration
  use {
    'jpalardy/vim-slime',
    config = function()
      if vim.env.TERM == 'xterm-kitty' then
        vim.g.slime_target = "kitty"
      else
        vim.g.slime_target = "tmux"
      end

      vim.g.slime_no_mappings = 1

      vim.api.nvim_set_keymap('', '[slime]', '', { noremap = true })
      vim.api.nvim_set_keymap('', '<leader>s', '[slime]', {})
      vim.api.nvim_set_keymap('' , '[slime]l', ':<c-u>call slime#send_lines(v:count1)<cr>', {})
      vim.api.nvim_set_keymap('v', '[slime]l', ':<c-u>call slime#send_op(visualmode(), 1)<cr>', {})
      vim.api.nvim_set_keymap('', '[slime]v', ':<c-u>call slime#config()<cr>', {})
      vim.api.nvim_set_keymap('' , '[slime]b', ':<c-u>call slime#send_range(line(1), line("$"))<cr>', {})
      vim.cmd [[
        augroup slime_augroup:
          autocmd!

          "" file execute commands
          autocmd FileType python noremap <buffer> <silent> [slime]f
            \ :execute ":call slime#send(\"%run -i " . @% . "\r\")" <cr>
          autocmd FileType matlab noremap <buffer> <silent> [slime]f
            \ :execute ":call slime#send(\"run '" . @% . "'\r\")" <cr>
          autocmd FileType sql noremap <buffer> <silent> [slime]f
            \ :execute ":call slime#send('\\i " . @% . "\r')" <cr>
          autocmd FileType r noremap <buffer> <silent> [slime]f
            \ :execute ":call slime#send(\"source('" . @% . "', echo=TRUE)\r\")" <cr>
          autocmd FileType ruby noremap <buffer> <silent> [slime]f
            \ :execute ":call slime#send(\"load '" . @% . "'\r\")" <cr>
          autocmd FileType julia noremap <buffer> <silent> [slime]f
            \ :execute ":call slime#send('include(\"" . @% . "\");\r')" <cr>
          autocmd FileType lua noremap <buffer> <silent> [slime]f
            \ :execute ":call slime#send('dofile(\"" . @% . "\");\r')" <cr>
          autocmd FileType scheme noremap <buffer> <silent> [slime]f
            \ :execute ":call slime#send(',require-reloadable \"" . @% . "\"\r')" <cr>

          "" weave commands
          autocmd FileType rmd,r noremap <buffer> <silent> [slime]w
            \ :execute ":call slime#send(\"rmarkdown::render('" . @% . "', output_format='all', quiet=TRUE)\r\")" <cr>
          autocmd FileType julia noremap <buffer> <silent> [slime]w
            \ :execute ":call slime#send('weave(\"" . @% . "\"; doctype=\"md2html\", out_path=:pwd, mod=Main)\r')" <cr>

          autocmd FileType markdown noremap <buffer> <silent> [slime]c
            \ :execute ":call slime#send_cell()" <cr>
          autocmd FileType markdown let b:slime_cell_delimiter = "```"

          autocmd FileType org noremap <buffer> <silent> [slime]c
            \ :execute ":call slime#send_cell()" <cr>
          autocmd FileType org let b:slime_cell_delimiter = "#+"

        augroup END
      ]]
    end
  }
  ---}}}

  --- ufo {{{
  -- ultra fold
  use {
    'kevinhwang91/nvim-ufo',
    requires = { 'kevinhwang91/promise-async', 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require'ufo'.setup({
          open_fold_hl_timeout = 150,
          provider_selector = function(bufnr, filetype, buftype)
              return {'treesitter', 'indent'}
          end
      })
      vim.keymap.set('n', 'zR', require'ufo'.openAllFolds)
      vim.keymap.set('n', 'zM', require'ufo'.closeAllFolds)
      vim.keymap.set('n', 'zr', require'ufo'.openFoldsExceptKinds)
      vim.keymap.set('n', 'zm', require'ufo'.closeFoldsWith) -- closeAllFolds == closeFoldsWith(0)
      vim.api.nvim_create_autocmd('BufRead', {
        callback = function()
          vim.cmd[[ silent! foldclose! ]]
          local bufnr = vim.api.nvim_get_current_buf()
          -- make sure buffer is attached
          vim.wait(100, function() require'ufo'.attach(bufnr) end)
          if require'ufo'.hasAttached(bufnr) then
            local winid = vim.api.nvim_get_current_win()
            local method = vim.wo[winid].foldmethod
            if method == 'diff' or method == 'marker' then
              require'ufo'.closeAllFolds()
              return
            end
            -- getFolds returns a Promise if providerName == 'lsp', use vim.wait in this case
            local ok, ranges = pcall(require'ufo'.getFolds, bufnr, 'treesitter')
            if ok and ranges then
              if require'ufo'.applyFolds(bufnr, ranges) then
                pcall(require'ufo'.closeAllFolds)
              end
            end
          end
        end
      })
    end
  }
  ---}}}

  ---indentLine {{{
  -- displays thin vertical lines at each indentation level for code indented with spaces
  use {
    'Yggdroot/indentLine',
    config = function()
      vim.g['indentLine_defaultGroup'] = 'IndentLine'
      vim.g['indentLine_concealcursor'] = 'c'
      vim.g['indentLine_conceallevel'] = 0
      vim.cmd [[
        autocmd ColorScheme leuven highlight IndentLine guifg='#dadad7' ctermfg=253'
        autocmd ColorScheme dracula highlight IndentLine guifg='#2f3751' ctermfg=253'
        autocmd TermOpen * IndentLinesDisable
        autocmd Filetype * if &ft ==# "help" | :IndentLinesDisable | endif
        autocmd Filetype * if &ft ==# "NeogitStatus" | :IndentLinesDisable | endif
      ]]
    end
  }
  ---}}}

  ---surround {{{
  -- surround text with pairs of elements
  use {
    'tpope/vim-surround',
    require = { 'tpope/vim-repeat' },
    config = function()
      vim.g.surround_no_mappings = 1
      vim.api.nvim_set_keymap('n', 'ds', '<Plug>Dsurround', { noremap = true })
      vim.api.nvim_set_keymap('n', 'cs', '<Plug>Csurround', { noremap = true })
      vim.api.nvim_set_keymap('n', 'ys', '<Plug>Ysurround', { noremap = true })
      vim.api.nvim_set_keymap('n', 'yS', '<Plug>YSurround', { noremap = true })
      vim.api.nvim_set_keymap('n', 'yss', '<Plug>Yssurround', { noremap = true })
      vim.api.nvim_set_keymap('n', 'ySS', '<Plug>YSsurround', { noremap = true })
      vim.api.nvim_set_keymap('x', 'Y', '<Plug>VSurround', { noremap = true })
      vim.api.nvim_set_keymap('x', 'gY', '<Plug>VgSurround', { noremap = true })
      vim.api.nvim_set_keymap('i', '<c-s>', '<Plug>Isurround', { noremap = true })
      -- surrounds text with escaped delimiters `\` (char 92), e.g. foo -> \( foo \)
      -- prompts for delimiter with `\1delimiter: \1`
      -- replaces first character `\r^.\r\\\\&` and removes second character `\r.$\r`
      -- removes first character `\r^.\r` and replaces second character `\r.$\r\\\\&`
      -- see manual for more details :help surround-customizing
      vim.g.surround_92 = "\1delimiter: \r^.\r\\\\&\r.$\r\1 \r \1\r^.\r\r.$\r\\\\&\1"
    end

  }
  ---}}}

  ---matchit {{{
  -- extended % matching for HTML, Latex and many other languages
  use { 'vim-scripts/matchit.zip' }
  ---}}}

  ---rename {{{
  -- rename files in vim
  use { 'danro/rename.vim' }
  ---}}}

  ---pencil {{{
  -- rethinking Vim as a tool for writing
  use {
    'gzagatti/vim-pencil',
    config = function ()
      vim.g['pencil#conceallevel'] = 0
      vim.g['pencil#concealcursor'] = 'c'
      vim.cmd [[
        augroup pencil
          autocmd!
          autocmd FileType tex,org call pencil#init({'wrap': 'soft'})
        augroup END
      ]]
    end
  }
  ---}}}

  ---goyo{{{
  -- distraction free-writing in Vim
  use {
    'junegunn/goyo.vim',
    config = function ()
      vim.g.goyo_width = "120"
      vim.g.goyo_height = "90%"
      vim.api.nvim_set_keymap('n', '<leader>go', '<cmd>Goyo<cr>', { noremap = true })
      vim.cmd [[
        function! s:GoyoEnter()
          if executable('tmux') && strlen($TMUX)
            silent !tmux set -w status off
            silent !tmux list-panes -F '\#F' | grep -q Z || tmux resize-pane -Z
          endif
          lua require'lualine'.hide()
          autocmd VimResized * exe "normal \<c-w>="
          set noshowmode
          set noshowcmd
        endfunction


        function! s:GoyoLeave()
          if executable('tmux') && strlen($TMUX)
            silent !tmux set -w status on
            silent !tmux list-panes -F '\#F' | grep -q Z && tmux resize-pane -Z
          endif
          lua require'lualine'.hide({unhide=true})
          set showmode
          set showcmd
        endfunction

        autocmd! User GoyoEnter nested call <SID>GoyoEnter()
        autocmd! User GoyoLeave nested call <SID>GoyoLeave()
      ]]
    end
  }
  ---}}}

  ---easy align {{{
  -- vim alignment
  use { 'junegunn/vim-easy-align' }
  ---}}}

  ---telescope {{{
  -- find, filter, preview, pick
  use {
    'nvim-telescope/telescope.nvim',
    requires = { 'nvim-telescope/telescope-file-browser.nvim' },
    config = function ()

      local actions = require'telescope.actions'
      local finders = require "telescope.finders"
      local action_state = require "telescope.actions.state"
      local builtin = require "telescope.builtin"
      local themes = require "telescope.themes"

      local function narrow_picker(prompt_bufnr)
        local picker = action_state.get_current_picker(prompt_bufnr)
        local manager = picker.manager
        local results = {}

        if #picker:get_multi_selection() > 0 then
          for _, entry in ipairs(picker:get_multi_selection()) do
              table.insert(results, entry)
              print(vim.inspect(entry))
          end
        else
          for entry in manager:iter() do
              table.insert(results, entry)
          end
        end

        local finder = finders.new_table {
            results = results,
            entry_maker = function(entry) return entry end,
        }

        picker:refresh(finder, { reset_prompt = true })
      end

      local function buffers_instead(prompt_bufnr)
        local picker = action_state.get_current_picker(prompt_bufnr)
        local prompt_text = picker:_get_prompt()
        builtin.buffers(themes.get_ivy({ default_text = prompt_text }))
      end

      local function find_files_instead(prompt_bufnr)
        local picker = action_state.get_current_picker(prompt_bufnr)
        local prompt_text = picker:_get_prompt()
        builtin.find_files(themes.get_ivy({ default_text = prompt_text }))
      end

      -- UFO will not apply folds if we start from insert mode,
      -- so stop insert and performs the same action in normal mode
      local stop_insert_first = function(key)
        return function(prompt_bufnr)
          vim.cmd[[stopinsert]]
          vim.cmd(string.format("exe \"normal %s\"", key))
        end
      end

      require'telescope'.setup {
        defaults = {
          cache_pickers = {
              num_pickers = 20,
              limit_entries = 1000,
          },
          mappings = {
            i = {
              ["<c-g>"] = "close",
              ["<c-q>"] = actions.smart_add_to_qflist,
              ["<c-r>"] = narrow_picker,
              ["<cr>"] = stop_insert_first("\\<cr>"),
              ["<c-x>"] = stop_insert_first("\\<c-x>"),
              ["<c-v>"] = stop_insert_first("\\<c-v>"),
              ["<c-t>"] = false,
            },
            n = {
              ["<c-g>"] = "close",
              ["<c-q>"] = actions.smart_add_to_qflist,
              ["<c-r>"] = narrow_picker,
              ["<c-t>"] = false,
            },
          },
        },
        pickers = {
            buffers = {
              mappings = {
                i = {
                  ["<right>"] = find_files_instead,
                },
                n = {
                  ["<right>"] = find_files_instead,
                },
              },
            },
            find_files = {
              no_ignore = true,
              mappings = {
                i = {
                  ["<left>"] = buffers_instead,
                },
                n = {
                  ["<left>"] = buffers_instead,
                },
              },
            },
        },
      }

      vim.api.nvim_set_keymap('n', '[telescope]', '', { noremap = true })
      vim.api.nvim_set_keymap('n', '<space>', '[telescope]', {})
      vim.keymap.set('n', '[telescope]/', function () builtin.buffers(themes.get_ivy()) end, { noremap = true })
      vim.keymap.set('n', '[telescope]f', function () builtin.live_grep(themes.get_ivy()) end, { noremap = true })
      vim.keymap.set('n', '[telescope]y', function () builtin.registers(themes.get_ivy()) end, { noremap = true })
      vim.keymap.set('n', '[telescope]q', function () builtin.quickfix(themes.get_ivy()) end, { noremap = true })
      vim.keymap.set('n', '[telescope].', function () builtin.resume(themes.get_ivy()) end, { noremap = true })
    end
  }
  ---}}}

  ---orgmode {{{
  -- orgmode clone written in Lua
    use {
      'gzagatti/orgmode',
      branch= 'nested-link',
      requires = { 'nvim-treesitter/nvim-treesitter' },
      config = function ()
        require'orgmode'.setup_ts_grammar()
        require'orgmode'.setup {
          org_indent_mode = 'noindent',
          mappings = {
            org = {
              org_do_promote = '<h',
              org_do_demote = '>h',
            },
          },
          org_agenda_files = {
            vim.env.HOME .. '/org/**/*',
          },
          org_default_notes_file = vim.env.HOME .. '/org/inbox.orgbundle/text.org',
          org_todo_keywords = {
            'TODO(t)', '|', 'POSTPONED(p)', 'CANCELLED(c)', 'DONE(d)'
          }
        }
      end,
    }
  ---}}}

  ---org-goodies{{{
  -- use {
  --   here 'org-goodies.nvim',
  --   requires = { 'nvim-orgmode/orgmode' },
  -- }
  ---}}}

  ---tablemode {{{
  --- instant table creation
    use {
      'dhruvasagar/vim-table-mode',
    }
  ---}}}

  ---cmp {{{
  -- auto-completion for nvim written in Lua
  use {
    'hrsh7th/nvim-cmp',
    requires = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'hrsh7th/vim-vsnip',
      'hrsh7th/cmp-vsnip',
      'gzagatti/cmp-latex-symbols',
      'hrsh7th/cmp-nvim-lua',
    },
    config = function ()

      vim.g.vsnip_snippet_dir = vim.env.HOME.."/.config/nvim/vsnip"

      local cmp = require'cmp'

      -- https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings
      local has_words_before = function ()
        -- table.unpack is not defined, so we cannot fix the warning.
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      local feedkey = function (key, mode)
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
      end

      cmp.setup {
        snippet = {
          expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
          end,
        },
        mapping = {
          ["<Tab>"] = cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_next_item()
              elseif has_words_before() then
                cmp.complete()
              else
                fallback()
              end
            end,
            { "i", "s" }
          ),
          ["<S-Tab>"] = cmp.mapping(function()
              if cmp.visible() then
                cmp.select_prev_item()
              else
                fallback()
              end
            end,
            { "i", "s" }
          ),
          ["<CR>"] = cmp.mapping.confirm { select = true },
          ["<C-Space>"] = cmp.mapping.complete(),
        },
        sources = cmp.config.sources({
          { name = 'vsnip' },
          { name = 'nvim_lsp' },
          { name = 'path' },
          { name = 'nvim_lua' },
          -- override trigger characters, so they don't interfere with snippets
          { name = 'orgmode', trigger_characters = {} },
          { name = 'latex_symbols' },
          { name = 'buffer', keyword_length = 3 },
        }),
      }

      vim.api.nvim_set_keymap('i', '<right>', 'vsnip#jumpable(1) ? "<Plug>(vsnip-jump-next)" : ""', { expr = true, noremap = true })
      vim.api.nvim_set_keymap('s', '<right>', 'vsnip#jumpable(1) ? "<Plug>(vsnip-jump-next)" : ""', { expr = true, noremap = true })
      vim.api.nvim_set_keymap('i', '<left>', 'vsnip#jumpable(-1) ? "<Plug>(vsnip-jump-prev)" : ""', { expr = true, noremap = true })
      vim.api.nvim_set_keymap('s', '<left>', 'vsnip#jumpable(-1) ? "<Plug>(vsnip-jump-prev)" : ""', { expr = true, noremap = true })

      function cmp_sources_list(arglead, _, _)
        -- the API does not allow for the retrieval of sources from cmdline
        local global_sources = require'cmp.config'.global.sources
        local out = {}
        for i = 1,#global_sources do
          if global_sources[i].name:find("^" .. arglead) ~= nil then
           out[#out + 1] = global_sources[i].name
          end
        end
        return out
      end

      function disable_cmp_source(name)
          local current_sources = cmp.get_config().sources
          local new_sources = {}
          for i = 1,#current_sources do
            if current_sources[i].name ~= name then
              new_sources[i] = current_sources[i]
            end
          end
          cmp.setup.buffer({sources = new_sources})
      end

      function enable_cmp_source(name)
          local global_sources = require'cmp.config'.global.sources
          local new_sources = cmp.get_config().sources
          for i = 1,#global_sources do
            if global_sources[i].name == name then
              new_sources[#new_sources+1] = global_sources[i]
            end
          end
          cmp.setup.buffer({sources = new_sources})
      end

      vim.cmd [[ command! -nargs=1 -complete=customlist,v:lua.cmp_sources_list CmpDisable lua disable_cmp_source(<f-args>) ]]
      vim.cmd [[ command! -nargs=1 -complete=customlist,v:lua.cmp_sources_list CmpEnable lua enable_cmp_source(<f-args>) ]]

    end
  }
  ---}}}

  ---gnupg {{{
  -- easy gpg handling
  use {
    'jamessan/vim-gnupg',
    config = function () vim.g['GPGPreferSymmetric'] = 1 end
  }
  ---}}}

  ---emmet {{{
  -- improves HTML and CSS workflow
  use {
    'mattn/emmet-vim',
    ft = {'html', 'css'}
  }
  ---}}}

  ---asciidoctor {{{
  -- asciidoctor support
  use {
    'habamax/vim-asciidoctor',
    config =  function ()

      vim.g['asciidoctor_folding'] = 1
      vim.g['asciidoctor_fold_options'] = 1
      vim.g['asciidoctor_fenced_languages'] = { 'sh', 'css' }
      vim.g['asciidoctor_extensions'] = { 'asciidoctor-tufte', 'asciidoctor-bibtex' }
      vim.g['asciidoctor_autocompile'] = 0

      vim.cmd [[
        function! s:ToggleAsciidoctorAutocompile()
          augroup asciidoctor
            autocmd!
            if g:asciidoctor_autocompile == 0
              autocmd BufWritePost *.adoc :execute "silent normal! mq" ':Asciidoctor2HTML' "\r`q"
            endif
          augroup END
          if g:asciidoctor_autocompile == 0
            let g:asciidoctor_autocompile = 1
            echo "asciidoctor: Compiler started in continuous mode"
          else
            let g:asciidoctor_autocompile = 0
            echo "asciidoctor: Compiler stopped"
          endif
        endfunction
      ]]
    end
  }
  ---}}}

  ---sniprun {{{
  -- run lines/blocs of code (independently of the rest of the file)
  use {
    'michaelb/sniprun',
    run = "bash ./install.sh 1",
    config = function ()
      require'sniprun'.setup {
        repl_enable = {'Python3_jupyter', 'Julia_jupyter'},
        interpreter_options = {
          Python3_original = {
            interpreter = 'python',
          },
          Julia_original = {
            interpreter = 'julia',
          },
        },
        snipruncolors = {
          SniprunVirtualTextOk = {bg="#66eeff",fg="#000000",ctermbg="61",cterfg="black"},
        }
      }
    end
  }
  ---}}}

  ---luadev {{{
  -- REPL/debug console for nvim
    use {
      -- 'bfredl/nvim-luadev',
      'gzagatti/nvim-luadev',
      config = function ()
          vim.api.nvim_set_keymap('n', '<leader>ee', '<plug>(Luadev-RunLine):Luadev<cr>', { silent= true })
          vim.api.nvim_set_keymap('v', '<leader>ee', '<plug>(Luadev-Run):Luadev<cr>', { silent=true })
          vim.api.nvim_set_keymap('n', '<leader>ev', '<plug>(Luadev-RunVimLine):Luadev<cr>', { silent= true })
          vim.api.nvim_set_keymap('v', '<leader>ev', '<plug>(Luadev-RunVim):Luadev<cr>', { silent= true })
      end
    }
  ---}}}

  ---minimap {{{
  -- a dotted minimap of the file
    use {
      'wfxr/minimap.vim',
      config = function ()
        vim.g ['minimap_auto_start'] = 0
        vim.g ['minimap_auto_start_win_enter'] = 0
        vim.api.nvim_set_keymap('n', '<f10>', ':MinimapToggle<cr>', { noremap = true })
      end
    }
  ---}}}

  ---treesiter {{{
  -- an incremental parsing system for programming tools
    use {
      'nvim-treesitter/nvim-treesitter',
      run = ':TSUpdate',
      config = function ()
        require'nvim-treesitter.install'.update()
        require'nvim-treesitter.configs'.setup {
          ensure_installed = 'all', -- one of 'all', 'maintained', or a list of languages
          ignore_install = { }, -- List of parsers to ignore installing
          highlight = {
            enable = true,
            -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
            -- Set to `true` if you depend on 'syntax' being enabled.
            -- This option may slow down the editor, and cause duplicate highlights.
            -- Instead of true it can also be a list of languages
            -- additional_vim_regex_highlighting = { 'org' },
            additional_vim_regex_highlighting = false,
          },
          incremental_selection = {
            enable = true,
            keymaps = {
              init_selection = 'gnn',
              node_incremental = 'n',
              scope_incremental = 'gs',
              node_decremental = 'N',
            },
          },
          indent = {
            enable = true,
            disable = { "julia" }
          },
          query_linter = {
            enable = true,
            use_virtual_text = true,
            lint_events = {"BufWrite", "CursorHold"},
          },
        }
    end
  }
  -- debugging and learning about treesitter
    use {
      'nvim-treesitter/playground',
      requires = { 'nvim-treesitter/nvim-treesitter', opt = true }
    }
  ---}}}

  ---neogit {{{
  use {
    'NeogitOrg/neogit',
    requires = { 'nvim-lua/plenary.nvim' },
    config = function ()
      require'neogit'.setup {
        use_magit_keybindings = true,
        disable_commit_confirmation = true,
        commit_popup = {
            kind = "split",
        },
      }
    end,
  }
  ---}}}

  ---fugitive {{{
  use {
      'tpope/vim-fugitive'
  }
  ---}}}

  ---lsp config {{{
  -- neovim built-in language server
    use {
      'neovim/nvim-lspconfig',
      requires = {
        'hrsh7th/nvim-cmp',
        'barreiroleo/ltex-extra.nvim'
      },
      config = function ()

        ----config {{{
        vim.lsp.set_log_level("INFO")

        local lspconfig = require'lspconfig'

        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities = require'cmp_nvim_lsp'.default_capabilities()

        local opts = { noremap=true, silent=true }

        vim.api.nvim_set_keymap('n', 'gS', '<cmd>lua vim.lsp.stop_client(vim.lsp.get_active_clients())<cr>',
          { noremap = true})

        -- on_attach is only called after the language server
        -- attaches to the buffer
        local on_attach = function(client, bufnr)

          print("Attaching ", client.name, " LSP in buffer ", bufnr, "...")

          -- diagnostic
          diagnostic_picker = function()

            local builtin = require "telescope.builtin"
            local themes = require "telescope.themes"
            local actions = require "telescope.actions"
            local action_state = require "telescope.actions.state"

            local _diagnostic_picker = nil

            local function toggle_diagnostic(prompt_bufnr)
              local picker = action_state.get_current_picker(prompt_bufnr)
              local prompt_text = picker:_get_prompt()
              if picker.prompt_title == "Diagnostics - Buffer" then
                new_prompt_title = "Diagnostics - Workspace"
                new_key = "<left>"
                new_picker_bufnr = nil
              else
                new_prompt_title = "Diagnostics - Buffer"
                new_key = "<right>"
                new_picker_bufnr = 0
              end
              pcall(actions.close, prompt_bufnr)
              _diagnostic_picker(new_prompt_title, prompt_text, new_picker_bufnr, new_key)
            end

            _diagnostic_picker = function(prompt_title, default_text, bufnr, key)
              builtin.diagnostics(themes.get_ivy({
                prompt_title = prompt_title,
                default_text = default_text,
                bufnr = bufnr,
                attach_mappings = function(_, map)
                  map({"i", "n"}, key, toggle_diagnostic)
                  return true
                end,
              }))
            end

            _diagnostic_picker("Diagnostics - Buffer", ":error:", 0, "<right>")

          end

          vim.keymap.set('n', '[telescope]l', function() diagnostic_picker(nil) end)

          local diagnostic_hidden = {}

          function diagnostic_toggle(toggle_bufnr, revert)
            toggle_bufnr = vim.api.nvim_buf_get_number(toggle_bufnr) print("Toggle diagnostics", toggle_bufnr, diagnostic_hidden[toggle_bufnr])
            if (diagnostic_hidden[toggle_bufnr] and not revert) or
              (not diagnostic_hidden[toggle_bufnr] and revert) then
              vim.diagnostic.enable(toggle_bufnr, nil)
              diagnostic_hidden[toggle_bufnr] = false
            else
              vim.diagnostic.disable(toggle_bufnr, nil)
              diagnostic_hidden[toggle_bufnr] = true
            end
          end

          vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gl',
            '<cmd>lua diagnostic_toggle(0)<cr>', opts)
          vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gL',
            '<cmd>lua vim.diagnostic.open_float()<cr>', opts)
          vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gn',
            '<cmd>lua vim.diagnostic.goto_next()<cr>', opts)
          vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gp',
            '<cmd>lua vim.diagnostic.goto_prev()<cr>', opts)

          -- documentation help
          vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD',
            '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
          vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd',
            '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
          vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K',
            '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)

          -- code action
          vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gA',
            '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)

          -- variable management
          vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr',
            '<cmd>lua vim.lsp.buf.rename()<cr>', opts)

          -- formatting
          vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gQ',
            '<cmd>lua vim.lsp.buf.formatting()<cr>', opts)

          -- language specific
          if (client.name == 'texlab') then
            vim.api.nvim_buf_set_keymap(bufnr, 'n', '<c-c><c-c>',
              '<cmd>echo \'Building file.\'<cr><cmd>TexlabBuild<cr>', opts)
            vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gt',
              '<cmd>TexlabForward<cr>', opts)
          end

          if (client.name == "ltex") then
            -- tmpdir = vim.api.nvim_eval[[tempname()]] .. "-ltex"
            require'ltex_extra'.setup {
              load_langs = { 'en-US' },
              init_check = true,
              path = '.ltex', -- tmpdir
              log_level = "info"
            }
          end
        end

        local function my_config(config)
          config = config or {}
          local defaults = {
            on_attach = on_attach,
            autostart = false,
            capabilities = capabilities,
          }
          return vim.tbl_deep_extend("keep", config, defaults)
        end
        ----}}}

      ----servers {{{
      -- https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md
      -- to check status: :lua vim.cmd('split'..vim.lsp.get_log_path())
      -- to check start options: :help lsp.start

      -----vim {{{
      -- server deployed with npm
      lspconfig.vimls.setup(my_config())
      -----}}}

      -----html {{{
      -- server deployed with npm
      lspconfig.html.setup(my_config())
      -----}}}

      -----julia {{{
      -- server deployed with Julia
      lspconfig.julials.setup(my_config())
      -----}}}

      -----python {{{
      -- server deployed with Homebrew
      lspconfig.pyright.setup(
        my_config({
            settings = {
              python = {
                venvPath = vim.env.HOME .. '/.pyenv/versions'
              }
            }
        })
      )
      -----}}}

      -----json {{{
      -- server deployed with npm
      lspconfig.jsonls.setup(my_config())
      -----}}}

      -----text {{{
      -- server deployed with Homebrew
      lspconfig.ltex.setup(
        my_config({
          settings = {
            ltex = {
              disabledRules = {
                -- ["en"]    = { "PROFANITY" }, -- "MORFOLOGIK_RULE_EN"
                -- ["en-GB"] = { "PROFANITY" }, -- "MORFOLOGIK_RULE_EN_GB"
                ["en-US"] = { "PROFANITY" }, -- "MORFOLOGIK_RULE_EN_US",
              },
            },
          },
          get_language_id = function(bufnr, filetype)
              buf_name = vim.api.nvim_buf_get_name(bufnr)
              if buf_name:match(".sty$") then
                -- set the language-id, to one for which ltex parsing is disabled
                -- see allowed ids: https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#textDocumentItem
                return "lua"
              else
                -- from nvim-lspconfig/lua/lua/lspconfig/server_configurations/ltex.lua
                language_id_mapping = {
                    bib = 'bibtex',
                    plaintex = 'tex',
                    rnoweb = 'sweave',
                    rst = 'restructuredtext',
                    tex = 'latex',
                    xhtml = 'xhtml',
                }
              local language_id = language_id_mapping[filetype]
                if language_id then
                  return language_id
                else
                  return filetype
                end
              end
          end
        })
      )
      -----}}}

      -----latex {{{
      -- server deployed with Homebrew
      -- https://github.com/wbthomason/dotfiles/blob/linux/neovim/.config/nvim/plugin/lsp.lua#L168
      lspconfig.texlab.setup(
        my_config({
          settings = {
            texlab = {
              build = { args = { "-lualatex", "-interaction=nonstopmode", "--shell-escape", "-synctex=1", "%f" } },
              chktex = { onOpenAndSave = true, },
              formatterLineLengh = 0,
              forwardSearch = { executable = 'zathura', args = {  '--synctex-forward=%l:1:%f', '%p' } },
            },
          },
        })
      )
      -----}}}

      -----clang {{{
      -- server deployed with Homebrew
      lspconfig.ccls.setup(
        my_config({
          init_options = {
            cache = {
              directory = ".ccls-cache",
            }
          }
        })
      )
      -----}}}

      -----lua {{{
      -- server deployed internally
      -- https://github.com/wbthomason/dotfiles/blob/linux/neovim/.config/nvim/plugin/lsp.lua#L153
      lspconfig.lua_ls.setup(
        my_config({
        settings = {
            Lua = {
              diagnostics = {
                globals = { "vim" },
                disable = { "lowercase-global" },
                runtime = { version = "LuaJIT", path = vim.split(package.path, ';') },
                workspace = {
                  library = {
                    [vim.fn.expand "$VIMRUNTIME/lua"] = true,
                    [vim.fn.expand "$VIMRUNTIME/lua/vim/lsp"] = true,
                  },
                },
              },
            },
          },
        })
      )
      -----}}}

      -----ruby {{{
      -- server deployed with Homebrew
      lspconfig.solargraph.setup(
        my_config({
          settings = {
            solargraph = {
              diagnostic = true,
              useBundler = true
            },
          },
        })
      )
      -----}}}

      -----css {{{
      -- server deployed with Homebrew
      lspconfig.stylelint_lsp.setup(
        my_config({
          settings = {
              stylelintplus = {
                autoFixOnSave = true,
                autoFixOnFormat = true
            },
          },
        })
      )
      -----}}}

      -----racket {{{
      lspconfig.racket_langserver.setup(my_config())
      -----}}}

      -----r {{{
      lspconfig.r_language_server.setup(my_config())
      -----}}}

      ----}}}
      end,
    }
  ---}}}

  ---aerial {{{
  -- code outline window
  use {
    'stevearc/aerial.nvim',
    config = function()
      require'aerial'.setup({
        layout = {
            default_direction = "right",
        },
      })
      vim.api.nvim_set_keymap('n', '<f9>', '<cmd>AerialToggle! right<CR>', { noremap = true })
    end
  }
  ---}}}

  ---hologram {{{
  -- image viewer for Neovim
  -- use {
  --   here  'hologram.nvim',
  --   config = function()
  --     require'hologram'.setup()
  --   end,
  -- }
  ---}}}

  ---clipboard image {{{
  -- paste image from clipboard
  use {
    'gzagatti/clipboard-image.nvim',
    config = function()

      local function uuid_name()
        local img_dir = vim.fn.expand("%:p:h") .. "/assets"
        img_dir = io.popen('ls "'..img_dir..'" 2>/dev/null')
        local files = {}
        if img_dir ~= nil then
          for filename in img_dir:lines() do
            filename = filename:match("(.+)%..+$")
            if filename ~= nil then files[filename] = true end
          end
          img_dir.close()
        end
        repeat
          uuid = vim.fn.call("system", {"uuidgen"}):sub(10, 13)
        until files[uuid] == nil
        return uuid
      end

      local function resize(img)
        os.execute(string.format(
          'mogrify -quality 95 -resize "600x400>" "%s"',
          img.path
        ))
      end

      require'clipboard-image'.setup {
        default = {
          img_dir = {"%:p:h"},
          img_dir_txt = ".",
        },
        org = {
          img_dir = {"%:p:h", "assets"},
          img_dir_txt = "./assets",
          img_name = uuid_name,
          affix = "[[%s]]",
          img_handler = resize,
        },
        tex = {
          img_dir = {"%:p:h", "assets"},
          img_dir_txt = "./assets",
          img_name = uuid_name,
          affix = "\\includegraphics{%s}",
          img_handler = resize,
        }
      }

      vim.api.nvim_create_user_command(
        'PastePNG',
        function(opts) require'clipboard-image.paste'.paste_img({img_format='png'}) end,
        { nargs = 0 }
      )
      vim.api.nvim_create_user_command(
        'PasteJPG',
        function(opts) require'clipboard-image.paste'.paste_img({img_format='jpg'}) end,
        { nargs = 0 }
      )

    end,
  }
  --}}}

  ---nabla {{{
  -- equation rendering
  -- TODO support LaTex equations
  -- TODO support visual selection
  -- use {
  --   'jbyuki/nabla.nvim',
  --   config = function()
  --     vim.api.nvim_set_keymap('n', '<leader>gE', "<cmd>lua require'nabla'.popup()<cr>", { noremap=true })
  --   end,
  -- }
  --}}}

  ---beancount {{{
  -- support for beancount files
  use { 'nathangrigg/vim-beancount' }
  --}}}

  ---drawit {{{
  -- ASCII drawing plugin
  use { 'vim-scripts/DrawIt' }
  --}}}

  ---venn {{{
  -- draw ASCII diagrams
  use { 'jbyuki/venn.nvim' }
  --}}}

  ---theme: dracula {{{
  use {
    'dracula/vim',
    config = function ()
      if (vim.env.THEME == 'dracula') or (vim.env.THEME == nil) then
        vim.cmd [[
          colorscheme dracula
        ]]
      end
    end
  }
  ---}}}

  ---theme: leuven {{{
  use {
    'gzagatti/vim-leuven-theme',
    config = function ()
      if (vim.env.THEME == 'leuven') then
        vim.cmd [[
          colorscheme leuven
        ]]
      end
    end
  }
  ---}}}

  end,
  config = {
    package_root = package_root,
    compile_path = compile_path,
    auto_clean = true,
  },
}
end
--}}}

--config {{{
_G.load_config = function()

--basic settings {{{

---basic {{{
vim.opt.encoding = 'utf-8'
vim.opt.lazyredraw = true
---}}}

---colors {{{
vim.opt.termguicolors = true
vim.opt.guicursor = 'a:blinkon0-Cursor,i-ci:ver100'
---}}}

---leaders {{{
vim.g.mapleader = ';'
vim.g.maplocalleader = '\\'
--}}}

---mouse {{{
if vim.fn.has('mouse') then
  vim.opt.mouse= 'nv'
  -- do not scroll in insert
  vim.api.nvim_set_keymap('i', '<Up>', '<nop>', { noremap = true })
  vim.api.nvim_set_keymap('i', '<Down>', '<nop>', { noremap = true })
  vim.api.nvim_set_keymap('i', '<Right>', '<nop>', { noremap = true })
  vim.api.nvim_set_keymap('i', '<Left>', '<nop>', { noremap = true })
end
---}}}

---autocompletion {{{
vim.opt.wildmenu = true -- autocomplete feature when cycling through TAB
vim.opt.wildmode = 'longest:full,full'
vim.opt.wildignorecase = true
vim.opt.completeopt = 'menu,menuone,noselect'
---}}}

---line ruler {{{
vim.opt.number = true
vim.opt.numberwidth = 4
--}}}

---white space {{{
vim.opt.wrap = true
vim.opt.shiftround = true
local indent = 2
vim.opt.shiftwidth = indent
vim.opt.softtabstop = indent
vim.opt.expandtab = true
vim.opt.backspace = 'indent,eol,start'
vim.opt.list = true
vim.opt.listchars = { tab = '»·', trail = '·', extends = '›', precedes = '‹', nbsp = '␣'}
--}}}

---folding {{{
vim.o.foldcolumn = "0"
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = true
--}}}

---searching {{{
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = false
---}}}

---buffers {{{
vim.opt.switchbuf = 'useopen'
vim.opt.autowriteall = true
vim.opt.autoread = true
vim.cmd [[
  autocmd FocusGained,CursorHold * if getcmdwintype() == '' | checktime | endif
]]
---}}}

---backup and swap files {{{
vim.opt.backupdir = vim.env.HOME .. '/.local/share/nvim/swap' -- backup files
vim.opt.directory = vim.env.HOME .. '/.local/share/nvim/swap' -- swap files
---}}}

---tags {{{
vim.opt.tags='.git/tags,tags,./tags'
---}}}

---sign column {{{
vim.cmd [[
  highlight SignColumn ctermbg=NONE guibg=NONE
]]
vim.opt.signcolumn = 'number'
---}}}

---status line {{{
vim.opt.laststatus = 2
---}}}

---auto save {{{
vim.cmd [[
  augroup auto_save
    autocmd!
    au CursorHold,InsertLeave * silent! wall
  augroup END
]]
---}}}

---newtrw{{{
vim.cmd [[
  let g:netrw_browsex_viewer= "-"
  function! s:myNFH(filename)
    if executable("xdg-open")
      let cmd = ":!xdg-open "
    elseif executable("open")
      let cmd = ":!open "
    else
      return 0
    endif
    let path = "file://" . expand("%:p:h") . "/" . a:filename
    execute cmd . shellescape(path, 1)
    return 1
  endfunction
  function! NFH_jpg(filename)
    call s:myNFH(a:filename)
  endfunction
  function! NFH_png(filename)
    call s:myNFH(a:filename)
  endfunction
  function! NFH_svg(filename)
    call s:myNFH(a:filename)
  endfunction
  function! NFH_gif(filename)
    call s:myNFH(a:filename)
  endfunction
  function! NFH_pdf(filename)
    call s:myNFH(a:filename)
  endfunction
]]
---}}}

---filetype plugins {{{
vim.cmd [[
  filetype plugin indent on
]]
---}}}

---providers {{{
-- python
vim.g['loaded_python_provider'] = 0
vim.g['python3_host_prog'] = vim.env.HOME .. "/.pyenv/versions/vim3/bin/python"

-- ruby
vim.g['loaded_ruby_provider'] = 0

--perl
vim.g['loaded_perl_provider'] = 0
---}}}

---terminal {{{
vim.api.nvim_set_keymap('t', '<c-h>', '<C-\\><C-N><C-w>h', { noremap = true })
vim.api.nvim_set_keymap('t', '<c-j>', '<C-\\><C-N><C-w>j', { noremap = true })
vim.api.nvim_set_keymap('t', '<c-k>', '<C-\\><C-N><C-w>k', { noremap = true })
vim.api.nvim_set_keymap('t', '<c-l>', '<C-\\><C-N><C-w>l', { noremap = true })
vim.cmd [[
  au TermOpen * setlocal nonumber
]]
---}}}

---quickfix {{{
vim.cmd[[packadd cfilter]]
---}}}

--}}}

--key mappings {{{

---.vimrc {{{
--open .vimrc in a horizantal split$
vim.api.nvim_set_keymap('n', '<leader><f4>', ':split $MYVIMRC<cr>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader><f5>', ':source $MYVIMRC<cr>:PackerCompile<cr>', { noremap = true })
---}}}

---map j and k such that is based on display lines, not physical ones {{{
vim.api.nvim_set_keymap('', 'j', 'gj', { noremap = true })
vim.api.nvim_set_keymap('', 'k', 'gk', { noremap = true })
if (vim.g['kitty_navigator_no_mappings'] == 1) and (vim.g['tmux_navigator_no_mappings'] == 1) then
  vim.api.nvim_set_keymap('', '<c-h>', '<cmd>wincmd h<cr>', { noremap = true })
  vim.api.nvim_set_keymap('', '<c-j>', '<cmd>wincmd j<cr>', { noremap = true })
  vim.api.nvim_set_keymap('', '<c-k>', '<cmd>wincmd k<cr>', { noremap = true })
  vim.api.nvim_set_keymap('', '<c-l>', '<cmd>wincmd l<cr>', { noremap = true })
end
---}}}

---moving laterally when concealed {{{
-- https://stackoverflow.com/questions/12397103/the-conceal-feature-in-vim-still-makes-me-move-over-all-the-characters
-- https://github.com/albfan/ag.vim/commit/bdccf94877401035377aafdcf45cd44b46a50fb5
vim.cmd [[
  function! s:ForwardSkipConceal(count)
    let cnt=a:count
    let mvcnt=0
    let c=col('.')
    let l=line('.')
    let lc=col('$')
    let line=getline('.')
    while cnt
      if c>=lc
        let mvcnt+=cnt
        break
      endif
      if stridx(&concealcursor, 'n')==-1
        let isconcealed=0
      else
        let [isconcealed, cchar, group]=synconcealed(l, c)
      endif
      if isconcealed
        let cnt-=strchars(cchar)
        let oldc=c
        let c+=1
        while c<lc && synconcealed(l, c)[0]
          let c+=1
        endwhile
        let mvcnt+=strchars(line[oldc-1:c-3])
      else
        let cnt-=1
        let mvcnt+=1
        let c+=len(matchstr(line[c-1:], '.'))
      endif
    endwhile
    "exec "normal ".mvcnt."l"
    return ":\<C-u>\e".mvcnt."l"
  endfunction

  function! s:BackwardSkipConceal(count)
    let cnt=a:count
    let mvcnt=0
    let c=col('.')
    let l=line('.')
    let lc=1
    let line=getline('.')
    while cnt
      if c<=lc
        let mvcnt+=cnt
        break
      endif
      if stridx(&concealcursor, 'n')==-1
        let isconcealed=0
      else
        let [isconcealed, cchar, group]=synconcealed(l, c)
      endif
      if isconcealed
        let cnt-=strchars(cchar)
        let oldc=c
        let c-=1
        while c>lc && synconcealed(l, c)[0]
          let c-=1
        endwhile
        let mvcnt+=strchars(line[c+1:oldc-1])
      else
        let cnt-=1
        let mvcnt+=1
        let c+=len(matchstr(line[c-1:], '.'))
      endif
    endwhile
    "exec "normal ".mvcnt."h"
    return ":\<C-u>\e".mvcnt."h"
  endfunction

  function! s:ToggleConceal()
    if &conceallevel==0
      set conceallevel=2 conceallevel?
    else
      set conceallevel=0 conceallevel?
    endif
  endfunction

  nnoremap <expr> <silent> <buffer> l <SID>ForwardSkipConceal(v:count1)
  nnoremap <expr> <silent> <buffer> h <SID>BackwardSkipConceal(v:count1)
  nnoremap <expr> <leader>hc <SID>ToggleConceal()
]]

vim.opt.conceallevel = 0
vim.opt.concealcursor = 'c'
---}}}

---copy/paste mode toggle and shortcuts {{{
-- vim.api.nvim_set_keymap('n', '<f4>', ':set invpaste paste?<cr>', {})
-- vim.api.nvim_set_keymap('i', '<f4>', '<c-o>:set invpaste paste?<cr>', {})
if vim.fn.has('mac') == 1 then
  vim.api.nvim_set_keymap('', '<leader>p', '"*p', {})
  vim.api.nvim_set_keymap('', '<leader>y', '"*y', {})
elseif vim.fn.has('unix') == 1 then
  vim.api.nvim_set_keymap('', '<leader>p', '"+p', {})
  vim.api.nvim_set_keymap('', '<leader>y', '"+y', {})
end
---}}}

---line transposition {{{
vim.api.nvim_set_keymap('n', '<s-down>', ':set fdm=manual<cr>:m .+1<cr>:set fdm=marker<cr>', { noremap = true })
vim.api.nvim_set_keymap('n', '<s-up>', ':set fdm=manual<cr>:m .-2<cr>:set fdm=marker<cr>', { noremap = true })
vim.api.nvim_set_keymap( 'v', '<s-down>', '<esc>:set fdm=manual<cr>\'<V\'>:m \'>+1<cr>:set fdm=marker<cr>gv',
  { noremap = true })
vim.api.nvim_set_keymap( 'v', '<s-up>', '<esc>:set fdm=manual<cr>\'<V\'>:m \'<-2<cr>:set fdm=marker<cr>gv',
  { noremap = true })
---}}}

---select last inserted text {{{
vim.api.nvim_set_keymap('n', 'gV', '`[v`]', { noremap = true })
---}}}

---write with capital W{{{
vim.cmd [[
  command! W w
]]
---}}}

---delete trailling whitespace {{{
vim.api.nvim_set_keymap('n', '<leader>dt', ':execute "silent normal! mq" \':%s/\\s\\+$//ge\' "\\r`q"<cr>',
  { silent = true })
---}}}

---starts very magic regex {{{
vim.api.nvim_set_keymap('n', '/', '/\\v', { noremap = true })
vim.api.nvim_set_keymap('n', '?', '?\\v', { noremap = true })
---}}}

--- command-line window {{{
-- maps for the command-line window get on the way of quitting Vim
vim.api.nvim_set_keymap('n', 'q:', '', { nowait = true, noremap = true })
vim.api.nvim_set_keymap('n', 'q/', '', { nowait = true, noremap = true })
vim.api.nvim_set_keymap('n', 'q?', '', { nowait = true, noremap = true })
vim.api.nvim_set_keymap('n', 'c:', 'q:', { noremap = true })
vim.api.nvim_set_keymap('n', 'c/', 'q/', { noremap = true })
vim.api.nvim_set_keymap('n', 'c?', 'q?', { noremap = true })
---}}}

--}}}

--cmd {{{
-- reloads a lua module
function loaded(arglead, _, _)
  local out = {}
  for k, _ in pairs(package.loaded) do
    if k:find("^" .. arglead) ~= nil then
      out[#out + 1] = k
    end
  end
  return out
end

function reload(modname)
  local _loaded = loaded(modname, _, _)
  for _, k in ipairs(_loaded) do
    if modname == k then
      package.loaded[modname] = nil
      require(modname)
      print("Lua module", modname, "reloaded.")
      return
    end
  end
  require(modname)
  print("Lua module", modname, "loaded.")
end

vim.cmd [[ command! -nargs=1 -complete=customlist,v:lua.loaded Luareload lua reload(<f-args>) ]]
-- }}}

--autocmd {{{
vim.cmd [[
  augroup vimrctweaks
    autocmd!

    "create directory if not exist
    function! s:auto_mkdir(dir, force)
      if !isdirectory(a:dir)
            \ && (
            \     a:force
            \     || input("'" . a:dir . "' does not exist. Create? [y/N]") =~? '^y\%[es]$'
            \    )
          call mkdir(iconv(a:dir, &encoding, &termencoding), 'p')
      endif
    endfunction
    autocmd BufWritePre * call s:auto_mkdir(expand('<afile>:p:h'), v:cmdbang)

    "configuration files
    autocmd BufNewFile,BufRead *.*rc,*rc,init.lua setlocal foldmethod=marker

    "leave the command-line window
    autocmd CmdwinEnter * nmap <buffer> <nowait> q :quit<cr>

    "remove item from quickfix/loclist window
    function! Remove_from_qf()
      let l:qfvar = getwininfo(win_getid())[0]['quickfix']
      let l:llvar = getwininfo(win_getid())[0]['loclist']
      let l:iniline = line('.')
      if l:qfvar == 1
        if l:llvar == 1
          call setloclist(0, filter(getloclist(0), {idx -> idx != line('.') - 1}), 'r')
        else
          call setqflist(filter(getqflist(), {idx -> idx != line('.') - 1}), 'r')
        endif
        exe "exe " .. l:iniline
      endif
    endfunction
    autocmd FileType qf nnoremap <buffer> <silent> dd :call Remove_from_qf()<CR>
    autocmd FileType qf nnoremap <buffer> <silent> <nowait> q :cclose<CR>

    "rmd
    " adds vim-markdown as a filetype plugin in order to allow
    " for syntax highlighing and folding.
    autocmd FileType rmd runtime ftplugin/markdown.vim
    autocmd FileType rmd runtime after/ftplugin/markdown.vim

    "julia
    autocmd BufNewFile,BufRead *.jl set filetype=julia
    " to get the syntax highlighing working in markdown, you need to add a
    " syntax for Julia which does not come default with NeoVim
    " https://github.com/JuliaEditorSupport/julia-vim/tree/master/syntax
    autocmd BufNewFile,BufRead *.jmd set filetype=markdown

    "latex
    autocmd BufNewFile,BufRead *.tex set filetype=tex
    " autocmd BufDelete *.tex silent! execute ":!cd " . expand("<afile>:h") . "; latexmk -c " . expand("<afile>:t")

    "asciidoctor
    autocmd Filetype asciidoctor nnoremap <leader>ll :call ToggleAsciidoctorAutocompile()<cr>
    autocmd Filetype asciidoctor nnoremap <leader>lv :silent AsciidoctorOpenHTML<cr>

    "elisp
    autocmd BufNewFile,BufRead *.elisp set filetype=elisp

    "direnv
    autocmd BufNewFile,BufRead .envrc set filetype=sh

  augroup END
]]
---}}}

end
-- }}}

load_plugins()
load_config()
