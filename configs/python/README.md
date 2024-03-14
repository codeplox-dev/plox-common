# Common python lint/etc configs

To leverage these files, after submoduling this repository, do the following from the
root of your git project, them upload the symlinked files for continually tracking:

```bash
ln -s plox-common/configs/python/* . && \
    ln -s plox-common/configs/python/.pydocstyle.ini .

# git add the symlinked files, etc
```
