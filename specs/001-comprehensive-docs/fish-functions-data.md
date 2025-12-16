# Fish Functions Data

## Function: _nb_parse_note_args

- **File**: _nb_parse_note_args.fish
- **Description**: Internal helper function that parses arguments for nb note commands. Handles path, filename, and content parsing with support for 1-3+ arguments.
- **Usage**: `_nb_parse_note_args <arg1> [arg2] [arg3...]`
- **Example**: Called internally by `nq`, `ni`, and `nid` functions

## Function: _nb_parse_todo_args

- **File**: _nb_parse_todo_args.fish
- **Description**: Internal helper function that parses arguments for nb todo commands. Handles path, todo_id, title, description, tasks, related, tags, and command identification.
- **Usage**: `_nb_parse_todo_args <args...>`
- **Example**: Called internally by `nt` function to parse complex todo arguments

## Function: _nb_upsert_note

- **File**: _nb_upsert_note.fish
- **Description**: Internal helper function that creates or updates a note using nb. If note exists, edits it; if not, creates it.
- **Usage**: `_nb_upsert_note <path> <filename> <content>`
- **Example**: Called internally by note functions to handle create/update logic

## Function: _rsync_dotfiles

- **File**: _rsync_dotfiles.fish
- **Description**: Internal helper function that syncs dotfiles to remote host via rsync. Handles terminfo setup and copies configs from ~/.ssh-dotfiles/ and specific dotfiles.
- **Usage**: `_rsync_dotfiles [ssh_opts...] <host>`
- **Example**: Called internally by `s` function for SSH connections

## Function: ai

- **File**: ai.fish
- **Description**: Wrapper for aichat command
- **Usage**: `ai <args>`
- **Example**: N/A

## Function: brewadd

- **File**: brewadd.fish
- **Description**: Install Homebrew package and update Brewfile
- **Usage**: `brewadd <package>`
- **Example**: N/A

## Function: brewrem

- **File**: brewrem.fish
- **Description**: Uninstall Homebrew package and update Brewfile
- **Usage**: `brewrem <package>`
- **Example**: N/A

## Function: brg

- **File**: brg.fish
- **Description**: Alias for batgrep with smart case search
- **Usage**: `brg <pattern>`
- **Example**: N/A

## Function: c

- **File**: c.fish
- **Description**: Open nvim in chezmoi source directory and return to previous directory on exit
- **Usage**: `c [args]`
- **Example**: N/A

## Function: ca

- **File**: ca.fish
- **Description**: Wrapper for cursor-agent command
- **Usage**: `ca <args>`
- **Example**: N/A

## Function: cat

- **File**: cat.fish
- **Description**: Alias for bat with paging disabled
- **Usage**: `cat <file>`
- **Example**: N/A

## Function: cm

- **File**: cm.fish
- **Description**: Alias for chezmoi
- **Usage**: `cm <args>`
- **Example**: N/A

## Function: cmf

- **File**: cmf.fish
- **Description**: Force apply chezmoi changes and reload fish config
- **Usage**: `cmf [args]`
- **Example**: N/A

## Function: cmg

- **File**: cmg.fish
- **Description**: Open lazygit in chezmoi source directory
- **Usage**: `cmg [args]`
- **Example**: N/A

## Function: dbuild

- **File**: dbuild.fish
- **Description**: Build Docker compose in detached tmux session with logging
- **Usage**: `dbuild`
- **Example**: Run with `dlog` to tail build output, `dtail` for container logs, `exportlogs` to dump logs

## Function: ddeploy

- **File**: ddeploy.fish
- **Description**: Build, stop, and start Docker compose in detached tmux session with logging
- **Usage**: `ddeploy`
- **Example**: Run with `dlog` to tail build output, `dtail` for container logs, `exportlogs` to dump logs

## Function: ddown

- **File**: ddown.fish
- **Description**: Stop Docker compose services
- **Usage**: `ddown`
- **Example**: N/A

## Function: dlog

- **File**: dlog.fish
- **Description**: Tail the most recent Docker build log file
- **Usage**: `dlog`
- **Example**: N/A

