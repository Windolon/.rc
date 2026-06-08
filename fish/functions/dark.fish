function dark --description "Set dark terminal theme"
    sed -i "s/zenwritten_light.toml/zenwritten_dark.toml/" ~/.rc/alacritty/alacritty.toml
end
