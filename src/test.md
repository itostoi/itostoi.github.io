# Stuffs

1) Let's try doing a fixed preamble:
2) 3 files: 2 markdown, 1 css, should be compiled into 1 html file.

We need a preamble system to build a side (or top) nav.
Can we do bash + templating to generate markdown.

1) get all the files in the directory - maybe recursively?
2) build markdown of some kind? - it'd basically be a list of all the markdown
files in the target directory.
3) Specify the output as a preamble file when building.

[Pandoc](https://pandoc.org/chunkedhtml-demo/8.14-raw-html.html)

# Lorem ipsum dolor sit amet
Some text goes here
Looks like vertical dividers explicitly need whitespace above and below.

```js
() => {
  console.log("Hello World");
}
```

```cpp
vector<int> v;
cout << "Hello World" << endl;
```

Converting from a markdown file to html:
```
pandoc test.md --from markdown --to html -o index.html
pandoc about.md --include-before-body preamble.html --from markdown --to html -o about.html   
--include-in-header
--include-before-body
--include-after-body
```

Fake and cringe.

----


>  Suffering builds character.


----


[Link test](https://fsf.org)

