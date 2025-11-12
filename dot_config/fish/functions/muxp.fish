function muxp -d "Starts a new tmux session using the default 'project' tmuxinator template, and inside the directory in default project directory matching the name provided"
  set -l project_name $argv[1]

  if test -z $project_name
    echo "Project Name is Required"
    return 1
  end

  # TODO: Check if first argument provided is a built-in tmuxinator subcommand
  # If so, pass through to actual `tmux` command
  # Otherwise, continue with the logic below
  # TODO: Alias actual `mux` command with this implementation once this is complete so I can use `mux` in the following way:
  # mux <project-without-custom-tmuxinator-config> - to start or attach to a tmux session with this project name, using the default tmuxinator project configuration or a specific one for this project
  # mux stop
  # mux ls
  # mux ... etc. ...
  set -l builtin_tmuxinator_cmds "commands" "completions" "copy" "debug" "delete" "doctor" "edit" "implode" "list" "local" "new" "open" "start" "stop" "version"

      # Define a regex pattern
  #     set regex "^(apple|banana|cherry)$"
  #
  #         # Check if the first argument matches the regex pattern
  #             if string match -q -r "$regex" "$first_argument"
  #                     echo "Match found: $first_argument matches the pattern."
  #                             return 0
  #                                 end

  if test -e ~/.config/tmuxinator/$project_name.yml
    mux $project_name
  else
    mux project -n $project_name d=$project_name
  end
end
