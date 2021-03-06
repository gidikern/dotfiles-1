# <a id="my-dot-files"></a>My dot files #

Designed for my own use, but feel free to use and submit issues and suggestions. I would be glad to know that it helped anyone besides me.


## <a id="os"></a>Requirements

This setup is specifically created for use with [Ubuntu 13.04 Raring Ringtail (x86_64)](http://releases.ubuntu.com/raring/), to use with other versions or distributions just replace the [APT](https://en.wikipedia.org/wiki/Advanced_Packaging_Tool) calls and the [Ubuntu repositories and packages](https://help.ubuntu.com/community/Repositories/Ubuntu).

All commands below are meant to run on [bash](https://en.wikipedia.org/wiki/Bash_(Unix_shell\)) (default shell on Ubuntu). Open a terminal with <kbd>Ctrl</kbd>+<kbd>Alt</kbd>+<kbd>t</kbd>. To open bash (if `echo $0` doesn't print `bash`):

```bash
/usr/bin/env bash
```


## <a id="install-software"></a>Install required software

<a id="ppa"></a>Add software sources to install software that are not from Canonical:

```bash
# Enable Canonical Partner
sudo sed -i "/^# deb .*partner/ s/^# //" /etc/apt/sources.list

# Add ppa's
sudo add-apt-repository -y ppa:zanchey/fishfish-snapshot
sudo add-apt-repository -y ppa:chris-lea/node.js
sudo add-apt-repository -y ppa:webupd8team/sublime-text-2
sudo add-apt-repository -y ppa:skype-wrapper/ppa

# Heroku Toolbelt ppa
wget -O- https://toolbelt.heroku.com/apt/release.key | sudo apt-key add -
echo "deb http://toolbelt.heroku.com/ubuntu ./" | sudo tee /etc/apt/sources.list.d/heroku.list

# Opera ppa
wget -O - http://deb.opera.com/archive.key | sudo apt-key add -
echo "deb http://deb.opera.com/opera/ stable non-free" | sudo tee /etc/apt/sources.list.d/opera.list

# Google Talk Plugin ppa
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
echo "deb http://dl.google.com/linux/talkplugin/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google.list
```

<a id="apt"></a>Install apt packages:

```bash
# Update package list
sudo apt-get update

# Install this package first, because it requires manual interaction
sudo apt-get install -y ttf-mscorefonts-installer

# Install packages
typeset -A pkgfor
pkgfor[app]="fbreader sublime-text vim-gtk kdiff3-qt meld guake pinta inkscape shutter"
pkgfor[build]="build-essential checkinstall"
pkgfor[db]="mongodb libsqlite3-dev postgresql libpq-dev"
pkgfor[vcs]="git git-svn gitg hg"
pkgfor[media]="qbittorrent vlc audacious"
pkgfor[shell]="fishfish xclip trash-cli curl imagemagick ffmpeg graphviz heroku-toolbelt"
pkgfor[stack]="nodejs rbenv openjdk-7-jdk"
pkgfor[ubuntu]="ubuntu-restricted-extras aptitude synaptic python-software-properties p7zip-full p7zip-rar"
pkgfor[web]="chromium-browser chromium-codecs-ffmpeg-extra opera google-talkplugin skype skype-wrapper"
pkgfor[libs]="exuberant-ctags libxslt-dev libxml2-dev libxml2-utils libqt4-dev libreadline-dev libfreetype6-dev"
sudo apt-get install -y ${pkgfor[app]} ${pkgfor[build]} ${pkgfor[db]} ${pkgfor[vcs]} ${pkgfor[media]} ${pkgfor[shell]} ${pkgfor[stack]} ${pkgfor[ubuntu]} ${pkgfor[web]} ${pkgfor[libs]}

# Remove unwanted packages
sudo apt-get purge -y unity-lens-shopping ubuntuone-client* python-ubuntuone-* totem deja-dup rhythmbox transmission* thunderbird

# Perform full upgrade
sudo apt-get dist-upgrade -y

# Clean up
sudo apt-get autoremove --purge -y
sudo apt-get autoclean
```

<a id="phantomjs"></a>Install [PhantomJS](http://phantomjs.org/) manually, since apt package is too old:

```bash
PHANTOMJS=phantomjs-1.9.1-linux-x86_64
curl http://phantomjs.googlecode.com/files/$PHANTOMJS.tar.bz2 | tar -xj
sudo mv $PHANTOMJS /usr/lib/phantomjs
sudo ln -s /usr/lib/phantomjs/bin/phantomjs /usr/bin/phantomjs
```


## <a id="configure-development-environment"></a>Configure workspace

<a id="ssh"></a>Configure SSH key:

```bash
# Generate SSH key
ssh-keygen -t rsa -C "michelpm@gmail.com"

# Copy to clipboard
xclip -sel clip < ~/.ssh/id_rsa.pub
```

<a id="ssh-github"></a>To upload to [Github](https://github.com/), go to [Account settings](https://github.com/settings/ssh), click 'Add SSH key', paste in the 'Key' text field and click in 'Add key'.

<a id="ssh-heroku"></a>To upload the key to [Heroku](http://www.heroku.com/), use the [Heroku Toolbelt](https://toolbelt.herokuapp.com/):

```bash
# Login
heroku login

# Remove previous keys if you are not using them anymore, you may use also `keys:remove`
heroku keys:clear

# Upload
heroku keys:add
```

<a id="configure-workspace"></a>Configure workspace:

```bash
# Create empty folders on the workspace
mkdir -p ~/ws/{clone,st2,ruby,nodejs}

# Clone this repository
git clone git@github.com:mmacedo/dotfiles.git ~/dotfiles
```


## <a id="configure-programming-stacks"></a>Configure programming stacks

<a id="npm"></a><a id="nodejs"></a>Install global [npm (node.js)](http://nodejs.org/) packages for their binaries (they will not be in the path to require as a library):

```bash
sudo npm install -global coffee-script less jade ejs jasmine-node
```

<a id="nvm"></a></a>Install [nvm](https://github.com/creationix/nvm) and install the latest [Node.js](http://nodejs.org/):

```bash
# Install nvm
curl https://raw.github.com/creationix/nvm/master/install.sh | bash

# Load nvm to install node
. .nvm/nvm.sh

# Install latest node
nvm install v0.11.4
```

<a id="pyenv"></a><a id="python"></a>Install [pyenv](https://github.com/yyuu/pyenv) and build the latest [Python](http://www.python.org/):

```bash
# Install pyenv
git clone git://github.com/yyuu/pyenv.git .pyenv

# Load pyenv to install python
eval "$(rbenv init -)"

# Install dependencies
sudo apt-get build-dep -y python3.3

# Install latest python
pyenv install 3.3.2
pyenv global 3.3.2
```

<a id="rbenv"></a><a id="ruby"></a>Install several [rbenv](https://github.com/sstephenson/rbenv) plugins with [rbenv-installer](https://github.com/fesplugas/rbenv-installer) and build the latest [MRI/CRuby](http://www.ruby-lang.org/):

```bash
# Run rbenv-installer
curl https://raw.github.com/fesplugas/rbenv-installer/master/bin/rbenv-installer | bash

# Run rbenv-bootstrap to install apt packages necessary to build Ruby on Ubuntu
sudo rbenv bootstrap-ubuntu-12-10

# Copy Ruby dotfiles
for rc in ~/dotfiles/{irb,pry,gem}rc; do ln -s $rc ~/.${rc##*/}; done

# Load rbenv ruby to install rubies and gems
eval "$(rbenv init -)"

# Install latest MRI
rbenv install 2.0.0-p247
rbenv global 2.0.0-p247

# Install gems
gem update --system
gem install bundler
pushd ~/dotfiles; bundle install; popd
```


## <a id="install-and-configure-text-editors-and-ides"></a>Configure applications

<a id="guake"></a>Configure [Guake](http://guake.org/).

```bash
gconftool-2 --load ~/dotfiles/guake-preferences.xml
```

<a id="st2"></a>Configure [Sublime Text 2](http://www.sublimetext.com/) and install [Sublime Package Control](http://wbond.net/sublime_packages/package_control) and [URL handler](http://blog.byscripts.info/2013/02/txmt-protocol-and-sublime-text-2-english.html). First time you open Sublime Text 2 after doing these steps, Sublime Text 2 will install Sublime Package Control. First time it opens after that, Sublime Package Control is going to read my list of packages and install every one of them, but it is going to generate several errors and may need a few restarts until it finishes. Also, do not forget to enter license.

```bash
ST2=~/.config/sublime-text-2

# Copy configuration
mkdir -p $ST2/Packages/User
for file in ~/dotfiles/st2/*; do ln -s "$file" "$ST2/Packages/User/$(basename $file)"; done

# Install package_control package
mkdir -p $ST2/Installed\ Packages
curl http://sublime.wbond.net/Package%20Control.sublime-package > $ST2/Installed\ Packages/Package\ Control.sublime-package

# Install url handler for txtm:// and subl:// with Sublime Text 2
wget https://raw.github.com/MrZYX/PKGBUILDs/master/sublime-url-handler/sublime-url-handler
chmod +x sublime-url-handler
sudo mv sublime-url-handler /usr/bin/
wget https://raw.github.com/MrZYX/PKGBUILDs/master/sublime-url-handler/sublime-url-handler.desktop
sudo mv sublime-url-handler.desktop /usr/share/applications/
sudo update-desktop-database
```

<a id="vim"></a><a id="janus"></a>Install a [Vim](http://www.vim.org/) [distribution](https://github.com/carlhuda/janus) (need the ruby in the path to have rake installed). I don't pay much to attention to it, since I use it mainly to edit git commit messages.

```bash
curl -Lo- https://bit.ly/janus-bootstrap | bash
```


## <a id="configure-command-line-tools"></a>Configure command line tools

<a id="ack"></a>Install and configure [ack](http://betterthangrep.com/):

```bash
curl http://beyondgrep.com/ack-2.04-single-file > ~/bin/ack && chmod 0755 !#:3
ln -s ~/dotfiles/ackrc ~/.ackrc
```

<a id="git"></a>Configure [git](http://git-scm.com/):

```bash
ln -s ~/dotfiles/gitconfig ~/.gitconfig
```

<a id="hg"></a>Configure [hg](http://mercurial.selenic.com/):

```bash
hg clone http://bitbucket.org/sjl/hg-prompt/
ln -s ~/dotfiles/hgrc ~/.hgrc
```

<a id="fish"></a>Configure [fish](http://fishshell.com/):

```bash
chsh -s $(which fish)
curl -L https://github.com/bpinto/oh-my-fish/raw/master/tools/install.sh | bash
mkdir -p ~/.config/fish && ln -s ~/dotfiles/{config,source,functions,pyenv,rbenv}.fish ~/.config/fish/
mkdir -p ~/.oh-my-fish/themes/my && ln -s ~/dotfiles/fish_prompt.fish ~/.oh-my-fish/themes/my/
```
