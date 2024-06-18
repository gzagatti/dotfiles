# Configuration file for jupyter-console.
# see: https://jupyter-console.readthedocs.io/en/latest/config_options.html

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

# Add shortcuts from 'emacs' insert mode to 'vi' insert mode.
c.ZMQInteractiveShell.emacs_bindings_in_vi_insert_mode = True

# Whether to include output from clients other than this one sharing the same
# kernel.
#
# Outputs are not displayed until enter is pressed.
c.ZMQTerminalInteractiveShell.include_other_output = True
