{ config, lib, pkgs, ... }:

let


  # issues: OpenGL
  # the motivation for nixGL; https://discourse.nixos.org/t/design-discussion-about-nixgl-opengl-cuda-opencl-wrapper-for-nix/2453
  # nixGL/Home Manager issue; https://github.com/guibou/nixGL/issues/44
  # nixGL/Home Manager issue; https://github.com/guibou/nixGL/issues/114
  # nixGL causes all software ran under it to gain nixGL status; https://github.com/guibou/nixGL/issues/116
  # solution: wrap packages with nixGL
  # nixGL customizes LD_LIBRARY_PATH and related envs so that nixpkgs find a compatible OpenGL driver
  # add channel; nix-channel --add https://github.com/guibou/nixGL/archive/main.tar.gz nixgl
  # customising packages in config; https://gsc.io/70266391-48a6-49be-ab5d-acb5d7f17e76-nixos/doc/nixos-manual/html/sec-package-management.html#sec-customising-packages
  nixgl = import <nixgl> {} ;
  nixGLWrap = pkg: pkgs.runCommand "${pkg.name}-nixgl-wrapper" {} ''
    mkdir $out
    ln -s ${pkg}/* $out
    rm $out/bin
    mkdir $out/bin
    for bin in ${pkg}/bin/*; do
      wrapped_bin=$out/bin/$(basename $bin)
      echo "exec ${lib.getExe nixgl.auto.nixGLDefault} $bin \"\$@\"" > $wrapped_bin
      chmod +x $wrapped_bin
    done
  '';

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
  home.stateVersion = "22.11";

  home.packages = [

    # nixgl
    nixgl.auto.nixGLDefault

    # terminal
    (nixGLWrap pkgs.kitty)

    # browser
    pkgs.firefox
    pkgs.vivaldi

    # text editor
    pkgs.emacs

    # doc
    (nixGLWrap pkgs.libreoffice)
    pkgs.okular
    pkgs.zathura

    # doc utils
    pkgs.ghostscript
    pkgs.hugo
    pkgs.pandoc

    # reference
    (nixGLWrap pkgs.calibre)
    pkgs.font-manager
    pkgs.zotero

    # image
    pkgs.gimp
    pkgs.gpick
    (nixGLWrap pkgs.gthumb)
    (nixGLWrap pkgs.inkscape)
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
    pkgs.nodePackages.pyright

    # misc
    pkgs.gsettings-desktop-schemas
    pkgs.openfortivpn
    pkgs.python310Packages.jupyterlab
    pkgs.qgis

    # TODO doesn't work
    # layers and layers of wrapping; Zoom does not seem to play nicely with nixGL
    # https://github.com/NixOS/nixpkgs/issues/94958
    # pkgs.zoom-us
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
