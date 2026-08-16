# .mov -> .gif
# Usage: mov2gif <file> <scale>
# Translated from inc/functions.zsh's mov2gif().
function mov2gif --description 'Video to GIF conversion with ffmpeg + ImageMagick'
    set -l file (string replace -r '\.[^.]*$' '' -- $argv[1])
    set -l scale $argv[2]
    if test -z "$scale"
        set scale 600
    end
    set -l tmpFolder .mov2png

    section "$argv[1] >> $file.gif (scale: $scale)"

    rm -rf "$tmpFolder" 2>/dev/null
    mkdir "$tmpFolder" 2>/dev/null

    formatexec "ffmpeg -i '$file.mov' -vf scale=\"$scale\":-1 -r 10 '$tmpFolder/ffout%3d.png' -v 0"
    formatexec "magick -delay 8 -loop 0 '$tmpFolder/ffout*.png' '$file-$scale.gif'"

    if test -d "$tmpFolder"
        /bin/rm -rf "$tmpFolder" 2>/dev/null
    end

    ok (pwd)"/$PC_PATH$file.gif$PC_RESET saved"
end
