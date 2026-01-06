if status is-interactive
    fish_add_path $HOME/.local/bin $HOME/bin
    set -gx EDITOR nvim

    set -gx pure_color_success green
end
