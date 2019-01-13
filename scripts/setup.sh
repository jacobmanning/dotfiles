set -e

echo '*******************************' >&2
echo 'dotfiles/scripts/setup.sh' >&2
echo 'Configuring your shell...' >&2
echo '*******************************' >&2
echo >&2

if ! [ -x "$(command -v apt)" ]; then
  echo '[ERROR] Auto-install only supported on Ubuntu' >&2
  echo >&2
  exit 1
fi

if ! [ $(id -u) = "0" ]; then
  echo '[ERROR] Please re-run this script with `sudo` to install packages' >&2
  echo >&2
  exit 1
fi

apt update

if ! [ -x "$(command -v add-apt-repository)" ]; then
  apt-get install -y software-properties-common python-software-properties
fi


# Check if git is installed
if ! [ -x "$(command -v git)" ]; then
  add-apt-repository -y ppa:git-core/ppa
  apt update
  apt install -y git
fi

# Check if curl is installed
if ! [ -x "$(command -v curl)" ]; then
  apt install -y curl
fi

echo '*******************************' >&2
echo 'Configuring rc files...' >&2
echo '*******************************' >&2
echo >&2

# TODO: Use config/rc and config/minimal
if [ -d config ] && [ -d scripts ]; then
  # Running from inside `dotfiles`
  cp config/jacob_profile ~/.jacob_profile
  cat config/rc/profile_setup >> ~/.bash_profile
  cp config/tmux.conf ~/.tmux.conf
  cp config/minimal/plugin_install_vimrc ~/.vimrc
  cp config/zshrc ~/.zshrc
elif [ -d dotfiles ] && [ -d dotfiles/config ] && [ -d dotfiles/scripts ]; then
  # Running from outside `dotfiles`
  cp dotfiles/config/jacob_profile ~/.jacob_profile
  cat dotfiles/config/rc/profile_setup >> ~/.bash_profile
  cp dotfiles/config/tmux.conf ~/.tmux.conf
  cp dotfiles/config/minimal/plugin_install_vimrc ~/.vimrc
  cp dotfiles/config/zshrc ~/.zshrc
else
  echo '[ERROR] Please run this script as `dotfiles/scripts/setup.sh`' >&2
  echo >&2
fi

echo '*******************************' >&2
echo 'Installing fzf...' >&2
echo '*******************************' >&2
echo >&2

# Check if fzf installed
if [ -d ~/.fzf ]; then
  # fzf is already installed
  echo '*******************************' >&2
  echo 'fzf already installed!' >&2
  echo '*******************************' >&2
  echo >&2
else
  # Install fzf
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install --all
fi

echo '*******************************' >&2
echo 'Installing vim...' >&2
echo '*******************************' >&2
echo >&2

if [ -x "$(command -v vim)" ]; then
  echo '*******************************' >&2
  echo 'vim already installed!' >&2
  echo '*******************************' >&2
  echo >&2
else
  # Install vim
  add-apt-repository -y ppa:jonathonf/vim
  apt update
  apt install -y vim
fi

echo '*******************************' >&2
echo 'Configuring vim...' >&2
echo '*******************************' >&2
echo >&2

echo '*******************************' >&2
echo 'Installing Vundle...' >&2
echo '*******************************' >&2
echo >&2

# Check if Vundle installed
if [ -d ~/.vim/Vundle.vim ]; then
  # Vundle is already installed
  echo '*******************************' >&2
  echo 'Vundle already installed!' >&2
  echo '*******************************' >&2
  echo >&2
else
  # Install Vundle
  git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
fi

echo '*******************************' >&2
echo 'Installing vim-plug...' >&2
echo '*******************************' >&2
echo >&2

# Check if vim-plug installed
if [ -f ~/.vim/autoload/plug.vim ]; then
  # vim-plug is already installed
  echo '*******************************' >&2
  echo 'vim-plug already installed!' >&2
  echo '*******************************' >&2
  echo >&2
else
  # Install vim-plug
  curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

echo '*******************************' >&2
echo 'Installing vim plugins...' >&2
echo '*******************************' >&2
echo >&2

# Run Vundle::install, VimPlug::install, and quit
vim +PluginInstall +PlugInstall +qall

# Copy full vimrc
if [ -d config ] && [ -d scripts ]; then
  # Running from inside `dotfiles`
  cp config/vimrc ~/.vimrc
elif [ -d dotfiles ] && [ -d dotfiles/config ] && [ -d dotfiles/scripts ]; then
  # Running from outside `dotfiles`
  cp dotfiles/config/vimrc ~/.vimrc
else
  echo '[ERROR] Please run this script as `dotfiles/scripts/setup.sh`' >&2
  echo >&2
fi

echo '*******************************' >&2
echo 'Installing zsh...' >&2
echo '*******************************' >&2
echo >&2

# Check if using Ubuntu (lazily)
if [ -x "$(command -v zsh)" ]; then
  echo '*******************************' >&2
  echo 'zsh already installed!' >&2
  echo '*******************************' >&2
  echo >&2
else
  # Install zsh
  apt install -y zsh
  if [ $? -eq 0 ]; then
    chsh -s $(which zsh)
  fi
fi

echo '*******************************' >&2
echo 'Installing zsh plugins...' >&2
echo '*******************************' >&2
echo >&2

# Install dracula theme
if [ -d ~/.zsh/dracula ]; then
  git clone https://github.com/dracula/zsh.git ~/.zsh/dracula
  ln -s $DRACULA_THEME/dracula.zsh-theme $OH_MY_ZSH/themes/dracula.zsh-theme
fi

# Install auto-complete
if [ -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions ]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
fi

# Install syntax highlighting
if [ -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting ]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
fi

echo '*******************************' >&2
echo 'Installing trash-put...' >&2
echo '*******************************' >&2
echo >&2

if [ -x "$(command -v trash-put)" ]; then
  echo '*******************************' >&2
  echo 'trash-put already installed!' >&2
  echo '*******************************' >&2
  echo >&2
else
  # Install trash-put
  if ! [ -x "$(command -v python)" ]; then
    echo '*******************************' >&2
    echo 'trash-cli requires python' >&2
    echo '*******************************' >&2
    echo >&2
  else
    if [ -x "$(command -v easy_install)" ]; then
      easy_install trash-cli
    else
      git clone https://github.com/andreafrancia/trash-cli.git ~/.trash-cli
      current_dir=$pwd
      cd ~/.trash-cli
      python setup.py install --user
      cd $current_dir
    fi
  fi
fi

echo '*******************************' >&2
echo '*******************************' >&2
echo '[INFO] Restart your terminal!' >&2
echo '*******************************' >&2
echo '*******************************' >&2
echo >&2
