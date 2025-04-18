{
  config,
  lib,
  pkgs,
  ...
}: let
  essentials = config.yeldirs.cli.essentials;
  cfg = config.yeldirs.cli.essentials.ranger;
in {
  options = {
    yeldirs.cli.essentials.ranger = {
      enableGui = lib.mkEnableOption "ranger with graphical ui";
    };
  };

  config = lib.mkIf essentials.enable {
    # Various dependencies.
    home.packages = with pkgs;
      [
        atool # archive tools
        bat
        exiftool
        file # find filetype
        poppler_utils # pdftotext
      ]
      ++ (lib.optionals cfg.enableGui [
        ffmpeg
        ffmpegthumbnailer
        imagemagick # convert
        librsvg # rsvg-convert
      ]);

    programs.ranger = {
      enable = true;
      settings = {
        show_hidden = true;
        preview_images = cfg.enableGui;
        preview_images_method = "kitty";
        use_preview_script = true;
        preview_script = "${config.home.homeDirectory}/.config/ranger/scope.sh";
      };
      rifle = [
        {
          condition = "ext lock";
          command = "\${VISUAL:-$EDITOR} -- \"$@\"";
        }
        {
          condition = "ext nix";
          command = "\${VISUAL:-$EDITOR} -- \"$@\"";
        }
        {
          condition = "ext pdf, has google-chrome-stable,     X, flag f";
          command = "google-chrome-stable \"$@\"";
        }
        #
        # Everything below this is taken from the default rifle.conf
        # https://github.com/ranger/ranger/blob/master/ranger/config/rifle.conf
        #
        #############################
        #
        # vim: ft=cfg
        #
        # This is the configuration file of "rifle", ranger's file executor/opener.
        # Each line consists of conditions and a command.  For each line the conditions
        # are checked and if they are met, the respective command is run.
        #
        # Syntax:
        #   <condition1> , <condition2> , ... = command
        #
        # The command can contain these environment variables:
        #   $1-$9 | The n-th selected file
        #   $@    | All selected files
        #
        # If you use the special command "ask", rifle will ask you what program to run.
        #
        # Prefixing a condition with "!" will negate its result.
        # These conditions are currently supported:
        #   match <regexp> | The regexp matches $1
        #   ext <regexp>   | The regexp matches the extension of $1
        #   mime <regexp>  | The regexp matches the mime type of $1
        #   name <regexp>  | The regexp matches the basename of $1
        #   path <regexp>  | The regexp matches the absolute path of $1
        #   has <program>  | The program is installed (i.e. located in $PATH)
        #   env <variable> | The environment variable "variable" is non-empty
        #   file           | $1 is a file
        #   directory      | $1 is a directory
        #   number <n>     | change the number of this command to n
        #   terminal       | stdin, stderr and stdout are connected to a terminal
        #   X              | A graphical environment is available (darwin, Xorg, or Wayland)
        #
        # There are also pseudo-conditions which have a "side effect":
        #   flag <flags>  | Change how the program is run. See below.
        #   label <label> | Assign a label or name to the command so it can
        #                 | be started with :open_with <label> in ranger
        #                 | or `rifle -p <label>` in the standalone executable.
        #   else          | Always true.
        #
        # Flags are single characters which slightly transform the command:
        #   f | Fork the program, make it run in the background.
        #     |   New command = setsid $command >& /dev/null &
        #   r | Execute the command with root permissions
        #     |   New command = sudo $command
        #   t | Run the program in a new terminal.  If $TERMCMD is not defined,
        #     | rifle will attempt to extract it from $TERM.
        #     |   New command = $TERMCMD -e $command
        # Note: The "New command" serves only as an illustration, the exact
        # implementation may differ.
        # Note: When using rifle in ranger, there is an additional flag "c" for
        # only running the current file even if you have marked multiple files.

        #-------------------------------------------
        # Websites
        #-------------------------------------------
        # Rarely installed browsers get higher priority; It is assumed that if you
        # install a rare browser, you probably use it.  Firefox/konqueror/w3m on the
        # other hand are often only installed as fallback browsers.
        {
          condition = "ext x?html?, has surf,             X, flag f";
          command = "surf -- file://\"$1\"";
        }
        {
          condition = "ext x?html?, has vimprobable,      X, flag f";
          command = "vimprobable -- \"$@\"";
        }
        {
          condition = "ext x?html?, has vimprobable2,     X, flag f";
          command = "vimprobable2 -- \"$@\"";
        }
        {
          condition = "ext x?html?, has qutebrowser,      X, flag f";
          command = "qutebrowser -- \"$@\"";
        }
        {
          condition = "ext x?html?, has dwb,              X, flag f";
          command = "dwb -- \"$@\"";
        }
        {
          condition = "ext x?html?, has jumanji,          X, flag f";
          command = "jumanji -- \"$@\"";
        }
        {
          condition = "ext x?html?, has luakit,           X, flag f";
          command = "luakit -- \"$@\"";
        }
        {
          condition = "ext x?html?, has uzbl,             X, flag f";
          command = "uzbl -- \"$@\"";
        }
        {
          condition = "ext x?html?, has uzbl-tabbed,      X, flag f";
          command = "uzbl-tabbed -- \"$@\"";
        }
        {
          condition = "ext x?html?, has uzbl-browser,     X, flag f";
          command = "uzbl-browser -- \"$@\"";
        }
        {
          condition = "ext x?html?, has uzbl-core,        X, flag f";
          command = "uzbl-core -- \"$@\"";
        }
        {
          condition = "ext x?html?, has midori,           X, flag f";
          command = "midori -- \"$@\"";
        }
        {
          condition = "ext x?html?, has opera,            X, flag f";
          command = "opera -- \"$@\"";
        }
        {
          condition = "ext x?html?, has firefox,          X, flag f";
          command = "firefox -- \"$@\"";
        }
        {
          condition = "ext x?html?, has seamonkey,        X, flag f";
          command = "seamonkey -- \"$@\"";
        }
        {
          condition = "ext x?html?, has iceweasel,        X, flag f";
          command = "iceweasel -- \"$@\"";
        }
        {
          condition = "ext x?html?, has chromium-browser, X, flag f";
          command = "chromium-browser -- \"$@\"";
        }
        {
          condition = "ext x?html?, has chromium,         X, flag f";
          command = "chromium -- \"$@\"";
        }
        {
          condition = "ext x?html?, has google-chrome,    X, flag f";
          command = "google-chrome -- \"$@\"";
        }
        {
          condition = "ext x?html?, has epiphany,         X, flag f";
          command = "epiphany -- \"$@\"";
        }
        {
          condition = "ext x?html?, has konqueror,        X, flag f";
          command = "konqueror -- \"$@\"";
        }
        {
          condition = "ext x?html?, has elinks,            terminal";
          command = "elinks \"$@\"";
        }
        {
          condition = "ext x?html?, has links2,            terminal";
          command = "links2 \"$@\"";
        }
        {
          condition = "ext x?html?, has links,             terminal";
          command = "links \"$@\"";
        }
        {
          condition = "ext x?html?, has lynx,              terminal";
          command = "lynx -- \"$@\"";
        }
        {
          condition = "ext x?html?, has w3m,               terminal";
          command = "w3m \"$@\"";
        }

        #-------------------------------------------
        # Misc
        #-------------------------------------------
        # Define the "editor" for text files as first action
        {
          condition = "mime ^text,  label editor";
          command = "\${VISUAL:-$EDITOR} -- \"$@\"";
        }
        {
          condition = "mime ^text,  label pager ";
          command = "$PAGER -- \"$@\"";
        }
        {
          condition = "!mime ^text, label editor, ext xml|json|csv|tex|py|pl|rb|rs|js|sh|php|dart|tpl";
          command = "\${VISUAL:-$EDITOR} -- \"$@\"";
        }
        {
          condition = "!mime ^text, label pager,  ext xml|json|csv|tex|py|pl|rb|rs|js|sh|php|dart";
          command = "$PAGER -- \"$@\"";
        }

        {
          condition = "ext 1                        ";
          command = "man \"$1\"";
        }
        {
          condition = "ext s[wmf]c, has zsnes, X    ";
          command = "zsnes \"$1\"";
        }
        {
          condition = "ext s[wmf]c, has snes9x-gtk,X";
          command = "snes9x-gtk \"$1\"";
        }
        {
          condition = "ext nes, has fceux, X        ";
          command = "fceux \"$1\"";
        }
        {
          condition = "ext exe, has wine            ";
          command = "wine \"$1\"";
        }
        {
          condition = "name ^[mM]akefile$           ";
          command = "make";
        }

        #--------------------------------------------
        # Scripts
        #-------------------------------------------
        {
          condition = "ext py ";
          command = "python -- \"$1\"";
        }
        {
          condition = "ext pl ";
          command = "perl -- \"$1\"";
        }
        {
          condition = "ext rb ";
          command = "ruby -- \"$1\"";
        }
        {
          condition = "ext js ";
          command = "node -- \"$1\"";
        }
        {
          condition = "ext sh ";
          command = "sh -- \"$1\"";
        }
        {
          condition = "ext php";
          command = "php -- \"$1\"";
        }
        {
          condition = "ext dart";
          command = "dart run -- \"$1\"";
        }

        #--------------------------------------------
        # Audio without X
        #-------------------------------------------
        {
          condition = "mime ^audio|ogg$, terminal, has mpv     ";
          command = "mpv -- \"$@\"";
        }
        {
          condition = "mime ^audio|ogg$, terminal, has mplayer2";
          command = "mplayer2 -- \"$@\"";
        }
        {
          condition = "mime ^audio|ogg$, terminal, has mplayer ";
          command = "mplayer -- \"$@\"";
        }
        {
          condition = "ext midi?,        terminal, has wildmidi";
          command = "wildmidi -- \"$@\"";
        }

        #--------------------------------------------
        # Video/Audio with a GUI
        #-------------------------------------------
        {
          condition = "mime ^video|^audio, has gmplayer, X, flag f";
          command = "gmplayer -- \"$@\"";
        }
        {
          condition = "mime ^video|^audio, has smplayer, X, flag f";
          command = "smplayer \"$@\"";
        }
        {
          condition = "mime ^video,        has mpv,      X, flag f";
          command = "mpv -- \"$@\"";
        }
        {
          condition = "mime ^video,        has mpv,      X, flag f";
          command = "mpv --fs -- \"$@\"";
        }
        {
          condition = "mime ^video,        has mplayer2, X, flag f";
          command = "mplayer2 -- \"$@\"";
        }
        {
          condition = "mime ^video,        has mplayer2, X, flag f";
          command = "mplayer2 -fs -- \"$@\"";
        }
        {
          condition = "mime ^video,        has mplayer,  X, flag f";
          command = "mplayer -- \"$@\"";
        }
        {
          condition = "mime ^video,        has mplayer,  X, flag f";
          command = "mplayer -fs -- \"$@\"";
        }
        {
          condition = "mime ^video|^audio, has vlc,      X, flag f";
          command = "vlc -- \"$@\"";
        }
        {
          condition = "mime ^video|^audio, has totem,    X, flag f";
          command = "totem -- \"$@\"";
        }
        {
          condition = "mime ^video|^audio, has totem,    X, flag f";
          command = "totem --fullscreen -- \"$@\"";
        }
        {
          condition = "mime ^audio,        has audacity, X, flag f";
          command = "audacity -- \"$@\"";
        }
        {
          condition = "ext aup,            has audacity, X, flag f";
          command = "audacity -- \"$@\"";
        }

        #--------------------------------------------
        # Video without X
        #-------------------------------------------
        {
          condition = "mime ^video, terminal, !X, has mpv      ";
          command = "mpv -- \"$@\"";
        }
        {
          condition = "mime ^video, terminal, !X, has mplayer2 ";
          command = "mplayer2 -- \"$@\"";
        }
        {
          condition = "mime ^video, terminal, !X, has mplayer  ";
          command = "mplayer -- \"$@\"";
        }

        #-------------------------------------------
        # Documents
        #-------------------------------------------
        {
          condition = "ext pdf, has llpp,     X, flag f";
          command = "llpp \"$@\"";
        }
        {
          condition = "ext pdf, has zathura,  X, flag f";
          command = "zathura -- \"$@\"";
        }
        {
          condition = "ext pdf, has mupdf,    X, flag f";
          command = "mupdf \"$@\"";
        }
        {
          condition = "ext pdf, has mupdf-x11,X, flag f";
          command = "mupdf-x11 \"$@\"";
        }
        {
          condition = "ext pdf, has apvlv,    X, flag f";
          command = "apvlv -- \"$@\"";
        }
        {
          condition = "ext pdf, has xpdf,     X, flag f";
          command = "xpdf -- \"$@\"";
        }
        {
          condition = "ext pdf, has evince,   X, flag f";
          command = "evince -- \"$@\"";
        }
        {
          condition = "ext pdf, has atril,    X, flag f";
          command = "atril -- \"$@\"";
        }
        {
          condition = "ext pdf, has okular,   X, flag f";
          command = "okular -- \"$@\"";
        }
        {
          condition = "ext pdf, has epdfview, X, flag f";
          command = "epdfview -- \"$@\"";
        }
        {
          condition = "ext pdf, has qpdfview, X, flag f";
          command = "qpdfview \"$@\"";
        }
        {
          condition = "ext pdf, has open,     X, flag f";
          command = "open \"$@\"";
        }

        {
          condition = "ext sc,    has sc,                   ";
          command = "sc -- \"$@\"";
        }
        {
          condition = "ext docx?, has catdoc,       terminal";
          command = "catdoc -- \"$@\" | $PAGER";
        }

        {
          condition = "ext                        sxc|xlsx?|xlt|xlw|gnm|gnumeric, has gnumeric,    X, flag f";
          command = "gnumeric -- \"$@\"";
        }
        {
          condition = "ext                        sxc|xlsx?|xlt|xlw|gnm|gnumeric, has kspread,     X, flag f";
          command = "kspread -- \"$@\"";
        }
        {
          condition = "ext pptx?|od[dfgpst]|docx?|sxc|xlsx?|xlt|xlw|gnm|gnumeric, has libreoffice, X, flag f";
          command = "libreoffice \"$@\"";
        }
        {
          condition = "ext pptx?|od[dfgpst]|docx?|sxc|xlsx?|xlt|xlw|gnm|gnumeric, has soffice,     X, flag f";
          command = "soffice \"$@\"";
        }
        {
          condition = "ext pptx?|od[dfgpst]|docx?|sxc|xlsx?|xlt|xlw|gnm|gnumeric, has ooffice,     X, flag f";
          command = "ooffice \"$@\"";
        }

        {
          condition = "ext djvu, has zathura,X, flag f";
          command = "zathura -- \"$@\"";
        }
        {
          condition = "ext djvu, has evince, X, flag f";
          command = "evince -- \"$@\"";
        }
        {
          condition = "ext djvu, has atril,  X, flag f";
          command = "atril -- \"$@\"";
        }
        {
          condition = "ext djvu, has djview, X, flag f";
          command = "djview -- \"$@\"";
        }

        {
          condition = "ext epub, has ebook-viewer, X, flag f";
          command = "ebook-viewer -- \"$@\"";
        }
        {
          condition = "ext epub, has zathura,      X, flag f";
          command = "zathura -- \"$@\"";
        }
        {
          condition = "ext epub, has mupdf,        X, flag f";
          command = "mupdf -- \"$@\"";
        }
        {
          condition = "ext mobi, has ebook-viewer, X, flag f";
          command = "ebook-viewer -- \"$@\"";
        }

        {
          condition = "ext cb[rz], has qcomicbook, X, flag f";
          command = "qcomicbook \"$@\"";
        }
        {
          condition = "ext cb[rz], has mcomix,     X, flag f";
          command = "mcomix -- \"$@\"";
        }
        {
          condition = "ext cb[rz], has zathura,    X, flag f";
          command = "zathura -- \"$@\"";
        }
        {
          condition = "ext cb[rz], has atril,      X, flag f";
          command = "atril -- \"$@\"";
        }

        {
          condition = "ext sla,  has scribus,      X, flag f";
          command = "scribus -- \"$@\"";
        }

        #-------------------------------------------
        # Images
        #-------------------------------------------
        {
          condition = "mime ^image, has viewnior,  X, flag f";
          command = "viewnior -- \"$@\"";
        }

        {
          condition = "mime ^image/svg, has inkscape, X, flag f";
          command = "inkscape -- \"$@\"";
        }
        {
          condition = "mime ^image/svg, has display,  X, flag f";
          command = "display -- \"$@\"";
        }

        {
          condition = "mime ^image, has imv,       X, flag f";
          command = "imv -- \"$@\"";
        }
        {
          condition = "mime ^image, has pqiv,      X, flag f";
          command = "pqiv -- \"$@\"";
        }
        {
          condition = "mime ^image, has sxiv,      X, flag f";
          command = "sxiv -- \"$@\"";
        }
        {
          condition = "mime ^image, has feh,       X, flag f, !ext gif";
          command = "feh -- \"$@\"";
        }
        {
          condition = "mime ^image, has mirage,    X, flag f";
          command = "mirage -- \"$@\"";
        }
        {
          condition = "mime ^image, has ristretto, X, flag f";
          command = "ristretto \"$@\"";
        }
        {
          condition = "mime ^image, has eog,       X, flag f";
          command = "eog -- \"$@\"";
        }
        {
          condition = "mime ^image, has eom,       X, flag f";
          command = "eom -- \"$@\"";
        }
        {
          condition = "mime ^image, has nomacs,    X, flag f";
          command = "nomacs -- \"$@\"";
        }
        {
          condition = "mime ^image, has geeqie,    X, flag f";
          command = "geeqie -- \"$@\"";
        }
        {
          condition = "mime ^image, has gpicview,  X, flag f";
          command = "gpicview -- \"$@\"";
        }
        {
          condition = "mime ^image, has gwenview,  X, flag f";
          command = "gwenview -- \"$@\"";
        }
        {
          condition = "mime ^image, has xviewer,   X, flag f";
          command = "xviewer -- \"$@\"";
        }
        {
          condition = "mime ^image, has mcomix,    X, flag f";
          command = "mcomix -- \"$@\"";
        }
        {
          condition = "mime ^image, has gimp,      X, flag f";
          command = "gimp -- \"$@\"";
        }
        {
          condition = "mime ^image, has krita,     X, flag f";
          command = "krita -- \"$@\"";
        }
        {
          condition = "ext kra,     has krita,     X, flag f";
          command = "krita -- \"$@\"";
        }
        {
          condition = "ext xcf,                    X, flag f";
          command = "gimp -- \"$@\"";
        }

        #-------------------------------------------
        # Archives
        #-------------------------------------------

        # avoid password prompt by providing empty password
        {
          condition = "ext 7z, has 7z";
          command = "7z -p l \"$@\" | $PAGER";
        }
        # This requires atool
        {
          condition = "ext ace|ar|arc|bz2?|cab|cpio|cpt|deb|dgc|dmg|gz,     has atool";
          command = "atool --list --each -- \"$@\" | $PAGER";
        }
        {
          condition = "ext iso|jar|msi|pkg|rar|shar|tar|tgz|xar|xpi|xz|zip, has atool";
          command = "atool --list --each -- \"$@\" | $PAGER";
        }
        {
          condition = "ext 7z|ace|ar|arc|bz2?|cab|cpio|cpt|deb|dgc|dmg|gz,  has atool";
          command = "atool --extract --each -- \"$@\"";
        }
        {
          condition = "ext iso|jar|msi|pkg|rar|shar|tar|tgz|xar|xpi|xz|zip, has atool";
          command = "atool --extract --each -- \"$@\"";
        }

        # Listing and extracting archives without atool:
        {
          condition = "ext tar|gz|bz2|xz, has tar";
          command = "tar vvtf \"$1\" | $PAGER";
        }
        {
          condition = "ext tar|gz|bz2|xz, has tar";
          command = "for file in \"$@\"; do tar vvxf \"$file\"; done";
        }
        {
          condition = "ext bz2, has bzip2";
          command = "for file in \"$@\"; do bzip2 -dk \"$file\"; done";
        }
        {
          condition = "ext zip, has unzip";
          command = "unzip -l \"$1\" | less";
        }
        {
          condition = "ext zip, has unzip";
          command = "for file in \"$@\"; do unzip -d \"\${file%.*}\" \"$file\"; done";
        }
        {
          condition = "ext ace, has unace";
          command = "unace l \"$1\" | less";
        }
        {
          condition = "ext ace, has unace";
          command = "for file in \"$@\"; do unace e \"$file\"; done";
        }
        {
          condition = "ext rar, has unrar";
          command = "unrar l \"$1\" | less";
        }
        {
          condition = "ext rar, has unrar";
          command = "for file in \"$@\"; do unrar x \"$file\"; done";
        }
        {
          condition = "ext rar|zip, has qcomicbook, X, flag f";
          command = "qcomicbook \"$@\"";
        }
        {
          condition = "ext rar|zip, has mcomix,     X, flag f";
          command = "mcomix -- \"$@\"";
        }
        {
          condition = "ext rar|zip, has zathura,    X, flag f";
          command = "zathura -- \"$@\"";
        }

        #-------------------------------------------
        # Fonts
        #-------------------------------------------
        {
          condition = "mime ^font, has fontforge, X, flag f";
          command = "fontforge \"$@\"";
        }

        #-------------------------------------------
        # Flag t fallback terminals
        #-------------------------------------------
        # Rarely installed terminal emulators get higher priority; It is assumed that
        # if you install a rare terminal emulator, you probably use it.
        # gnome-terminal/konsole/xterm on the other hand are often installed as part of
        # a desktop environment or as fallback terminal emulators.
        {
          condition = "mime ^ranger/x-terminal-emulator, has terminology";
          command = "terminology -e \"$@\"";
        }
        {
          condition = "mime ^ranger/x-terminal-emulator, has kitty";
          command = "kitty -- \"$@\"";
        }
        {
          condition = "mime ^ranger/x-terminal-emulator, has alacritty";
          command = "alacritty -e \"$@\"";
        }
        {
          condition = "mime ^ranger/x-terminal-emulator, has sakura";
          command = "sakura -e \"$@\"";
        }
        {
          condition = "mime ^ranger/x-terminal-emulator, has lilyterm";
          command = "lilyterm -e \"$@\"";
        }
        #{ condition = "mime ^ranger/x-terminal-emulator, has cool-retro-term"; command = "cool-retro-term -e \"$@\""; }
        {
          condition = "mime ^ranger/x-terminal-emulator, has termite";
          command = "termite -x '\"$@\"'";
        }
        #{ condition = "mime ^ranger/x-terminal-emulator, has yakuake"; command = "yakuake -e \"$@\""; }
        {
          condition = "mime ^ranger/x-terminal-emulator, has guake";
          command = "guake -ne \"$@\"";
        }
        {
          condition = "mime ^ranger/x-terminal-emulator, has tilda";
          command = "tilda -c \"$@\"";
        }
        {
          condition = "mime ^ranger/x-terminal-emulator, has st";
          command = "st -e \"$@\"";
        }
        {
          condition = "mime ^ranger/x-terminal-emulator, has terminator";
          command = "terminator -x \"$@\"";
        }
        {
          condition = "mime ^ranger/x-terminal-emulator, has urxvt";
          command = "urxvt -e \"$@\"";
        }
        {
          condition = "mime ^ranger/x-terminal-emulator, has pantheon-terminal";
          command = "pantheon-terminal -e \"$@\"";
        }
        {
          condition = "mime ^ranger/x-terminal-emulator, has lxterminal";
          command = "lxterminal -e \"$@\"";
        }
        {
          condition = "mime ^ranger/x-terminal-emulator, has mate-terminal";
          command = "mate-terminal -x \"$@\"";
        }
        {
          condition = "mime ^ranger/x-terminal-emulator, has xfce4-terminal";
          command = "xfce4-terminal -x \"$@\"";
        }
        {
          condition = "mime ^ranger/x-terminal-emulator, has konsole";
          command = "konsole -e \"$@\"";
        }
        {
          condition = "mime ^ranger/x-terminal-emulator, has gnome-terminal";
          command = "gnome-terminal -- \"$@\"";
        }
        {
          condition = "mime ^ranger/x-terminal-emulator, has xterm";
          command = "xterm -e \"$@\"";
        }

        #-------------------------------------------
        # Misc
        #-------------------------------------------
        {
          condition = "label wallpaper, number 11, mime ^image, has feh, X";
          command = "feh --bg-scale \"$1\"";
        }
        {
          condition = "label wallpaper, number 12, mime ^image, has feh, X";
          command = "feh --bg-tile \"$1\"";
        }
        {
          condition = "label wallpaper, number 13, mime ^image, has feh, X";
          command = "feh --bg-center \"$1\"";
        }
        {
          condition = "label wallpaper, number 14, mime ^image, has feh, X";
          command = "feh --bg-fill \"$1\"";
        }

        #-------------------------------------------
        # Generic file openers
        #-------------------------------------------
        {
          condition = "label open, has xdg-open";
          command = "xdg-open \"$@\"";
        }
        {
          condition = "label open, has open    ";
          command = "open -- \"$@\"";
        }

        # Define the editor for non-text files + pager as last action
        {
          condition = "              !mime ^text, !ext xml|json|csv|tex|py|pl|rb|rs|js|sh|php|dart ";
          command = "ask";
        }
        {
          condition = "label editor, !mime ^text, !ext xml|json|csv|tex|py|pl|rb|rs|js|sh|php|dart ";
          command = "\${VISUAL:-$EDITOR} -- \"$@\"";
        }
        {
          condition = "label pager,  !mime ^text, !ext xml|json|csv|tex|py|pl|rb|rs|js|sh|php|dart ";
          command = "$PAGER -- \"$@\"";
        }

        ######################################################################
        # The actions below are left so low down in this file on purpose, so #
        # they are never triggered accidentally.                             #
        ######################################################################

        # Execute a file as program/script.
        {
          condition = "mime application/x-executable";
          command = "\"$1\"";
        }

        # Move the file to trash using trash-cli.
        {
          condition = "label trash, has trash-put";
          command = "trash-put -- \"$@\"";
        }
        {
          condition = "label trash";
          command = "mkdir -p -- \"\${XDG_DATA_HOME:-$HOME/.local/share}/ranger/trash\"; mv -- \"$@\" \"\${XDG_DATA_HOME:-$HOME/.local/share}/ranger/trash\"";
        }
        #
        #############################
        #
        # End of default configuration
        #
        #############################
      ];
    };

    xdg.configFile."ranger/scope.sh".executable = true;
    xdg.configFile."ranger/scope.sh".source =
      pkgs.writeText "scope.sh"
      /*
      bash
      */
      ''
        #!/usr/bin/env bash

        set -o noclobber -o noglob -o nounset -o pipefail
        IFS=$'\n'

        ## If the option `use_preview_script` is set to `true`,
        ## then this script will be called and its output will be displayed in ranger.
        ## ANSI color codes are supported.
        ## STDIN is disabled, so interactive scripts won't work properly

        ## This script is considered a configuration file and must be updated manually.
        ## It will be left untouched if you upgrade ranger.

        ## Because of some automated testing we do on the script #'s for comments need
        ## to be doubled up. Code that is commented out, because it's an alternative for
        ## example, gets only one #.

        ## Meanings of exit codes:
        ## code | meaning    | action of ranger
        ## -----+------------+-------------------------------------------
        ## 0    | success    | Display stdout as preview
        ## 1    | no preview | Display no preview at all
        ## 2    | plain text | Display the plain content of the file
        ## 3    | fix width  | Don't reload when width changes
        ## 4    | fix height | Don't reload when height changes
        ## 5    | fix both   | Don't ever reload
        ## 6    | image      | Display the image `$IMAGE_CACHE_PATH` points to as an image preview
        ## 7    | image      | Display the file directly as an image

        ## Script arguments
        FILE_PATH="''${1}"         # Full path of the highlighted file
        PV_WIDTH="''${2}"          # Width of the preview pane (number of fitting characters)
        ## shellcheck disable=SC2034 # PV_HEIGHT is provided for convenience and unused
        PV_HEIGHT="''${3}"         # Height of the preview pane (number of fitting characters)
        IMAGE_CACHE_PATH="''${4}"  # Full path that should be used to cache image preview
        PV_IMAGE_ENABLED="''${5}"  # 'True' if image previews are enabled, 'False' otherwise.

        FILE_EXTENSION="''${FILE_PATH##*.}"
        FILE_EXTENSION_LOWER="$(printf "%s" "''${FILE_EXTENSION}" | tr '[:upper:]' '[:lower:]')"

        ## Settings
        HIGHLIGHT_SIZE_MAX=262143  # 256KiB
        HIGHLIGHT_TABWIDTH="''${HIGHLIGHT_TABWIDTH:-8}"
        HIGHLIGHT_STYLE="''${HIGHLIGHT_STYLE:-pablo}"
        HIGHLIGHT_OPTIONS="--replace-tabs=''${HIGHLIGHT_TABWIDTH} --style=''${HIGHLIGHT_STYLE} ''${HIGHLIGHT_OPTIONS:-}"
        PYGMENTIZE_STYLE="''${PYGMENTIZE_STYLE:-autumn}"
        BAT_STYLE="''${BAT_STYLE:-plain}"
        OPENSCAD_IMGSIZE="''${RNGR_OPENSCAD_IMGSIZE:-1000,1000}"
        OPENSCAD_COLORSCHEME="''${RNGR_OPENSCAD_COLORSCHEME:-Tomorrow Night}"
        SQLITE_TABLE_LIMIT=20  # Display only the top <limit> tables in database, set to 0 for no exhaustive preview (only the sqlite_master table is displayed).
        SQLITE_ROW_LIMIT=5     # Display only the first and the last (<limit> - 1) records in each table, set to 0 for no limits.

        handle_extension() {
            case "''${FILE_EXTENSION_LOWER}" in
                ## Archive
                a|ace|alz|arc|arj|bz|bz2|cab|cpio|deb|gz|jar|lha|lz|lzh|lzma|lzo|\
                rpm|rz|t7z|tar|tbz|tbz2|tgz|tlz|txz|tZ|tzo|war|xpi|xz|Z|zip)
                    atool --list -- "''${FILE_PATH}" && exit 5
                    bsdtar --list --file "''${FILE_PATH}" && exit 5
                    exit 1;;
                rar)
                    ## Avoid password prompt by providing empty password
                    unrar lt -p- -- "''${FILE_PATH}" && exit 5
                    exit 1;;
                7z)
                    ## Avoid password prompt by providing empty password
                    7z l -p -- "''${FILE_PATH}" && exit 5
                    exit 1;;

                ## PDF
                pdf)
                    ## Preview as text conversion
                    pdftotext -l 10 -nopgbrk -q -- "''${FILE_PATH}" - | \
                      fmt -w "''${PV_WIDTH}" && exit 5
                    mutool draw -F txt -i -- "''${FILE_PATH}" 1-10 | \
                      fmt -w "''${PV_WIDTH}" && exit 5
                    exiftool "''${FILE_PATH}" && exit 5
                    exit 1;;

                ## BitTorrent
                torrent)
                    transmission-show -- "''${FILE_PATH}" && exit 5
                    exit 1;;

                ## OpenDocument
                odt|sxw)
                    ## Preview as text conversion
                    odt2txt "''${FILE_PATH}" && exit 5
                    ## Preview as markdown conversion
                    pandoc -s -t markdown -- "''${FILE_PATH}" && exit 5
                    exit 1;;
                ods|odp)
                    ## Preview as text conversion (unsupported by pandoc for markdown)
                    odt2txt "''${FILE_PATH}" && exit 5
                    exit 1;;

                ## XLSX
                xlsx)
                    ## Preview as csv conversion
                    ## Uses: https://github.com/dilshod/xlsx2csv
                    xlsx2csv -- "''${FILE_PATH}" && exit 5
                    exit 1;;

                ## HTML
                htm|html|xhtml)
                    ## Preview as text conversion
                    w3m -dump "''${FILE_PATH}" && exit 5
                    lynx -dump -- "''${FILE_PATH}" && exit 5
                    elinks -dump "''${FILE_PATH}" && exit 5
                    pandoc -s -t markdown -- "''${FILE_PATH}" && exit 5
                    ;;

                ## JSON
                json)
                    jq --color-output . "''${FILE_PATH}" && exit 5
                    python -m json.tool -- "''${FILE_PATH}" && exit 5
                    ;;

                ## Jupyter Notebooks
                ipynb)
                    jupyter nbconvert --to markdown "''${FILE_PATH}" --stdout | env COLORTERM=8bit bat --color=always --style=plain --language=markdown && exit 5
                    jupyter nbconvert --to markdown "''${FILE_PATH}" --stdout && exit 5
                    jq --color-output . "''${FILE_PATH}" && exit 5
                    python -m json.tool -- "''${FILE_PATH}" && exit 5
                    ;;

                ## Direct Stream Digital/Transfer (DSDIFF) and wavpack aren't detected
                ## by file(1).
                dff|dsf|wv|wvc)
                    mediainfo "''${FILE_PATH}" && exit 5
                    exiftool "''${FILE_PATH}" && exit 5
                    ;; # Continue with next handler on failure
            esac
        }

        handle_image() {
            ## Size of the preview if there are multiple options or it has to be
            ## rendered from vector graphics. If the conversion program allows
            ## specifying only one dimension while keeping the aspect ratio, the width
            ## will be used.
            local DEFAULT_SIZE="1920x1080"

            local mimetype="''${1}"
            case "''${mimetype}" in
                ## SVG
                image/svg+xml|image/svg)
                    rsvg-convert --keep-aspect-ratio --width "''${DEFAULT_SIZE%x*}" "''${FILE_PATH}" -o "''${IMAGE_CACHE_PATH}.png" \
                        && mv "''${IMAGE_CACHE_PATH}.png" "''${IMAGE_CACHE_PATH}" \
                        && exit 6
                    exit 1;;

                ## DjVu
                image/vnd.djvu)
                    ddjvu -format=tiff -quality=90 -page=1 -size="''${DEFAULT_SIZE}" \
                          - "''${IMAGE_CACHE_PATH}" < "''${FILE_PATH}" \
                          && exit 6 || exit 1;;

                ## Image
                image/*)
                    local orientation
                    orientation="$( identify -format '%[EXIF:Orientation]\n' -- "''${FILE_PATH}" )"
                    ## If orientation data is present and the image actually
                    ## needs rotating ("1" means no rotation)...
                    if [[ -n "$orientation" && "$orientation" != 1 ]]; then
                        ## ...auto-rotate the image according to the EXIF data.
                        convert -- "''${FILE_PATH}" -auto-orient "''${IMAGE_CACHE_PATH}" && exit 6
                    fi

                    ## `w3mimgdisplay` will be called for all images (unless overridden
                    ## as above), but might fail for unsupported types.
                    exit 7;;

                ## Video
                video/*)
                    # Get embedded thumbnail
                    ffmpeg -i "''${FILE_PATH}" -map 0:v -map -0:V -c copy "''${IMAGE_CACHE_PATH}" && exit 6
                    # Get frame 10% into video
                    ffmpegthumbnailer -i "''${FILE_PATH}" -o "''${IMAGE_CACHE_PATH}" -s 0 && exit 6
                    exit 1;;

                ## Audio
                audio/*)
                    # Get embedded thumbnail
                    ffmpeg -i "''${FILE_PATH}" -map 0:v -map -0:V -c copy \
                      "''${IMAGE_CACHE_PATH}" && exit 6;;

                ## PDF
                # application/pdf)
                #     pdftoppm -f 1 -l 1 \
                #              -scale-to-x "''${DEFAULT_SIZE%x*}" \
                #              -scale-to-y -1 \
                #              -singlefile \
                #              -jpeg -tiffcompression jpeg \
                #              -- "''${FILE_PATH}" "''${IMAGE_CACHE_PATH%.*}" \
                #         && exit 6 || exit 1;;


                ## ePub, MOBI, FB2 (using Calibre)
                # application/epub+zip|application/x-mobipocket-ebook|\
                # application/x-fictionbook+xml)
                #     # ePub (using https://github.com/marianosimone/epub-thumbnailer)
                #     epub-thumbnailer "''${FILE_PATH}" "''${IMAGE_CACHE_PATH}" \
                #         "''${DEFAULT_SIZE%x*}" && exit 6
                #     ebook-meta --get-cover="''${IMAGE_CACHE_PATH}" -- "''${FILE_PATH}" \
                #         >/dev/null && exit 6
                #     exit 1;;

                ## Font
                application/font*|application/*opentype)
                    preview_png="/tmp/$(basename "''${IMAGE_CACHE_PATH%.*}").png"
                    if fontimage -o "''${preview_png}" \
                                 --pixelsize "120" \
                                 --fontname \
                                 --pixelsize "80" \
                                 --text "  ABCDEFGHIJKLMNOPQRSTUVWXYZ  " \
                                 --text "  abcdefghijklmnopqrstuvwxyz  " \
                                 --text "  0123456789.:,;(*!?') ff fl fi ffi ffl  " \
                                 --text "  The quick brown fox jumps over the lazy dog.  " \
                                 "''${FILE_PATH}";
                    then
                        convert -- "''${preview_png}" "''${IMAGE_CACHE_PATH}" \
                            && rm "''${preview_png}" \
                            && exit 6
                    else
                        exit 1
                    fi
                    ;;

                ## Preview archives using the first image inside.
                ## (Very useful for comic book collections for example.)
                # application/zip|application/x-rar|application/x-7z-compressed|\
                #     application/x-xz|application/x-bzip2|application/x-gzip|application/x-tar)
                #     local fn=""; local fe=""
                #     local zip=""; local rar=""; local tar=""; local bsd=""
                #     case "''${mimetype}" in
                #         application/zip) zip=1 ;;
                #         application/x-rar) rar=1 ;;
                #         application/x-7z-compressed) ;;
                #         *) tar=1 ;;
                #     esac
                #     { [ "$tar" ] && fn=$(tar --list --file "''${FILE_PATH}"); } || \
                #     { fn=$(bsdtar --list --file "''${FILE_PATH}") && bsd=1 && tar=""; } || \
                #     { [ "$rar" ] && fn=$(unrar lb -p- -- "''${FILE_PATH}"); } || \
                #     { [ "$zip" ] && fn=$(zipinfo -1 -- "''${FILE_PATH}"); } || return
                #
                #     fn=$(echo "$fn" | python -c "from __future__ import print_function; \
                #             import sys; import mimetypes as m; \
                #             [ print(l, end=${"''\''"}) for l in sys.stdin if \
                #               (m.guess_type(l[:-1])[0] or ${"''\''"}).startswith('image/') ]" |\
                #         sort -V | head -n 1)
                #     [ "$fn" = "" ] && return
                #     [ "$bsd" ] && fn=$(printf '%b' "$fn")
                #
                #     [ "$tar" ] && tar --extract --to-stdout \
                #         --file "''${FILE_PATH}" -- "$fn" > "''${IMAGE_CACHE_PATH}" && exit 6
                #     fe=$(echo -n "$fn" | sed 's/[][*?\]/\\\0/g')
                #     [ "$bsd" ] && bsdtar --extract --to-stdout \
                #         --file "''${FILE_PATH}" -- "$fe" > "''${IMAGE_CACHE_PATH}" && exit 6
                #     [ "$bsd" ] || [ "$tar" ] && rm -- "''${IMAGE_CACHE_PATH}"
                #     [ "$rar" ] && unrar p -p- -inul -- "''${FILE_PATH}" "$fn" > \
                #         "''${IMAGE_CACHE_PATH}" && exit 6
                #     [ "$zip" ] && unzip -pP "" -- "''${FILE_PATH}" "$fe" > \
                #         "''${IMAGE_CACHE_PATH}" && exit 6
                #     [ "$rar" ] || [ "$zip" ] && rm -- "''${IMAGE_CACHE_PATH}"
                #     ;;
            esac

            # openscad_image() {
            #     TMPPNG="$(mktemp -t XXXXXX.png)"
            #     openscad --colorscheme="''${OPENSCAD_COLORSCHEME}" \
            #         --imgsize="''${OPENSCAD_IMGSIZE/x/,}" \
            #         -o "''${TMPPNG}" "''${1}"
            #     mv "''${TMPPNG}" "''${IMAGE_CACHE_PATH}"
            # }

            case "''${FILE_EXTENSION_LOWER}" in
               ## 3D models
               ## OpenSCAD only supports png image output, and ''${IMAGE_CACHE_PATH}
               ## is hardcoded as jpeg. So we make a tempfile.png and just
               ## move/rename it to jpg. This works because image libraries are
               ## smart enough to handle it.
               # csg|scad)
               #     openscad_image "''${FILE_PATH}" && exit 6
               #     ;;
               # 3mf|amf|dxf|off|stl)
               #     openscad_image <(echo "import(\"''${FILE_PATH}\");") && exit 6
               #     ;;
               drawio)
                   draw.io -x "''${FILE_PATH}" -o "''${IMAGE_CACHE_PATH}" \
                       --width "''${DEFAULT_SIZE%x*}" && exit 6
                   exit 1;;
            esac
        }

        handle_mime() {
            local mimetype="''${1}"
            case "''${mimetype}" in
                ## RTF and DOC
                text/rtf|*msword)
                    ## Preview as text conversion
                    ## note: catdoc does not always work for .doc files
                    ## catdoc: http://www.wagner.pp.ru/~vitus/software/catdoc/
                    catdoc -- "''${FILE_PATH}" && exit 5
                    exit 1;;

                ## DOCX, ePub, FB2 (using markdown)
                ## You might want to remove "|epub" and/or "|fb2" below if you have
                ## uncommented other methods to preview those formats
                *wordprocessingml.document|*/epub+zip|*/x-fictionbook+xml)
                    ## Preview as markdown conversion
                    pandoc -s -t markdown -- "''${FILE_PATH}" && exit 5
                    exit 1;;

                ## E-mails
                message/rfc822)
                    ## Parsing performed by mu: https://github.com/djcb/mu
                    mu view -- "''${FILE_PATH}" && exit 5
                    exit 1;;

                ## XLS
                *ms-excel)
                    ## Preview as csv conversion
                    ## xls2csv comes with catdoc:
                    ##   http://www.wagner.pp.ru/~vitus/software/catdoc/
                    xls2csv -- "''${FILE_PATH}" && exit 5
                    exit 1;;

                ## SQLite
                *sqlite3)
                    ## Preview as text conversion
                    sqlite_tables="$( sqlite3 "file:''${FILE_PATH}?mode=ro" '.tables' )" \
                        || exit 1
                    [ -z "''${sqlite_tables}" ] &&
                        { echo "Empty SQLite database." && exit 5; }
                    sqlite_show_query() {
                        sqlite-utils query "''${FILE_PATH}" "''${1}" --table --fmt fancy_grid \
                        || sqlite3 "file:''${FILE_PATH}?mode=ro" "''${1}" -header -column
                    }
                    ## Display basic table information
                    sqlite_rowcount_query="$(
                        sqlite3 "file:''${FILE_PATH}?mode=ro" -noheader \
                            'SELECT group_concat(
                                "SELECT """ || name || """ AS tblname,
                                                  count(*) AS rowcount
                                 FROM " || name,
                                " UNION ALL "
                            )
                            FROM sqlite_master
                            WHERE type="table" AND name NOT LIKE "sqlite_%";'
                    )"
                    sqlite_show_query \
                        "SELECT tblname AS 'table', rowcount AS 'count',
                        (
                            SELECT '(' || group_concat(name, ', ') || ')'
                            FROM pragma_table_info(tblname)
                        ) AS 'columns',
                        (
                            SELECT '(' || group_concat(
                                upper(type) || (
                                    CASE WHEN pk > 0 THEN ' PRIMARY KEY' ELSE ${"''\''"} END
                                ),
                                ', '
                            ) || ')'
                            FROM pragma_table_info(tblname)
                        ) AS 'types'
                        FROM (''${sqlite_rowcount_query});"
                    if [ "''${SQLITE_TABLE_LIMIT}" -gt 0 ] &&
                       [ "''${SQLITE_ROW_LIMIT}" -ge 0 ]; then
                        ## Do exhaustive preview
                        echo && printf '>%.0s' $( seq "''${PV_WIDTH}" ) && echo
                        sqlite3 "file:''${FILE_PATH}?mode=ro" -noheader \
                            "SELECT name FROM sqlite_master
                            WHERE type='table' AND name NOT LIKE 'sqlite_%'
                            LIMIT ''${SQLITE_TABLE_LIMIT};" |
                            while read -r sqlite_table; do
                                sqlite_rowcount="$(
                                    sqlite3 "file:''${FILE_PATH}?mode=ro" -noheader \
                                        "SELECT count(*) FROM ''${sqlite_table}"
                                )"
                                echo
                                if [ "''${SQLITE_ROW_LIMIT}" -gt 0 ] &&
                                   [ "''${SQLITE_ROW_LIMIT}" \
                                     -lt "''${sqlite_rowcount}" ]; then
                                    echo "''${sqlite_table} [''${SQLITE_ROW_LIMIT} of ''${sqlite_rowcount}]:"
                                    sqlite_ellipsis_query="$(
                                        sqlite3 "file:''${FILE_PATH}?mode=ro" -noheader \
                                            "SELECT 'SELECT ' || group_concat(
                                                ${"'''...'''"}, ', '
                                            )
                                            FROM pragma_table_info(
                                                ${"'\${sqlite_table}'"}
                                            );"
                                    )"
                                    sqlite_show_query \
                                        "SELECT * FROM (
                                            SELECT * FROM ''${sqlite_table} LIMIT 1
                                        )
                                        UNION ALL ''${sqlite_ellipsis_query} UNION ALL
                                        SELECT * FROM (
                                            SELECT * FROM ''${sqlite_table}
                                            LIMIT (''${SQLITE_ROW_LIMIT} - 1)
                                            OFFSET (
                                                ''${sqlite_rowcount}
                                                - (''${SQLITE_ROW_LIMIT} - 1)
                                            )
                                        );"
                                else
                                    echo "''${sqlite_table} [''${sqlite_rowcount}]:"
                                    sqlite_show_query "SELECT * FROM ''${sqlite_table};"
                                fi
                            done
                    fi
                    exit 5;;

                ## Text
                text/* | */xml)
                    ## Syntax highlight
                    if [[ "$( stat --printf='%s' -- "''${FILE_PATH}" )" -gt "''${HIGHLIGHT_SIZE_MAX}" ]]; then
                        exit 2
                    fi
                    if [[ "$( tput colors )" -ge 256 ]]; then
                        local pygmentize_format='terminal256'
                        local highlight_format='xterm256'
                    else
                        local pygmentize_format='terminal'
                        local highlight_format='ansi'
                    fi
                    env HIGHLIGHT_OPTIONS="''${HIGHLIGHT_OPTIONS}" highlight \
                        --out-format="''${highlight_format}" \
                        --force -- "''${FILE_PATH}" && exit 5
                    env COLORTERM=8bit bat --color=always --style="''${BAT_STYLE}" \
                        -- "''${FILE_PATH}" && exit 5
                    pygmentize -f "''${pygmentize_format}" -O "style=''${PYGMENTIZE_STYLE}"\
                        -- "''${FILE_PATH}" && exit 5
                    exit 2;;

                ## DjVu
                image/vnd.djvu)
                    ## Preview as text conversion (requires djvulibre)
                    djvutxt "''${FILE_PATH}" | fmt -w "''${PV_WIDTH}" && exit 5
                    exiftool "''${FILE_PATH}" && exit 5
                    exit 1;;

                ## Image
                image/*)
                    ## Preview as text conversion
                    # img2txt --gamma=0.6 --width="''${PV_WIDTH}" -- "''${FILE_PATH}" && exit 4
                    exiftool "''${FILE_PATH}" && exit 5
                    exit 1;;

                ## Video and audio
                video/* | audio/*)
                    mediainfo "''${FILE_PATH}" && exit 5
                    exiftool "''${FILE_PATH}" && exit 5
                    exit 1;;

                ## ELF files (executables and shared objects)
                application/x-executable | application/x-pie-executable | application/x-sharedlib)
                    readelf -WCa "''${FILE_PATH}" && exit 5
                    exit 1;;
            esac
        }

        handle_fallback() {
            echo '----- File Type Classification -----' && file --dereference --brief -- "''${FILE_PATH}" && exit 5
        }


        MIMETYPE="$( file --dereference --brief --mime-type -- "''${FILE_PATH}" )"
        if [[ "''${PV_IMAGE_ENABLED}" == 'True' ]]; then
            handle_image "''${MIMETYPE}"
        fi
        handle_extension
        handle_mime "''${MIMETYPE}"
        handle_fallback

        exit 1
      '';
  };
}
