Download this gist. Extract it. Then run these commands from the command line
where you extracted it:

```bash

# make a temporary virtualenv, requires virtualenvwrapper
mktmpenv
# go back to the previous directory
cd -
# setup
pip install https://github.com/texastribune/django-gistpage/tarball/master
curl http://www.texastribune.org/test/gistpage/ -o index.html
python -m DjangoGistServer 8000

```

Now open http://localhost:8000 in your browser.
