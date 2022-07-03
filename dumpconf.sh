conf_name="dconf-root-all.txt"
dconf_path="/"

errors_tpl="$(tput setaf 1)%txt%$(tput sgr0)"
notice_tpl="$(tput setaf 9)%txt%$(tput sgr0)"
info_tpl="$(tput setaf 7)%txt%$(tput sgr0)"

curtpl="ctpl$info_tpl"

print_txt_with_tpl () {
echo $curtpl | sed "s/%txt%/$*/"
}

print_error () {
  curtpl=$errors_tpl
  print_txt_with_tpl $*
}

print_notice () {
  curtpl=$notice_tpl
  print_txt_with_tpl $*
}

conf_bak_name_tpl="dconf-root-all-%date%-%ver%.txt"
bakconf_path="bakconfs"
bak_ver_limit=10
CONST_MSG_bak_overlimit_error="Backup versions limit exceeds. Please cleanup $bakconf_path directory. Aborting."
CONST_ERRCODE_bak_overlimit_error=1
bakconf_path="$bakconf_path/"

bak_ver_limit=$(( $bak_ver_limit+1 ))
mkdir -p $bakconf_path

#formname output formed name based on passed file version
formname () {
now=`date +%y%m%d`
ver=$1

#Zeropad config version if needed
if [ $ver -le 9 ]
then
ver="0"$ver;
fi;

echo $conf_bak_name_tpl | sed "s/%date%/$now/" | sed "s/%ver%/$ver/";
}

baknamewithpath () {
echo "$bakconf_path$(formname $1)"
}

cnt=1
lastbackup=""
while [ $cnt -lt $bak_ver_limit ]
do
bakname=$(baknamewithpath $cnt)
if [ ! -f $bakname ]
then
  break;
else
  echo "Backup $bakname already exists. Skipping this name..."
  lastbackup=$bakname
  echo "Setting $bakname as last backup"
fi
((cnt+=1))
done

if [ $cnt -ge $bak_ver_limit ]
then
  print_error $CONST_MSG_bak_overlimit_error;
  exit $CONST_ERRCODE_bak_overlimit_error;
fi

echo "$bakname seems like free name for backup. Processing..."

echo -n "Backing up old $conf_name to $bakname... "
mv $conf_name $bakname && echo "Done!"
echo -n "Dumping dconf$doconf_path to $conf_name..."
dconf dump $dconf_path > $conf_name && echo "Done!"

echo "Comparing current config $conf_name with last backup $lastbackup..."
diff $conf_name $lastbackup && echo "$(tput setaf 2)No differences found$(tput sgr0)"