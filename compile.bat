@echo off
del game.love
del game.love.tmp
7z a -tzip ".\game.love" "./*" -mx9 -xr!.*/ -xr!*.git* -xr!*.bat -xr!*.md -xr!*.txt -xr!*.love -xr!*.zip -xr!*.db -xr!*.rst -xr!*.py -xr!Makefile -xr!*.js -xr!*.rockspec -xr!mlib/Examples -xr!"mlib/Reference Pictures" -xr!hump/docs -xr!hump/spec
