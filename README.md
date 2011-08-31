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

## License

Copyright (c) 2011 Josh O'Rourke

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
