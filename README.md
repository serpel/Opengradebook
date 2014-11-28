opengradebook
=============
> Fork of Fedena opensource project for Honduras schools.

## Install OpenGradebook for development

### Requeriments
* Ubuntu 14.04 LTS

### Recomended specs
* 2 Core & 1GB RAM

### Step 1: Install ruby
```ruby
sudo add-apt-repository ppa:brightbox/ruby-ng-experimental 
sudo apt-get update
sudo apt-get install ruby1.8
sudo gem install bundle
```

```ruby
* sudo gem install rubygems-update -v 1.3.7
* sudo env REALLY_GEM_UPDATE_SYSTEM=1 gem update --system 1.3.7
```

### Step 2: Install mysql
sudo apt-get install libmysqlclient-dev mysql-server

### Step 3: Install git & utils
```
sudo apt-get install git
sudo apt-get install build-essential libssl-dev libcurl4-gnutls-dev libexpat1-dev gettext unzip
git config --global user.name "yourusername"
git config --global user.email "youremail@example.com"
```

### Step 4: Clone the repository
```
cd $user
git clone https://github.com/serpel/Opengradebook
```

### Step 5: Configure project
```ruby
cd Opengradebook/
bundle install
rake db:create RAILS_ENV=development
rake fedena:plugins:install_all RAILS_ENV=development
```
### Optional:
* rubymine
* mysql workbench

#### Install Rubymine IDE
download RubyMine 6.3.3 or later for linux
```
cd path-where-rubymine-is-located
sudo tar xvfz ./RubyMine-6.3.3.tar.gz -C /opt/ && sudo ln -fs /opt/RubyMine-6.3.3 /opt/Rubymine && sudo ln -fs /opt/Rubymine/bin/rubymine.sh /usr/bin/mine && sudo bash -c 'cat > /usr/share/applications/jetbrains-rubymine.desktop <<EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=JetBrains RubyMine
Exec="/opt/Rubymine/bin/rubymine.sh" %f
Icon=/opt/Rubymine/bin/RMlogo.svg
Comment=Develop with pleasure!
Categories=Development;IDE;
Terminal=false
StartupNotify=true
StartupWMClass=jetbrains-rubymine
EOF'
```

#### Install Mysql workbench 5.2 or later
use ubuntu market

### Contact
serpel.js@gmail.com

