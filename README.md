Subbot is a **Sub**reddit announcer **bot** for IRC. It is designed to sit in a channel and post whenever a new post is made to a subreddit.

# Prereqs
+ At least ruby 1.9
+ bundler

# Installation
1. git clone & cd to directory
2. `bundle install`
3. Edit configs (see below)
4. `rake db:create`
5. `ruby bot.rb`
6. ???
7. Profit!

# Configs
*Almost* all the configs are to bestored in `conf/config.yml` The exception is the path to the SQLite DB file. That is hard-coded into `conf/database.rb`. Sorry about that!

`example.config.yml` is an example config you can copy and edit, just rename it `config.yml`. It has comments that describe what each setting does

# Legal stuff

```
Copyright (c) 2013 Jeff Sandberg

MIT License

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
```
