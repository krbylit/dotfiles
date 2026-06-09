function tft --description "Launch tftui for a Terraform environment"
    function __tft_find_root
        set -l dir $PWD

        while true
            if test -d "$dir/infra/terraform"
                echo "$dir/infra/terraform"
                return 0
            end

            if test -f "$dir/terraform.tf"; and test -f "$dir/common.auto.tfvars"
                echo "$dir"
                return 0
            end

            if test "$dir" = /
                return 1
            end

            set dir (dirname "$dir")
        end
    end

    set -l tf_root (__tft_find_root)
    if test -z "$tf_root"
        echo "error: could not find terraform root"
        return 1
    end

    pushd "$tf_root" >/dev/null

    if test (count $argv) -gt 0; and string match -q -- '-*' $argv[1]
        tftui $argv
        set -l status_code $status
        popd >/dev/null
        return $status_code
    end

    if test (count $argv) -eq 0
        tftui
        set -l status_code $status
        popd >/dev/null
        return $status_code
    end

    set -l app_name (string match -r 'application_name\s*=\s*"([^"]+)"' < common.auto.tfvars)[2]
    if test -z "$app_name"
        echo "error: could not read application_name from common.auto.tfvars"
        popd >/dev/null
        return 1
    end

    set -l env $argv[1]
    set -l workspace "$app_name-$env"
    set -l varfile "environments/$env/$workspace.tfvars"

    if not test -f "$varfile"
        echo "error: $tf_root/$varfile not found"
        popd >/dev/null
        return 1
    end

    terraform workspace select "$workspace" >/dev/null 2>/dev/null
    or terraform workspace new "$workspace" >/dev/null
    or begin
        popd >/dev/null
        return 1
    end

    echo "workspace: $workspace"
    echo "var-file:  $tf_root/$varfile"

    tftui -f "$varfile"
    set -l status_code $status
    popd >/dev/null
    return $status_code
end
