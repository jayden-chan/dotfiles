{ ... }:

{
  programs.tmux = {
    enable = true;

    terminal = "xterm-256color";
    mouse = true;
    baseIndex = 1;
    escapeTime = 0;
    historyLimit = 50000;

    extraConfig = ''
      set -sa terminal-overrides ",xterm*:Tc"
      set -g renumber-windows on

      # reload with prefix-r
      bind r source-file ~/.config/tmux/tmux.conf \; display "Config reloaded."

      # Make new windows/splits keep CWD
      bind c new-window -c "#{pane_current_path}"
      bind '"' split-window -c "#{pane_current_path}"
      bind % split-window -h -c "#{pane_current_path}"
      bind n display-popup -d "#{pane_current_path}" -xC -yC -w100% -h100% -E 'lazygit'

      bind S choose-window "join-pane -v -s "%%""
      bind V choose-window "join-pane -h -s "%%""

      # seamless vim/tmux pane navigation
      # https://github.com/christoomey/vim-tmux-navigator
      set-option -g focus-events on
      is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
          | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?|mprocs)(diff)?$'"

      bind -n 'M-j' if-shell "$is_vim" 'send-keys M-j' 'select-pane -L'
      bind -n 'M-k' if-shell "$is_vim" 'send-keys M-k' 'select-pane -D'
      bind -n 'M-i' if-shell "$is_vim" 'send-keys M-i' 'select-pane -U'
      bind -n 'M-l' if-shell "$is_vim" 'send-keys M-l' 'select-pane -R'

      bind -T copy-mode-vi 'M-j' select-pane -L
      bind -T copy-mode-vi 'M-k' select-pane -D
      bind -T copy-mode-vi 'M-i' select-pane -U
      bind -T copy-mode-vi 'M-l' select-pane -R

      # in practice these binds really are Meta + key, these are just
      # some additional scuffed bindings that are needed because of
      # macos command key/ctrl key clown fiesta hackery
      bind j if-shell "$is_vim" 'send-keys M-j' 'select-pane -L'
      bind k if-shell "$is_vim" 'send-keys M-k' 'select-pane -D'
      bind i if-shell "$is_vim" 'send-keys M-i' 'select-pane -U'
      bind l if-shell "$is_vim" 'send-keys M-l' 'select-pane -R'

      bind -T copy-mode-vi j select-pane -L
      bind -T copy-mode-vi k select-pane -D
      bind -T copy-mode-vi i select-pane -U
      bind -T copy-mode-vi l select-pane -R

      # resize panes
      bind -r J resize-pane -L
      bind -r K resize-pane -D
      bind -r I resize-pane -U
      bind -r L resize-pane -R

      # switch windows with alt+number
      bind -n M-1 select-window -t 1
      bind -n M-2 select-window -t 2
      bind -n M-3 select-window -t 3
      bind -n M-4 select-window -t 4
      bind -n M-5 select-window -t 5
      bind -n M-6 select-window -t 6
      bind -n M-7 select-window -t 7
      bind -n M-8 select-window -t 8
      bind -n M-9 select-window -t 9

      # switch sessions with prefix+number
      bind 1 attach-session -t 1
      bind 2 attach-session -t 2
      bind 3 attach-session -t 3
      bind 4 attach-session -t 4
      bind 5 attach-session -t 5
      bind 6 attach-session -t 6
      bind 7 attach-session -t 7
      bind 8 attach-session -t 8
      bind 9 attach-session -t 9

      # Use peasant non-standard vim keys for copy mode
      bind -T copy-mode-vi k send -X cursor-down
      bind -T copy-mode-vi l send -X cursor-right
      bind -T copy-mode-vi j send -X cursor-left
      bind -T copy-mode-vi i send -X cursor-up
      bind -T copy-mode-vi K send -X -N 12 scroll-down
      bind -T copy-mode-vi L send -X end-of-line
      bind -T copy-mode-vi J send -X start-of-line
      bind -T copy-mode-vi I send -X -N 12 scroll-up

      # Don't exit copy mode after selecting something with the mouse
      unbind -T copy-mode-vi MouseDragEnd1Pane

      bind -T copy-mode-vi v     send -X begin-selection
      bind -T copy-mode-vi 'C-v' send -X begin-selection \; send -X rectangle-toggle
      bind -T copy-mode-vi V     send -X select-line
      bind -T copy-mode-vi r     send -X rectangle-toggle
      bind -T copy-mode-vi y     send -X copy-pipe-and-cancel "xclip -in -selection clipboard"

      ########################################################
      # Powerline style statusbar
      ########################################################

      %hidden c_red=colour1
      %hidden c_green=colour2
      %hidden c_yellow=colour3
      %hidden c_orange=colour11
      %hidden c_blue=colour4
      %hidden c_purple=colour5
      %hidden c_teal=colour6
      %hidden c_gray=colour7
      %hidden c_gray2=colour8
      %hidden c_fg=#b5b1a4
      %hidden c_bg=colour0
      %hidden c_text=colour15
      %hidden c_primary=$c_red

      set-option -g status "on"

      # default statusbar color
      set-option -g status-style bg=$c_bg,fg=$c_text
      set-option -g status-position bottom

      # default window title colors
      set-window-option -g window-status-style bg=colour3,fg=$c_bg

      # default window with an activity alert
      set-window-option -g window-status-activity-style bg=terminal,fg=colour8

      # active window title colors
      set-window-option -g window-status-current-style bg=colour1,fg=$c_bg

      # pane border
      set-option -g pane-active-border-style fg=colour7
      set-option -g pane-border-style fg=colour7

      # message infos
      set-option -g message-style bg=terminal,fg=terminal

      # writing commands inactive
      set-option -g message-command-style bg=terminal,fg=terminal

      # pane number display
      set-option -g display-panes-active-colour colour6
      set-option -g display-panes-colour terminal

      # clock
      set-window-option -g clock-mode-colour colour4

      # bell
      set-window-option -g window-status-bell-style bg=colour167,fg=colour235

      ## Theme settings mixed
      set-option -g status-justify "left"
      set-option -g status-left-style none
      set-option -g status-left-length "80"
      set-option -g status-right-style none
      set-option -g status-right-length "80"
      set-window-option -g window-status-separator ""

      set-option -g status-left "#[fg=$c_bg, bg=$c_fg] #S #[fg=$c_fg, bg=$c_bg]"
      set-option -g status-right "#[fg=$c_gray2, bg=$c_bg]#[fg=$c_gray,bg=$c_gray2] %b %-d  %-I:%M #[fg=$c_blue, bg=$c_gray2]#[fg=$c_bg, bg=$c_blue, bold] #h "

      set-window-option -g window-status-current-format "#[fg=$c_bg, bg=$c_primary]#[fg=$c_bg, bg=$c_primary] #I #[fg=$c_bg, bg=$c_primary, bold] #W #[fg=$c_primary, bg=$c_bg]"
      set-window-option -g window-status-format "#[fg=$c_bg,bg=$c_gray2,noitalics]#[fg=$c_gray,bg=$c_gray2] #I #[fg=$c_gray, bg=$c_gray2] #W #[fg=$c_gray2, bg=$c_bg, noitalics]"
    '';
  };
}
