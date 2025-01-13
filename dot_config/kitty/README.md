# Kitty config

## Themes

- `kitten themes` for an interactive picker

- [Many themes](https://github.com/dexpota/kitty-themes)

  Choose a theme and create a symlink:

  ```
  cd ~/.config/kitty
  ln -s ./kitty-themes/themes/Floraverse.conf ~/.config/kitty/theme.conf
  ```

  Add this line to your kitty.conf configuration file:

  `include ./theme.conf`

  If you have enabled remote control in kitty you can run this command:

  `kitty @ set-colors -a "~/.config/kitty/kitty-themes/themes/AdventureTime.conf"`

## Icons

- [Term kitty](https://github.com/hristost/kitty-alternative-icon)
- [B/W kitties](https://github.com/DinkDonk/kitty-icon)
