#  useful scripts for blog
# use fd for fast finding brew install fd
# brew install optipng

# compress all images with optipng
# go to static folder and execute
fd "\.png" -exec optipng {} \;