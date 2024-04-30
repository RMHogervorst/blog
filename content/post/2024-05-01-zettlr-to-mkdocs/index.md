---
title: Zettlr to mkdocs
description: "This is a technical walkthrough of how I turn zettlr markdown notes into a mkdocs website. It does not entirely match my wishes"
subtitle: "Let's use python, I already know that"
date: 2024-05-01
preview: ""
draft: false
tags:
    - automation
    - bibtex
    - PKM
    - citations
    - zettelkasten
categories:
    - blog
difficulty:
    - intermediate
post-type: 
    - post
share_img: "img/presentation_images/keyboard02_10p.jpg"
image: "img/presentation_images/keyboard02_10p.jpg"
---


This is a technical walkthrough of how I turn zettlr markdown files into a mkdocs website. This is an experiment and not yet finished, but I want to write down my thoughtprocess in the hope that it works for you too.

I was looking for a way to publish my zettelkasten to a website that only I can see.

my solution is: any self published, local website will do, as long as I put it behind a tailscale network, then I can view the website with my devices everywhere (through tailscale). 

So an external process to turn zettlr notes into a website, see [outline private personal knowledge project](/blog/2024/04/30/private-pkm/) for more information.


**wishes**
- don't change anything about zettlr (or as small as possible)
- support citations (I did not put in bibtext references for nothing)
- ability to search
- should display math equations (not too many, but when shown they are crucial)

nice to have:
- display a graph of my zettels

zettlr notes in my zettelkasten are vanilla markdown and look like this:

```bash
# heading with title

possible #tags

content with [@references] or sometimes @references.

links to other zettels go by id like [[202201011201]]

```

options:
- python slipbox <https://github.com/lggruspe/slipbox>
- mkdocs zettelkasten <https://buvis.github.io/mkdocs-zettelkasten/>
 
**slipbox** uses graphviz to visualize graph, supports citations.
But would need to have the ID of the zettel in the first heading 1.

**mkdocs zettelkasten** has no graph view, and does not work with citations (There is a mkdocs citations plugin, but that uses footnotes, and is not what I want)
requires that every zettel has a yaml frontmatter with title, id and possibly tags. 
Every file should be named `[ID].md` where they were called `[ID] and a title.md` before.

I have worked with mkdocs before so that has my preference, and mkdocs is very extensible.  but both are good contenders.

This post goes into details of how I turned my zettlr zettels into (mostly) working mkdocs pages.

I created a bash script that turns a markdown doc into another markdown doc

- you pass it the filename and the directory
- it extracts the ID (from the filename)
- it extracts the title (because i put a title (with spaces) in the filename)
- it extracts tags
- finds the last update
- and finally it processes the markdown with pandoc so that citations are put into place in the style I want and a reference at the bottom. 

This is file `transform.sh`:
```Bash
#!/bin/bash
## debug steps
# echo "file=${1}"
# echo "outputdir=${2-.}"

# split filename, extract ID
ID=$(echo "$1" | grep -oP "([0-9]{14})")

# '^.*'=anything zero or more times
# '[0-9]{14}'=14 numbers
# ' *'= optional space
# '(.+)'=at least one of anything, and first capture group ()
# '\.md'=.md
# \1 return first capture group
NAME=$(echo "${1}" | sed -E "s@^.*[0-9]{14} *(.+)\.md@\1@g") 

# extract tags, sort, and unique only, remove #, enumerate with ', ', remove last ', '.
TAGS=$(egrep -o '#[A-Za-z]+' "$1" | sort -u | sed 's/#//g' | awk 'ORS=", "' | sed 's/, $//')

# extract last update date of file
LASTUPDATE=$(date -r "${1}" "+%Y-%m-%d %H:%M:%S" )

# create filename
FILENAME="${2-.}/${ID}.md"

### DEBUG
#echo $ID
#echo $NAME
#echo $TAGS
#echo $FILENAME

cat > $FILENAME << EOL
---
id: $ID
title: $NAME
tags: [$TAGS]
date: "$LASTUPDATE"
---

EOL
# add citations and  replace [[ID]] links with [ID](ID) links
pandoc "${1}" -t markdown-citations+space_in_atx_header --atx-headers --bibliography="output/slipbox_citations.bib" --csl="output/apa-6th-edition.csl" --metadata=link-citations:true | sed -E "s/\[\[([0-9]{14})\]\]/[\1](\1)/g" >> $FILENAME
```

I can then search for zettels in a directory and pass them to this project 
`find ~/PATH_TO/slipbox/ -regextype posix-extended -regex ".*[0-9]{14}.*\.md" -exec ./transform.sh {} output \;`

The process without pandoc goes really fast, with pandoc slightly slower but within 10 seconds all 1000 files are processed and copied.

Unfortunately the pandoc citations addition modifies the markdown. So I have to do extra work to make it all work

bugs
- tags appear twice, once on top, once with weird {.button} thing (this is not caused by pandoc)
- date does not use the date, or last_change field (this is not caused by pandoc)
- references add code block that is not parsed by mkdocs and looks like this: 

```
::: {#refs .references .hanging-indent} ::: {#ref-killjoyAnarchismItsMisunderstanders2023} Killjoy, M. (2023). Anarchism and its Misunderstanders. https://www.tangledwilderness.org/features/anarchism-and-its-misunderstanders. ::: :::
```





## conclusion
Points
1. don't change anything about zettlr (or as small as possible)
2. support citations (I did not put in bibtext references for nothing)
3. ability to search
4. should display math equations (not too many, but when shown they are crucial)

nice to have:
5. display a graph of my zettels

(1) and (3) are done. You can easily search in mkdocs and I did not have to change anything in my original files. 
(4) math equations seems to work alright with a plugin. 

(2) is a breaking point, this process can add citations with markdown, but it is visually unpleasing. (5) I did not even go into.


I feel the set of tools fights eachother. one thing tries to make cool html, another tries to intelligently parse that as markdown and it all does not really deliver a nice result. This is not really the best solution. I stop development here.