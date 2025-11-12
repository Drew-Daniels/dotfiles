function muxp -d "Starts a new tmux session using the default 'project' tmuxinator template, and inside the directory in default project directory matching the name provided"
  set -l project_name $argv[1]

  if test -z $project_name
    echo "Project Name is Required"
    return 1
  end

  if test -e ~/.config/tmuxinator/$project_name.yml
    mux $project_name
  else
    mux project -n $project_name d=$project_name
  end
end
