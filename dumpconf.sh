mv cin-all-dconf.txt oldconfs/cin-all-dconf-bak-`date +%y%m%d`.txt
dconf dump /org/cinnamon/ > cin-all-dconf.txt