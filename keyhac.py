import time
import sys
import os.path
import re

import keyhac_keymap
from keyhac import *

####################################################################################################
## fakeymacs 最小設定
####################################################################################################

def configure(keymap):

    # emacs のキーバインドにするウィンドウのクラスネームを指定
    emacs_target_class   = ["Edit"]               # テキスト入力フィールドなどが該当

    # emacs のキーバインドに“したくない”アプリケーションソフトを指定
    not_emacs_target     = ["bash.exe",           # WSL
            "ubuntu.exe",         # WSL
            "debian.exe",         # WSL
            "mintty.exe",         # mintty
            "WindowsTerminal.exe",# WindowsTerminal
            "alacritty.exe",      # Alacritty
            "gvim.exe",           # GVim
            "Code.exe",           # VSCode
            "VirtualBox.exe",     # VirtualBox
            "Xming.exe",          # Xming
            "vcxsrv.exe",         # VcXsrv
            "putty.exe",          # PuTTY
            "ttermpro.exe",       # TeraTerm
            ]

    def is_emacs_target(window):
        if window != config.last_window:
            config.last_window = window

        if window.getClassName() in emacs_target_class:
            return True

        if window.getProcessName() in not_emacs_target:
            return False

        return True

    def us_layout_to_jis_layout(window):
        if config.us_layout_to_jis_layout:
            return True

        return False

    ####################################################################################################
    ## 基本設定
    ####################################################################################################

    # コンフィグを格納するクラスを定義
    class KeyhacConfig:
        pass

    config = KeyhacConfig()
    config.last_window = None

    # mark がセットされると True になる
    config.is_marked = False

    # リージョンを拡張する際に、順方向に拡張すると True、逆方向に拡張すると False になる
    config.forward_direction = None

    # 検索が開始されると True になる
    config.is_searching = False

    # US配列キーボードをJIS配列キーボード設定されたOSで使う
    config.us_layout_to_jis_layout = False

    ##################################################
    ## IME の切り替え
    ##################################################

    def toggle_input_method():
        keymap.InputKeyCommand("A-(25)")()
        delay(0.1)

        # IME の状態を格納する
        ime_status = keymap.getWindow().getImeStatus()
        if ime_status:
            message = "[あ]"
        else:
            message = "[A]"

        # IME の状態をバルーンヘルプで表示する
        keymap.popBalloon("ime_status", message, 500)
        delay(0.1)

    def toggle_keyboard_layout():
        # キーボードレイアウトの状態を変更する
        if config.us_layout_to_jis_layout:
            config.us_layout_to_jis_layout = False
            keymap.popBalloon("layout", "JIS keyboard", 500)
        else:
            config.us_layout_to_jis_layout = True
            keymap.popBalloon("layout", "US keyboard", 500)

        keymap.updateKeymap()
        delay(0.1)

    ##################################################
    ## ファイル操作
    ##################################################

    def find_file():
        keymap.InputKeyCommand("C-o")()

    def save_buffer():
        keymap.InputKeyCommand("C-s")()

    def write_file():
        keymap.InputKeyCommand("A-f", "A-a")()

    ##################################################
    ## カーソル移動
    ##################################################

    def backward_char():
        keymap.InputKeyCommand("Left")()

    def forward_char():
        keymap.InputKeyCommand("Right")()

    def backward_word():
        keymap.InputKeyCommand("C-Left")()

    def forward_word():
        keymap.InputKeyCommand("C-Right")()

    def previous_line():
        keymap.InputKeyCommand("Up")()

    def next_line():
        keymap.InputKeyCommand("Down")()

    def move_beginning_of_line():
        keymap.InputKeyCommand("Home")()

    def move_end_of_line():
        keymap.InputKeyCommand("End")()

    def beginning_of_buffer():
        keymap.InputKeyCommand("C-Home")()

    def end_of_buffer():
        keymap.InputKeyCommand("C-End")()

    def scroll_up():
        keymap.InputKeyCommand("PageUp")()

    def scroll_down():
        keymap.InputKeyCommand("PageDown")()

    ##################################################
    ## カット / コピー / 削除 / アンドゥ
    ##################################################

    def delete_backward_char():
        keymap.InputKeyCommand("Back")()

    def delete_char():
        keymap.InputKeyCommand("Delete")()

    def backward_kill_word(repeat=1):
        reset_region()
        config.is_marked = True

        def move_beginning_of_region():
            for i in range(repeat):
                backward_word()

        mark(move_beginning_of_region, False)()
        delay()
        kill_region()

    def kill_word(repeat=1):
        reset_region()
        config.is_marked = True

        def move_end_of_region():
            for i in range(repeat):
                forward_word()

        mark(move_end_of_region, True)()
        delay()
        kill_region()

    def kill_line(repeat=1):
        reset_region()
        config.is_marked = True

        if repeat == 1:
            mark(move_end_of_line, True)()
            delay()

            copy()
            keymap.InputKeyCommand("Delete")()
        else:
            def move_end_of_region():
                for i in range(repeat - 1):
                    next_line()
                move_end_of_line()
                forward_char()

            mark(move_end_of_region, True)()
            delay()
            kill_region()

    def kill_region():
        cut()

    def kill_ring_save():
        copy()
        reset_region()

    def yank():
        keymap.InputKeyCommand("C-v")()

    def undo():
        keymap.InputKeyCommand("C-z")()

    def set_mark_command():
        if config.is_marked:
            reset_region()
            config.is_marked = False
            config.forward_direction = None
        else:
            config.is_marked = True

    def mark_whole_buffer():
        if (check_window("EXCEL.EXE$", "EXCEL") or # Microsoft Excel
                check_window(None, "Edit$")):          # NotePad 等
            keymap.InputKeyCommand("C-End", "C-S-Home")()
            config.forward_direction = False
        else:
            keymap.InputKeyCommand("C-Home", "C-a")()
            config.forward_direction = False
        config.is_marked = True

    ##################################################
    ## 文字列検索
    ##################################################

    def isearch(direction):
        if config.is_searching:
            if check_window("EXCEL.EXE", "EXCEL"): # Microsoft Excel
                if check_window(None, "EDTBX"): # 検索ウィンドウ
                    keymap.InputKeyCommand({"backward":"A-S-f", "forward":"A-f"}[direction])()
                else:
                    keymap.InputKeyCommand("C-f")()
            else:
                keymap.InputKeyCommand({"backward":"S-F3", "forward":"F3"}[direction])()
        else:
            keymap.InputKeyCommand("C-f")()
            config.is_searching = True

    def isearch_backward():
        isearch("backward")

    def isearch_forward():
        isearch("forward")

    ##################################################
    ## バッファ / ウィンドウ操作
    ##################################################

    def kill_buffer():
        keymap.InputKeyCommand("C-F4")()

    def switch_to_buffer():
        keymap.InputKeyCommand("C-Tab")()

    ##################################################
    ## その他
    ##################################################

    def newline():
        keymap.InputKeyCommand("Enter")()

    def newline_and_indent():
        keymap.InputKeyCommand("Enter", "Tab")()

    def indent_for_tab_command():
        keymap.InputKeyCommand("Tab")()

    def keyboard_quit():
        reset_region()

        if not check_window("EXCEL.EXE$", "EXCEL"):
            keymap.InputKeyCommand("Esc")()

        keymap.command_RecordStop()

    def kill_emacs():
        # Excel のファイルを開いた直後一回目、kill_emacs が正常に動作しない。その対策
        keymap.InputKeyCommand("D-Alt", "F4")()
        delay(0.1)
        keymap.InputKeyCommand("U-Alt")()

    ##################################################
    ## 共通関数
    ##################################################

    def delay(sec=0.02):
        time.sleep(sec)

    def copy():
        keymap.InputKeyCommand("C-c")()

    def cut():
        keymap.InputKeyCommand("C-x")()

    def check_window(processName, className):
        return ((processName is None or re.match(processName, keymap.getWindow().getProcessName())) and
                (className is None or re.match(className, keymap.getWindow().getClassName())))

    def reset_region():
        if config.is_marked and config.forward_direction is not None:
            if (check_window("EXCEL.EXE", None) or                        # Microsoft Excel
                    check_window(None, "Edit$")):                             # NotePad 等
                if config.forward_direction:
                    keymap.InputKeyCommand("Left", "Right")()
                else:
                    keymap.InputKeyCommand("Right", "Left")()
            else:
                # 選択されているリージョンのハイライトを解除するためにカーソルキーを発行する
                if config.forward_direction:
                    keymap.InputKeyCommand("Right")()
                else:
                    keymap.InputKeyCommand("Left")()

    def mark(func, forward_direction):
        def _func():
            if config.is_marked:
                # D-Shift だと、A-< や A-> 押下時に、D-Shift が解除されてしまう。その対策
                keymap.InputKeyCommand("D-LShift", "D-RShift")()
                delay()
                func()
                keymap.InputKeyCommand("U-LShift", "U-RShift")()

                # config.forward_direction が未設定の場合、設定する
                if config.forward_direction is None:
                    config.forward_direction = forward_direction
            else:
                func()
        return _func

    def reset_mark(func):
        def _func():
            func()
            config.is_marked = False
            config.forward_direction = None
        return _func

    def reset_search(func):
        def _func():
            func()
            config.is_searching = False
        return _func

    ##################################################
    ## emacsキーバインド
    ##################################################

    keymap_emacs = keymap.defineWindowKeymap(check_func=is_emacs_target)

    ## マルチストロークキーの設定
    keymap_emacs["C-x"] = keymap.defineMultiStrokeKeymap("C-x")
    keymap_emacs["C-m"] = keymap.defineMultiStrokeKeymap("C-m")

    ## 数字キーの設定
    for n in range(10):
        s_vkey = str(n)
        keymap_emacs[     s_vkey] = reset_mark(keymap.InputKeyCommand(     s_vkey))
        keymap_emacs["S-"+s_vkey] = reset_mark(keymap.InputKeyCommand("S-"+s_vkey))

    ## アルファベットキーの設定
    for vkey in range(VK_A, VK_Z + 1):
        s_vkey = "(" + str(vkey) + ")"
        keymap_emacs[     s_vkey] = reset_mark(keymap.InputKeyCommand(     s_vkey))
        keymap_emacs["S-"+s_vkey] = reset_mark(keymap.InputKeyCommand("S-"+s_vkey))

    ## 特殊文字キーの設定
    s_vkey = "(" + str(VK_SPACE) + ")"
    keymap_emacs[     s_vkey] = reset_mark(keymap.InputKeyCommand(     s_vkey))
    keymap_emacs["S-"+s_vkey] = reset_mark(keymap.InputKeyCommand("S-"+s_vkey))
    for vkey in [VK_OEM_MINUS, VK_OEM_PLUS, VK_OEM_COMMA, VK_OEM_PERIOD, VK_OEM_1, VK_OEM_2, VK_OEM_3, VK_OEM_4, VK_OEM_5, VK_OEM_6, VK_OEM_7, VK_OEM_102]:
        s_key = "(" + str(vkey) + ")"
        keymap_emacs[     s_vkey] = reset_mark(keymap.InputKeyCommand(     s_vkey))
        keymap_emacs["S-"+s_vkey] = reset_mark(keymap.InputKeyCommand("S-"+s_vkey))
    for vkey in [VK_MULTIPLY, VK_ADD, VK_SUBTRACT, VK_DECIMAL, VK_DIVIDE]:
        s_key = "(" + str(vkey) + ")"
        keymap_emacs[     s_vkey] = reset_mark(keymap.InputKeyCommand(     s_vkey))
        keymap_emacs["S-"+s_vkey] = reset_mark(keymap.InputKeyCommand("S-"+s_vkey))

    ## quoted-insertキーの設定
    key_condition = keyhac_keymap.KeyCondition.fromString("C-x")
    for vkey in list(key_condition.vk_str_table.keys()):
        if vkey in [VK_MENU, VK_LMENU, VK_RMENU, VK_CONTROL, VK_LCONTROL, VK_RCONTROL, VK_SHIFT, VK_LSHIFT, VK_RSHIFT, VK_LWIN, VK_RWIN]:
            continue

        s_vkey = "(" + str(vkey) + ")"
        keymap_emacs["C-m"][       s_vkey] = reset_search(reset_mark(keymap.InputKeyCommand(       s_vkey)))
        keymap_emacs["C-m"]["S-"  +s_vkey] = reset_search(reset_mark(keymap.InputKeyCommand("S-"  +s_vkey)))
        keymap_emacs["C-m"]["C-"  +s_vkey] = reset_search(reset_mark(keymap.InputKeyCommand("C-"  +s_vkey)))
        keymap_emacs["C-m"]["A-"  +s_vkey] = reset_search(reset_mark(keymap.InputKeyCommand("A-"  +s_vkey)))
        keymap_emacs["C-m"]["C-S-"+s_vkey] = reset_search(reset_mark(keymap.InputKeyCommand("C-S-"+s_vkey)))
        keymap_emacs["C-m"]["A-S-"+s_vkey] = reset_search(reset_mark(keymap.InputKeyCommand("A-s-"+s_vkey)))

    ## 「ファイル操作」のキー設定
    keymap_emacs["C-x"]["C-f"] = reset_search(reset_mark(find_file))
    keymap_emacs["C-x"]["C-s"] = reset_search(reset_mark(save_buffer))
    keymap_emacs["C-x"]["C-w"] = reset_search(reset_mark(write_file))

    ## 「カーソル移動」のキー設定
    keymap_emacs["C-b"]        = reset_search(mark(backward_char, False))
    keymap_emacs["C-f"]        = reset_search(mark(forward_char, True))
    keymap_emacs["A-b"]        = reset_search(mark(backward_word, False))
    keymap_emacs["A-f"]        = reset_search(mark(forward_word, True))
    keymap_emacs["C-p"]        = reset_search(mark(previous_line, False))
    keymap_emacs["C-n"]        = reset_search(mark(next_line, True))
    keymap_emacs["C-a"]        = reset_search(mark(move_beginning_of_line, False))
    keymap_emacs["C-e"]        = reset_search(mark(move_end_of_line, True))
    keymap_emacs["A-S-Comma"]  = reset_search(mark(beginning_of_buffer, False))
    keymap_emacs["A-S-Period"] = reset_search(mark(end_of_buffer, True))

    keymap_emacs["Left"]       = reset_search(mark(backward_char, False))
    keymap_emacs["Right"]      = reset_search(mark(forward_char, True))
    keymap_emacs["C-Left"]     = reset_search(mark(backward_word, False))
    keymap_emacs["C-Right"]    = reset_search(mark(forward_word, True))
    keymap_emacs["Up"]         = reset_search(mark(previous_line, False))
    keymap_emacs["Down"]       = reset_search(mark(next_line, True))
    keymap_emacs["Home"]       = reset_search(mark(move_beginning_of_line, False))
    keymap_emacs["End"]        = reset_search(mark(move_end_of_line, True))
    keymap_emacs["C-Home"]     = reset_search(mark(beginning_of_buffer, False))
    keymap_emacs["C-End"]      = reset_search(mark(end_of_buffer, True))
    keymap_emacs["PageUP"]     = reset_search(mark(scroll_up, False))
    keymap_emacs["PageDown"]   = reset_search(mark(scroll_down, True))

    ## 「カット / コピー / 削除 / アンドゥ」のキー設定
    keymap_emacs["C-h"]        = reset_search(reset_mark(delete_backward_char))
    keymap_emacs["C-d"]        = reset_search(reset_mark(delete_char))
    keymap_emacs["C-k"]        = reset_search(reset_mark(kill_line))
    keymap_emacs["C-w"]        = reset_search(reset_mark(kill_region))
    keymap_emacs["A-w"]        = reset_search(reset_mark(kill_ring_save))
    keymap_emacs["C-y"]        = reset_search(reset_mark(yank))
    keymap_emacs["C-x"]["u"]   = reset_search(reset_mark(undo))

    keymap_emacs["Back"]       = reset_search(reset_mark(delete_backward_char))
    keymap_emacs["Delete"]     = reset_search(reset_mark(delete_char))
    keymap_emacs["C-Back"]     = reset_search(reset_mark(backward_kill_word))
    keymap_emacs["C-Delete"]   = reset_search(reset_mark(kill_word))
    keymap_emacs["C-z"]        = reset_search(reset_mark(undo))

    keymap_emacs["C-Space"]    = set_mark_command
    keymap_emacs["C-x"]["h"]   = reset_search(mark_whole_buffer)
    keymap_emacs["C-x"]["C-p"] = reset_search(mark_whole_buffer)

    ## 「バッファ / ウィンドウ操作」のキー設定
    keymap_emacs["C-x"]["k"]   = reset_search(reset_mark(kill_buffer))
    keymap_emacs["C-x"]["b"]   = reset_search(reset_mark(switch_to_buffer))
    keymap_emacs["A-k"]        = reset_search(reset_mark(kill_buffer))

    ## 「文字列検索 / 置換」のキー設定
    keymap_emacs["C-r"]        = reset_mark(isearch_backward)
    keymap_emacs["C-s"]        = reset_mark(isearch_forward)

    ## 「その他」のキー設定
    keymap_emacs["Enter"]      = reset_mark(newline)
    keymap_emacs["C-j"]        = reset_mark(newline_and_indent)
    keymap_emacs["Tab"]        = reset_mark(indent_for_tab_command)
    keymap_emacs["C-g"]        = reset_search(reset_mark(keyboard_quit))
    keymap_emacs["C-x"]["C-c"] = reset_search(reset_mark(kill_emacs))

    ## 「スクロール」のキー設定
    keymap_emacs["A-v"]        = reset_search(mark(scroll_up, False))
    keymap_emacs["C-v"]        = reset_search(mark(scroll_down, True))

    ####################################################################################################
    ## globalキーバインド
    ####################################################################################################

    keymap_global = keymap.defineWindowKeymap()

    ## グローバルキーマップ
    keymap.replaceKey( 29, 'Apps' ) # 無変換キーをメニューキーに
    keymap_global["C-S-p"] = keymap.command_ClipboardList
    keymap_global["C-S-Space"] = toggle_keyboard_layout

    # ウィンドウ移動
    keymap_global["C-S-H"] = keymap.MoveWindowCommand( -15, 0 ) # ウィンドウ左
    keymap_global["C-S-L"] = keymap.MoveWindowCommand( +15, 0 ) # ウィンドウ右
    keymap_global["C-S-K"] = keymap.MoveWindowCommand( 0, -15 ) # ウィンドウ上
    keymap_global["C-S-J"] = keymap.MoveWindowCommand( 0, +15 ) # ウィンドウ下

    ## IME の切り替えのキー設定
    keymap_global["(243)" ] = toggle_input_method
    keymap_global["(244)" ] = toggle_input_method
    keymap_global["C-Yen" ] = toggle_input_method
    keymap_global["A-(25)"] = toggle_input_method

    ## USキーボードレイアウトのキー設定
    keymap_us2jis = keymap.defineWindowKeymap(check_func=us_layout_to_jis_layout)
    keymap_us2jis["(243)"]   = "S-(192)"
    keymap_us2jis["(244)"]   = "S-(192)"
    keymap_us2jis["S-(243)"] = "S-Caret"
    keymap_us2jis["S-(244)"] = "S-Caret"
    keymap_us2jis["S-2"]     = "Atmark"
    keymap_us2jis["S-6"]     = "Caret"
    keymap_us2jis["S-7"]     = "S-6"
    keymap_us2jis["S-8"]     = "S-Colon"
    keymap_us2jis["S-9"]     = "S-8"
    keymap_us2jis["S-0"]     = "S-9"
    keymap_us2jis["S-(189)"] = "S-BackSlash"
    keymap_us2jis["(222)"]   = "S-Minus"
    keymap_us2jis["S-(222)"] = "(107)"

    keymap_us2jis["(192)"]   = "(219)"
    keymap_us2jis["S-(192)"] = "S-(219)"
    keymap_us2jis["(219)"]   = "(221)"
    keymap_us2jis["S-(219)"] = "S-(221)"
    keymap_us2jis["(221)"]   = "(220)"
    keymap_us2jis["S-(221)"] = "S-(220)"
    keymap_us2jis["C-(221)"] = toggle_input_method

    keymap_us2jis["S-(187)"] = "(186)"
    keymap_us2jis["(186)"]   = "S-7"
    keymap_us2jis["S-(186)"] = "S-2"

    ####################################################################################################
    ## 特定アプリのキーバインド
    ####################################################################################################

    keymap_teams = keymap.defineWindowKeymap(exe_name="teams.exe", class_name="Chrome_WidgetWin_1")
    keymap_teams["C-S-p"]   = "A-Up"
    keymap_teams["C-S-n"]   = "A-Down"
    keymap_teams["C-Tab"]   = "C-F6"
    keymap_teams["C-S-Tab"] = "C-S-F6"

    keymap_outlook = keymap.defineWindowKeymap(exe_name="outlook.exe", class_name="OutlookGrid")
    keymap_outlook["C-r"]   = "C-S-r"
    keymap_outlook["C-S-r"] = "C-r"
    keymap_outlook["C-f"]   = "C-f"
    keymap_outlook["C-s"]   = "C-e"
