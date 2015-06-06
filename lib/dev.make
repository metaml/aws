all:
	sudo gem install rake bundler
	bundle install
	bundle exec rake init
