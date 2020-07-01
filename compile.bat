@echo off
del game.love
del game.love.tmp
7z a -tzip ".\game.love" "./*" -mx0 -xr!.git -xr!*.git* -xr!*.bat -xr!*.md -xr!*.txt -xr!*.love -xr!*.zip -xr!*.db -xr!*.rst -xr!*.py
