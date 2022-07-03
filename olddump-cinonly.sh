
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
dconf dump / > $root_set_name
echo "Diff with previous:"
diff $file_name $dconf_set_name && echo "$(tput setaf 2)$(tput bold)No differrence with latest backup$(tput sgr0)"
