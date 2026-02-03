if status is-interactive
    fish_add_path $HOME/.local/bin $HOME/bin
    set -gx EDITOR nvim
    fish_config theme choose "fish default"

    set -gx pure_color_success green

    # https://askubuntu.com/a/264286
    set -gx LC_ALL "en_GB.UTF-8"
    set -gx LANG "en_GB.UTF-8"
    set -gx LANGUAGE "en_GB:en"
end
