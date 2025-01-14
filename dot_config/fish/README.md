# Fish shell

> [!TODO]
>
> - Add feature to `s.fish` to store locally a hash of the files to copy and check for modifications that way before calling `rsync`, then also do not make `rsync` do the hash check

## Tips

- `fzf` (e.g. <c-f>) can easily search with glob-like patterns

  - https://junegunn.github.io/fzf/search-syntax/
    How to get better results
    A common mistake is to type unnecessary spaces. You may type git add to search for git add something. But if you do so, fzf sees it as two separate terms and process them separately, so it will match add ... git which is not what you want.

    fzf picks up both

    ```
    fzf -q 'git add' << EOF
    add things to git
    git add something
    EOF
    ```

    So most of the time, you’ll get better results by typing less.
    gitadd is better than git add; add git will be filtered out.
    gadd should work well too.
    Or gas. fzf gives big bonus scores to the matching characters at word boundaries so acronym queries like this work surprisingly well.

  - e.g. `python !Library` search for 'python' excluding the Library/ dir
  - very useful to employ the available keymaps:
    - <c-f> to find files
    - <c-s> to search command history
    - <c-p> to search running processes (n.b. `kill ` > <tab> to fzf for a proc to kill)
    - <c-g> to search git commits
    - <c-v> to search env vars (nice instead of `echo $ENV_VAR`)
    - <tab> brings up autocomplete suggestions in fzf finder (same as ctrl+i, but this doesn't use fzf). if done at empty prompt, we can browse all commands and their man page in the preview

- `bang-bang` plugin allows prev cmd/arg substitution with `!!` for cmd and `!$` for arg
  - e.g. `vim text.txt` > no permission > `sudo !!` > vim opens text.txt
- run bash-dependant scripts easily with fish with `bass`, just prepend the cmd with `bass`
  - e.g. `source venv/bin/activate` > error > `bass source venv/bin/activate` > properly sets bash env vars and carries over to fish
- `zoxide` can be very helpfully used in interactive mode with `zi` cmd
  - e.g. `zi dir` pulls up results in `fzf`
- `fifc` provides fzf over cmd completions
  - e.g. `grep --` > <tab> > shows fzf of completions for all grep arguments, along with preview of man page docs

## Plugin docs

- `eza`
  - https://github.com/eza-community/eza
- jorgebucaran/fisher
- patrickf1/fzf.fish
- jorgebucaran/nvm.fish
- catppuccin/fish
- oh-my-fish/plugin-bang-bang
- edc/bass
- aohorodnyk/fish-autovenv
- oh-my-fish/plugin-cd
- gazorby/fifc
- laughedelic/fish_logo
- laughedelic/pisces
