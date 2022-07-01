dconf_set_name="cin-all-dconf.txt"
orig_name="oldconfs/cin-all-dconf-bak-`date +%y%m%d`"
file_name="$orig_name-01"
cnt=1
while [ -f "$file_name.txt" ]
do
  cnt=$((cnt+1))
  if [[ $cnt -lt 10 ]]
  then
    file_name="$orig_name-0$cnt"
  else
    file_name="$orig_name-$cnt"
  fi
done
file_name="$file_name.txt"
echo "Writing backup to $file_name"
mv cin-all-dconf.txt $file_name
echo "Dumping settings..."
dconf dump /org/cinnamon/ > $dconf_set_name
echo "Diff with previous:"
diff $file_name $dconf_set_name && echo "No differrence with latest backup"
