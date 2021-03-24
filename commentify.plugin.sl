% Copy to ~/.config/mc/plugin for this file to be loaded at mc's startup.

define commentify()
{
    variable cur_pos, start_skip = -1, off_add; % Current cursor offset
    variable bol, eol;                          % Begin-Of-Line offset
    variable initial = 1, adding;
    variable char = '\0';

    % Get current cursor position and beginning of current line.
    bol = mc->cure_get_bol();
    eol = mc->cure_get_eol();
    while (initial || isspace(char) && (bol + start_skip + 1 < eol))
    {
        initial = 0;
        start_skip++;
        char = mc->cure_get_byte(bol+start_skip);
    }

    % Move to the start of the line
    cur_pos = mc->cure_cursor_offset();
    mc->cure_cursor_move(bol + start_skip - cur_pos);
    % Insert or remove an "/*" ?
    if (mc->cure_get_byte(bol + start_skip) == '/' &&
        mc->cure_get_byte(bol + start_skip + 1) == '*')
    {
        adding = 0;
        mc->cure_delete();
        mc->cure_delete();
    }
    else
    {
        adding = 1;
        mc->cure_insert_ahead('*');
        mc->cure_insert_ahead('/');
    }

    % Move to the end of the line.
    cur_pos = mc->cure_cursor_offset();
    eol = mc->cure_get_eol();
    mc->cure_cursor_move(eol - cur_pos);

    % Insert "*/" (or remove).
    if (adding)
    {
        mc->cure_insert_ahead('/');
        mc->cure_insert_ahead('*');
    } else {
        % Found "*/" at end ?
        if (mc->cure_get_byte(eol-1) == '/' &&
                mc->cure_get_byte(eol-2) == '*')
        {
            mc->cure_backspace();
            mc->cure_backspace();
        }
    }
}

mc->editor_map_key_to_func("Commentify","alt-i","commentify");