## Function: dtail

- **File**: dtail.fish
- **Description**: Tail journald logs for all running Docker containers
- **Usage**: `dtail`
- **Example**: N/A

## Function: dup

- **File**: dup.fish
- **Description**: Restart Docker compose services (down then up)
- **Usage**: `dup`
- **Example**: N/A

## Function: exportlogs

- **File**: exportlogs.fish
- **Description**: Export journald logs for a container to a file, optionally filtered by date
- **Usage**: `exportlogs <container-name> [YYYYMMDD or json] [json]`
- **Example**: `exportlogs myapp 20231215 json` exports logs for date 20231215 in JSON format

## Function: fc

- **File**: fc.fish
- **Description**: Edit fish config file in nvim
- **Usage**: `fc [args]`
- **Example**: N/A

## Function: fish_prompt

- **File**: fish_prompt.fish
- **Description**: Custom fish prompt that uses starship
- **Usage**: Automatically called by fish shell
- **Example**: N/A

## Function: fish_right_prompt

- **File**: fish_right_prompt.fish
- **Description**: Custom fish right prompt that uses starship
- **Usage**: Automatically called by fish shell
- **Example**: N/A

## Function: fish_user_key_bindings

- **File**: fish_user_key_bindings.fish
- **Description**: Fish user key bindings override function. Runs last when fish sets up keys for final overrides.
- **Usage**: Automatically called by fish shell
- **Example**: N/A

## Function: fisher

- **File**: fisher.fish
- **Description**: A plugin manager for Fish shell (version 4.4.5)
- **Usage**: `fisher install <plugins...>`, `fisher remove <plugins...>`, `fisher update [plugins...]`, `fisher list [regex]`
- **Example**: `fisher install jorgebucaran/nvm.fish`

## Function: frg

- **File**: frg.fish
- **Description**: Interactive ripgrep with fzf preview using bat
- **Usage**: `frg <pattern>`
- **Example**: N/A

## Function: fzf_configure_bindings

- **File**: fzf_configure_bindings.fish
- **Description**: Installs the default key bindings for fzf.fish with user overrides passed as options
- **Usage**: `fzf_configure_bindings [--directory=key] [--git_log=key] [--git_status=key] [--history=key] [--processes=key] [--variables=key]`
- **Example**: N/A

## Function: gc

- **File**: gc.fish
- **Description**: Edit ghostty config file in nvim
- **Usage**: `gc [args]`
- **Example**: N/A

## Function: gdiff

- **File**: gdiff.fish
- **Description**: Git diff with histogram algorithm and ignoring space changes
- **Usage**: `gdiff [args]`
- **Example**: N/A

## Function: help

- **File**: help.fish
- **Description**: Display colorized --help output using bat
- **Usage**: `help <command>`
- **Example**: `help git`

## Function: ksh

- **File**: ksh.fish
- **Description**: SSH with kitty kitten using custom config, prefers zsh over bash
- **Usage**: `ksh <host>`
- **Example**: N/A

## Function: l

- **File**: l.fish
- **Description**: Enhanced ls using eza with icons, smart grouping, and directories first
- **Usage**: `l`
- **Example**: N/A

## Function: la

- **File**: la.fish
- **Description**: Enhanced ls -a using eza with all files, icons, and directories first
- **Usage**: `la`
- **Example**: N/A

## Function: lart

- **File**: lart.fish
- **Description**: List all files sorted by modification time (oldest first)
- **Usage**: `lart [path]`
- **Example**: N/A

## Function: ld

- **File**: ld.fish
- **Description**: Alias for lazydocker
- **Usage**: `ld [args]`
- **Example**: N/A

## Function: ldot

- **File**: ldot.fish
- **Description**: List dotfiles with details
- **Usage**: `ldot`
- **Example**: N/A

## Function: lg

- **File**: lg.fish
- **Description**: Alias for lazygit
- **Usage**: `lg [args]`
- **Example**: N/A

## Function: ll

- **File**: ll.fish
- **Description**: List files in columns with color
- **Usage**: `ll [path]`
- **Example**: N/A

