{ config, pkgs, ... }:

let
  username = "delaney";
  fullName = "Delaney Gillilan";
  email = "delaneygillilan@gmail.com";

  update-icons = pkgs.writeScriptBin "update-icons" ''
    #!${pkgs.bash}/bin/bash
    set -euo pipefail
    shopt -s inherit_errexit

    ICON_DIR="$HOME/Desktop/.icons"
    rm -rf "$ICON_DIR"
    mkdir -p "$ICON_DIR"
    cp ~/.nix-profile/share/applications/*.desktop "$ICON_DIR"
    update-desktop-database --verbose "$ICON_DIR"
  '';
in
{
  nixpkgs.config.allowUnfree = true;

  xdg.enable = true;
  xdg.mime.enable = true;
  targets.genericLinux.enable = true;


  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = username;
  home.homeDirectory = "/home/${username}";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.11";

  home.keyboard = {
    layout = "us";
    variant = "colemak";
  };

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    update-icons
    nixpkgs-fmt
    powerline-fonts
    fira-code
    nixUnstable
    git-crypt
    git-lfs
    nix-direnv
  ] ++ [
    slack
    spotify
  ];

  programs.direnv = {
    enable = true;
    nix-direnv = {
      enable = true;
      enableFlakes = true;
    };
  };

  home.file = {
    ".config/nix/nix.conf".text = "experimental-features = nix-command flakes";
    ".ssh/id_rsa".source = .secrets/id_rsa;
    ".ssh/id_rsa.pub".source = .secrets/id_rsa.pub;
  };

  programs.zsh = with pkgs;
    {
      enable = true;

      # If a command is issued that can't be executed as a normal command, and the
      # command is the name of a directory, perform the cd command to that directory.
      # This option is only applicable if the option SHIN_STDIN is set, i.e. if
      # commands are being read from standard input. The option is designed for
      # interactive use; it is recommended that cd be used explicitly in scripts to
      # avoid ambiguity.
      autocd = true;

      enableAutosuggestions = true;
      enableCompletion = true;

      shellAliases = {
        xbc = "code ~/work/praetor/praetor.code-workspace";
        xbp = "cd ~/work/praetor && ./run.sh";
        xbd = "cd ~/work/praetor && ./clearDatabases.sh";
        hu = "~/nixfiles/update.sh";
        cat = "${bat}/bin/bat";
        e = "\${EDITOR:-nvim}";
        ll = "ls -la";
        pw = "ps aux | grep -v grep | grep -e";
        rot13 = "tr \"[A-Za-z]\" \"[N-ZA-Mn-za-m]\"";
        serve_this = "${python3}/bin/python -m http.server";


        # for enabling and disabling the current theme. This means go back to a very basic theme
        zsh_theme_enable = "prompt_powerlevel9k_teardown";
        zsh_theme_disable = "prompt_powerlevel9k_setup";
      };

      initExtra = ''DIRENV_LOG_FORMAT=""'';

      history = {
        expireDuplicatesFirst = true;
        save = 100000000;
        size = 1000000000;
      };

      oh-my-zsh = {
        enable = true;

        plugins = [
          "command-not-found"
          "git"
          "history"
          "sudo"
          "golang"
          "timer"
        ];
      };


      plugins = [
        {
          name = "powerlevel9k";
          file = "powerlevel9k.zsh-theme";
          src = fetchFromGitHub {
            owner = "bhilburn";
            repo = "powerlevel9k";
            rev = "571a859413866897cf962396f02f65a288f677ac";
            sha256 = "0xwa1v3c4p3cbr9bm7cnsjqvddvmicy9p16jp0jnjdivr6y9s8ax";
          };
        }
        {
          name = "zsh-completions";
          src = fetchFromGitHub {
            owner = "zsh-users";
            repo = "zsh-completions";
            rev = "0.27.0";
            sha256 = "1c2xx9bkkvyy0c6aq9vv3fjw7snlm0m5bjygfk5391qgjpvchd29";
          };
        }

        {
          name = "zsh-history-substring-search";
          src = fetchFromGitHub {
            owner = "zsh-users";
            repo = "zsh-history-substring-search";
            rev = "47a7d416c652a109f6e8856081abc042b50125f4";
            sha256 = "1mvilqivq0qlsvx2rqn6xkxyf9yf4wj8r85qrxizkf0biyzyy4hl";
          };
        }

        {
          name = "zsh-syntax-highlighting";
          src = fetchFromGitHub {
            owner = "zsh-users";
            repo = "zsh-syntax-highlighting";
            rev = "db6cac391bee957c20ff3175b2f03c4817253e60";
            sha256 = "0d9nf3aljqmpz2kjarsrb5nv4rjy8jnrkqdlalwm2299jklbsnmw";
          };
        }

        {
          name = "nix-shell";
          src = fetchFromGitHub {
            owner = "chisui";
            repo = "zsh-nix-shell";
            rev = "03a1487655c96a17c00e8c81efdd8555829715f8";
            sha256 = "1avnmkjh0zh6wmm87njprna1zy4fb7cpzcp8q7y03nw3aq22q4ms";
          };
        }
        {
          name = "enhancd";
          file = "init.sh";
          src = fetchFromGitHub {
            owner = "b4b4r07";
            repo = "enhancd";
            rev = "fd805158ea19d640f8e7713230532bc95d379ddc";
            sha256 = "0pc19dkp5qah2iv92pzrgfygq83vjq1i26ny97p8dw6hfgpyg04l";
          };
        }

        {
          name = "gitit";
          src = fetchFromGitHub {
            owner = "peterhurford";
            repo = "git-it-on.zsh";
            rev = "4827030e1ead6124e3e7c575c0dd375a9c6081a2";
            sha256 = "01xsqhygbxmv38vwfzvs7b16iq130d2r917a5dnx8l4aijx282j2";
          };
        }

      ];
    };

  programs.brave = {
    enable = true;
  };

  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
    userSettings = {
      "editor.fontFamily" = "Fira Code";
      "terminal.integrated.fontFamily" = "Fira Code";
      "workbench.colorTheme" = "Gruvbox Dark Medium";
      "editor.fontSize" = 12;
      "terminal.integrated.fontSize" = 12;
      "editor.fontLigatures" = true;
      "editor.formatOnSave" = true;
      "terminal.integrated.defaultProfile.linux" = "zsh";
      "keyboard.dispatch" = "keyCode";
    };

    # To fetch the SHA256, use `nix-prefetch-url` with this template:
    #
    #   https://<publisher>.gallery.vsassets.io/_apis/public/gallery/publisher/<publisher>/extension/<name>/<version>/assetbyname/Microsoft.VisualStudio.Services.VSIXPackage
    # wget -O - https://raw.githubusercontent.com/NixOS/nixpkgs/master/pkgs/misc/vscode-extensions/update_installed_exts.sh | bash
    extensions = with pkgs.vscode-extensions; [
    ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "githistory";
        publisher = "donjayamanne";
        version = "0.6.18";
        sha256 = "01lc9gpqdjy6himn7jsfjrfz8xrk728c20903lxkxy5fliv232gz";
      }
      {
        name = "gitlens";
        publisher = "eamodio";
        version = "11.6.0";
        sha256 = "0lhrw24ilncdczh90jnjx71ld3b626xpk8b9qmwgzzhby89qs417";
      }
      {
        name = "go";
        publisher = "golang";
        version = "0.27.2";
        sha256 = "1ayyqm7bpz9axxp9avnr0y7kcqzpl1l538m7szdqgrra3956irna";
      }
      {
        name = "gruvbox";
        publisher = "jdinhlife";
        version = "1.5.0";
        sha256 = "14dm19bwlpmvarcxqn0a7yi1xgpvp93q6yayvqkssravic0mwh3g";
      }
      {
        name = "nix-ide";
        publisher = "jnoortheen";
        version = "0.1.16";
        sha256 = "04ky1mzyjjr1mrwv3sxz4mgjcq5ylh6n01lvhb19h3fmwafkdxbp";
      }
      {
        name = "volar";
        publisher = "johnsoncodehk";
        version = "0.27.11";
        sha256 = "1fwd307prfgfp2rarwmmgrmx3s5f0gzacd7s6qh1fx3ia9qw1r61";
      }
      {
        name = "git-graph";
        publisher = "mhutchie";
        version = "1.30.0";
        sha256 = "000zhgzijf3h6abhv4p3cz99ykj6489wfn81j0s691prr8q9lxxh";
      }
      {
        name = "vscode-proto3";
        publisher = "zxh404";
        version = "0.5.4";
        sha256 = "08dfl5h1k6s542qw5qx2czm1wb37ck9w2vpjz44kp2az352nmksb";
      }
    ];
  };

  programs.git = {
    enable = true;
    userName = fullName;
    userEmail = email;
  };

} 
 