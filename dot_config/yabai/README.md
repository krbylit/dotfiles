The issue is that kitty does not assign AX references, so yabai cannot manage it. The best workaround I've found is to launch kitty with env var AX_APPLICATION=1. This gives kitty the correct AX role/subrole.

--- yabai output from launching kitty:

```
EVENT_HANDLER_APPLICATION_LAUNCHED: kitty (73832) is not finished launching, subscribing to finishedLaunching changes -[workspace_context observeValueForKeyPath:ofObject:change:context:]: kitty (73832) finished launching
EVENT_HANDLER_APPLICATION_LAUNCHED: kitty (73832)
window_manager_create_and_add_window:24835 kitty - zsh (AXWindow:AXUnknown:1)
window_manager_create_and_add_window: ignoring AXUnknown window kitty 24835
```

yabai query output:

```
{
 "id":24897,
 "pid":75310,
 "app":"kitty",
 "title":"",
 "scratchpad":"",
 "frame":{
  "x":0.0000,
  "y":0.0000,
  "w":1920.0000,
  "h":1080.0000
 },
 "role":"",
 "subrole":"",
 "root-window":true,
 "display":1,
 "space":1,
 "level":0,
 "sub-level":0,
 "layer":"normal",
 "sub-layer":"normal",
 "opacity":1.0000,
 "split-type":"none",
 "split-child":"none",
 "stack-index":0,
 "can-move":false,
 "can-resize":false,
 "has-focus":false,
 "has-shadow":true,
 "has-parent-zoom":false,
 "has-fullscreen-zoom":false,
 "has-ax-reference":false,
 "is-native-fullscreen":false,
 "is-visible":false,
 "is-minimized":false,
 "is-hidden":false,
 "is-floating":false,
 "is-sticky":false,
 "is-grabbed":false
}
```
