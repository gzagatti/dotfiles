import os
import sys
import warnings
from subprocess import check_call
from notebook.utils import to_api_path

_script_exporter = None

# Post save converters
def post_save(model, os_path, contents_manager, **kwargs):
    """post-save hook for converting notebook to presentation.
    see https://jupyter-notebook.readthedocs.io/en/stable/extending/savehooks.html
    """
    from nbconvert.exporters.script import ScriptExporter
    if model["type"] != "notebook":
        return
    global _script_exporter
    if _script_exporter is None:
        _script_exporter = ScriptExporter(parent=contents_manager)
    log = contents_manager.log
    base, ext = os.path.splitext(os_path)
    script, resources = _script_exporter.from_filename(os_path)
    slide_fname = base + ".slides.html"
    if os.path.exists(slide_fname):
        log.info("Saving notebook as %s.", to_api_path(slide_fname, contents_manager.root_dir))
        check_call(["jupyter", "nbconvert", "--to", "slides", os_path])

c.FileContentsManager.post_save_hook = post_save

# Julia WebIO config
# Add the path to WebIO/deps so that we can load the `jlstaticserve` extension.
if os.path.exists(os.path.expanduser("~/.julia")):
    webio_deps_dir = os.path.expanduser("~/.julia/packages/WebIO/nTMDV/deps")
    if os.path.isfile(os.path.join(webio_deps_dir, "jlstaticserve.py")):
        sys.path.append(webio_deps_dir)
    else:
        warning_msg = (
            'Directory %s could not be found; WebIO.jl will not work as expected. '
            + 'Make sure WebIO.jl is installed correctly (try running '
            + 'Pkg.add("WebIO") and Pkg.build("WebIO") from the Julia console to '
            + 'make sure it is).'
        ) % webio_deps_dir
        warnings.warn(warning_msg)

###JULIA-WEBIO-CONFIG-BEGIN
# Add the path to WebIO/deps so that we can load the `jlstaticserve` extension.
import os, sys, warnings
webio_deps_dir = "/home/gzagatti/.julia/packages/WebIO/adnrr/deps"
if os.path.isfile(os.path.join(webio_deps_dir, "jlstaticserve.py")):
    sys.path.append(webio_deps_dir)
else:
    warning_msg = (
        'Directory %s could not be found; WebIO.jl will not work as expected. '
        + 'Make sure WebIO.jl is installed correctly (try running '
        + 'Pkg.add("WebIO") and Pkg.build("WebIO") from the Julia console to '
        + 'make sure it is).'
    ) % webio_deps_dir
    warnings.warn(warning_msg)
###JULIA-WEBIO-CONFIG-END
