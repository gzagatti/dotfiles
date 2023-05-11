import re

from kittens.tui.handler import result_handler
from kitty.key_encoding import KeyEvent, parse_shortcut
from kittens.ssh.utils import is_kitten_cmdline

# for logging during debug, use something like
# boss.call_remote_control(window, ("send-text", "--match", "id:{target}", f"{message}\n"))


def is_window_vim(window, vim_id):
    fp = window.child.foreground_processes
    wtitle = window.child_title
    for p in fp:
        q = list(p["cmdline"] or ())
        if is_kitten_cmdline(q):
            wtitle = wtitle.split(": ")[1]
            vim_id = f"^{vim_id}(\s+\S+|$)"
            if re.search(vim_id, wtitle, re.I):
                return True
            else:
                return False
        else:
            if len(q) == 0:
                continue
            if re.search(vim_id, p["cmdline"][0], re.I):
                return True
    return False


def encode_key_mapping(window, key_mapping):
    mods, key = parse_shortcut(key_mapping)
    event = KeyEvent(
        mods=mods,
        key=key,
        shift=bool(mods & 1),
        alt=bool(mods & 2),
        ctrl=bool(mods & 4),
        super=bool(mods & 8),
        hyper=bool(mods & 16),
        meta=bool(mods & 32),
    ).as_window_system_event()

    return window.encoded_key(event)


def main():
    pass


@result_handler(no_ui=True)
def handle_result(args, result, target_window_id, boss):
    window = boss.window_id_map.get(target_window_id)
    direction = args[2]
    key_mapping = args[3]
    vim_id = args[4] if len(args) > 4 else "(n?vim|emacs)"

    if window is None:
        return

    if is_window_vim(window, vim_id):
        encoded = encode_key_mapping(window, key_mapping)
        window.write_to_child(encoded)
    else:
        # do nothing if fully focused on one window
        if boss.active_tab._current_layout_name != "stack":
            boss.active_tab.neighboring_window(direction)
