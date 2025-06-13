# Running Apps with AX Roles for Yabai

- Use Automator to make a .app:
- Open Automator → New Document → Application.
- Add “Run Shell Script”.
- Add script to open the app with appropriate AX env var:

  ```
  #!/bin/bash
  AX_APPLICATION=1 open -a "kitty"
  ```

- Save as `~/Applications/app-ax-role.app`
- Launch app with this instead, Yabai will now be able to control the window since it has AX roles.
