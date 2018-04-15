find . -maxdepth 1 -type f -size +70M | while read fname; do
    echo $fname
done

i="abcdefghi.webm"
echo ${i[0,-6]}.mp4