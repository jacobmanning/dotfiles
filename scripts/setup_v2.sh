set -e

# Environment options
env_ubuntu=
env_sudo=
back_dir_upon_completion=0

# Configuration options
config_all=1
config_no_sudo=0
config_not_ubuntu=0
config_minimal=0
config_config_only=0
config_vim_full=1
config_vim_basic=0
config_vim_minimal=0
config_zsh=1
config_trash_put=1
config_tmux=1
config_rust=0
config_pyenv=0
config_fzf=1

# Display script usage
usage()
{
  echo 'Usage: [sudo] scripts/setup.sh [OPTIONS]' >&2
  echo '--minimal: Only minimal installations' >&2
  echo '--config-files: Copy rc files' >&2
  echo '--no-sudo: No sudo operations' >&2
  echo '--not-ubuntu: Not on Ubuntu' >&2
  echo '--vim-full: Full Vim install' >&2
  echo '--vim-basic: Basic Vim install' >&2
  echo '--vim-minimal: Minimal Vim install' >&2
  echo '--zsh: Install zsh' >&2
  echo '--trash-put: Install trash-put' >&2
  echo '--tmux: Install/Copy tmux config' >&2
  echo '--rust: Add rust config' >&2
  echo '--pyenv: Install pyenv' >&2
  echo '--fzf: Install fzf' >&2
}

exit_safely()
{
  if [ $back_dir_upon_completion -eq 1 ]; then
    cd ..
  fi

  if [ -n $1 ]; then
    exit $1
  else
    exit 1
  fi
}

check_ubuntu_env()
{
  if ! [ -x "$(command -v apt)" ]; then
    env_ubuntu=0
  else
    env_ubuntu=1
  fi
}

check_sudo_env()
{
  if ! [ $(id -u) = "0" ]; then
    env_sudo=0
  else
    env_sudo=1
  fi
}

# Check if git is installed
check_and_install_git_or_exit()
{
  if ! [ -x "$(command -v git)" ]; then
    if [[ $env_ubuntu -eq 1 ]] && [[ $env_sudo -eq 1 ]]; then
      add-apt-repository -y ppa:git-core/ppa
      apt update
      apt install -y git
    else
      echo '[ERROR] `git` is required' >&2
      echo >&2
      exit_safely 1
    fi
  fi
}

# Check if curl is installed
check_and_install_curl_or_exit()
{
  if ! [ -x "$(command -v curl)" ]; then
    if [[ $env_ubuntu -eq 1 ]] && [[ $env_sudo -eq 1 ]]; then
      apt install -y curl
    else
      echo '[ERROR] `curl` is required' >&2
      echo >&2
      exit_safely 1
    fi
  fi
}

setup_config_files()
{
  if [[ $config_config_files -eq 1 ]] || [[ $config_all -eq 1  ]]; then
    echo 'TODO'
  fi
}

install_fzf()
{
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
    check_and_install_git_or_exit
    # Install fzf
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install --all
  fi

  # COPY FZF CONFIG
}

install_vim()
{
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
    if [[ $env_ubuntu -eq 1 ]] && [[ $env_sudo -eq 1 ]]; then
      add-apt-repository -y ppa:jonathonf/vim
      apt update
      apt install -y vim
    else
      echo '[ERROR] Ubuntu and sudo required to install vim' >&2
      echo >&2
      exit_safely 1
    fi
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
    check_and_install_git_or_exit
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
    check_and_install_curl_or_exit
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
}

configure_full_vim()
{
  echo 'TODO'
  # INSTALL vundle/vim-plug
  # INSTALL ctags
  # Copy vimrc
}

configure_basic_vim()
{
  echo 'TODO'
  # INSTALL vundle/vim-plug
  # Copy vimrc
}

configure_minimal_vim()
{
  echo 'TODO'
  # COPY ssh_vimrc
}

install_trash_put()
{
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
}

configure_trash_put()
{
  echo 'TODO'
}

install_zsh()
{
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
    if [[ $env_ubuntu -eq 1 ]] && [[ $env_sudo -eq 1 ]]; then
      apt install -y zsh
    else
      echo '[ERROR] Ubuntu and sudo required to install zsh' >&2
      echo >&2
      exit_safely 1
    fi
  fi

  check_and_install_git_or_exit

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
}

# Parse command line arguments
while [ "$1" != "" ]; do
  config_all=0
  case $1 in
    --minimal ) config_minimal=1
      ;;
    --config-files ) config_config_files=1
      ;;
    --no-sudo ) config_no_sudo=1
      ;;
    --not-ubuntu ) config_not_ubuntu=1
      ;;
    --vim-full ) config_vim_full=1
      ;;
    --vim-basic ) config_vim_basic=1
      ;;
    --vim-minimal ) config_vim_minimal=1
      ;;
    --zsh ) config_zsh=1
      ;;
    --trash-put ) config_trash_put=1
      ;;
    --tmux ) config_tmux=1
      ;;
    --rust ) config_rust=1
      ;;
    --pyenv ) config_pyenv=1
      ;;
    --fzf) config_fzf=1
      ;;
    -h | --help ) usage
      exit
      ;;
    * ) usage
      exit 1
  esac
  shift
done

cwd=${PWD##*/}

if [ cwd != 'dotfiles' ]; then
  if [ cd dotfiles -eq 0 ]; then
    back_dir_upon_completion=1
  else
    echo '[ERROR] Please run this script as `scripts/setup.sh`' >&2
    echo >&2
    exit_safely 1
  fi
fi

echo '*******************************' >&2
echo 'Configuring your shell...' >&2
echo '*******************************' >&2
echo >&2

# TODO: REMOVE THIS
exit_safely 0

check_ubuntu_env
check_sudo_env

if [[ $env_ubuntu -eq 1 ]] && [[ $env_sudo -eq 1 ]]; then
  apt update

  if ! [ -x "$(command -v add-apt-repository)" ]; then
    apt-get install -y software-properties-common python-software-properties
  fi
fi

check_and_install_git_or_exit
check_and_install_curl_or_exit

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

if [[ $config_fzf -eq 1 ]] || [[ $config_all -eq 1 ]]; then
  install_fzf
fi

if [[ $config_vim_full -eq 1 ]] ||
   [[ $config_vim_basic -eq 1 ]] ||
   [[ $config_vim_minimal -eq 1 ]]; then
  install_vim
fi

if [ $config_zsh -eq 1 ]; then
  install_zsh
fi

if [ $config_trash_put -eq 1 ]; then
  install_trash_put
fi

echo '*******************************' >&2
echo '*******************************' >&2
echo '[INFO] Restart your terminal!' >&2
echo '*******************************' >&2
echo '*******************************' >&2
echo >&2
exit_safely 0
