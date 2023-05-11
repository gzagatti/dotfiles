from typing import List
from pathlib import Path
from kitty.boss import Boss
from kittens.tui.handler import result_handler


def main(args: List[str]) -> str:
    pass


@result_handler(no_ui=True)
def handle_result(
    args: List[str], result: None, target_window_id: int, boss: Boss
) -> None:
    args = args[1:]
    files = []
    w = boss.window_id_map.get(target_window_id)
    for arg in args:
        file = Path(arg).expanduser()
        if file.exists():
            files.append(file)
    if len(files) == 0:
        return
    try:
        imgviewer = next(boss.match_windows(f"title:imgviewer{w.id}"))
    except StopIteration:
        imgviewer = boss.launch(
            "--window-title", f"imgviewer{w.id}", "--cwd", "current", "--keep-focus"
        )
        imgviewer = next(boss.match_windows(f"title:imgviewer{w.id}"))
        imgviewer.write_to_child("export HISTFILE=\r")
    imgviewer.write_to_child(f"timg {' '.join(str(f) for f in files)}\r")
