@echo off
echo "Moonshine"
rmdir /Q /S "moonshine"
git submodule add --force https://github.com/vrld/moonshine.git
echo "Hump"
rmdir /Q /S "humb"
git submodule add --force https://github.com/vrld/hump.git
echo "MLib"
rmdir /Q /S "mlib"
git submodule add --force https://github.com/davisdude/mlib.git
echo "Konami"
rmdir /Q /S "Konami"
git submodule add --force https://github.com/Tjakka5/Konami.git
