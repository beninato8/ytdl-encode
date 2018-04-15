encode()
{
    #$1 = file
    echo encoding...
    ffmpeg -loglevel quiet -i "$1" -crf 20 -c:v libx264 -vf "scale=trunc(iw/2)*2:trunc(ih/2)*2" -preset fast -c:a libmp3lame -b:a 320k ${1[0,-5]}_encoded.mp4 >/dev/null 2>&1
    echo "done encoding"
}

doStuff()
{
    youtube-dl -f 'bestvideo[height<=720]+bestaudio/best[height<=720]' $p
    sleep 2
    
    for i in *.webm; do
        ffmpeg -i $i ${i[0,-6]}.mp4 >/dev/null 2>&1
    done

    find . -maxdepth 1 -type f -size +70M | while read fname; do
        if [[ $fname =~ ^.*\..(mp4|mkv)$ ]]; then
            encode $fname;
        fi
    done
    find . -maxdepth 1 -type f -size -70M | while read fname; do
        if [[ $fname =~ ^.*\..(mp4|mkv|webm)$ ]]; then
            echo "$fname is too small, skipping encoding";
            mv $fname ${fname[0,-5]}_encoded${fname[-4,${#fname}]}
        fi
    done
    sleep 2

    for i in *; do
        [ -f "$i" ] || break
        if [[ $i =~ ^.*encoded\..*$ ]]; then
            mv -v $i completed/
        fi
    done

    for i in *.{mp4,mkv,webm}; do
        [ -f "$i" ] || break
        rm -v $i
    done
}
setopt NULL_GLOB

while read p; do
    echo "starting $p"
    doStuff $p
    echo "done with $p"
    echo "$p" >> completed_vids
    # exit 1
done < vidlist