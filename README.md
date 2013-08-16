ruby-mud
========

A ruby based mud, with the ability to import ROM files.

I was interested in learning activerecord more a few years ago, which lead me to try creating a simple mud. There's plenty of jankiness here.

Prerequisites
=========
git, rvm

Setup
=========

Clone the repo:
```
git clone https://github.com/brycecovert/ruby-mud.git 
```

Install dependencies:
```
$ rvm gemset create ruby-mud
$ rvm gemset use ruby-mud
$ gem install bundler
$ bundle install
```

Create the dev db:
```
$ rake # This creates a simple db and imports an area from rom
```

Start the server:
```
$ ruby lib/socket_server.rb
```

Connect:
```
$ telnet localhost:2000
```
