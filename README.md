# Swiftmarks

Swiftmarks is a Ruby on Rails web application for managing your bookmarks. It's designed
to be simple and private with a focus on doing one thing well.


## Features

* Multiple users
* Tagging
* Search
* Bookmarklet
* Import Bookmarks (Netscape Bookmark file format supported)


## Installation

Before you can install Swiftmarks, you must have MySQL and Ruby 1.9.2 installed.

To install on your local machine, open a terminal, change to the directory where
you installed Swiftmarks, and run the following commands:

1. Setup the database

        $ mysqladmin -u root create swiftmarks_development
        $ rake db:schema:load


2. Install Bundler and application dependencies

        $ gem install bundler
        $ bundle install


3. Run the server

        $ rails server


4. Open your web browser and navigate to "http://localhost:3000"

5. You're done!


## Help

Please [contact me](https://github.com/inbox/new/jpo) if you have any questions or problems.
