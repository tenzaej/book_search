# README

The goal with this minimalist Book Search is for users to be able to:
- [ ] Type in a search term, and return for them a list of books matching that query, form the Google Books API.
- [ ] The listing for each book should show a picture of the book's cover, along with general information, eg author, title, publisher.
- [ ] The listing will _also_ provide a link to the Google Books page for this entry, so if they want to preview the book, buy it, get more information, they can do so.
- [ ] ...and then, Host it on Heroku, which is a thing I haven't done in a long while.

As I said above, minimalist.

At this juncture, there is no need for a database, as Google Books will be providing all of the data. I spent about a day wondering about how one could accomplish all of this with a single html file with lots of `<script>` tags, ajax'ing responses on-to and off-of the page, etc. However, my hunch is that that's _probably_ not what is meant by "single-page app", and I don't yet have enough experience with JavaScript, SPA architecture and design, JavaScript frameworks (testing or otherwise), and so on, to pull that off in a wholesome way. So, I'm going to use the language and framework that I use at my day job - the tried-and-true Ruby on Rails.
