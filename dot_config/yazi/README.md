# Yazi file manager

- Yazi plugins can be installed with the Yazi package manager, a bunch are listed [here](https://yazi-rs.github.io/docs/resources/). And also look in "awesome-yazi" GitHub lists for more plugins.
  - Because of our symlinked /plugins dir, with _some_ plugins, normal `ya pkg add` fails to copy to the correct location, so either clone the plugin repo directly to `/chezmoi/cm-util/ctrld-configs/yazi/plugins` or copy files downloaded from `ya pkg add`.
  - Plugins must also be added to `yazi.toml` to be enabled, so follow the GitHub READMEs.
  - One exception is our [`searchjump`](https://github.com/qsdrqs/searchjump.yazi) plugin, which must be git cloned: `git clone https://github.com/DreamMaoMao/searchjump.yazi.git ~/.local/share/chezmoi/cm-util/ctrld-configs/yazi/plugins/searchjump.yazi`
  - `ya pkg` to use Yazi plugin manager
    - `ya pkg upgrade` to update all plugins
