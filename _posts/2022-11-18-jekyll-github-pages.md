---
layout: post
title: "Github Pages"
date: 18.11.2022
categories: jekyll
---


`jekyll new . --force` Создать проект jekyll в текущей директории
<details>
<summary>
Сразу создадутся файлы:
</summary>
    _posts
    _config.yml
    .gitignore
    404.html
    about.markdown
    Gemfile
    Gemfile.lock
    index.markdown
    README.md
</details>
<summary>
В _config.yml задаются тема и плагины:
</summary>
    theme: minima
    plugins:
    - jekyll-feed
</details>

В _config.yml:
```
baseurl: "/MyPages"
url: "https://aq1990.github.io"
```

Запустить
`bundle exec jekyll serve` Первый запуск
`exec jekyll serve`

5. Минимальный Front Matter
```
---
layout: "page"
title: "Donate"
---
```

Создать пост в папке _posts.
Front Matter

7. Drafts/Черновики
Создать папку `_drafts`
Создать в ней файл `my-first-draft.md`
В файле должен быть Front Matter
`jekyll serve --draft` Запустить сервер с черновиками

8. Страница в корне сайта
`layout: "page"` а не "post"

9. 
`permalink: "/my-new-url/"` принудительно задать url вместо дата+категория
`permalink: ./catergories/:year/:month/:day/:title` тот же url что и по умолчанию

10. Front Matter по умолчанию
в _config.yml
defaults:
  -
    scope:
      path:
    values:
      layout: "posts"

11. Тема
gem "minima", "~> 2.5"