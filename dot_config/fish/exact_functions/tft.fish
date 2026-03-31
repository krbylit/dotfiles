function tft --description "Launch tftui with workspace + var-file for an environment"
    # Usage: tft <env>        — select workspace & var-file, launch tftui
    #        tft              — launch tftui with no var-file (plain mode)
    #        tft -d [args...] — pass-through to tftui directly
    #
    # Run from infra/terraform/ (the submodule directory).
    # The symlinks in the submodule resolve environments/ and
    # common.auto.tfvars from the app repo automatically.

    # Pass-through mode: if first arg is a flag, forward everything
    if test (count $argv) -gt 0; and string match -q -- '-*' $argv[1]
        tftui $argv
        return
    end

    # If no env arg, launch plain tftui
    if test (count $argv) -eq 0
        tftui
        return
    end

    set -l env $argv[1]

    # Read application_name from common.auto.tfvars (symlinked from app repo)
    if not test -f common.auto.tfvars
        echo "error: common.auto.tfvars not found in current directory"
        return 1
    end

    set -l app_name (string match -r 'application_name\s*=\s*"([^"]+)"' < common.auto.tfvars)[2]
    if test -z "$app_name"
        echo "error: could not read application_name from common.auto.tfvars"
        return 1
    end

    set -l workspace "$app_name-$env"
    set -l varfile "environments/$workspace.tfvars"

    if not test -f $varfile
        echo "error: $varfile not found"
        echo "available:"
        ls environments/*.tfvars 2>/dev/null
        return 1
    end

    # Select or create the workspace
    terraform workspace select $workspace 2>/dev/null
    or terraform workspace new $workspace
    or return 1

    echo "workspace: $workspace"
    echo "var-file:  $varfile"
    tftui -f $varfile
end
