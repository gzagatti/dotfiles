{ config, pkgs, ... }:

let

  nixgl = import <nixgl> {} ;

  /* gl-kitty = pkgs.writeShellScriptBin "kitty" ''
      ${nixgl.auto.nixGLDefault}/bin/nixGL ${pkgs.kitty}/bin/kitty "$@"
    '' ; */

in

{

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "gzagatti";
  home.homeDirectory = "/home/gzagatti";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.05";


  home.packages = [

    # browser
    pkgs.firefox
    pkgs.luakit

    # text editor
    pkgs.emacs

    # doc
    pkgs.libreoffice
    pkgs.okular
    pkgs.zathura

    # doc utils
    pkgs.ghostscript
    pkgs.hugo
    pkgs.pandoc

    # reference
    pkgs.calibre
    pkgs.font-manager
    pkgs.zotero

    # image
    pkgs.gimp
    pkgs.gpick
    pkgs.gthumb
    pkgs.inkscape
    pkgs.peek

    # image utils
    pkgs.exiftool
    pkgs.ffmpeg
    pkgs.graphicsmagick
    pkgs.graphviz
    pkgs.imagemagick
    pkgs.pngquant
    pkgs.timg
    pkgs.zopfli

    # media
    pkgs.spotify
    pkgs.vlc

    # messaging
    pkgs.weechat

    # cli utils
    pkgs.aspell
    pkgs.bat
    pkgs.code-minimap
    pkgs.ctags
    pkgs.curl
    pkgs.direnv
    pkgs.entr
    pkgs.fd
    pkgs.fzf
    pkgs.git-lfs
    pkgs.gnused
    pkgs.jq
    pkgs.nmap
    pkgs.python310Packages.pygments
    pkgs.ripgrep
    pkgs.rofi

    # compilers
    pkgs.cmake
    pkgs.maven
    pkgs.ninja

    # langs
    pkgs.R
    pkgs.lua5_4
    pkgs.luarocks
    pkgs.nodejs
    pkgs.racket-minimal
    pkgs.rbenv
    pkgs.ruby_3_1
    pkgs.rustup

    # language servers
    pkgs.ccls
    pkgs.rubyPackages_3_1.solargraph
    pkgs.sumneko-lua-language-server
    pkgs.texlab

    # misc
    pkgs.gsettings-desktop-schemas
    pkgs.openfortivpn
    pkgs.python310Packages.jupyterlab
    pkgs.qgis

    # GL applications
    # https://discourse.nixos.org/t/design-discussion-about-nixgl-opengl-cuda-opencl-wrapper-for-nix/2453/6
    # https://github.com/guibou/nixGL/issues/114
    # nix-channel --add https://github.com/guibou/nixGL/archive/main.tar.gz nixgl
    # https://pmiddend.github.io/posts/nixgl-on-ubuntu/
    # https://nixos.wiki/wiki/Tensorflow
    # https://discourse.nixos.org/t/using-nixgl-to-fix-opengl-applications-on-non-nixos-distributions/9940
    # hardware.opengl.setLdLibraryPath = true; # seems only to apply to NixOS
    # nixGL kitty; need to figure how to automatically call with nixGL
    nixgl.auto.nixGLDefault
    # pkgs.kitty
    pkgs.kitty
    # gl-kitty

    # TODO doesn't work
    # pkgs.zoom-us
    # pkgs.nodePackages.pyright
    # doesn't install tlmgr
    # pkgs.texlive.combined.scheme-small
    # pkgs.biber

  ];


  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Enable XDG integration
  xdg.enable = true;
  xdg.mime.enable = true;
  targets.genericLinux.enable = true;

}
