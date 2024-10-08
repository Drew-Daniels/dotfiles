complete -c spotify_player -n __fish_use_subcommand -s t -l theme -d 'Application theme' -r
complete -c spotify_player -n __fish_use_subcommand -s c -l config-folder -d 'Path to the application\'s config folder' -r
complete -c spotify_player -n __fish_use_subcommand -s C -l cache-folder -d 'Path to the application\'s cache folder' -r
complete -c spotify_player -n __fish_use_subcommand -s h -l help -d 'Print help'
complete -c spotify_player -n __fish_use_subcommand -s V -l version -d 'Print version'
complete -c spotify_player -n __fish_use_subcommand -f -a get -d 'Get Spotify data'
complete -c spotify_player -n __fish_use_subcommand -f -a playback -d 'Interact with the playback'
complete -c spotify_player -n __fish_use_subcommand -f -a connect -d 'Connect to a Spotify device'
complete -c spotify_player -n __fish_use_subcommand -f -a like -d 'Like currently playing track'
complete -c spotify_player -n __fish_use_subcommand -f -a authenticate -d 'Authenticate the application'
complete -c spotify_player -n __fish_use_subcommand -f -a playlist -d 'Playlist editing'
complete -c spotify_player -n __fish_use_subcommand -f -a generate -d 'Generate shell completion for the application CLI'
complete -c spotify_player -n __fish_use_subcommand -f -a search -d 'Search spotify'
complete -c spotify_player -n __fish_use_subcommand -f -a help -d 'Print this message or the help of the given subcommand(s)'
complete -c spotify_player -n "__fish_seen_subcommand_from get; and not __fish_seen_subcommand_from key item help" -s h -l help -d 'Print help'
complete -c spotify_player -n "__fish_seen_subcommand_from get; and not __fish_seen_subcommand_from key item help" -f -a key -d 'Get data by key'
complete -c spotify_player -n "__fish_seen_subcommand_from get; and not __fish_seen_subcommand_from key item help" -f -a item -d 'Get a Spotify item\'s data'
complete -c spotify_player -n "__fish_seen_subcommand_from get; and not __fish_seen_subcommand_from key item help" -f -a help -d 'Print this message or the help of the given subcommand(s)'
complete -c spotify_player -n "__fish_seen_subcommand_from get key" -s h -l help -d 'Print help'
complete -c spotify_player -n "__fish_seen_subcommand_from get item" -s i -l id -r
complete -c spotify_player -n "__fish_seen_subcommand_from get item" -s n -l name -r
complete -c spotify_player -n "__fish_seen_subcommand_from get item" -s h -l help -d 'Print help'
complete -c spotify_player -n "__fish_seen_subcommand_from get help; and not __fish_seen_subcommand_from key item help" -f -a key -d 'Get data by key'
complete -c spotify_player -n "__fish_seen_subcommand_from get help; and not __fish_seen_subcommand_from key item help" -f -a item -d 'Get a Spotify item\'s data'
complete -c spotify_player -n "__fish_seen_subcommand_from get help; and not __fish_seen_subcommand_from key item help" -f -a help -d 'Print this message or the help of the given subcommand(s)'
complete -c spotify_player -n "__fish_seen_subcommand_from playback; and not __fish_seen_subcommand_from start play-pause play pause next previous shuffle repeat volume seek help" -s h -l help -d 'Print help'
complete -c spotify_player -n "__fish_seen_subcommand_from playback; and not __fish_seen_subcommand_from start play-pause play pause next previous shuffle repeat volume seek help" -f -a start -d 'Start a new playback'
complete -c spotify_player -n "__fish_seen_subcommand_from playback; and not __fish_seen_subcommand_from start play-pause play pause next previous shuffle repeat volume seek help" -f -a play-pause -d 'Toggle between play and pause'
complete -c spotify_player -n "__fish_seen_subcommand_from playback; and not __fish_seen_subcommand_from start play-pause play pause next previous shuffle repeat volume seek help" -f -a play -d 'Resume the current playback if stopped'
complete -c spotify_player -n "__fish_seen_subcommand_from playback; and not __fish_seen_subcommand_from start play-pause play pause next previous shuffle repeat volume seek help" -f -a pause -d 'Pause the current playback if playing'
complete -c spotify_player -n "__fish_seen_subcommand_from playback; and not __fish_seen_subcommand_from start play-pause play pause next previous shuffle repeat volume seek help" -f -a next -d 'Skip to the next track'
complete -c spotify_player -n "__fish_seen_subcommand_from playback; and not __fish_seen_subcommand_from start play-pause play pause next previous shuffle repeat volume seek help" -f -a previous -d 'Skip to the previous track'
complete -c spotify_player -n "__fish_seen_subcommand_from playback; and not __fish_seen_subcommand_from start play-pause play pause next previous shuffle repeat volume seek help" -f -a shuffle -d 'Toggle the shuffle mode'
complete -c spotify_player -n "__fish_seen_subcommand_from playback; and not __fish_seen_subcommand_from start play-pause play pause next previous shuffle repeat volume seek help" -f -a repeat -d 'Cycle the repeat mode'
complete -c spotify_player -n "__fish_seen_subcommand_from playback; and not __fish_seen_subcommand_from start play-pause play pause next previous shuffle repeat volume seek help" -f -a volume -d 'Set the volume percentage'
complete -c spotify_player -n "__fish_seen_subcommand_from playback; and not __fish_seen_subcommand_from start play-pause play pause next previous shuffle repeat volume seek help" -f -a seek -d 'Seek by an offset milliseconds'
complete -c spotify_player -n "__fish_seen_subcommand_from playback; and not __fish_seen_subcommand_from start play-pause play pause next previous shuffle repeat volume seek help" -f -a help -d 'Print this message or the help of the given subcommand(s)'
complete -c spotify_player -n "__fish_seen_subcommand_from playback start; and not __fish_seen_subcommand_from context liked radio help" -s h -l help -d 'Print help'
complete -c spotify_player -n "__fish_seen_subcommand_from playback start; and not __fish_seen_subcommand_from context liked radio help" -f -a context -d 'Start a context playback'
complete -c spotify_player -n "__fish_seen_subcommand_from playback start; and not __fish_seen_subcommand_from context liked radio help" -f -a liked -d 'Start a liked tracks playback'
complete -c spotify_player -n "__fish_seen_subcommand_from playback start; and not __fish_seen_subcommand_from context liked radio help" -f -a radio -d 'Start a radio playback'
complete -c spotify_player -n "__fish_seen_subcommand_from playback start; and not __fish_seen_subcommand_from context liked radio help" -f -a help -d 'Print this message or the help of the given subcommand(s)'
complete -c spotify_player -n "__fish_seen_subcommand_from playback start context" -s i -l id -r
complete -c spotify_player -n "__fish_seen_subcommand_from playback start context" -s n -l name -r
complete -c spotify_player -n "__fish_seen_subcommand_from playback start context" -s s -l shuffle -d 'Shuffle tracks within the launched playback'
complete -c spotify_player -n "__fish_seen_subcommand_from playback start context" -s h -l help -d 'Print help'
complete -c spotify_player -n "__fish_seen_subcommand_from playback start liked" -s l -l limit -d 'The limit for number of tracks to play' -r
complete -c spotify_player -n "__fish_seen_subcommand_from playback start liked" -s r -l random -d 'Randomly pick the tracks instead of picking tracks from the beginning'
complete -c spotify_player -n "__fish_seen_subcommand_from playback start liked" -s h -l help -d 'Print help'
complete -c spotify_player -n "__fish_seen_subcommand_from playback start radio" -s i -l id -r
complete -c spotify_player -n "__fish_seen_subcommand_from playback start radio" -s n -l name -r
complete -c spotify_player -n "__fish_seen_subcommand_from playback start radio" -s h -l help -d 'Print help'
complete -c spotify_player -n "__fish_seen_subcommand_from playback start help; and not __fish_seen_subcommand_from context liked radio help" -f -a context -d 'Start a context playback'
complete -c spotify_player -n "__fish_seen_subcommand_from playback start help; and not __fish_seen_subcommand_from context liked radio help" -f -a liked -d 'Start a liked tracks playback'
complete -c spotify_player -n "__fish_seen_subcommand_from playback start help; and not __fish_seen_subcommand_from context liked radio help" -f -a radio -d 'Start a radio playback'
complete -c spotify_player -n "__fish_seen_subcommand_from playback start help; and not __fish_seen_subcommand_from context liked radio help" -f -a help -d 'Print this message or the help of the given subcommand(s)'
complete -c spotify_player -n "__fish_seen_subcommand_from playback play-pause" -s h -l help -d 'Print help'
complete -c spotify_player -n "__fish_seen_subcommand_from playback play" -s h -l help -d 'Print help'
complete -c spotify_player -n "__fish_seen_subcommand_from playback pause" -s h -l help -d 'Print help'
complete -c spotify_player -n "__fish_seen_subcommand_from playback next" -s h -l help -d 'Print help'
complete -c spotify_player -n "__fish_seen_subcommand_from playback previous" -s h -l help -d 'Print help'
complete -c spotify_player -n "__fish_seen_subcommand_from playback shuffle" -s h -l help -d 'Print help'
complete -c spotify_player -n "__fish_seen_subcommand_from playback repeat" -s h -l help -d 'Print help'
complete -c spotify_player -n "__fish_seen_subcommand_from playback volume" -l offset -d 'Increase the volume percent by an offset'
complete -c spotify_player -n "__fish_seen_subcommand_from playback volume" -s h -l help -d 'Print help'
complete -c spotify_player -n "__fish_seen_subcommand_from playback seek" -s h -l help -d 'Print help'
complete -c spotify_player -n "__fish_seen_subcommand_from playback help; and not __fish_seen_subcommand_from start play-pause play pause next previous shuffle repeat volume seek help" -f -a start -d 'Start a new playback'
complete -c spotify_player -n "__fish_seen_subcommand_from playback help; and not __fish_seen_subcommand_from start play-pause play pause next previous shuffle repeat volume seek help" -f -a play-pause -d 'Toggle between play and pause'
complete -c spotify_player -n "__fish_seen_subcommand_from playback help; and not __fish_seen_subcommand_from start play-pause play pause next previous shuffle repeat volume seek help" -f -a play -d 'Resume the current playback if stopped'
complete -c spotify_player -n "__fish_seen_subcommand_from playback help; and not __fish_seen_subcommand_from start play-pause play pause next previous shuffle repeat volume seek help" -f -a pause -d 'Pause the current playback if playing'
complete -c spotify_player -n "__fish_seen_subcommand_from playback help; and not __fish_seen_subcommand_from start play-pause play pause next previous shuffle repeat volume seek help" -f -a next -d 'Skip to the next track'
complete -c spotify_player -n "__fish_seen_subcommand_from playback help; and not __fish_seen_subcommand_from start play-pause play pause next previous shuffle repeat volume seek help" -f -a previous -d 'Skip to the previous track'
complete -c spotify_player -n "__fish_seen_subcommand_from playback help; and not __fish_seen_subcommand_from start play-pause play pause next previous shuffle repeat volume seek help" -f -a shuffle -d 'Toggle the shuffle mode'
complete -c spotify_player -n "__fish_seen_subcommand_from playback help; and not __fish_seen_subcommand_from start play-pause play pause next previous shuffle repeat volume seek help" -f -a repeat -d 'Cycle the repeat mode'
complete -c spotify_player -n "__fish_seen_subcommand_from playback help; and not __fish_seen_subcommand_from start play-pause play pause next previous shuffle repeat volume seek help" -f -a volume -d 'Set the volume percentage'
complete -c spotify_player -n "__fish_seen_subcommand_from playback help; and not __fish_seen_subcommand_from start play-pause play pause next previous shuffle repeat volume seek help" -f -a seek -d 'Seek by an offset milliseconds'
complete -c spotify_player -n "__fish_seen_subcommand_from playback help; and not __fish_seen_subcommand_from start play-pause play pause next previous shuffle repeat volume seek help" -f -a help -d 'Print this message or the help of the given subcommand(s)'
complete -c spotify_player -n "__fish_seen_subcommand_from playback help start; and not __fish_seen_subcommand_from context liked radio" -f -a context -d 'Start a context playback'
complete -c spotify_player -n "__fish_seen_subcommand_from playback help start; and not __fish_seen_subcommand_from context liked radio" -f -a liked -d 'Start a liked tracks playback'
complete -c spotify_player -n "__fish_seen_subcommand_from playback help start; and not __fish_seen_subcommand_from context liked radio" -f -a radio -d 'Start a radio playback'
complete -c spotify_player -n "__fish_seen_subcommand_from connect" -s i -l id -r
complete -c spotify_player -n "__fish_seen_subcommand_from connect" -s n -l name -r
complete -c spotify_player -n "__fish_seen_subcommand_from connect" -s h -l help -d 'Print help'
complete -c spotify_player -n "__fish_seen_subcommand_from like" -s u -l unlike -d 'Unlike the currently playing track'
complete -c spotify_player -n "__fish_seen_subcommand_from like" -s h -l help -d 'Print help'
complete -c spotify_player -n "__fish_seen_subcommand_from authenticate" -s h -l help -d 'Print help'
complete -c spotify_player -n "__fish_seen_subcommand_from playlist; and not __fish_seen_subcommand_from new delete import list fork sync help" -s h -l help -d 'Print help'
complete -c spotify_player -n "__fish_seen_subcommand_from playlist; and not __fish_seen_subcommand_from new delete import list fork sync help" -f -a new -d 'Create a new playlist'
complete -c spotify_player -n "__fish_seen_subcommand_from playlist; and not __fish_seen_subcommand_from new delete import list fork sync help" -f -a delete -d 'Delete a playlist'
complete -c spotify_player -n "__fish_seen_subcommand_from playlist; and not __fish_seen_subcommand_from new delete import list fork sync help" -f -a import -d 'Imports all songs from a playlist into another playlist.'
complete -c spotify_player -n "__fish_seen_subcommand_from playlist; and not __fish_seen_subcommand_from new delete import list fork sync help" -f -a list -d 'Lists all user playlists.'
complete -c spotify_player -n "__fish_seen_subcommand_from playlist; and not __fish_seen_subcommand_from new delete import list fork sync help" -f -a fork -d 'Creates a copy of a playlist and imports it.'
complete -c spotify_player -n "__fish_seen_subcommand_from playlist; and not __fish_seen_subcommand_from new delete import list fork sync help" -f -a sync -d 'Syncs imports for all playlists or a single playlist.'
complete -c spotify_player -n "__fish_seen_subcommand_from playlist; and not __fish_seen_subcommand_from new delete import list fork sync help" -f -a help -d 'Print this message or the help of the given subcommand(s)'
complete -c spotify_player -n "__fish_seen_subcommand_from playlist new" -s p -l public -d 'Sets the playlist to public'
complete -c spotify_player -n "__fish_seen_subcommand_from playlist new" -s c -l collab -d 'Sets the playlist to collaborative'
complete -c spotify_player -n "__fish_seen_subcommand_from playlist new" -s h -l help -d 'Print help'
complete -c spotify_player -n "__fish_seen_subcommand_from playlist delete" -s h -l help -d 'Print help'
complete -c spotify_player -n "__fish_seen_subcommand_from playlist import" -s d -l delete -d 'Deletes any previously imported tracks that are no longer in the imported playlist since last import.'
complete -c spotify_player -n "__fish_seen_subcommand_from playlist import" -s h -l help -d 'Print help'
complete -c spotify_player -n "__fish_seen_subcommand_from playlist list" -s h -l help -d 'Print help'
complete -c spotify_player -n "__fish_seen_subcommand_from playlist fork" -s h -l help -d 'Print help'
complete -c spotify_player -n "__fish_seen_subcommand_from playlist sync" -s d -l delete -d 'Deletes any previously imported tracks that are no longer in an imported playlist since last import.'
complete -c spotify_player -n "__fish_seen_subcommand_from playlist sync" -s h -l help -d 'Print help'
complete -c spotify_player -n "__fish_seen_subcommand_from playlist help; and not __fish_seen_subcommand_from new delete import list fork sync help" -f -a new -d 'Create a new playlist'
complete -c spotify_player -n "__fish_seen_subcommand_from playlist help; and not __fish_seen_subcommand_from new delete import list fork sync help" -f -a delete -d 'Delete a playlist'
complete -c spotify_player -n "__fish_seen_subcommand_from playlist help; and not __fish_seen_subcommand_from new delete import list fork sync help" -f -a import -d 'Imports all songs from a playlist into another playlist.'
complete -c spotify_player -n "__fish_seen_subcommand_from playlist help; and not __fish_seen_subcommand_from new delete import list fork sync help" -f -a list -d 'Lists all user playlists.'
complete -c spotify_player -n "__fish_seen_subcommand_from playlist help; and not __fish_seen_subcommand_from new delete import list fork sync help" -f -a fork -d 'Creates a copy of a playlist and imports it.'
complete -c spotify_player -n "__fish_seen_subcommand_from playlist help; and not __fish_seen_subcommand_from new delete import list fork sync help" -f -a sync -d 'Syncs imports for all playlists or a single playlist.'
complete -c spotify_player -n "__fish_seen_subcommand_from playlist help; and not __fish_seen_subcommand_from new delete import list fork sync help" -f -a help -d 'Print this message or the help of the given subcommand(s)'
complete -c spotify_player -n "__fish_seen_subcommand_from generate" -s h -l help -d 'Print help'
complete -c spotify_player -n "__fish_seen_subcommand_from search" -s h -l help -d 'Print help'
complete -c spotify_player -n "__fish_seen_subcommand_from help; and not __fish_seen_subcommand_from get playback connect like authenticate playlist generate search help" -f -a get -d 'Get Spotify data'
complete -c spotify_player -n "__fish_seen_subcommand_from help; and not __fish_seen_subcommand_from get playback connect like authenticate playlist generate search help" -f -a playback -d 'Interact with the playback'
complete -c spotify_player -n "__fish_seen_subcommand_from help; and not __fish_seen_subcommand_from get playback connect like authenticate playlist generate search help" -f -a connect -d 'Connect to a Spotify device'
complete -c spotify_player -n "__fish_seen_subcommand_from help; and not __fish_seen_subcommand_from get playback connect like authenticate playlist generate search help" -f -a like -d 'Like currently playing track'
complete -c spotify_player -n "__fish_seen_subcommand_from help; and not __fish_seen_subcommand_from get playback connect like authenticate playlist generate search help" -f -a authenticate -d 'Authenticate the application'
complete -c spotify_player -n "__fish_seen_subcommand_from help; and not __fish_seen_subcommand_from get playback connect like authenticate playlist generate search help" -f -a playlist -d 'Playlist editing'
complete -c spotify_player -n "__fish_seen_subcommand_from help; and not __fish_seen_subcommand_from get playback connect like authenticate playlist generate search help" -f -a generate -d 'Generate shell completion for the application CLI'
complete -c spotify_player -n "__fish_seen_subcommand_from help; and not __fish_seen_subcommand_from get playback connect like authenticate playlist generate search help" -f -a search -d 'Search spotify'
complete -c spotify_player -n "__fish_seen_subcommand_from help; and not __fish_seen_subcommand_from get playback connect like authenticate playlist generate search help" -f -a help -d 'Print this message or the help of the given subcommand(s)'
complete -c spotify_player -n "__fish_seen_subcommand_from help get; and not __fish_seen_subcommand_from key item" -f -a key -d 'Get data by key'
complete -c spotify_player -n "__fish_seen_subcommand_from help get; and not __fish_seen_subcommand_from key item" -f -a item -d 'Get a Spotify item\'s data'
complete -c spotify_player -n "__fish_seen_subcommand_from help playback; and not __fish_seen_subcommand_from start play-pause play pause next previous shuffle repeat volume seek" -f -a start -d 'Start a new playback'
complete -c spotify_player -n "__fish_seen_subcommand_from help playback; and not __fish_seen_subcommand_from start play-pause play pause next previous shuffle repeat volume seek" -f -a play-pause -d 'Toggle between play and pause'
complete -c spotify_player -n "__fish_seen_subcommand_from help playback; and not __fish_seen_subcommand_from start play-pause play pause next previous shuffle repeat volume seek" -f -a play -d 'Resume the current playback if stopped'
complete -c spotify_player -n "__fish_seen_subcommand_from help playback; and not __fish_seen_subcommand_from start play-pause play pause next previous shuffle repeat volume seek" -f -a pause -d 'Pause the current playback if playing'
complete -c spotify_player -n "__fish_seen_subcommand_from help playback; and not __fish_seen_subcommand_from start play-pause play pause next previous shuffle repeat volume seek" -f -a next -d 'Skip to the next track'
complete -c spotify_player -n "__fish_seen_subcommand_from help playback; and not __fish_seen_subcommand_from start play-pause play pause next previous shuffle repeat volume seek" -f -a previous -d 'Skip to the previous track'
complete -c spotify_player -n "__fish_seen_subcommand_from help playback; and not __fish_seen_subcommand_from start play-pause play pause next previous shuffle repeat volume seek" -f -a shuffle -d 'Toggle the shuffle mode'
complete -c spotify_player -n "__fish_seen_subcommand_from help playback; and not __fish_seen_subcommand_from start play-pause play pause next previous shuffle repeat volume seek" -f -a repeat -d 'Cycle the repeat mode'
complete -c spotify_player -n "__fish_seen_subcommand_from help playback; and not __fish_seen_subcommand_from start play-pause play pause next previous shuffle repeat volume seek" -f -a volume -d 'Set the volume percentage'
complete -c spotify_player -n "__fish_seen_subcommand_from help playback; and not __fish_seen_subcommand_from start play-pause play pause next previous shuffle repeat volume seek" -f -a seek -d 'Seek by an offset milliseconds'
complete -c spotify_player -n "__fish_seen_subcommand_from help playback start; and not __fish_seen_subcommand_from context liked radio" -f -a context -d 'Start a context playback'
complete -c spotify_player -n "__fish_seen_subcommand_from help playback start; and not __fish_seen_subcommand_from context liked radio" -f -a liked -d 'Start a liked tracks playback'
complete -c spotify_player -n "__fish_seen_subcommand_from help playback start; and not __fish_seen_subcommand_from context liked radio" -f -a radio -d 'Start a radio playback'
complete -c spotify_player -n "__fish_seen_subcommand_from help playlist; and not __fish_seen_subcommand_from new delete import list fork sync" -f -a new -d 'Create a new playlist'
complete -c spotify_player -n "__fish_seen_subcommand_from help playlist; and not __fish_seen_subcommand_from new delete import list fork sync" -f -a delete -d 'Delete a playlist'
complete -c spotify_player -n "__fish_seen_subcommand_from help playlist; and not __fish_seen_subcommand_from new delete import list fork sync" -f -a import -d 'Imports all songs from a playlist into another playlist.'
complete -c spotify_player -n "__fish_seen_subcommand_from help playlist; and not __fish_seen_subcommand_from new delete import list fork sync" -f -a list -d 'Lists all user playlists.'
complete -c spotify_player -n "__fish_seen_subcommand_from help playlist; and not __fish_seen_subcommand_from new delete import list fork sync" -f -a fork -d 'Creates a copy of a playlist and imports it.'
complete -c spotify_player -n "__fish_seen_subcommand_from help playlist; and not __fish_seen_subcommand_from new delete import list fork sync" -f -a sync -d 'Syncs imports for all playlists or a single playlist.'
