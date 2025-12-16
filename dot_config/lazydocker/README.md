# Lazydocker Configuration

## Overview

Lazydocker is a terminal UI for managing Docker and Docker Compose environments. It provides a simple, intuitive interface for viewing container logs, managing containers/images/volumes, and executing common Docker operations without memorizing complex CLI commands. This tool is essential for quickly inspecting Docker environments during development and debugging.

Key benefits:

- **Visual Overview**: See all containers, images, volumes, and networks at a glance
- **Interactive Logs**: Stream and search logs from multiple containers simultaneously
- **Quick Actions**: Execute shell commands, restart containers, prune resources with keyboard shortcuts
- **Docker Compose Integration**: Manage multi-container applications with service-level controls
- **Custom Commands**: Define frequently-used Docker operations for one-key execution

## Configuration Files

| File | Purpose |
|------|---------|
| `config.yml` | Main configuration (symlinked from `cm-util/ctrld-configs/lazydocker/config.yml`) |

The configuration is managed through chezmoi's symlink system, pointing to a shared config file in `cm-util/ctrld-configs/lazydocker/`. This allows the same configuration to be used across multiple machines while keeping machine-specific settings separate.

## Key Features

### Custom Theme (Catppuccin)

The UI uses a Catppuccin-inspired color scheme with rounded borders:

- **Active Border**: `#f4dbd6` (Rosewater, bold)
- **Inactive Border**: `#a5adcb` (Lavender)
- **Selected Line**: `#363a4f` (Surface0 background)
- **Options Text**: `#8aadf4` (Blue)
- **Border Style**: Rounded corners for modern appearance

### Enhanced Log Viewing

Logs are configured with timestamps enabled for debugging, and the main panel wraps text for readability:

```yaml
logs:
  timestamps: true
  since: ""  # Shows all logs (not just recent)
  tail: ""   # Shows all log lines (no limit)
```

### Docker Compose Custom Commands

The configuration includes several custom commands for advanced Docker Compose workflows:

**For Services:**

- **Rebuild no cache**: Force rebuild without using cached layers
- **Rebuild**: Standard rebuild using cache
- **Clean system**: Comprehensive cleanup (prune containers, images, volumes, and build cache)

**For Images:**

- **Tag as prod-debug**: Tag images for debugging production builds
- **Remove all images**: Nuclear option to clear all images

**For Containers:**

- **sh**: Quick shell access using `docker exec -it`

### Stats Graphs

Real-time resource monitoring with color-coded graphs:

- **CPU Usage**: Blue graph showing percentage
- **Memory Usage**: Green graph showing percentage

### GUI Customization

```yaml
gui:
  scrollHeight: 2                    # Smooth scrolling
  sidePanelWidth: 0.333             # 1/3 screen width for side panels
  showBottomLine: true              # Show keybinding hints
  expandFocusedSidePanel: false     # No accordion effect
  screenMode: "normal"              # Default screen mode (normal/half/fullscreen)
  containerStatusHealthStyle: "long" # Full text status (not icons)
```

## Keybindings

### Global Navigation

| Key | Action | Description |
|-----|--------|-------------|
| `+` | Next screen mode | Cycle through normal → half → fullscreen |
| `_` | Previous screen mode | Cycle backwards through screen modes |
| `1` | Focus projects | Switch to projects panel |
| `2` | Focus services | Switch to services panel |
| `3` | Focus containers | Switch to containers panel |
| `4` | Focus images | Switch to images panel |
| `5` | Focus volumes | Switch to volumes panel |
| `6` | Focus networks | Switch to networks panel |
| `[` | Previous tab | Navigate to previous tab in current panel |
| `]` | Next tab | Navigate to next tab in current panel |
| `Enter` | Focus main panel | Move cursor to main content area |
| `Esc` | Return | Go back to previous panel/view |

### Project Panel

| Key | Action | Description |
|-----|--------|-------------|
| `e` | Edit config | Open Lazydocker config in editor |
| `o` | Open config | View Lazydocker config file |
| `m` | View logs | Display project-wide logs |

