@echo off
echo "Moonshine"
rmdir /Q /S "moonshine"
git submodule add -f https://github.com/SpeckyYT/moonshine.git
echo "Hump"
rmdir /Q /S "humb"
git submodule add -f https://github.com/vrld/hump.git
echo "MLib"
rmdir /Q /S "mlib"
git submodule add -f https://github.com/davisdude/mlib.git
echo "Konami"
rmdir /Q /S "Konami"
git submodule add -f https://github.com/Tjakka5/Konami.git
git submodule update --remote --merge
