{
  config,
  lib,
  osConfig,
  ...
}: let
  cfg = config.yeldirs.desktop.games.input-remapper;
in {
  options = {
    yeldirs.desktop.games.input-remapper.enable = lib.mkEnableOption "input-remapper configs";
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = osConfig.services.input-remapper.enable;
        message = "input-remapper must be enabled!";
      }
    ];

    xdg.configFile = {
      "autostart/input-mapper-autoload.desktop".source = "${osConfig.services.input-remapper.package}/share/applications/input-remapper-autoload.desktop";

      "input-remapper-2/config.json".text =
        /*
        json
        */
        ''
          {
            "version": "2.0.1",
            "autoload": {
              "Razer Razer Nostromo": "gaming"
            }
          }
        '';
      "input-remapper-2/presets/Razer Razer Nostromo/gaming.json".text =
        /*
        json
        */
        ''
          [
            {
              "input_combination": [
                {
                  "type": 1,
                  "code": 58,
                  "origin_hash": "a32eabf653d6398c61442ec4541b598b"
                }
              ],
              "target_uinput": "keyboard",
              "output_symbol": "Shift_L",
              "name": "LSFT",
              "mapping_type": "key_macro"
            },
            {
              "input_combination": [
                {
                  "type": 1,
                  "code": 42,
                  "origin_hash": "a32eabf653d6398c61442ec4541b598b"
                }
              ],
              "target_uinput": "keyboard",
              "output_symbol": "Control_L",
              "name": "LCTL",
              "mapping_type": "key_macro"
            },
            {
              "input_combination": [
                {
                  "type": 1,
                  "code": 56,
                  "origin_hash": "a32eabf653d6398c61442ec4541b598b"
                }
              ],
              "target_uinput": "keyboard",
              "output_symbol": "  space",
              "name": "SPC",
              "mapping_type": "key_macro"
            },
            {
              "input_combination": [
                {
                  "type": 1,
                  "code": 57,
                  "origin_hash": "a32eabf653d6398c61442ec4541b598b"
                }
              ],
              "target_uinput": "keyboard",
              "output_symbol": "Alt_L",
              "name": "LALT",
              "mapping_type": "key_macro"
            }
          ]
        '';
      "input-remapper-2/xmodmap.json".text =/* json */ ''
        {
          "Escape": 1,
          "1": 2,
          "2": 3,
          "3": 4,
          "4": 5,
          "5": 6,
          "6": 7,
          "7": 8,
          "8": 9,
          "9": 10,
          "0": 11,
          "ssharp": 12,
          "dead_acute": 13,
          "BackSpace": 14,
          "Tab": 15,
          "q": 16,
          "w": 17,
          "e": 18,
          "r": 19,
          "t": 20,
          "z": 21,
          "u": 22,
          "i": 23,
          "o": 24,
          "p": 25,
          "udiaeresis": 26,
          "plus": 27,
          "Return": 28,
          "Control_L": 29,
          "a": 30,
          "s": 31,
          "d": 32,
          "f": 33,
          "g": 34,
          "h": 35,
          "j": 36,
          "k": 37,
          "l": 38,
          "odiaeresis": 39,
          "adiaeresis": 40,
          "dead_circumflex": 41,
          "Shift_L": 42,
          "numbersign": 43,
          "y": 44,
          "x": 45,
          "c": 46,
          "v": 47,
          "b": 48,
          "n": 49,
          "m": 50,
          "comma": 51,
          "period": 52,
          "minus": 53,
          "Shift_R": 54,
          "KP_Multiply": 55,
          "Alt_L": 56,
          "space": 57,
          "Caps_Lock": 58,
          "F1": 59,
          "F2": 60,
          "F3": 61,
          "F4": 62,
          "F5": 63,
          "F6": 64,
          "F7": 65,
          "F8": 66,
          "F9": 67,
          "F10": 68,
          "Num_Lock": 69,
          "Scroll_Lock": 70,
          "KP_Home": 71,
          "KP_Up": 72,
          "KP_Prior": 73,
          "KP_Subtract": 74,
          "KP_Left": 75,
          "KP_Begin": 76,
          "KP_Right": 77,
          "KP_Add": 78,
          "KP_End": 79,
          "KP_Down": 80,
          "KP_Next": 81,
          "KP_Insert": 82,
          "KP_Delete": 83,
          "ISO_Level3_Shift": 100,
          "less": 86,
          "F11": 87,
          "F12": 88,
          "Katakana": 90,
          "Hiragana": 91,
          "Henkan_Mode": 92,
          "Hiragana_Katakana": 93,
          "Muhenkan": 94,
          "KP_Enter": 96,
          "Control_R": 97,
          "KP_Divide": 98,
          "Print": 210,
          "Linefeed": 101,
          "Home": 102,
          "Up": 103,
          "Prior": 104,
          "Left": 105,
          "Right": 106,
          "End": 107,
          "Down": 108,
          "Next": 109,
          "Insert": 110,
          "Delete": 111,
          "XF86AudioMute": 113,
          "XF86AudioLowerVolume": 114,
          "XF86AudioRaiseVolume": 115,
          "XF86PowerOff": 116,
          "KP_Equal": 117,
          "plusminus": 118,
          "Pause": 119,
          "XF86LaunchA": 120,
          "KP_Decimal": 121,
          "Hangul": 122,
          "Hangul_Hanja": 123,
          "Super_L": 125,
          "Super_R": 126,
          "Menu": 127,
          "Cancel": 223,
          "Redo": 182,
          "SunProps": 130,
          "Undo": 131,
          "SunFront": 132,
          "XF86Copy": 133,
          "XF86Open": 134,
          "XF86Paste": 135,
          "Find": 136,
          "XF86Cut": 137,
          "Help": 138,
          "XF86MenuKB": 139,
          "XF86Calculator": 140,
          "XF86Sleep": 142,
          "XF86WakeUp": 143,
          "XF86Explorer": 144,
          "XF86Send": 231,
          "XF86Xfer": 147,
          "XF86Launch1": 148,
          "XF86Launch2": 149,
          "XF86WWW": 150,
          "XF86DOS": 151,
          "XF86ScreenSaver": 152,
          "XF86RotateWindows": 153,
          "XF86TaskPane": 154,
          "XF86Mail": 215,
          "XF86Favorites": 156,
          "XF86MyComputer": 157,
          "XF86Back": 158,
          "XF86Forward": 159,
          "XF86Eject": 162,
          "XF86AudioNext": 163,
          "XF86AudioPlay": 207,
          "XF86AudioPrev": 165,
          "XF86AudioStop": 166,
          "XF86AudioRecord": 167,
          "XF86AudioRewind": 168,
          "XF86Phone": 169,
          "XF86Tools": 183,
          "XF86HomePage": 172,
          "XF86Reload": 173,
          "XF86Close": 206,
          "XF86ScrollUp": 177,
          "XF86ScrollDown": 178,
          "parenleft": 179,
          "parenright": 180,
          "XF86New": 181,
          "XF86Launch5": 184,
          "XF86Launch6": 185,
          "XF86Launch7": 186,
          "XF86Launch8": 187,
          "XF86Launch9": 188,
          "XF86AudioMicMute": 190,
          "XF86TouchpadToggle": 191,
          "XF86TouchpadOn": 192,
          "XF86TouchpadOff": 193,
          "ISO_Level5_Shift": 195,
          "NoSymbol": 199,
          "XF86AudioPause": 201,
          "XF86Launch3": 202,
          "XF86Launch4": 203,
          "XF86LaunchB": 204,
          "XF86Suspend": 205,
          "XF86AudioForward": 208,
          "XF86WebCam": 212,
          "XF86AudioPreset": 213,
          "XF86Messenger": 216,
          "XF86Search": 217,
          "XF86Go": 218,
          "XF86Finance": 219,
          "XF86Game": 220,
          "XF86Shop": 221,
          "XF86MonBrightnessDown": 224,
          "XF86MonBrightnessUp": 225,
          "XF86AudioMedia": 226,
          "XF86Display": 227,
          "XF86KbdLightOnOff": 228,
          "XF86KbdBrightnessDown": 229,
          "XF86KbdBrightnessUp": 230,
          "XF86Reply": 232,
          "XF86MailForward": 233,
          "XF86Save": 234,
          "XF86Documents": 235,
          "XF86Battery": 236,
          "XF86Bluetooth": 237,
          "XF86WLAN": 238,
          "XF86UWB": 239,
          "XF86Next_VMode": 241,
          "XF86Prev_VMode": 242,
          "XF86MonBrightnessCycle": 243,
          "XF86BrightnessAuto": 244,
          "XF86DisplayOff": 245,
          "XF86WWAN": 246,
          "XF86RFKill": 247
        }
        '';
    };
  };
}
