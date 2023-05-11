import filecmp
from typing import List
from pathlib import Path
from kitty.boss import Boss
from kittens.tui.handler import result_handler
from kitty.constants import config_dir
from kitty.utils import reload_conf_in_all_kitties


def main(args: List[str]) -> None:
    pass


@result_handler(no_ui=True)
def handle_result(
    args: List[str], result: None, target_window_id: int, boss: Boss
) -> None:
    current_theme = Path(config_dir) / "current-theme.conf"
    dracula = Path(config_dir) / "themes/dracula.conf"
    leuven = Path(config_dir) / "themes/leuven.conf"
    if current_theme.is_symlink():
        current_theme.unlink()
    if not Path.exists(current_theme):
        current_theme.touch()
    if dracula.exists() and leuven.exists() and not filecmp.cmp(current_theme, leuven):
        current_theme.write_text(leuven.read_text())
    elif dracula.exists():
        current_theme.write_text(dracula.read_text())
    reload_conf_in_all_kitties()