### Containers Panel

| Key | Action | Description |
|-----|--------|-------------|
| `d` | Remove | Delete selected container |
| `e` | Toggle stopped | Show/hide stopped containers |
| `p` | Pause | Pause running container |
| `s` | Stop | Stop running container |
| `r` | Restart | Restart container |
| `a` | Attach | Attach to container's stdin/stdout |
| `m` | View logs | Stream container logs |
| `E` | Exec shell | Open shell in container (via custom `sh` command) |
| `c` | Custom command | Run predefined custom command |
| `b` | Bulk commands | View available bulk operations |
| `w` | Open browser | Open container's first HTTP port in browser |
| `/` | Filter | Filter container list by text |

### Services Panel (Docker Compose)

| Key | Action | Description |
|-----|--------|-------------|
| `u` | Up service | Start selected service |
| `d` | Remove | Remove service containers |
| `s` | Stop | Stop service |
| `p` | Pause | Pause service |
| `r` | Restart | Restart service |
| `S` | Start | Start stopped service |
| `a` | Attach | Attach to service output |
| `m` | View logs | Stream service logs |
| `U` | Up project | Start all services in compose file |
| `D` | Down project | Stop and remove all project containers |
| `R` | Restart options | View restart menu |
| `c` | Custom command | Run custom service command |
| `b` | Bulk commands | View bulk operations |
| `E` | Exec shell | Open shell in service container |
| `w` | Open browser | Open service in browser |
| `/` | Filter | Filter services by text |

### Images Panel

| Key | Action | Description |
|-----|--------|-------------|
| `c` | Custom command | Run custom image command |
| `d` | Remove | Delete selected image |
| `b` | Bulk commands | View bulk operations |
| `/` | Filter | Filter images by text |

### Volumes Panel

| Key | Action | Description |
|-----|--------|-------------|
| `c` | Custom command | Run custom volume command |
| `d` | Remove | Delete selected volume |
| `b` | Bulk commands | View bulk operations |
| `/` | Filter | Filter volumes by text |

### Networks Panel

| Key | Action | Description |
|-----|--------|-------------|
| `c` | Custom command | Run custom network command |
| `d` | Remove | Delete selected network |
| `b` | Bulk commands | View bulk operations |
| `/` | Filter | Filter networks by text |

## Common Workflows

### Viewing Container Logs

1. Press `3` to focus containers panel
2. Navigate to desired container with arrow keys
3. Press `m` to view logs
4. Logs appear in main panel with timestamps
5. Press `Esc` to return to container list

**Tip**: The configuration shows all logs with timestamps, making it easy to debug timing-related issues.

### Executing Shell in Container

1. Focus containers panel (`3`)
2. Select target container
3. Press `E` to exec shell
4. Custom command runs: `docker exec -it <container-id> sh`
5. Interact with container shell
6. Exit shell with `exit` or `Ctrl+D`

**Note**: Uses `sh` instead of `bash` for broader compatibility (Alpine Linux containers, minimal images, etc.).

### Managing Docker Compose Services

1. Press `2` to focus services panel
2. Navigate to service
3. Common actions:
   - `u`: Bring service up (`docker compose up -d <service>`)
   - `s`: Stop service
   - `r`: Restart service
   - `m`: View service logs
   - `R`: View restart options (rebuild, recreate, etc.)

### Rebuilding Service (No Cache)

1. Focus services panel (`2`)
2. Select service to rebuild
3. Press `c` for custom commands
4. Select "Rebuild no cache"
5. Executes: `docker compose build --no-cache <service>`
6. Follow with `u` to bring up rebuilt service

### Cleaning Docker System

**WARNING**: This removes ALL stopped containers, unused images, volumes, and build cache.

1. Focus services panel (`2`)
2. Press `c` for custom commands
3. Select "Clean system"
4. Executes comprehensive prune:

   ```bash
   docker system prune -a --volumes --force && docker builder prune --all --force
   ```

