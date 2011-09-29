# Ruby Trots for a Stupid Hacker

[![Build Status](https://secure.travis-ci.org/argent-smith/ruby-trots.png)](http://travis-ci.org/argent-smith/ruby-trots)

It's something like a quick "avoid-some-stupidities" reference for my precious
self. The examples in this reference are the actual BDD and code snippets I
used to clean my mind up.

# Why?

Because. Today young and not-so-young rubyists like the concepts of
self-documenting code and good BDD. Yet they often neglect one human feature:
monkey reads => monkey understands. Quality of the majority of _real_ good
software's RDoc/Yard/Readme/Everyting documentation is _really_ poor. So from
time to time I have to re-learn the libs, frameworks and techniques myself. My
opensource-centered mind and vainglorious ego, of course, wouldn't allow me to 
keep all this great knowledge under the desk. So here it is.

## How to Run

`rake -T` my dear friend. Experiment with it: I suppose you are a hacker after
all. I like those `spec:doc` and `features:pretty` things.

## Trot One
### A Thor::Group#class_option bug?

Once upon time I was forced (well, not so, but as a stupid hacker I'm always looking for an
excuse) to adopt Yehuda Katz' amazing Thor framework. Shortly after some first
hacks I've found that my `Thor::Group`'ed tasks __don't see__ a `class_option :something` which I've
aliased as `-smth`. After a couple of days digging everything I've finally
found that Thor parses option one-dash option aliases only when they're also
one-lettered, so when I've changed my precious option alias to `-s` it passed
the tests.

See the examples:

1. [thor_class_option_right.feature][4]
2. [thor_class_option_wrong.feature][5]

This way I decided that one-dash-one-letter options is kinda good tradition after all.

One more stupid knowledge bug was eliminated.

## Trot Two
### Thor::Actions#directory issue?

The next rake in the grass was my first attempt to work with templated
filenames while doing a custom generator. [Thor doc][6] reads:

> Copies recursively the files from source directory to root directory. If any of the files finishes with .tt, it’s considered to be a template and is placed in the destination without the extension .tt. If any empty directory is found, it’s copied and all .empty_directory files are ignored. Remember that file paths can also be encoded, let’s suppose a doc directory with the following files:
> 
> ```
>   doc/
>     components/.empty_directory
>     README
>     rdoc.rb.tt
>     %app_name%.rb
> ```
> 
> When invoked as:
> 
> ```
>   directory "doc"
> ```
> 
> It will create a doc directory in the destination with the following files (assuming that the `app_name` method returns the value “blog”):
> 
> ```
>   doc/
>     components/
>     README
>     rdoc.rb
>     blog.rb
> ```

I already had some helper methods hidden under `private` section: this way I
wanted them to be not visible to Thor as tasks. Misteriously the generator
refused to create a file with an expected name. After two days of thinking
hard and chatting with Thor guys I found that _I should never use private_ to
hide my methods: while not `public` they're invisible to the Thor API.
Instead, I should use this:

```ruby
no_tasks do

  def meth_one
    ...
  end

  def meth_two
    ...
  end

end
```

This is a good self-explaining style and completely legal with Thor.

Illustration:

1. [thor_directory_issue.feature][7]

## LICENSES:

* Literature: [![CC-BY][1]][2]
* Code: [MIT][3]

[1]: http://i.creativecommons.org/l/by/3.0/80x15.png
[2]: http://creativecommons.org/licenses/by/3.0/ "CC-BY License"
[3]: https://github.com/argent-smith/ruby-trots/blob/master/LICENSE.markdown "MIT License"
[4]: https://github.com/argent-smith/ruby-trots/blob/master/features/thor_class_option_right.feature "see the file"
[5]: https://github.com/argent-smith/ruby-trots/blob/master/features/thor_class_option_wrong.feature "see the file"
[6]: http://rdoc.info/github/wycats/thor/master/Thor/Actions#directory-instance_method
[7]: https://github.com/argent-smith/ruby-trots/blob/master/features/thor_directory_issue.feature    "see the file"

