## Book Search

### Description

A no-frills app for searching for books and articles and such. It currently sends search terms along to Google Books API, and displays the book's cover, author, title, and publisher, along with a link to view the listing on Google Books itself.

### How To Use

The app is currently hosted on Heroku, and so the easiest way to use it would be to visit it [here](https://shrouded-everglades-99818.herokuapp.com/). Just enter a search term, hit enter, and then view what comes up. Pagination will allow you to move forward and backward among results, and clicking on any listed author(s) or publisher will perform another search with that as the new search term.

### How To Run (locally)


To run it locally, you'll first want to clone it from this repo:

```
git clone https://github.com/tenzaej/book_search.git
```

After that, go into the directory...

```
cd book_search
```

...and make sure you've got dependencies installed. This app uses ruby 2.5.5 and an assortment of gems, so use whatever ruby version manager you prefer, and install the dependencies. For me, it looks something like this:

```
rbenv install 2.5.5
rbenv local 2.5.5
gem install bundler
bundle install
```

From there, you can start the server locally with

```
bundle exec rails server
```

If all is well, you should be able to navigate to localhost:3000 and start to search.

### How To Run Tests

After you have cloned the project and installed its various dependencies, running the tests locally consists of the following command:

```
bundle exec rspec
```


