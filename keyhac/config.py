# -*- mode: python; coding: utf-8-dos -*-

## [下記をもとに編集 @haccht]
## http://www49.atwiki.jp/ntemacs/pages/25.html

##
## Windows の操作を emacs のキーバインドで行う設定（keyhac版）
##

# このスクリプトは、keyhac で動作します。
#   https://sites.google.com/site/craftware/keyhac
# スクリプトですので、使いやすいようにカスタマイズしてご利用ください。
#
# この内容は、utf-8-dos の coding-system で config.py の名前でセーブして
# 利用してください。また、このスクリプトの最後の方にキーボードマクロの
# キーバインドの設定があります。英語キーボードと日本語キーボードで設定の
# 内容を変える必要があるので、利用しているキーボードに応じて、コメントの
# 設定を変更してください。（現在の設定は、英語キーボードとなっています。）
#
# emacs の挙動と明らかに違う動きの部分は以下のとおりです。
# ・C-c、C-z は、Windows の「コピー」、「取り消し」が機能するようにしている。
# ・C-x C-y で、クリップボード履歴を表示する。（C-n で選択を移動し、Enter で確定する）
# ・C-k を連続して実行しても、クリップボードへの削除文字列の蓄積は行われない。
#   C-u による行数指定をすると、削除行を一括してクリップボードに入れることができる。
# ・C-l は、対応する Windows の機能がないのでサポートしていない。


from time   import sleep
from keyhac import *
from pyauto.pyauto_const import *