## Function: logtail

- **File**: logtail.fish
- **Description**: Tail a log file with bat syntax highlighting
- **Usage**: `logtail <logfile>`
- **Example**: N/A

## Function: lr

- **File**: lr.fish
- **Description**: List files recursively sorted by time
- **Usage**: `lr [path]`
- **Example**: N/A

## Function: lrt

- **File**: lrt.fish
- **Description**: List files sorted by modification time (newest first)
- **Usage**: `lrt [path]`
- **Example**: N/A

## Function: ls

- **File**: lS.fish
- **Description**: Enhanced ls with color (macOS -G flag)
- **Usage**: `ls [args]`
- **Example**: N/A

## Function: lsa

- **File**: lsa.fish
- **Description**: List all files with details and human-readable sizes
- **Usage**: `lsa [path]`
- **Example**: N/A

## Function: lsn

- **File**: lsn.fish
- **Description**: List files one per line
- **Usage**: `lsn [path]`
- **Example**: N/A

## Function: lsr

- **File**: lsr.fish
- **Description**: List all files recursively with details
- **Usage**: `lsr [path]`
- **Example**: N/A

## Function: lt

- **File**: lt.fish
- **Description**: List files sorted by modification time with details
- **Usage**: `lt [path]`
- **Example**: N/A

## Function: ne

- **File**: ne.fish
- **Description**: Open nb directory for editing in nvim
- **Usage**: `ne`
- **Example**: N/A

## Function: ni

- **File**: ni.fish
- **Description**: Helper for nb ideas/ folder. Toggle tasks, add content, or open ideas inbox.
- **Usage**: `ni [path/filename] [content]` or `ni <filename>` to toggle task
- **Example**: `ni "new idea"` adds to ideas/inbox.md, `ni mytask` toggles mytask in inbox

## Function: nid

- **File**: nid.fish
- **Description**: Helper for nb ideas/dev.md folder. Toggle tasks, add content, or open dev ideas.
- **Usage**: `nid [path/filename] [content]` or `nid <filename>` to toggle task
- **Example**: `nid "dev task"` adds to ideas/dev.md, `nid mytask` toggles mytask in dev.md

## Function: nq

- **File**: nq.fish
- **Description**: Quick note feature for nb. Smartly adds notes to daily notes or creates/edits specific notes.
- **Usage**: `nq` to list, `nq "content"` to add to today's note, `nq <path>/filename` to edit/create note
- **Example**: `nq "quick note"` adds to today's note, `nq work/meeting` edits work/meeting.md

## Function: ns

- **File**: ns.fish
- **Description**: Open scratch.md in nb
- **Usage**: `ns`
- **Example**: N/A

## Function: nt

- **File**: nt.fish
- **Description**: Wrapper for nb todos in todos/ folder. Supports do/undo, add, edit, list with complex argument parsing.
- **Usage**: `nt` to open todos, `nt <do|undo> <todoID>`, `nt <title>` to add, `nt l` to list, `nt c` for closed, `nt o` for open
- **Example**: `nt "Buy milk"` adds todo, `nt do 5` completes todo 5, `nt work/` lists work folder todos

## Function: profile_fish

- **File**: profile_fish.fish
- **Description**: Profile fish shell startup time and open results in nvim
- **Usage**: `profile_fish`
- **Example**: N/A

## Function: rg_fzf_search

- **File**: rg_fzf_search.fish
- **Description**: Search and transform search action using ripgrep and fzf (FIXME: fish conversion not working)
- **Usage**: `rg_fzf_search [initial_query]`
- **Example**: N/A

## Function: ripgrep_live

- **File**: ripgrep_live.fish
- **Description**: Live ripgrep search with fzf and vim integration. Opens files or builds quickfix list.
- **Usage**: `ripgrep_live`
- **Example**: Type pattern in fzf, press Enter to open in vim, or select multiple with Tab and Enter for quickfix

## Function: s

- **File**: s.fish
- **Description**: SSH with custom config, rsync dotfiles, and auto-attach to zellij/tmux session with environment setup
- **Usage**: `s [ssh_options] <host>`
- **Example**: `s myserver` connects and attaches to session named $USER-myserver

