#!/bin/bash

session=monitor

tmux new-session -d -s $session
tmux send-keys -t 0 'htop' C-m

tmux split-window -v -p 20 "watch -n 1 'sensors | egrep \"Tdie|Tctl|fan|in0\"'"
tmux split-pane -t 0 -h 'nvtop'
tmux split-pane -t 2 -h
tmux send-keys -t 3 "workon aio" C-m
tmux send-keys -t 3 "watch -n 2 'sudo \$(which liquidctl) status'" C-m

tmux attach-session -t $session
