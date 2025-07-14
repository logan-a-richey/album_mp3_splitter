# Album Splitter
* `split_album.pl`: split an album (mp3) file into individual tracks (mp3).
* `tag_tracks.pl`: assign metadata to tracks.

# Usage:
Example usage of `split_album.pl`:
```perl
./split_album.pl <album.mp3> <timestamps.txt> [output_dir]
```

Example usage of `tag_tracks.pl`:
```perl
./tag_tracks.pl output2/ tracklist.txt \
    --album "My Album Name" \
    --year 2025 \
    --art my_album_art.png \
    --genre "Progressive Rock" \
    --comment "Prog rock is the best." 
```

# Requirements:
* `ffmpeg` at system level
* `easytag` for viewing mp3 metadata

# License
MIT Standard License

