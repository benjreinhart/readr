1.0.0 / 2013-09-29
==================

* Complete rewrite using [globber](https://github.com/benjreinhart/globber) as the file globbing engine
* Now accepts all options that [globber](https://github.com/benjreinhart/globber) accepts
* `friendlyPath` can no longer be a string
* File paths are no longer always absolute; they work the same as the paths from globber
* Added History.md
* Rewrote test suite
* Accepts an additional option, `encoding` (defaults to utf8), which can be anything that fs#readFile or fs#readFileSync accepts. Specify 'buffer' to get the contents as a raw buffer