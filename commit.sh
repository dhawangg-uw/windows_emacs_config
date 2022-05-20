# cp ~/AppData/Roaming/.emacs.d/init.el .
cp ~/AppData/Roaming/.emacs.d/lisp/xah-fly-keys.el .
git add .
git commit -m "commit: $(date +"%m%d%Y_%H%M")"
git push origin main
