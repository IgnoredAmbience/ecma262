#!/bin/bash

branch=$(git rev-parse --abbrev-ref HEAD)
ref=$(git rev-parse --short HEAD)
ref_uri="{{site.github.repository_url}}/tree/${ref}"
ref_link="[${ref}](${ref_uri})"

npm run build
git stash

git checkout edgemaster-publish
git rm -r $branch || true
mv out $branch
git add $branch

if grep "\[${branch}\]" index.md > /dev/null;
then
  sed -ire "/\[${branch}\]/d" index.md
fi
echo "* [${branch}](${branch}) (${ref_link})" >> index.md
git add index.md || true

git commit -m "Update spec for branch $branch" || true

git checkout master
git stash pop --index

echo "Now run: git push origin edgemaster-publish"
