# vim: ft=tmux
send-keys 'cd /home/jayden/Dev/Personal/lakehouse' Enter
new-window -c "/home/jayden/Dev/Personal/lakehouse"
split-window -h -c "/home/jayden/Dev/Personal/lakehouse" -l 80%
select-pane -L
send-keys 'j client-web' Enter
split-window -c "/home/jayden/Dev/Personal/lakehouse" -l 25%
send-keys 'j weblogs' Enter
select-pane -R
send-keys 'j db up' Enter
