function is-macos --description "Check if running on macOS"
    test (uname) = Darwin
end
