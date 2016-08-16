## OSX Dev Setup (From Scratch)

### Install Homebrew
```sh
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```
Note: if homebrew is already install, run `brew update`

### Install rbenv, ruby-build?, mysql
```sh
brew install rbenv ruby-build mysql
```
Run `rbenv init` and follow instructions for updating your PATH

### Install Ruby 2.3.1 and set global ruby
```sh
rbenv install 2.3.1
rbenv global 2.3.1
rbenv version
```

### Clone this repo
```sh
git clone git@github.com/NunchukCyborgs/apartment_search.git
cd apartment_search
```

### Install Bundler and Bundle
```sh
gem install bundler
bundle
```

### Setup Databases
```sh
bundle exec rake db:setup
```
Note: you probably want to bash alias for `bundle exec` to `be`

### Setup Elastic Search

JDK version must be higher than > 1.8.0_73 
```sh
java -version
```

Install ES
```sh
curl -L -O https://download.elastic.co/elasticsearch/release/org/elasticsearch/distribution/tar/elasticsearch/2.3.4/elasticsearch-2.3.4.tar.gz
tar -xvf elasticsearch-2.3.4.tar.gz
cd elasticsearch-2.3.4/bin
./elasticsearch
```

Setup Database
```sh
be rake db:setup
```

### Get Started

Run rails server
```sh
rails s

#Bonus Points
rails c
```