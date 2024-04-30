---
title: zettlr to hugo
description: ""
subtitle: ""
date: 2024-05-02
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


This is a technical walkthrough of how I turn zettlr markdown files into a hugo website. This is an experiment and not yet finished, but I want to write down my thoughtprocess in the hope that it works for you too.

I was looking for a way to publish my zettelkasten to a website that only I can see.

my solution is: any self published, local website will do, as long as I put it behind a tailscale network, then I can view the website with my devices everywhere (through tailscale). 

So an external process to turn zettlr notes into a website it is, see [outline private personal knowledge project](/blog/2024/04/30/private-pkm/) for more information.


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

I found this <https://labs.loupbrun.ca/hugo-cite/> project that enables citations in hugo. It only supports one style, but that is fine, because I use that style. 

I have to change citations in the file from `[@asdfasldfkjasldf]` to shortcode cite: ```{{< cite "asdfasldfkjasldf" >}}```. 
And add another shortcode ```{{< bibliography cited >}}``` to add a list of work. 


I have worked with hugo a lot, this blog is hugo, the satRdays website is hugo, and my notes website is hugo too. 

The conversion process works really well, this is the script I have right now:

```Bash
#!/bin/bash
# echo "file=${1}"
# echo "outputdir=${2-.}"
# split filename
ID=$(echo "$1" | grep -oP "([0-9]{14})")
# this is not robust enough for different directories
#NAME=$(echo "${1:16:-3}"| sed -e 's/^[[:space:]]*//') # skip first 14 characters, skip last 3 (.md) (we pass ./)

# '^.*'=anything zero or more times
# '[0-9]{14}'=14 numbers
# ' *'= optional space
# '(.+)'=at least one of anything, and first capture group ()
# '\.md'=.md
# \1 return first capture group
NAME=$(echo "${1}" | sed -E "s@^.*[0-9]{14} *(.+)\.md@\1@g") 

# extract tags, sort, and unique only, remove #, enumerate with ', ', remove last ', '.
TAGS=$(egrep -o '#[A-Za-z]+' "$1" | sort -u | sed 's/#//g' | awk 'ORS=", "' | sed 's/, $//')

CITATIONS=$(egrep -o '@[a-zA-Z0-9]{2,}' "$1" | sort -u | sed 's/@//g' | awk 'ORS=", "' | sed 's/, $//')
LINKS=$(egrep -o '\[\[[0-9]{14}\]\]' "$1" | sort -u |sed -E 's/\[\[([0-9]{14})\]\]/\1/g'| awk 'ORS=", "' | sed 's/, $//')

# extract last update date of file
LASTUPDATE=$(date -r "${1}" "+%Y-%m-%dT%H:%M:%S" )

# create filename
FILENAME="content/${ID}.md"

### DEBUG
#echo $ID
#echo $NAME
#echo $TAGS
#echo $FILENAME

cat > $FILENAME << EOL
---
url: "/$ID/"
title: $NAME
tags: [$TAGS]
citations: [$CITATIONS]
links: [$LINKS]
lastmod: $LASTUPDATE
date: ${ID:0:4}-${ID:4:2}-${ID:6:2}T${ID:8:2}:${ID:10:2}:${ID:12:2}
bibFile: "static/citations/slipbox_citations.json"
---

EOL

cat "${1}" | sed -E 's/\[\[([0-9]{14})\]\]/[\1]({{< ref "\1" >}})/g' | \
    sed -E 's/@([a-zA-Z0-9]{2,}) /{{< cite "\1" >}} /g' | \
    sed -E 's/\[@([a-zA-Z0-9]{2,})\]/[{{< cite "\1" >}}]/g' | \
    sed -E 's/#([A-Za-z]+)/[#\1]({{< ref "tags\/\1" >}})/g'| \
    sed 's/```{yaml}/```yaml/g' >> $FILENAME


# append a references section if not empty
if [ -n "$CITATIONS" ]; then
    cat >> $FILENAME << EOL
"

# References
{{< bibliography cited >}}"
EOL

fi
```

It creates the right frontmatter for hugo,
the internal urls all work, but you have to tell hugo to ignore missing links (I sometimes refer to no longer existing notes.).

There was a smal bug that took me a few hours to figure out, 
hugo did not pick up the correct date even though I put it into the frontmatter, because it expects YYYY-MM-DDTHH:MM:SS and I had not added the seconds. You also have to enable some options in the config of the website. 

So far I have not been able to add search, although it does work on my notes.rmhogervorst.nl site. 

I have some ideas about the graph visualisation, but it doesn't yet work. 

