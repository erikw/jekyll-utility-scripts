# jekyll-utility-scripts
A few helper scripts that I use for development with Jekyll. You can include these as a submodule in your Jekyll git repo like

```console
$ git submodule add git@github.com:erikw/jekyll-utility-scripts.git bin/
```


# Scripts
* `diff-upstream-theme.sh`: Open up a vim multi-tab diff of all files that you've overriden from an upstream theme.
* `jekyll.sh`: Wrapper to run jekyll commands.
* `serve.sh`: Convenient script for local development making short options for controlling the jekyll build process. See the source!
