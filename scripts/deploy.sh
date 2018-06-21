rm     /home/jayden/.tmux.conf        2>/dev/null
# rm     /home/jayden/.vimrc            2>/dev/null
rm     /home/jayden/.zshrc            2>/dev/null
rm     /home/jayden/.zlogout          2>/dev/null
rm     /home/jayden/.gitconfig        2>/dev/null
# rm     /home/jayden/.config/i3/config 2>/dev/null
rm -r  /home/jayden/.config/compton   2>/dev/null
rm -r  /home/jayden/.config/polybar   2>/dev/null
rm -r  /home/jayden/.config/termite   2>/dev/null
rm -r  /home/jayden/.config/dunst     2>/dev/null
rm -r  /home/jayden/.config/rofi      2>/dev/null
# rm -rf /home/jayden/.vim/             2>/dev/null

# mkdir  /home/jayden/.vim
mkdir  /home/jayden/.config/compton
mkdir  /home/jayden/.config/polybar
mkdir  /home/jayden/.config/termite
mkdir  /home/jayden/.config/dunst
mkdir  /home/jayden/.config/rofi

ln -fs /home/jayden/Documents/Git/dotfiles/tmux/.tmux.conf       /home/jayden/.tmux.conf
# ln -fs /home/jayden/Documents/Git/dotfiles/vim/vimrc             /home/jayden/.vimrc
ln -fs /home/jayden/Documents/Git/dotfiles/zsh/zshrc             /home/jayden/.zshrc
ln -fs /home/jayden/Documents/Git/dotfiles/zsh/zlogout           /home/jayden/.zlogout
# ln -fs /home/jayden/Documents/Git/dotfiles/vim/en.utf-8.add      /home/jayden/.vim/en.utf-8.add
# ln -fs /home/jayden/Documents/Git/dotfiles/snippets/             /home/jayden/.vim/
ln -fs /home/jayden/Documents/Git/dotfiles/git/gitconfig         /home/jayden/.gitconfig
# ln -fs /home/jayden/Documents/Git/dotfiles/i3/config             /home/jayden/.config/i3/config            
ln -fs /home/jayden/Documents/Git/dotfiles/compton/compton.conf  /home/jayden/.config/compton/compton.conf 
ln -fs /home/jayden/Documents/Git/dotfiles/polybar/config        /home/jayden/.config/polybar/config       
ln -fs /home/jayden/Documents/Git/dotfiles/termite/config        /home/jayden/.config/termite/config       
ln -fs /home/jayden/Documents/Git/dotfiles/dunst/dunstrc         /home/jayden/.config/dunst/dunstrc        
ln -fs /home/jayden/Documents/Git/dotfiles/rofi/Custom-Nord.rasi /home/jayden/.config/rofi/Custom-Nord.rasi        

# git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
