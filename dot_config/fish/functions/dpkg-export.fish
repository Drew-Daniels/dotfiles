function dpkg_export -d "Exports packages installed via dpkg (and apt) to a file"
    command dpkg -l | grep ^ii | awk '{print $2}' >~/.config/apt/packages
end