## Function: sc

- **File**: sc.fish
- **Description**: Edit secrets env.keys.fish file in nvim
- **Usage**: `sc [args]`
- **Example**: N/A

## Function: search_and_replace

- **File**: search_and_replace.fish
- **Description**: Wrapper for serpl command
- **Usage**: `search_and_replace <args>`
- **Example**: N/A

## Function: ter

- **File**: ter.fish
- **Description**: Alias for terraform
- **Usage**: `ter <args>`
- **Example**: N/A

## Function: tf

- **File**: tf.fish
- **Description**: Alias for terraform
- **Usage**: `tf <args>`
- **Example**: N/A

## Function: tft

- **File**: tft.fish
- **Description**: Wrapper for tftui with -d flag
- **Usage**: `tft [args]`
- **Example**: N/A

## Function: timer

- **File**: timer.fish
- **Description**: Set a timer with terminal notification using tclock
- **Usage**: `timer <duration>`
- **Example**: `timer 5m` sets 5 minute timer

## Function: v

- **File**: v.fish
- **Description**: Alias for nvim
- **Usage**: `v <file>`
- **Example**: N/A

## Function: vc

- **File**: vc.fish
- **Description**: Open nvim in nvim config directory and return to previous directory on exit
- **Usage**: `vc [args]`
- **Example**: N/A

## Function: venv

- **File**: venv.fish
- **Description**: Create and activate a Python virtual environment using uv venv, or deactivate if already in one
- **Usage**: `venv [--python 3.13]`
- **Example**: `venv` creates .venv in repo root, `venv --python 3.13` specifies Python version

## Function: venv_auto_activate

- **File**: venv_auto_activate.fish
- **Description**: Auto activate/deactivate virtualenv when changing directories (FIXME: currently disabled, --on-variable event handler not triggering)
- **Usage**: Automatically triggered on directory change
- **Example**: N/A

## Function: vi_copy_to_clipboard

- **File**: vi_copy_to_clipboard.fish
- **Description**: Copy current command line to system clipboard using pbcopy
- **Usage**: Bound to a key binding
- **Example**: N/A

## Function: vm

- **File**: vm.fish
- **Description**: Alias for vi-mongo
- **Usage**: `vm [args]`
- **Example**: N/A

## Function: vman

- **File**: vman.fish
- **Description**: Read man pages in nvim
- **Usage**: `vman <command>`
- **Example**: `vman git`

## Function: vtest

- **File**: vtest.fish
- **Description**: Run nvim with isolated test directories for data, state, and cache
- **Usage**: `vtest [args]`
- **Example**: N/A

## Function: y

- **File**: y.fish
- **Description**: Wrapper for yazi file manager with cwd tracking and session management
- **Usage**: `y [args]`
- **Example**: `y` opens yazi, cd to selected directory on exit

## Function: yazi_ripgrep

- **File**: yazi_ripgrep.fish
- **Description**: Ripgrep live search for yazi integration. Outputs selected file path for yazi navigation.
- **Usage**: `yazi_ripgrep`
- **Example**: Called from yazi to search and navigate to files

## Function: ywd

- **File**: ywd.fish
- **Description**: Copy current working directory to clipboard
- **Usage**: `ywd`
- **Example**: N/A

## Function: zel

- **File**: zel.fish
- **Description**: Smart zellij session manager. Attach to existing session or create new one, or list sessions.
- **Usage**: `zel` to start default, `zel <name>` to attach/create session, `zel l` to list sessions
- **Example**: `zel work` attaches to 'work' session or creates it if doesn't exist

## Function: zellij_picker

- **File**: zellij_picker.fish
- **Description**: Zellij session picker with fzf. Attach to or delete sessions interactively.
- **Usage**: `zellij_picker [initial_query]`
- **Example**: Select session with Enter to attach, Ctrl-x to delete

## Function: zs

- **File**: zs.fish
- **Description**: Start or attach to zellij session
- **Usage**: `zs <session_name>`
- **Example**: N/A
