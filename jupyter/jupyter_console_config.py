# Configuration file for jupyter-console.

#------------------------------------------------------------------------------
# JupyterConsoleApp configuration
#------------------------------------------------------------------------------

# Set to display confirmation dialog on exit. You can always use 'exit' or
# 'quit', to force a direct exit without any confirmation.
c.JupyterConsoleApp.confirm_exit = False

# The name of the default kernel to start.
c.JupyterConsoleApp.kernel_name = 'python3'

#------------------------------------------------------------------------------
# ZMQTerminalIPythonApp configuration
#------------------------------------------------------------------------------

# Configure matplotlib for interactive use with the default matplotlib backend.
c.InteractiveShellApp.matplotlib = 'tk'

# Set to confirm when you try to exit IPython with an EOF (Control-D in Unix,
#  Control-Z/Enter in Windows). By typing 'exit' or 'quit', you can force a
#  direct exit without any confirmation.
c.TerminalInteractiveShell.confirm_exit = False

# Options for displaying tab completions, 'column', 'multicolumn', and
# 'readlinelike'. These options are for `prompt_toolkit`, see `prompt_toolkit`
# documentation for more information.
c.TerminalInteractiveShell.display_completions = 'readlinelike'

# Autoindent IPython code entered interactively.
c.TerminalInteractiveShell.autoindent = False

#------------------------------------------------------------------------------
# ZMQTerminalInteractiveShell configuration
#------------------------------------------------------------------------------

# Shortcut style to use at the prompt. 'vi' or 'emacs'.
c.ZMQTerminalInteractiveShell.editing_mode = 'vi'

# Whether to include output from clients other than this one sharing the same
# kernel.
#
# Outputs are not displayed until enter is pressed.
c.ZMQTerminalInteractiveShell.include_other_output = True
