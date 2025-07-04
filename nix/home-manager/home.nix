{ config, lib, pkgs, ... }:

let


  # to add channel; nix-channel --add https://github.com/guibou/nixGL/archive/main.tar.gz nixgl
  # to customise packages in config; https://gsc.io/70266391-48a6-49be-ab5d-acb5d7f17e76-nixos/doc/nixos-manual/html/sec-package-management.html#sec-customising-packages

  # the motivation for nixGL; https://discourse.nixos.org/t/design-discussion-about-nixgl-opengl-cuda-opencl-wrapper-for-nix/2453
  nixgl = import <nixgl> {} ;
  nixGuiWrap = { pkg, light ? false }: pkgs.runCommand "${pkg.name}-nixgui-wrapper" {GTK_THEME= if light then ":light" else "";} ''
    mkdir $out
    ln -s ${pkg}/* $out
    rm $out/bin
    mkdir $out/bin
    # nixGL/Home Manager issue; https://github.com/guibou/nixGL/issues/44
    # nixGL/Home Manager issue; https://github.com/guibou/nixGL/issues/114
    # nixGL causes all software ran under it to gain nixGL status; https://github.com/guibou/nixGL/issues/116
    # we wrap packages with nixGL; it customizes LD_LIBRARY_PATH and related
    # envs so that nixpkgs find a compatible OpenGL driver
    nixgl_bin="${lib.getBin nixgl.auto.nixGLDefault}/bin/nixGL"
    # Similar to OpenGL, the executables installed by nix cannot find the GTK modules
    # required by the environment. The workaround is to unset the GTK_MODULES and
    # GTK3_MODULES so that it does not reach for system GTK modules.
    # We also need to modify the GTK_PATH to point to libcanberra-gtk3 installed via Nix
    GTK_PATH="${lib.getLib pkgs.libcanberra-gtk3}/lib/gtk-3.0"
    # light or dark
    for bin in ${pkg}/bin/*; do
      wrapped_bin=$out/bin/$(basename $bin)
      echo "exec env GTK_MODULES= GTK3_MODULES= GTK_PATH=\"$GTK_PATH\" GTK_THEME=\"$GTK_THEME\" $nixgl_bin  $bin \"\$@\"" > $wrapped_bin
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
    (nixGuiWrap { pkg = pkgs.kitty; })
    (nixGuiWrap { pkg = pkgs.wezterm; })
    (nixGuiWrap { pkg = pkgs.alacritty; })

    # browser
    (nixGuiWrap { pkg = pkgs.firefox; })
    pkgs.lagrange
    pkgs.bombadillo
    pkgs.amfora

    # text editor
    pkgs.emacs
    pkgs.neovim

    # doc
    (nixGuiWrap { pkg = pkgs.libreoffice; })
    (nixGuiWrap { pkg = pkgs.libsForQt5.okular; })
    # does not work properly; crashes randomly and does not navigate properly
    # (nixGuiWrap { pkg = pkgs.zathura; })

    # doc utils
    pkgs.ghostscript
    pkgs.hugo
    pkgs.pandoc
    pkgs.pdf2svg
    pkgs.biber
    pkgs.languagetool
    pkgs.typst
    pkgs.poppler_utils

    # reference
    # (nixGuiWrap { pkg = pkgs.calibre; light = true; })
    (nixGuiWrap { pkg = pkgs.font-manager; })
    (nixGuiWrap { pkg = pkgs.zotero; light = true; })
    (nixGuiWrap { pkg = pkgs.anki; })

    # graphics
    (nixGuiWrap { pkg = pkgs.gimp; })
    # TODO does not work in Wayland
    # (nixGuiWrap { pkg = pkgs.gpick; })
    (nixGuiWrap { pkg = pkgs.loupe; })
    (nixGuiWrap { pkg = pkgs.gthumb; })
    pkgs.fontforge
    # TODO does not work properly; need extensions properly working
    # (nixGuiWrap { pkg = pkgs.inkscape; })
    # (nixGuiWrap { pkg = pkgs.peek; })

    # image utils
    pkgs.exiftool
    pkgs.ffmpeg
    pkgs.graphicsmagick
    pkgs.graphviz
    pkgs.imagemagick
    pkgs.pngquant
    pkgs.timg
    pkgs.zopfli
    pkgs.trimage
    pkgs.pngcrush
    pkgs.swayimg

    # media
    (nixGuiWrap { pkg = pkgs.spotify; })
    (nixGuiWrap { pkg = pkgs.vlc; })
    # the AppArmor profile ./apparmor.d/nix-electron needs to be added to
    # /etc/apparmor.d/ and be owned by root in order to allow SUID sandbox
    # helper to run, otherwise electron apps installed with nix cannot be
    # started
    # see: https://github.com/NixOS/nixpkgs/issues/121694
    # see: https://discourse.ubuntu.com/t/ubuntu-24-04-lts-noble-numbat-release-notes/39890#p-99950-unprivileged-user-namespace-restrictions
    (nixGuiWrap { pkg = pkgs.freetube; })

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
    pkgs.python311Packages.pygments
    pkgs.ripgrep
    pkgs.wget
    pkgs.socat
    pkgs.jless
    pkgs.valgrind
    pkgs.tree-sitter
    pkgs.nss
    pkgs.uv
    # does not load apps correctly, mixes nix and system paths
    # pkgs.rofi

    # compilers
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
    pkgs.dotnet-sdk_8
    pkgs.go
    pkgs.sassc
    pkgs.jdk21
    pkgs.php
    # pkgs.pyenv
    pkgs.maven

    # misc
    pkgs.gsettings-desktop-schemas
    pkgs.openfortivpn
    pkgs.android-tools
    pkgs.qdl
    pkgs.fava
    pkgs.beancount
    pkgs.beanquery
    pkgs.beanprice
    pkgs.gnuplot
    pkgs.sc-im
    # on-screen permanent keyboard; help with XPS faulty keyboard
    # pkgs.onboard
    # TODO plugins do not work with installed version
    # (nixGuiWrap pkgs.qgis)

    # backup
    pkgs.borgmatic
    pkgs.borgbackup

    # iOS backup
    pkgs.libimobiledevice
    pkgs.libplist

  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Enable XDG integration
  xdg.enable = true;
  xdg.mime.enable = true;
  targets.genericLinux.enable = true;
  fonts.fontconfig.enable = true;

  # TODO: clean up
  # modified /etc/environment which was taking precedence; then added ~/.config/environment.d/90-profile.conf
  # need to remove /etc/environment.bkp if that's the case
  # link desktop files
  # https://github.com/nix-community/home-manager/issues/1439
  # home.activation = {
  #   linkDesktopApplications = {
  #     after = [ "writeBoundary" "createXdgUserDirectories" ];
  #     before = [ ];
  #     data = ''
  #       rm -rf ${config.home.homeDirectory}/.local/share/applications/home-manager
  #       rm -rf ${config.home.homeDirectory}/.icons/nix-icons
  #       mkdir -p ${config.home.homeDirectory}/.icons
  #       ln -sf ${config.home.homeDirectory}/.nix-profile/share/icons ${config.home.homeDirectory}/.icons/nix-icons
  #       /usr/bin/desktop-file-install ${config.home.homeDirectory}/.nix-profile/share/applications/*.desktop --dir ${config.xdg.dataHome}/applications/home-manager
  #       sed -i 's/Exec=/Exec=\/home\/${config.home.username}\/.nix-profile\/bin\//g' ${config.xdg.dataHome}/applications/home-manager/*.desktop
  #       /usr/bin/update-desktop-database ${config.xdg.dataHome}/applications
  #     '';
  #   };
  # };

}
