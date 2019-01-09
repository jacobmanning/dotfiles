echo '*******************************' >&2
echo 'dotfiles/scripts/setup.sh' >&2
echo 'Configuring your shell...' >&2
echo '*******************************' >&2
echo >&2

# Check if git is installed
if ! [ -x "$(command -v git)"]; then
  echo '[ERROR] `git` is not installed' >&2
  echo '[ERROR] Please install `git` and try again!' >&2
  echo >&2
  exit 1
fi

# Check if curl is installed
if ! [ -x "$(command -v curl)"]; then
  echo '[ERROR] `curl` is not installed' >&2
  echo '[ERROR] Please install `curl` and try again!' >&2
  echo >&2
  exit 1
fi

echo '*******************************' >&2
echo 'Configuring rc files...' >&2
echo '*******************************' >&2
echo >&2

if [ -d config ] && [ -d scripts ]; then
  # Running from inside `dotfiles`
  cp config/jacob_profile ~/.jacob_profile
  cat config/bash_profile >> ~/.bash_profile
  cp config/tmux.conf ~/.tmux.conf
  cp config/vimrc ~/.vimrc
  cp config/zshrc ~/.zshrc
elif [ -d dotfiles ] && [ -d dotfiles/config ] && [ -d dotfiles/scripts ]; then
  # Running from outside `dotfiles`
  cp dotfiles/config/jacob_profile ~/.jacob_profile
  cat dotfiles/config/bash_profile >> ~/.bash_profile
  cp dotfiles/config/tmux.conf ~/.tmux.conf
  cp dotfiles/config/vimrc ~/.vimrc
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
  ~/.fzf/install
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

vim +PluginInstall +PlugInstall +qall

echo '*******************************' >&2
echo 'Installing zsh...' >&2
echo '*******************************' >&2
echo >&2

# Check if using Ubuntu (lazily)
if ! [ -x "$(command -v apt)"]; then
  echo '[ERROR] Auto-install zsh only supported for Ubuntu' >&2
  echo >&2
else
  if [ -x "$(command -v zsh)"]; then
    echo '*******************************' >&2
    echo 'zsh already installed!' >&2
    echo '*******************************' >&2
    echo >&2
  else
    if ! [ $(id -u) = "0" ]; then
      echo '[WARN] Please re-run this script with `sudo` to install zsh' >&2
      echo >&2
    else
      # Install zsh
      apt install zsh

      # Install dracula theme
      # Install auto-complete
      # Install syntax highlighting
    fi
  fi
fi

echo '*******************************' >&2
echo 'Installing trash-put...' >&2
echo '*******************************' >&2
echo >&2

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
    git clone https://github.com/andreafrancia/trash-cli.git ~/.trash-cli.git
    current_dir=$pwd
    cd ~/.trash-cli
    python setup.py install --user
    cd $current_dir
  fi
fi

echo '*******************************' >&2
echo '*******************************' >&2
echo '[INFO] Restart your terminal!' >&2
echo '*******************************' >&2
echo '*******************************' >&2
echo >&2
