function setup-theme --description "Configure fish theme based on light or dark mode"
    set -l theme $argv[1]
    set -l fish_light_theme "zenbones"
    set -l fish_dark_theme "gruvbox-dark-material"

    if test "$theme" = light
        set -gx OS_THEME_DARK 0
        fish_config theme choose "$fish_light_theme" --color-theme=light
        alias jqp="jqp --theme='algol'"
        set -gx fzf_diff_highlighter delta --paging=never --width=20 --light
    else
        set -gx OS_THEME_DARK 1
        fish_config theme choose "$fish_dark_theme" --color-theme=dark
        alias jqp="jqp --theme='gruvbox'"
        set -gx fzf_diff_highlighter delta --paging=never --width=20 --dark
    end
end
