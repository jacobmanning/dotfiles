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
