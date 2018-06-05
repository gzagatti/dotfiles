### Dotfiles

System configuration for OSX implemented through Makefile script. Currently it establishes configuration for:

-   osx
-   vim
-   bash
-   tmux
-   jupyter
-   r
-   eclim
-   ruby
-   git

### Todo

-   study other forms of deployment <https://dotfiles.github.io/>
-   place Vundle plugins in a separate file as the list grows larger
-   place Vundle plugins into themes

### Patching CONDA PS1

-   in order to patch conda's PS1, run the following:
    ```sh
    patch -d $(conda info --root)/bin -N < conda_activate.patch
    ```

