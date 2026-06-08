function light --description "Set light terminal theme"
    sed -i "s/zenwritten_dark.toml/zenwritten_light.toml/" ~/.rc/alacritty/alacritty.toml
end
