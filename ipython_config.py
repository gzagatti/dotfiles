# Configuration file for ipython.
c = get_config()

# Configure matplotlib for interactive use with the default matplotlib backend.
c.InteractiveShellApp.matplotlib = 'osx'

# The IPython profile to use.
c.BaseIPythonApplication.profile = 'default'

# Whether to display a banner upon starting IPython.
c.TerminalIPythonApp.display_banner = True

# If a command or file is given via the command-line, e.g. 'ipython foo.py',
# start an interactive shell after executing the file or command.
c.TerminalIPythonApp.force_interact = False

# Autoindent IPython code entered interactively.
c.TerminalInteractiveShell.autoindent = False

# Set to confirm when you try to exit IPython with an EOF (Control-D in Unix,
#  Control-Z/Enter in Windows). By typing 'exit' or 'quit', you can force a
#  direct exit without any confirmation.
c.TerminalInteractiveShell.confirm_exit = False

# Options for displaying tab completions, 'column', 'multicolumn', and
# 'readlinelike'. These options are for `prompt_toolkit`, see `prompt_toolkit`
# documentation for more information.
c.TerminalInteractiveShell.display_completions = 'readlinelike'

# Shortcut style to use at the prompt. 'vi' or 'emacs'.
c.TerminalInteractiveShell.editing_mode = 'vi'

# Set the editor used by IPython (default to $EDITOR/vi/notepad).
c.TerminalInteractiveShell.editor = 'vim'

# Highlight matching brackets.
c.TerminalInteractiveShell.highlight_matching_brackets = True
