for i in *encoded.*; do
    [ -f "$i" ] || break
    echo "moving $i"
    mv -v $i completed/
done