opengradebook
=============
> Fork of Fedena opensource project.

## Install OpenGradebook for development

### Requirements
* Ubuntu 14.04 LTS

### Recommended specs
* 2 Core & 1GB RAM

### Installation

**Step 1:** Install ruby
```sh
sudo add-apt-repository ppa:brightbox/ruby-ng-experimental 
sudo apt-get update
sudo apt-get install ruby1.8
sudo gem install bundle
```

```ruby
* sudo gem install rubygems-update -v 1.3.7
* sudo env REALLY_GEM_UPDATE_SYSTEM=1 gem update --system 1.3.7
```

**Step 2:** Install mysql
```sh
sudo apt-get install libmysqlclient-dev mysql-server
```

**Step 3:**  Install git & utils
```sh
sudo apt-get install git
sudo apt-get install build-essential libssl-dev libcurl4-gnutls-dev libexpat1-dev gettext unzip
git config --global user.name "yourusername"
git config --global user.email "youremail@example.com"
```

**Step 4:**  Clone the repository
```sh
cd $user
git clone https://github.com/serpel/Opengradebook
```

**Step 5:**  Configure project
```ruby
cd Opengradebook/
bundle install
rake db:create RAILS_ENV=development
rake fedena:plugins:install_all RAILS_ENV=development
```

**Default data Demo:** 

Role          | Username      | Password
------------- | ------------- | ------------- 
admin         | admin         | admin`123`
student       | username      | username`123`
parent        | `p`studentusername | `p`studentusername`123`
employee      | username  | username`123`

**Optional:** 
* rubymine
* mysql workbench

**Install Rubymine IDE:**

JetBrains RubyMine is a commercial IDE for Ruby and Ruby on Rails built on JetBrains' IntelliJ IDEA platform. [rubymine]
> You must pay for it $$$, in this project we use RubyMine 6.3.3 for linux

```sh
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
**Install Mysql workbench 5.2 or later**
> You can find it in the ubuntu market

## Install for production environment
Before install you might check out cloud hosting like:
* Rackspace
* Amazon cloud
* Azure
* Digital Ocean
 
*All this sites offer a VPS Server with Linux.*

### Requirements
* Ubuntu 14.04 LTS

### Minimun requirements specs
* 1 Core & 512 RAM

*This may vary depending on the number of users.*

### Installation

**Step 1:** You need to install Apache (if you don't already have it installed):
```sh
sudo apt-get install apache2 apache2-mpm-prefork apache2-prefork-dev
```

**Step 2:** Install Phusion Passenger (an Apache module that lets you run Rails apps easily):
```ruby
cd path
sudo gem install passenger
sudo passenger-install-apache2-module
```
**Step 3:** The passenger-install-apache2-module script will guide you through what you need to do to get Passenger working. It should tell you to copy these lines into your /etc/apache2/apache2.conf:
```sh
LoadModule passenger_module /usr/lib/ruby/gems/1.8/gems/passenger-2.2.2/ext/apache2/mod_passenger.so
PassengerRoot /usr/lib/ruby/gems/1.8/gems/passenger-2.2.2
PassengerRuby /usr/bin/ruby1.8
```

**Step 4:**
Enable mod_rewrite for Apache:
```sh
sudo a2enmod rewrite
```

**Step 5:** Clone or copy the project to this path -> /var/www/opengradebook, this will create a folder in the current directory called 'opengradebook' with all the files needed to run your Rails app.
```sh
cd /var/www/
git clone https://github.com/serpel/Opengradebook
```

**Step 6:** Now you can add a vhost for you project.
Create a file in /etc/apache2/sites-available/ for your site (something like 'dev.example.com') and insert this:

```xml
<VirtualHost *>
    # Change these 3 lines to suit your project
    RailsEnv production
    ServerName dev.example.com
    DocumentRoot /var/www/opengradebook/public # Note the 'public' directory
</VirtualHost>
```
> Note: Remember change the **ServerName** to your domain

**Step 7:** Enable your new site and restart Apache:
```sh
sudo a2ensite dev.example.com
sudo /etc/init.d/apache2 restart
```
> Remember change dev.example.com to your domain

**Optional:** You might also need to make an entry in your etc/hosts file and restart your browser:
```sh
127.0.0.1   dev.example.com
```

### Support

Sergio Peralta serpel.js@gmail.com

Please file issues [click here] at Github. 

Copyright (c) 2012-2014 Sergio Peralta. This software is licensed under the MIT License.

Good luck!

[click here]:https://github.com/serpel/Opengradebook/issues
[rubymine]:https://www.jetbrains.com/ruby/

### Contributing

Fork it
Create your feature branch (git checkout -b my-new-feature)

Commit your changes (git commit -am 'Add some feature')

Push to the branch (git push origin my-new-feature)

Create a new Pull Request
