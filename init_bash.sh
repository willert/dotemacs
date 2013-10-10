OLD_PS1=$PS1;PS1='';OLD_PS2=$PS2;PS2='';
if [[ "x$EPROJECT_ROOT" != "x" ]] ; then
    cd $EPROJECT_ROOT 
    source ./perl5/etc/mist.mistrc
    history -r
fi

echo 

PS1=$OLD_PS1;PS2=$OLD_PS2;
