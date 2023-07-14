{ config, lib, pkgs, ... }:

let


  # to add channel; nix-channel --add https://github.com/guibou/nixGL/archive/main.tar.gz nixgl
  # to customise packages in config; https://gsc.io/70266391-48a6-49be-ab5d-acb5d7f17e76-nixos/doc/nixos-manual/html/sec-package-management.html#sec-customising-packages

  # the motivation for nixGL; https://discourse.nixos.org/t/design-discussion-about-nixgl-opengl-cuda-opencl-wrapper-for-nix/2453
  nixgl = import <nixgl> {} ;
  nixGuiWrap = pkg: pkgs.runCommand "${pkg.name}-nixgui-wrapper" {} ''
    mkdir $out
    ln -s ${pkg}/* $out
    rm $out/bin
    mkdir $out/bin
    # nixGL/Home Manager issue; https://github.com/guibou/nixGL/issues/44
    # nixGL/Home Manager issue; https://github.com/guibou/nixGL/issues/114
    # nixGL causes all software ran under it to gain nixGL status; https://github.com/guibou/nixGL/issues/116
    # we wrap packages with nixGL; it customizes LD_LIBRARY_PATH and related
    # envs so that nixpkgs find a compatible OpenGL driver
    nixgl_bin="${lib.getExe nixgl.auto.nixGLDefault}"
    # Similar to OpenGL, the executables installed by nix cannot find the GTK modules
    # required by the environment. The workaround is to unset the GTK_MODULES and
    # GTK3_MODULES so that it does not reach for system GTK modules.
    # We also need to modify the GTK_PATH to point to libcanberra-gtk3 installed via Nix
    gtk_path="${lib.getLib pkgs.libcanberra-gtk3}/lib/gtk-3.0"
    for bin in ${pkg}/bin/*; do
      wrapped_bin=$out/bin/$(basename $bin)
      echo "exec env GTK_MODULES= GTK3_MODULES= GTK_PATH=\"$gtk_path\" $nixgl_bin  $bin \"\$@\"" > $wrapped_bin
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
    (nixGuiWrap pkgs.kitty)

    # browser
    (nixGuiWrap pkgs.firefox)

    # text editor
    pkgs.emacs

    # doc
    (nixGuiWrap pkgs.libreoffice)
    (nixGuiWrap pkgs.okular)
    # does not work properly; crashes randomly and does not navigate properly
    # (nixGuiWrap pkgs.zathura)

    # doc utils
    pkgs.ghostscript
    pkgs.hugo
    pkgs.pandoc

    # reference
    (nixGuiWrap pkgs.calibre)
    (nixGuiWrap pkgs.font-manager)
    (nixGuiWrap pkgs.zotero)

    # image
    (nixGuiWrap pkgs.gimp)
    (nixGuiWrap pkgs.gpick)
    (nixGuiWrap pkgs.gthumb)
    # TODO does not work properly; need extensions properly working
    # (nixGuiWrap pkgs.inkscape)
    # (nixGuiWrap pkgs.peek)

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
    (nixGuiWrap pkgs.spotify)
    (nixGuiWrap pkgs.vlc)

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
    # does not load apps correctly, mixes nix and system paths
    # pkgs.rofi

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
    # TODO plugins do not work with installed version
    # (nixGuiWrap pkgs.qgis)

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