def configure(keymap):

    if 1:

        def is_emacs_target(window):
            if window.getClassName()   in ("ConsoleWindowClass", # Cmd, Cygwin
                                           "mintty",             # mintty
                                           "Emacs",              # NTEmacs
                                           "Vim",                # Vim
                                           "PuTTY",              # PuTTY
                                           "CtxICADisp",         # Citrix
                                           "SWT_Window0"):       # Eclipse
                return False
            if window.getProcessName() in ("xyzzy.exe",          # xyzzy
                                           "VirtualBox.exe",     # VirtualBox
                                           "XWin.exe",           # Cygwin/X
                                           "ConEmu.exe",         # Terminal
                                           "ttermpro.exe",       # Tera Term
                                           "Xming.exe"):         # Xming
                return False
            return True

        keymap_emacs = keymap.defineWindowKeymap(check_func=is_emacs_target)

        # mark が set 押されると True になる
        keymap_emacs.is_mark = False

        # universal-argument コマンドが実行されると True になる
        keymap_emacs.is_universal_argument = False

        # universal-argument コマンドが実行された後に数字が入力されると True になる
        keymap_emacs.is_digit = False

        # コマンドのリピート回数を設定する
        keymap_emacs.repeat_count = 1

        ########################################################################
        # IMEの切替え
        ########################################################################

        def toggle_input_method():
            keymap.command_InputKey("(243)")()

        ########################################################################
        # ファイル操作
        ########################################################################

        def find_file():
            keymap.command_InputKey("C-o")()
            keymap_emacs.is_mark = False

        def save_buffer():
            keymap.command_InputKey("C-s")()

        def write_file():
            keymap.command_InputKey("A-f", "A-a")()

        ########################################################################
        # カーソル移動 
        ########################################################################

        def forward_char():
            keymap.command_InputKey("Right")()

        def backward_char():
            keymap.command_InputKey("Left")()

        def next_line():
            keymap.command_InputKey("Down")()

        def previous_line():
            keymap.command_InputKey("Up")()

        def move_beginning_of_line():
            keymap.command_InputKey("Home")()

        def move_end_of_line():
            keymap.command_InputKey("End")()
            if keymap.getWindow().getClassName().startswith("_WwG"):  # Microsoft Word
                if keymap_emacs.is_mark:
                    keymap.command_InputKey("Left")()

        def beginning_of_buffer():
            keymap.command_InputKey("C-Home")()

        def end_of_buffer():
            keymap.command_InputKey("C-End")()

        def scroll_up():
            keymap.command_InputKey("PageUp")()

        def scroll_down():
            keymap.command_InputKey("PageDown")()

        ########################################################################
        # カット / コピー / 削除 / アンドゥ
        ########################################################################

        def delete_backward_char():
            keymap.command_InputKey("Back")()
            keymap_emacs.is_mark = False

        def delete_char():
            keymap.command_InputKey("Delete")()
            keymap_emacs.is_mark = False

        def kill_line():
            keymap_emacs.is_mark = True
            mark(move_end_of_line)()
            keymap.command_InputKey("C-c", "Delete")()
            keymap_emacs.is_mark = False

        def kill_line2():
            if keymap_emacs.repeat_count == 1:
                kill_line()
            else:
                keymap_emacs.is_mark = True
                if keymap.getWindow().getClassName().startswith("_WwG"):  # Microsoft Word
                    for i in range(keymap_emacs.repeat_count):
                        mark(next_line)()
                    mark(move_beginning_of_line)()
                else:
                    for i in range(keymap_emacs.repeat_count - 1):
                        mark(next_line)()
                    mark(move_end_of_line)()
                    mark(forward_char)()
                kill_region()
                keymap_emacs.is_mark = False

        def kill_region():
            keymap.command_InputKey("C-x")()
            keymap_emacs.is_mark = False

        def kill_ring_save():
            keymap.command_InputKey("C-c")()
            if not keymap.getWindow().getClassName().startswith("EXCEL"):  # Microsoft Excel 以外
                keymap.command_InputKey("Esc")()
            keymap_emacs.is_mark = False

        def windows_copy():
            keymap.command_InputKey("C-c")()
            keymap_emacs.is_mark = False

        def yank():
            keymap.command_InputKey("C-v")()
            keymap_emacs.is_mark = False

        def undo():
            keymap.command_InputKey("C-z")()
            keymap_emacs.is_mark = False

        def set_mark_command():
            if keymap_emacs.is_mark:
                keymap_emacs.is_mark = False
            else:
                keymap_emacs.is_mark = True

        def mark_whole_buffer():
            keymap.command_InputKey("C-End", "C-S-Home")()
            keymap_emacs.is_mark = True

        def mark_page():
            keymap.command_InputKey("C-End", "C-S-Home")()
            keymap_emacs.is_mark = True

        def open_line():
            keymap.command_InputKey("Enter", "Up", "End")()
            keymap_emacs.is_mark = False

        ########################################################################
        # バッファ / ウインドウ操作 
        ########################################################################

        def kill_buffer():
            keymap.command_InputKey("C-F4")()
            keymap_emacs.is_mark = False

        def other_window():
            keymap.command_InputKey("D-ALT")()
            keymap.command_InputKey("Tab")()
            sleep(0.01)
            keymap.command_InputKey("U-ALT")()
            keymap_emacs.is_mark = False

        ########################################################################
        # 文字列検索 / 置換 
        ########################################################################

        def isearch_forward():
            keymap.command_InputKey("C-f")()
            keymap_emacs.is_mark = False

        def isearch_backward():
            keymap.command_InputKey("C-f")()
            keymap_emacs.is_mark = False

        ########################################################################
        # キーボードマクロ
        ########################################################################

        def kmacro_start_macro():
            keymap.command_RecordStart()

        def kmacro_end_macro():
            keymap.command_RecordStop()
            # キーボードマクロの終了キー C-x ) の C-x がマクロに記録されてしまうのを削除する
            # キーボードマクロの終了キーの前提を C-x ) としていることについては、とりえず了承ください
            if len(keymap.record_seq) > 0 and keymap.record_seq[len(keymap.record_seq) - 1] == (162, True):
                keymap.record_seq.pop()
                if len(keymap.record_seq) > 0 and keymap.record_seq[len(keymap.record_seq) - 1] == (88, True):
                    keymap.record_seq.pop()
                    if len(keymap.record_seq) > 0 and keymap.record_seq[len(keymap.record_seq) - 1] == (88, False):
                        keymap.record_seq.pop()
                        if len(keymap.record_seq) > 0 and keymap.record_seq[len(keymap.record_seq) - 1] == (162, False):
                            for i in range(len(keymap.record_seq) - 1, -1, -1):
                                if keymap.record_seq[i] == (162, False):
                                    keymap.record_seq.pop()
                                else:
                                    break
                        else:
                            # コントロール系の入力が連続して行われる場合があるための対処
                            keymap.record_seq.append((162, True))

        def kmacro_end_and_call_macro():
            keymap.command_RecordPlay()

        ########################################################################
        # その他
        ########################################################################

        def newline():
            keymap.command_InputKey("Enter")()
            keymap_emacs.is_mark = False

        def newline_and_indent():
            keymap.command_InputKey("Enter", "Tab")()
            keymap_emacs.is_mark = False

        def indent_for_tab_command():
            keymap.command_InputKey("Tab")()
            keymap_emacs.is_mark = False

        def keyboard_quit():
            #if not keymap.getWindow().getClassName().startswith("EXCEL"):  # Microsoft Excel 以外
            # Excelも含めて全Windowで @haccht
            keymap.command_InputKey("Esc")()
            keymap.command_RecordStop()
            keymap_emacs.is_mark = False

        def kill_emacs():
            keymap.command_InputKey("A-F4")()
            keymap_emacs.is_mark = False

        def universal_argument():
            keymap_emacs.is_universal_argument = True
            keymap_emacs.repeat_count = keymap_emacs.repeat_count * 4

        def clipboard_list():
            keymap_emacs.is_mark = False
            keymap.command_ClipboardList()

        ########################################################################
        # 共通関数
        ########################################################################

        def digit(number):
            def _digit():
                if keymap_emacs.is_universal_argument == True:
                    if keymap_emacs.is_digit == True:
                        keymap_emacs.repeat_count = keymap_emacs.repeat_count * 10 + number
                    else:
                        keymap_emacs.repeat_count = number
                        keymap_emacs.is_digit = True
                else:
                    repeat(keymap.command_InputKey(str(number)))()
            return _digit

        def mark(func):
            def _mark():
                if keymap_emacs.is_mark:
                    # D-Shift だと、M-< や M-> 押下時に、D-Shift が解除されてしまう。その対策。
                    keymap.command_InputKey("D-LShift")()
                    keymap.command_InputKey("D-RShift")()
                func()
                if keymap_emacs.is_mark:
                    keymap.command_InputKey("U-LShift")()
                    keymap.command_InputKey("U-RShift")()
            return _mark

        def reset_mark(func):
            def _reset_mark():
                func()
                keymap_emacs.is_mark = False
            return _reset_mark

        def repeat(func):
            def _repeat():
                keymap_emacs.is_universal_argument = False
                keymap_emacs.is_digit = False
                repeat_count = keymap_emacs.repeat_count
                keymap_emacs.repeat_count = 1
                for i in range(repeat_count):
                    func()
            return _repeat

        def repeat2(func):
            def _repeat2():
                if keymap_emacs.is_mark == True:
                    keymap_emacs.repeat_count = 1
                repeat(func)()
            return _repeat2

        def reset(func):
            def _reset():
                keymap_emacs.is_universal_argument = False
                keymap_emacs.is_digit = False
                keymap_emacs.repeat_count = 1
                func()
            return _reset

        ########################################################################
        # キーバインド
        ########################################################################

        # http://www.azaelia.net/factory/vk.html

        # 0-9
        for vkey in range(48, 57 + 1):
            keymap_emacs["S-(" + str(vkey) + ")"] = reset_mark(repeat(keymap.command_InputKey("S-(" + str(vkey) + ")")))

        # A-Z
        for vkey in range(65, 90 + 1):
            keymap_emacs[  "(" + str(vkey) + ")"] = reset_mark(repeat(keymap.command_InputKey(  "(" + str(vkey) + ")")))
            keymap_emacs["S-(" + str(vkey) + ")"] = reset_mark(repeat(keymap.command_InputKey("S-(" + str(vkey) + ")")))

        # 10 key の特殊文字
        for vkey in [106, 107, 109, 110, 111]:
            keymap_emacs[  "(" + str(vkey) + ")"] = reset_mark(repeat(keymap.command_InputKey(  "(" + str(vkey) + ")")))

        # 特殊文字
        for vkey in list(range(186, 192 + 1)) + list(range(219, 222 + 1)) + [226]:
            keymap_emacs[  "(" + str(vkey) + ")"] = reset_mark(repeat(keymap.command_InputKey(  "(" + str(vkey) + ")")))
            keymap_emacs["S-(" + str(vkey) + ")"] = reset_mark(repeat(keymap.command_InputKey("S-(" + str(vkey) + ")")))

        keymap_emacs["C-q"] = keymap.defineMultiStrokeKeymap("C-q")
        for vkey in range(256):
            keymap_emacs["C-q"][  "(" + str(vkey) + ")"] = reset_mark(repeat(keymap.command_InputKey(  "(" + str(vkey) + ")")))
            keymap_emacs["C-q"]["S-(" + str(vkey) + ")"] = reset_mark(repeat(keymap.command_InputKey("S-(" + str(vkey) + ")")))
            keymap_emacs["C-q"]["C-(" + str(vkey) + ")"] = reset_mark(repeat(keymap.command_InputKey("C-(" + str(vkey) + ")")))
            keymap_emacs["C-q"]["A-(" + str(vkey) + ")"] = reset_mark(repeat(keymap.command_InputKey("A-(" + str(vkey) + ")")))

        for key in range(10):
            keymap_emacs[str(key)]      = digit(key)

        #keymap_emacs["C-u"]             = universal_argument

        keymap_emacs["C-b"]             = repeat(mark(backward_char))
        keymap_emacs["C-f"]             = repeat(mark(forward_char))
        keymap_emacs["C-n"]             = repeat(mark(next_line))
        keymap_emacs["C-p"]             = repeat(mark(previous_line))

        keymap_emacs["C-d"]             = repeat2(delete_char)
        keymap_emacs["C-h"]             = repeat2(delete_backward_char)

        keymap_emacs["C-Space"]         = reset(set_mark_command)
        keymap_emacs["C-Slash"]         = reset(undo)
        #keymap_emacs["C-Atmark"]        = reset(set_mark_command)
        keymap_emacs["C-Underscore"]    = reset(undo)
        keymap_emacs["C-a"]             = reset(mark(move_beginning_of_line))
        keymap_emacs["C-c"]             = reset(windows_copy)
        keymap_emacs["C-e"]             = reset(mark(move_end_of_line))
        keymap_emacs["C-g"]             = reset(keyboard_quit)
        keymap_emacs["C-i"]             = reset(indent_for_tab_command)
        keymap_emacs["C-j"]             = reset(newline_and_indent)
        keymap_emacs["C-k"]             = reset(kill_line2)
        keymap_emacs["C-m"]             = reset(newline)
        keymap_emacs["C-o"]             = reset(open_line)
        keymap_emacs["C-r"]             = reset(isearch_backward)
        keymap_emacs["C-s"]             = reset(isearch_forward)
        keymap_emacs["C-v"]             = reset(mark(scroll_down))
        keymap_emacs["C-w"]             = reset(kill_region)
        keymap_emacs["C-y"]             = reset(yank)
        keymap_emacs["C-z"]             = reset(undo)

        keymap_emacs["A-S-Comma"]       = reset(mark(beginning_of_buffer))
        keymap_emacs["A-S-Period"]      = reset(mark(end_of_buffer))
        keymap_emacs["A-v"]             = reset(mark(scroll_up))
        keymap_emacs["A-w"]             = reset(kill_ring_save)

        keymap_emacs["Esc"]             = reset(keyboard_quit)
        #keymap_emacs["Esc"]             = keymap.defineMultiStrokeKeymap("Esc")
        #keymap_emacs["Esc"]["Esc"]      = reset(keymap.command_InputKey("Esc"))
        #keymap_emacs["Esc"]["S-Comma"]  = reset(mark(beginning_of_buffer))
        #keymap_emacs["Esc"]["S-Period"] = reset(mark(end_of_buffer))
        #keymap_emacs["Esc"]["v"]        = reset(mark(scroll_up))
        #keymap_emacs["Esc"]["w"]        = reset(kill_ring_save)

        keymap_emacs["C-OpenBracket"]   = reset(keyboard_quit)
        #keymap_emacs["C-OpenBracket"]                  = keymap.defineMultiStrokeKeymap("C-OpenBracket")
        #keymap_emacs["C-OpenBracket"]["C-OpenBracket"] = reset(keymap.command_InputKey("Esc"))
        #keymap_emacs["C-OpenBracket"]["S-Comma"]       = reset(mark(beginning_of_buffer))
        #keymap_emacs["C-OpenBracket"]["S-Period"]      = reset(mark(end_of_buffer))
        #keymap_emacs["C-OpenBracket"]["v"]             = reset(mark(scroll_up))
        #keymap_emacs["C-OpenBracket"]["w"]             = reset(kill_ring_save)

        keymap_emacs["C-x"]             = keymap.defineMultiStrokeKeymap("C-x")
        keymap_emacs["C-x"]["C-c"]      = reset(kill_emacs)
        keymap_emacs["C-x"]["C-f"]      = reset(find_file)
        keymap_emacs["C-x"]["C-p"]      = reset(mark_page)
        keymap_emacs["C-x"]["C-s"]      = reset(save_buffer)
        keymap_emacs["C-x"]["C-w"]      = reset(write_file)
        keymap_emacs["C-x"]["C-y"]      = reset(clipboard_list)
        keymap_emacs["C-x"]["h"]        = reset(mark_whole_buffer)
        keymap_emacs["C-x"]["k"]        = reset(kill_buffer)
        keymap_emacs["C-x"]["o"]        = reset(other_window)
        keymap_emacs["C-x"]["u"]        = reset(undo)

        # キーボードマクロ（英語キーボードの場合）
        # keymap_emacs["C-x"]["S-9"]      = kmacro_start_macro
        # keymap_emacs["C-x"]["S-0"]      = kmacro_end_macro

        # キーボードマクロ（日本語キーボードの場合）
        keymap_emacs["C-x"]["S-8"]      = kmacro_start_macro
        keymap_emacs["C-x"]["S-9"]      = kmacro_end_macro

        # キーボードマクロ（共通）
        keymap_emacs["C-x"]["e"]        = repeat(kmacro_end_and_call_macro)


    if 1:

        ########################################################################
        # 共通関数 @haccht
        ########################################################################

        # 最大化とリストア
        def toggle_MaximizeWindow(getwnd):
            def _toggle_MaximizeWindow():
                wnd = getwnd()
                if wnd.isMaximized():
                    wnd.restore()
                else:
                    wnd.maximize()
            return _toggle_MaximizeWindow

        # IMEをオフにして実行
        def ime_off(func):
            def _ime_off():
                if keymap.wnd.getImeStatus():
                  keymap.wnd.setImeStatus(False)
                  sleep(0.01)
                func()
            return _ime_off

        # キー無効化
        def do_nothing():
            pass

        ########################################################################
        # キーバインドとローカルセッティング
        ########################################################################

        # ローカルセッティング
        keymap.clipboard_history.maxnum = 100
        keymap.replaceKey( 28, 244 )    # 変換キーをIMEトグルに
        keymap.replaceKey( 29, 'Apps' ) # 無変換キーをメニューキーに

        # グローバルキーマップ
        keymap_global = keymap.defineWindowKeymap()
        keymap_global[ "C-S-H" ] = keymap.command_MoveWindow( -15, 0 ) # ウィンドウ左
        keymap_global[ "C-S-L" ] = keymap.command_MoveWindow( +15, 0 ) # ウィンドウ右
        keymap_global[ "C-S-K" ] = keymap.command_MoveWindow( 0, -15 ) # ウィンドウ上
        keymap_global[ "C-S-J" ] = keymap.command_MoveWindow( 0, +15 ) # ウィンドウ下
        keymap_global[ "C-S-M" ] = toggle_MaximizeWindow(keymap.getTopLevelWindow) # ウィンドウ最大化トグル
        keymap_global[ "C-Yen" ] = toggle_input_method
        keymap_global[ "(242)" ] = do_nothing


    if 1:

        # for Excel
        keymap_excel = keymap.defineWindowKeymap(class_name=u'EXCEL*')
        keymap_excel[ "C-Enter"] = reset(keymap.command_InputKey("F2"))     # セル編集モード移行
        keymap_excel[ "Esc" ]    = reset(keyboard_quit)

        # for Outlook（グリッドビュー）
        keymap_outlook = keymap.defineWindowKeymap(exe_name=u'OUTLOOK.EXE', class_name=u'SUPERGRID')
        keymap_outlook[ "G" ] = keymap.defineMultiStrokeKeymap("G")
        keymap_outlook[ "G" ][ "G" ] = "Home"    # カーソル先頭
        keymap_outlook[ "G" ][ "I" ] = "C-S-I"   # 受信トレイ
        keymap_outlook[ "G" ][ "S" ] = "C-S-O"   # 送信トレイ
        keymap_outlook[ "G" ][ "N" ] = "C-S-M"   # メール作成	
        keymap_outlook[ "G" ][ "M" ] = "C-M"     # メール受信
        keymap_outlook[ "S-G" ]      = "End"     # カーソル末尾
        keymap_outlook[ "Slash" ]    = "C-E"     # メール検索
        keymap_outlook[ "J" ]        = "Down"    # カーソル下
        keymap_outlook[ "K" ]        = "Up"      # カーソル上
        keymap_outlook[ "H" ]        = "Left"    # カーソル左
        keymap_outlook[ "L" ]        = "Right"   # カーソル右
        keymap_outlook[ "C" ]        = "C-Y"     # フォルダ移動
        keymap_outlook[ "S-R" ]      = "C-S-R"   # 全員に返信
        keymap_outlook[ "R" ]        = "C-R"     # 返信
        keymap_outlook[ "F" ]        = "C-F"     # 転送
        keymap_outlook[ "D" ]        = "C-D"     # 削除
        keymap_outlook[ "S" ]        = "Insert"  # クイックフラグ
        keymap_outlook[ "S-S" ]      = "C-S-6"   # スケジュール
        keymap_outlook[ "U" ]        = "C-Z"     # アンドゥ
        keymap_outlook[ "E" ]        = ime_off(keymap.command_InputKey("C-S-V", "Right"))   # アーカイブ
        keymap_outlook[ "Space" ]    = ime_off(keymap.command_InputKey("Space"))
        keymap_outlook[ "S-Space" ]  = ime_off(keymap.command_InputKey("S-Space"))
        
        # for Outlook（エディットビュー）
        keymap_outlook_addr = keymap.defineWindowKeymap(exe_name=u'OUTLOOK.EXE', class_name=u'RichEdit20WPT')
        keymap_outlook_addr[ "C-I" ] = "C-K"     # 名前の確認


    if 1:
        # mintty
        keymap_mintty = keymap.defineWindowKeymap(exe_name=u'MINTTY.EXE')
        keymap_mintty[ "C-S-M" ]     = "A-Enter"

    if 1:
        # firefox
        keymap_firefox = keymap.defineWindowKeymap(exe_name=u'FIREFOX.EXE')
        keymap_firefox[ "C-I" ]      = "Insert"
