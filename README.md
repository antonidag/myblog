# My Blog

## Overview

The aim of this project is to eventually become my personal site and blog. I wanted to make a blog without depending on WordPress or any other fancy content management system (CMS). Additionally, I'm not a big fan of using front-end frameworks like React, as it can become to much of a hassle. I simply want a straightforward site for creating content.

[Hugo](https://gohugo.io/) is a SSG (Static Site Generator) that can generate static HTML files from markdown, aligning perfectly with my preferences for a simple way to manage and create content.

## Blog stack
- Github Pages for hosting
- [Hugo](https://gohugo.io/) for static site generation
- [utterances](https://utteranc.es/) for blog posts comments

## Getting Started

### Prerequisites
- Git
- Go
- Dart Sass

For windows
- [choco](https://chocolatey.org/)

For others
- check hugo :)

### Installation

hugo
```
choco install hugo-extended
```

Once installed, to create new site and run it locally
```bash
hugo new site quickstart
cd quickstart
git init
git submodule add https://github.com/theNewDynamic/gohugo-theme-ananke.git themes/ananke
echo "theme = 'ananke'" >> hugo.toml
hugo server
````




