# NixVim docs:    https://nix-community.github.io/nixvim/
# Neovim Options: https://nix-community.github.io/nixvim/NeovimOptions/index.html

{ pkgs, ... }:
{
  enable = true;
  defaultEditor = true;
  vimAlias = true;
  viAlias = true;

  # TODO colorscheme & syntax highlighting
  colorschemes.gruvbox = {
    enable = true;
  };

  plugins = {
    # List of Plugins Available: https://github.com/nix-community/nixvim/tree/main/plugins/by-name

    # Language Server Protocol bits: // TODO disable auto-'correction' of c source files whitespace formatting etc..
    #lspkind.enable = true;
    #lsp-format.enable = true;
    #lsp-status.enable = true;
    #lsp.enable = true;

    # Set background text etc..
    dashboard = {
      enable = true;
      settings = {
        config = {
          header = [
            " █████   █████ █████ ██████   ██████ █████ █████    █████ █████"
            "░░███   ░░███ ░░███ ░░██████ ██████ ░░███ ░░███    ░░███ ░░███ "
            " ░███    ░███  ░███  ░███░█████░███  ░███  ░███     ░░███ ███  "
            " ░███    ░███  ░███  ░███░░███ ░███  ░███  ░███      ░░█████   "
            " ░░███   ███   ░███  ░███ ░░░  ░███  ░███  ░███       ░░███    "
            "  ░░░█████░    ░███  ░███      ░███  ░███  ░███      █ ░███    "
            "    ░░███      █████ █████     █████ █████ ███████████ █████   "
            "     ░░░      ░░░░░ ░░░░░     ░░░░░ ░░░░░ ░░░░░░░░░░░ ░░░░░    "
            ""
          ];
          shortcut = [ { desc = "leader = <space>"; } ];
          disable_move = true;
          packages.enable = false;
          #project.limit = 5;
          project.enable = false;
          mru.limit = 15;
          footer = [
            ""
            "nixvim (neovim) - Configured with ❤️ in Cambridge, UK"
          ];
        };
      };
    };

    # Show prompt when pressing the <leader> key, to help remind what shortcuts are available and what they do
    which-key.enable = true;
    # NB: menu layout configured below with the keymaps

    # Git Plugins:
    gitblame = {
      enable = true;
      # TODO: disable by default
      settings = {
        message_template = " <author>, <date>";
        date_format = "%a %d %b %Y";
      };
    };
    lazygit.enable = true;
    gitsigns = {
      # Annotate git status line-by-line in the lefthand column
      enable = true;
      settings = {
        signs = {
          add.text = "+";
          change.text = "±";
          delete.text = "_";
          topdelete.text = "‾";
          changedelete.text = "~";
          untracked.text = "┆";
        };
        signcolumn = true;
        watch_gitdir.follow_files = true;
        current_line_blame = false;
      };
    };

    # Show tabs for different open buffers
    barbar = {
      enable = true;
    };

    # Prettify the status bar at the bottom:
    lualine.enable = true;

    # File Explorere sidebar
    web-devicons.enable = true;
    nvim-tree = {
      enable = true;
      modified.enable = true;
      # show all dotfiles and dotdirs, but hide .git dir:
      #filters.custom = [
      #  ".git"
      #];
    };

    # Floating terminal 'window':
    floaterm = {
      enable = true;
      settings = {
        width = 0.8;
        height = 0.6;
        autoclose = 1; # Close window only if the job exits normally
        keymap_new = "<leader>t";
        keymap_prev = "<leader>ap";
        keymap_next = "<leader>an";
        keymap_toggle = "<leader>at";
        keymap_kill = "<leader>ak";
      };
    };

    # Telescope: Fuzzy finder / grep functionality
    telescope = {
      enable = true;
      settings.defaults.layout_strategy = "vertical";
    };

    # Tree-sitter (Syntax Highlighting, indentation, folding etc..)
    treesitter.enable = true;
    # LSP (Code completion, Diagnostics, Formatting, etc..)
    lsp = {
      enable = true;
      servers = {
        #    asm_lsp.enable = true;
        bashls.enable = true;
        #    bitbake_language_server.enable = pkgs.stdenv.isLinux;
        clangd.enable = true;
        cmake.enable = true;
        #    dockerls.enable = true;
        #    #gitlab_ci_ls.enable = true; # TODO: Enable when available
        #    jsonls.enable = true;
        #    just.enable = true;
        #    lua_ls.enable = true;
        #    pyright.enable = true;
        #    ruff.enable = true;
        #    # TODO: the default config doesn’t work great quite yet
        #    # see https://github.com/nix-community/nixvim/issues/3296
        #    #statix.enable = true;
        yamlls.enable = true;
        #rust_analyzer = {
        #  enable = true;
        #}; // TODO enable once cargo is installed
        nixd = {
          enable = true;
          settings.formatting.command = [ "nixpkgs-fmt" ];
        };
      };
      keymaps.lspBuf = {
        # https://github.com/nix-community/nixvim/blob/main/modules/lsp/keymaps.nix
        "gd" = "definition";
        "gD" = "references";
        "gt" = "type_definition";
        "gi" = "implementation";
        "K" = "hover";
      };
    };

    # TODO: auto completion? get it to look up in the open source sourcecode, so no need to have all the web browsers open all the time for the repos.

    # TODO: don't allow file write if code will error? (temporarily good, only if can get large codebases to stop giving false-positives for errors)

    # Automatically pair brackets:
    nvim-autopairs.enable = true; # TODO also autocomplete semicolons after `{}` in nix files? how? LSP do a better job at this sort of thing?

    # Colour hexcodes etc.. inline:
    #colorizer = {
    #  enable = true;
    #  settings.names = false; # # TODO: this setting doesn't appear to be working!
    #};

    # Make it easier to comment and uncomment code
    #comment = {
    #  enable = true;
    #  settings = {
    #    # Set new custom ones TODO why are these keybinds not working??, set them below instead?
    #    toggler = {
    #      line = "mhh";
    #      block = "mbb";
    #    };
    #    opleader = {
    #      line = "mh";
    #      block = "mh";
    #    };
    #    extra = {
    #      above = "mk";
    #      below = "mj";
    #      eol = "ml";
    #    };
    #  };
    #};

    # TODO symbols-outline - list all the symbols in a file
    # https://github.com/simrat39/symbols-outline.nvim?tab=readme-ov-file

    ## TODO explore nvim-surround.enable = true;
  };

  opts = {
    # https://neovim.io/doc/user/options.html
    termguicolors = true;

    encoding = "utf-8";
    cursorline = true;

    wrap = true;
    sidescroll = 8;
    showbreak = "↳"; # # TODO future special characters, noted here for later: ↯ ❰❱❲❳⦃⦄⟬⟭〈〉⦗⦘⸨⸩⸙〘〙〈〉《》𑗋

    viewoptions = [
      "folds"
      "cursor"
    ];

    # Defines the column multiple used to display the Horizontal Tab character
    tabstop = 8; # TODO only want 2 for nix files, want 8 for most OSS applications!
    # Number of columns that make up one level of (auto)indentation
    shiftwidth = 2;
    # In Insert mode: Use the appropriate number of spaces to insert a <Tab>
    expandtab = true;
    # Do smart autoindenting when starting a new line
    smartindent = true;
    # TODO stop comments from losing their smart-indent!

    foldmethod = "syntax";
    foldcolumn = "1";
    foldlevel = 99;

    ruler = true;
    number = true;

    smartcase = true;
    incsearch = true;
    hlsearch = true;

    mouse = "a";

    list = true;
    listchars = "tab:⇆ ,trail:؟,nbsp:⎵,precedes:<,extends:>";
  };

  globals.mapleader = " ";
  keymaps = [
    # TODO idea: toggle relative line numbers for `d` and `y` then back to regular numbers afterwards
    # idea: make current file executable, or just chmod current file and specify +x or -r etc.. with examples given.
    # idea: home-manager switch command without having to leave nvim
    # Nix shortcuts:
    {
      key = "<leader>r";
      options.desc = "Reload: Test out new config";
      action = ":source $MYVIMRC<CR>";
    }
    {
      key = "<leader>nhs";
      options.desc = "Home-manager switch";
      action = ":FloatermNew home-manager switch<CR>";
    }
    # Git shortcuts:
    {
      key = "<leader>gb";
      options.desc = "Git: Toggle Inline Blame";
      action = ":GitBlameToggle<CR>";
    }
    {
      key = "<leader>gg";
      options.desc = "Open LazyGit";
      action = ":LazyGit<CR>";
    }

    # File manager:
    {
      key = "<leader>h";
      options.desc = "Toggle File Tree Visibility";
      action = ":NvimTreeToggle<CR>";
    }

    # Telescope: TODO try out different options and shortcut the ones which end up being useful. TODO hook into LSP to search files?
    # https://github.com/nvim-telescope/telescope.nvim
    {
      key = "<leader>ff";
      options.desc = "Telescope find files";
      action = ":Telescope find_files<CR>";
    }
    {
      key = "<leader>fg";
      options.desc = "Telescope live grep";
      action = ":Telescope live_grep<CR>";
    }
    {
      key = "<leader>fb";
      options.desc = "Telescope buffers";
      action = ":Telescope buffers<CR>";
    }
    {
      key = "<leader>fh";
      options.desc = "Telescope help_tags";
      action = ":Telescope help_tags<CR>";
    }
  ];
  # Specify Groups of keymaps for which-key
  plugins.which-key.settings.spec = [
    {
      # Git
      __unkeyed = "<leader>g";
      group = "Git";
      icon = "";
    }
    {
      # Nix
      __unkeyed = "<leader>n";
      group = "Nix etc..";
      icon = "󱄅";
    }
    {
      # Nix: Home-Manager
      __unkeyed = "<leader>nh";
      group = "Home-Manager";
      icon = "🏠";
    }
    {
      # Nix: NixOS
      __unkeyed = "<leader>no";
      group = "NixOS";
      icon = "";
    }
    {
      # Debugging: TODO add commands for this category
      __unkeyed = "<leader>d";
      group = "Debugging";
      icon = "";
    }
    {
      # Telescope, TODO: Goto definition, etc..
      __unkeyed = "<leader>f";
      group = "Navigate Codebase";
      icon = "󰥩";
    }
    {
      # Floaterm - floating terminal
      __unkeyed = "<leader>a"; # optimise for home-row!
      group = "Floaterm";
      icon = "";
    }
  ];
}
