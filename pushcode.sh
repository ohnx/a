#!/bin/bash
echo "Preparing code..."
bzip2 mini.img
rm -rf mini.img
echo "Adding/Removing code..."
git rm -r * --cached
git add *
echo "Commiting code wtih given message..."
git commit -m $@
echo "Pushing code..."
echo "You need to enter uname and pass here."
git push
echo "Restoring code..."
bzip2 -d mini.img.bz2
rm -rf mini.img.bz2
echo "Done!"
