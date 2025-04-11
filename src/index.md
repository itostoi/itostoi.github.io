# WIP-website
Welcome to Derek's personal website!


## TODO:
1) Fill in content.
2) See if linking to images is supported by pandoc.
3) Get some custom CSS going so the top nav is not scuffed.

----

# Stuff

Uses [Pandoc](https://pandoc.org/chunkedhtml-demo/8.14-raw-html.html) +
[GNU make](https://www.gnu.org/software/make/) to build markdown into a static
site. Very [Eggert](https://samueli.ucla.edu/people/paul-eggert/)-core.

```js
// this is a  code block
() => {
  console.log("Hello World");
}
```

```cpp
vector<int> v;
cout << "Hello World" << endl;
```

Helpful options when converting from a markdown file to html:
```
pandoc test.md --from markdown --to html -o index.html
--include-in-header
--include-before-body
--include-after-body
--standalone
```

---

>  Suffering builds character.
