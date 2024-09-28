{
  config,
  pkgs,
  ...
}: {
  home = {
    persistence = {
      "/persist/${config.home.homeDirectory}" = {
        directories = [
          ".config/Code"
        ];
      };
    };
  };
  programs = {
    vscode = {
      enable = true;
      mutableExtensionsDir = false;

      extensions = with pkgs;
        [
          vscode-extensions.bbenoist.nix
          vscode-extensions.kamadorueda.alejandra
          vscode-extensions.vscodevim.vim
          vscode-extensions.github.copilot
          vscode-extensions.github.copilot-chat
        ]
        ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
          {
            name = "advanced-new-file";
            publisher = "patbenatar";
            version = "1.2.2";
            sha256 = "sha256-z1QYlYn0RSy2FWCZBYYHbN5BTWp4cp/sOy19tRr1RiU=";
          }
        ];
      keybindings = [
        {
          key = "ctrl+shift+p";
          command = "-workbench.action.showCommands";
        }
        {
          key = "shift+alt+a";
          command = "workbench.action.showCommands";
        }

        {
          key = "ctrl+shift+[Equal]";
          command = "-workbench.action.terminal.toggleTerminal";
          when = "terminal.active";
        }
        {
          key = "shift+alt+t";
          command = "workbench.action.terminal.toggleTerminal";
          when = "terminal.active";
        }

        {
          key = "ctrl+shift+w";
          command = "-workbench.action.closeWindow";
        }
        {
          key = "ctrl+k ctrl+w";
          command = "-workbench.action.closeWindow";
        }
        {
          key = "ctrl+shift+w";
          command = "workbench.action.closeAllEditors";
        }

        {
          key = "ctrl+alt+n";
          command = "extension.advancedNewFile";
        }

        {
          key = "shift+alt+f";
          command = "editor.action.formatDocument";
          when = "editorHasDocumentFormattingProvider && editorTextFocus && !editorReadonly && !inCompositeEditor";
        }

        {
          key = "alt+enter";
          command = "editor.action.quickFix";
          when = "editorHasCodeActionsProvider && editorTextFocus && !editorReadonly";
        }
        {
          key = "ctrl+.";
          command = "-editor.action.quickFix";
          when = "editorHasCodeActionsProvider && editorTextFocus && !editorReadonly";
        }

        {
          key = "ctrl+shift+7";
          command = "editor.action.accessibleViewAcceptInlineCompletion";
          when = "accessibleViewIsShown && accessibleViewCurrentProviderId == 'inlineCompletions'";
        }
        {
          key = "tab";
          command = "editor.action.accessibleViewAcceptInlineCompletion";
          when = "accessibleViewIsShown && accessibleViewCurrentProviderId == 'inlineCompletions'";
        }

        {
          key = "ctrl+b";
          command = "-workbench.action.toggleSidebarVisibility";
        }
        {
          key = "ctrl+b";
          command = "-extension.vim_ctrl+b";
          when = "editorTextFocus && vim.active && vim.use<C-b> && !inDebugRepl && vim.mode != 'Insert'";
        }
        {
          key = "ctrl+b";
          command = "editor.action.revealDefinition";
          when = "editorHasDefinitionProvider && editorTextFocus && !isInEmbeddedEditor";
        }

        # Quick open (remove lots of default binds to make it work)
        {
          key = "ctrl+o";
          command = "-workbench.action.files.openFile";
          when = "true";
        }
        {
          key = "ctrl+o";
          command = "-workbench.action.files.openFolderViaWorkspace";
          when = "!openFolderWorkspaceSupport && workbenchState == 'workspace'";
        }
        {
          key = "ctrl+o";
          command = "-workbench.action.files.openFileFolder";
          when = "isMacNative && openFolderWorkspaceSupport";
        }
        {
          key = "ctrl+o";
          command = "-extension.vim_ctrl+o";
          when = "editorTextFocus && vim.active && vim.use<C-o> && !inDebugRepl";
        }
        {
          key = "ctrl+o";
          command = "-workbench.action.files.openLocalFile";
          when = "remoteFileDialogVisible";
        }
        {
          key = "ctrl+e";
          command = "-workbench.action.quickOpen";
        }
        {
          key = "ctrl+e";
          command = "-extension.vim_ctrl+e";
          when = "editorTextFocus && vim.active && vim.use<C-e> && !inDebugRepl";
        }
        {
          key = "ctrl+o";
          command = "workbench.action.quickOpen";
        }

        # Copilot
        {
          key = "ctrl+k i";
          command = "-inlineChat.start";
          when = "editorFocus && inlineChatHasProvider && !editorReadonly";
        }
        {
          key = "ctrl+i";
          command = "-inlineChat.start";
          when = "editorFocus && inlineChatHasProvider && !editorReadonly";
        }
        {
          key = "ctrl+e";
          command = "inlineChat.start";
          when = "editorFocus && inlineChatHasProvider && !editorReadonly";
        }

        # Navigation
        {
          key = "ctrl+alt+-";
          command = "-workbench.action.navigateBack";
          when = "canNavigateBack";
        }
        {
          key = "alt+left";
          command = "workbench.action.navigateBack";
          when = "canNavigateBack";
        }
        {
          key = "ctrl+shift+-";
          command = "-workbench.action.navigateForward";
          when = "canNavigateForward";
        }
        {
          key = "alt+right";
          command = "workbench.action.navigateForward";
          when = "canNavigateForward";
        }

        # Folding
        {
          key = "ctrl+k ctrl+j";
          command = "-editor.unfoldAll";
          when = "editorTextFocus";
        }
        {
          key = "shift+alt+down";
          command = "editor.unfoldAll";
          when = "editorTextFocus";
        }
        {
          key = "shift+alt+up";
          command = "editor.foldAll";
          when = "editorTextFocus";
        }
        {
          key = "ctrl+k ctrl+0";
          command = "-editor.foldAll";
          when = "editorTextFocus";
        }
        {
          key = "ctrl+alt+up";
          command = "editor.foldRecursively";
        }
        {
          key = "ctrl+alt+down";
          command = "editor.unfoldRecursively";
        }
        {
          key = "alt+up";
          command = "editor.fold";
          when = "editorTextFocus";
        }
        {
          key = "alt+down";
          command = "editor.unfold";
          when = "editorTextFocus";
        }

        # Disable defaults
        {
          key = "ctrl+w";
          command = "workbench.action.terminal.killEditor";
          when = "terminalEditorFocus && terminalFocus && terminalHasBeenCreated || terminalEditorFocus && terminalFocus && terminalProcessSupported";
        }

        # Extension vscodevim.vim disable defaults
        {
          key = "ctrl+w";
          command = "-extension.vim_ctrl+w";
        }
      ];
      userSettings = {
        "editor.lineNumbers" = "relative";
      };
    };
  };
}