### Monitoring Resource Usage

1. Focus containers panel (`3`)
2. Select container to monitor
3. View stats in right sidebar:
   - Blue graph: CPU percentage
   - Green graph: Memory percentage
4. Stats update in real-time

### Filtering and Search

1. In any list panel (containers, images, volumes, networks)
2. Press `/` to activate filter
3. Type search term
4. List filters to matching items
5. Press `Esc` to clear filter

### Pruning Unused Resources

**Images:**

1. Press `4` to focus images panel
2. Press `b` for bulk commands
3. Select prune option
4. Removes dangling/unused images

**Volumes:**

1. Press `5` to focus volumes panel
2. Press `b` for bulk commands
3. Select prune option
4. Removes unused volumes

**Networks:**

1. Press `6` to focus networks panel
2. Press `b` for bulk commands
3. Select prune option
4. Removes unused networks

## Integration Points

### Fish Shell Integration

Lazydocker is aliased in Fish shell for quick access:

- **Function**: `ld` (defined in `dot_config/fish/exact_functions/ld.fish`)
- **Usage**: `ld` launches Lazydocker with any additional arguments
- **Example**: `ld --config ~/.config/lazydocker/config.yml`

### Zsh Integration

For Zsh users, there's an alias in `dot_zshrc`:

```zsh
alias ld="lazydocker"
```

### Docker Compose Command Template

The configuration uses `docker compose` (v2) instead of legacy `docker-compose`:

```yaml
commandTemplates:
  dockerCompose: docker compose
```

All compose-related commands reference this template, making it easy to switch back to `docker-compose` v1 if needed.

## Customization Guide

### Common Modifications

**Change Color Theme**

1. Edit config file: `chezmoi edit ~/.config/lazydocker/config.yml`
2. Modify `gui.theme` section:

   ```yaml
   theme:
     activeBorderColor: ["#your-color", bold]
     inactiveBorderColor: ["#your-color"]
     selectedLineBgColor: ["#your-color"]
     optionsTextColor: ["#your-color"]
   ```

3. Apply changes: `chezmoi apply`
4. Restart Lazydocker

**Add Custom Command**

1. Edit config file: `chezmoi edit ~/.config/lazydocker/config.yml`
2. Add to appropriate section (`customCommands.services`, `customCommands.containers`, `customCommands.images`):

   ```yaml
   customCommands:
     services:
       - name: "Your command name:"
         attach: true  # Show output in terminal
         command: "{{ .DockerCompose }} your-command {{ .Service.Name }}"
         serviceNames: []  # Empty = available for all services
   ```

3. Apply changes: `chezmoi apply`
4. Access with `c` key in Lazydocker

**Adjust Panel Width**

1. Edit config file
2. Modify `gui.sidePanelWidth`:

   ```yaml
   gui:
     sidePanelWidth: 0.25  # 25% of screen width (default: 0.333)
   ```

3. Apply changes and restart

**Change Log Behavior**

1. Edit config file
2. Modify `logs` section:

   ```yaml
   logs:
     timestamps: false  # Hide timestamps
     since: "1h"        # Show only last hour
     tail: "200"        # Show only last 200 lines
   ```

3. Apply changes and restart

### Configuration Options

Key settings you can modify:

- **`gui.scrollHeight`**: Scroll speed (Current: `2`)
- **`gui.language`**: UI language - options: `auto`, `en`, `pl`, `nl`, `de`, `tr` (Current: `auto`)
- **`gui.border`**: Border style - options: `rounded`, `single`, `double`, `hidden` (Current: `rounded`)
- **`gui.sidePanelWidth`**: Side panel width as ratio of screen width (Current: `0.333`)
- **`gui.showBottomLine`**: Show keybinding hints at bottom (Current: `true`)
- **`gui.expandFocusedSidePanel`**: Accordion effect when focusing panels (Current: `false`)
- **`gui.screenMode`**: Default screen mode - options: `normal`, `half`, `fullscreen` (Current: `normal`)
- **`gui.containerStatusHealthStyle`**: Status display style - options: `long`, `short`, `icon` (Current: `long`)
- **`logs.timestamps`**: Show log timestamps (Current: `true`)
- **`logs.since`**: Time range for logs, e.g., `60m`, `24h` (Current: `` - shows all)
- **`logs.tail`**: Number of log lines to show (Current: `` - shows all)
- **`oS.openCommand`**: Command to open files (Current: `open {{filename}}`)
- **`oS.openLinkCommand`**: Command to open URLs (Current: `open {{link}}`)

