#  useful scripts for blog
# use fd for fast finding brew install fd
# brew install optipng
#### Add this as githook?
# compress all images with optipng
# go to static folder and execute
find . -name "*.png" -exec optipng '{}' \;
find . -name "*.jpg" -exec jpegoptim --all-progressive --strip-all '{}' \;

# go to content/ folder and execute
find . -name "*.png" -exec optipng '{}' \;
find . -name "*.jpg" -exec jpegoptim --all-progressive --strip-all '{}' \;


 /home/roel/.local/share/Hugo/0.82.0/hugo --minify --buildFuture  && ./pagefind --site public