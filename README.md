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

MIT License (MIT)

Copyright (c) 2025 LoganARichey

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.


