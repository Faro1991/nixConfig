# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{ inputs, outputs, lib, config, pkgs, ... }: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
  ];

  nixpkgs = {
    # You can add overlays here
    # overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      # outputs.overlays.additions
      # outputs.overlays.modifications
      # outputs.overlays.unstable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    # ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = (_: true);
    };
  };

  # TODO: Set your username
  home = {
    username = "fnord";
    homeDirectory = "/home/fnord";
  };

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  # home.packages = with pkgs; [ steam ];

  programs.zsh = {
    enable = true;
    shellAliases = {
      conf = "vim /home/fnord/Flakes/nixos/configuration.nix";
      redo = "sudo nixos-rebuild switch --flake '/home/fnord/Flakes/#pharasma'";
      home = "vim /home/fnord/.config/nixpkgs/home.nix";
    };
    history = {
      size = 10000;
    };
    oh-my-zsh = {
      enable = true;
      theme = "clean";
      plugins = ["git" "python" "man" "dotnet" "encode64" "history-substring-search" "colored-man-pages" "zsh-autosuggestions" "zsh-syntax-highlighting"];
    };
  };

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git = {
    enable = true;
    userName = "Fnord";
    userEmail = "19fnord@gmail.com";
    extraConfig = {
      credential.helper = "${
        pkgs.git.override { withLibsecret = true; }
      }/bin/git-credential-libsecret";
    };
  };

  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      dracula-theme.theme-dracula
      yzhang.markdown-all-in-one
      timonwong.shellcheck
      ms-vscode.PowerShell
      ms-python.python
      ms-dotnettools.csharp
      maximedenes.vscoq
      ionide.ionide-fsharp
      github.copilot
      github.codespaces
      github.vscode-pull-request-github
      eamodio.gitlens
      dbaeumer.vscode-eslint
      davidanson.vscode-markdownlint
      
    ];
  };

  stylix.autoEnable = true;
  stylix.image = ./wallpapers/steampunkEye.jpg;
  stylix.polarity = "dark";
  stylix.fonts = {
    serif = {
      package = pkgs.dejavu_fonts;
      name = "DejaVu Serif";
    };

    sansSerif = {
      package = pkgs.dejavu_fonts;
      name = "DejaVu Sans";
    };

    monospace = {
      package = pkgs.nerdfonts;
      name = "Fira Code";
    };

    emoji = {
      package = pkgs.noto-fonts-emoji;
      name = "Noto Color Emoji";
    };
  };


  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "22.11";
}
