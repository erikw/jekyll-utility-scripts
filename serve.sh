#!/usr/bin/env bash
# Convenient shorthands for running $(bundle exec jekyll serve) with options for common configurations.
#
# TODO detect changes to _config.yml and restart without --open-url? Like ~/bin/macos_appearance_monitor.sh maybe
# dev hack $(while :;do bin/serve.sh -c;done) let's restart with clean directory by giving SIGINT

set -eux

scriptname=${0##*/}
script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
root=$(dirname ${script_dir})
# Make $(set -e) not trigger on read(1). Reference: https://unix.stackexchange.com/a/622786
IFS= read -rd '' usage <<EOF || :
Usage: $ ./${scriptname} [-p] [-O] [-c] [-d] [-- --other --build --args]"
-p\tSet JEKYLL_ENV=production
-O\tDon't --open-url
-c\t\$(rm -rf _site) clean before serve
-d\tenable _drafts/
EOF

openurl=--open-url
clean=
drafts=
while getopts ":pOcdh?" opt; do
	case "$opt" in
		p) export JEKYLL_ENV=production;;	# Needed for example for staticman comments locally.
		O) openurl=;;
		c) clean=true;;
		d) drafts=--drafts;;
		#:) echo "Option -$OPTARG requires an argument." >&2; exit 1;;
		h|?|*) echo -e "$usage"; exit 0;;
	esac
done
shift $(($OPTIND - 1))

if [ -n "$clean" ]; then
	echo "Deleting _site/ and .jekyll-cache/ before build"
	rm -rf _site/ .jekyll-cache/
fi

# --incremental won't pick up changes in _config.yml on start of serve unfortuantely. It could be solved by $(rm -f .jekyll-metadata) before starting jekyll-serve. But who knows what more is not updating with --incremental? So let's skip.
bundle exec jekyll serve --watch --livereload --source $root $openurl $drafts $*
