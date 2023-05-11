def main():
    pass


def handle_result(args, result, target_window_id, boss):
    # do nothing if fully focused on one window
    if boss.active_tab._current_layout_name != "stack":
        boss.active_tab.neighboring_window(args[1])


handle_result.no_ui = True
