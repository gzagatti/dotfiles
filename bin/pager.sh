#!/usr/bin/env bash
set -eu

if [ "$#" -eq 3 ]; then
    INPUT_LINE_NUMBER=${1:-0}
    CURSOR_LINE=${2:-1}
    CURSOR_COLUMN=${3:-1}
    AUTOCMD_TERMCLOSE_CMD="call cursor(max([0,${INPUT_LINE_NUMBER}-1])+${CURSOR_LINE}, ${CURSOR_COLUMN})"
else
    AUTOCMD_TERMCLOSE_CMD="execute 'set modifiable' | execute '%s#\(\$\n\s*\)\+\%\$##' | execute 'normal G'"
fi

# 63<&0 :: sends stdin 0 to stdin 63
# sed </dev/fd/63 -e "s/'$'\x1b'']8;;file:[^\]*[\]//g" -e "/^ *\$/d" :: reads stdin 63, remove graphics and remove any empty lines at end of file
# sleep 0.01 :: waits for the command to complete
# printf "'$'\x1b'']2;" :: removes [Process exited 0] from display
exec nvim 63<&0 0</dev/null \
    -u NONE \
    -c "map <silent> q :qa!<CR>" \
    -c "vmap <silent> q :<C-U>qa!<CR>" \
    -c 'map ;y "+y' \
    -c 'hi Visual ctermbg=6 ctermfg=0' \
    -c "set scrollback=100000 laststatus=0" \
    -c "autocmd TermEnter * stopinsert" \
    -c "autocmd TermClose * ${AUTOCMD_TERMCLOSE_CMD}" \
    -c 'terminal sed </dev/fd/63 -e "s/'$'\x1b'']8;;file:[^\]*[\]//g" -e "/^ *\$/d" && sleep 0.01 && printf "'$'\x1b'']2;"'
