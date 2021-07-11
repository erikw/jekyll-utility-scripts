#!/usr/bin/env bash
# Open up a multi-tab vimdiff for all files being overriden in project from the theme
# Requirements: https://github.com/xenomachina/public/blob/master/vim/plugin/tab-multi-diff.vim described at http://www.xenomachina.com/2012/02/multi-diff-with-vim-andor-git.html

set -eux

theme=minimal-mistakes
theme_path=$(bundle info --path "$theme")
test $? -eq 0 || (echo "Can't find theme path from bundle" && exit 1)


find_files() {
	local path="$1"
	local opts=
	local ignorepaths=(.git .git-metadata .jekyll-cache node_modules _site .netlify README.md LICENSE)
	for ignorepath in ${ignorepaths[@]}; do
		opts="$opts -path $path/$ignorepath -prune -o"
    done
	find "$path" $opts -type f  -print | sed -e "s%${path}/%%" | grep -v ".*\.swp$" | sort
}

#upstream_files=$(find $theme_path | sed -e "s%${theme_path}/%%")
#local_files=$(find . $(prune_opts))
tmpd=$(mktemp --directory)

#upstream_files=$(find_files "$theme_path")
#local_files=$(find_files .) # Could use git-ls-files
find_files "$theme_path" > $tmpd/upstream_files.txt
find_files . > $tmpd/local_files.txt

overriding_files=$(comm -12 $tmpd/upstream_files.txt $tmpd/local_files.txt)

difffiles=
for file in ${overriding_files[@]}; do
	difffiles="$difffiles ./${file} ${theme_path}/${file}"
done

vim -c 'silent call TabMultiDiff()' $difffiles