### Command Template Variables

When creating custom commands, you can use these template variables:

- **`{{ .DockerCompose }}`**: Expands to `docker compose` (or whatever is set in `commandTemplates.dockerCompose`)
- **`{{ .Service.Name }}`**: Current service name
- **`{{ .Container.ID }}`**: Current container ID
- **`{{ .Container.Name }}`**: Current container name
- **`{{ .Image.Name }}`**: Current image name
- **`{{ .Image.ID }}`**: Current image ID

## Troubleshooting

### Lazydocker Won't Start

**Symptoms**: Error message when running `ld` or `lazydocker`

**Solution**:

1. Verify Docker is running: `docker ps`
2. Check Lazydocker is installed: `which lazydocker`
3. If missing, install via Homebrew: `brew install lazydocker`
4. Verify config syntax: `lazydocker --config ~/.config/lazydocker/config.yml --help`

### Custom Commands Not Appearing

**Symptoms**: Press `c` but custom commands don't show up

**Solution**:

1. Verify config syntax is valid YAML: `yamllint ~/.config/lazydocker/config.yml`
2. Check command is in correct section (`services`, `containers`, or `images`)
3. Restart Lazydocker to reload configuration
4. Check Lazydocker logs for parsing errors

### Shell Exec Fails with "executable file not found"

**Symptoms**: Pressing `E` shows error about shell not found

**Solution**:

1. Container might not have `sh` installed (rare)
2. Try modifying custom command to use `bash`:

   ```yaml
   customCommands:
     containers:
       - name: "bash:"
         attach: true
         command: "docker exec -it {{ .Container.ID }} bash"
   ```

3. Or try Alpine Linux's `ash`:

   ```yaml
   command: "docker exec -it {{ .Container.ID }} ash"
   ```

### Config Changes Not Taking Effect

**Symptoms**: Modified config but Lazydocker still uses old settings

**Solution**:

1. Ensure changes were applied: `chezmoi apply`
2. Completely quit Lazydocker (don't just switch away)
3. Restart Lazydocker: `ld`
4. Verify config location: `lazydocker` looks in `~/.config/jesseduffield/lazydocker/config.yml` by default, but this setup symlinks from `~/.config/lazydocker/config.yml`

### Docker Compose Commands Fail

**Symptoms**: Compose operations show errors about `docker-compose` not found

**Solution**:

1. Verify Docker Compose v2 is installed: `docker compose version`
2. If using legacy v1, edit config:

   ```yaml
   commandTemplates:
     dockerCompose: docker-compose
   ```

3. Apply changes and restart

### Stats Not Showing

**Symptoms**: Resource graphs are empty or not updating

**Solution**:

1. Verify Docker has stats enabled (should be default)
2. Check container is running (stats only work for active containers)
3. Restart Docker daemon if stats are globally broken
4. Try switching to different container and back

## External Resources

- [Official Documentation](https://github.com/jesseduffield/lazydocker)
- [Keybindings Reference](https://github.com/jesseduffield/lazydocker/blob/master/docs/keybindings/Keybindings_en.md)
- [Configuration Schema](https://www.schemastore.org/lazydocker.json)
- [Custom Commands Guide](https://github.com/jesseduffield/lazydocker/blob/master/docs/Custom_Commands.md)
- [Lazydocker Website](https://lazydocker.com/)
