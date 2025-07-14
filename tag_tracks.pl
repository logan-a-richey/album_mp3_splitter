#!/usr/bin/perl
use strict;
use warnings;
use Getopt::Long;
use File::Spec;

# Example Usage:
# ./tag_tracks.pl output2/ tracklist.txt --album "Chiptune Is Win Vol 4" --year 2020 --art chiptune_win_vol_4_album_cover.png --genre "chiptune" --comment "Chiptunes are the best."

# ------------------------------------------------------------------------------
# Command-Line Options
# ------------------------------------------------------------------------------

my $album     = '';
my $year      = 2020;
my $art       = '';
my $genre     = '';
my $comment   = '';

GetOptions(
    'album=s'   => \$album,
    'year=i'    => \$year,
    'art=s'     => \$art,
    'genre=s'   => \$genre,
    'comment=s' => \$comment,
) or die "Error in command line arguments\n";

# Positional args
my ($outdir, $tracklist) = @ARGV;
unless (defined $outdir && defined $tracklist && $album && $art) {
    die <<"USAGE";
Usage: $0 <song_dir> <tracklist.txt> 
    --album   "Album Name"
    --year    2020
    --art     cover.png
    [--genre  "genre"]
    [--comment "This is great"]

Example:
    $0 output/ tracklist.txt --album "Chiptune Vol 4" --year 2020 --art art.png --genre "chip" --comment "Awesome"
USAGE
}

# ------------------------------------------------------------------------------
# Read Tracklist
# ------------------------------------------------------------------------------

open my $fh, '<', $tracklist or die "Can't open $tracklist: $!";
my @entries;
while (<$fh>) {
    chomp;
    next unless /^(\d{1,2}:\d{2}(?::\d{2})?)\s+(.*)$/;
    my $label = $2;
    my ($artist, $title) = split /\s*-\s*/, $label, 2;
    push @entries, { artist => $artist, title => $title };
}
close $fh;

# ------------------------------------------------------------------------------
# Tag MP3 Files
# ------------------------------------------------------------------------------

for (my $i = 0; $i < @entries; $i++) {
    my $track_num = sprintf("%02d", $i + 1);
    my $filename_pattern = "track_${track_num}_";
    my ($artist, $title) = @{$entries[$i]}{qw(artist title)};

    opendir(my $dh, $outdir) or die "Can't open dir $outdir: $!";
    my @files = sort grep { /^$filename_pattern.*\.mp3$/ } readdir($dh);
    closedir $dh;

    if (@files != 1) {
        warn "Expected one file for track $track_num, found ".scalar(@files)."\n";
        next;
    }

    my $filepath = File::Spec->catfile($outdir, $files[0]);
    my $tempfile = "$filepath.tmp.mp3";

    my @cmd = (
        'ffmpeg', '-y', '-i', $filepath,
        '-i', $art,
        '-map', '0', '-map', '1',
        '-metadata', "title=$title",
        '-metadata', "artist=$artist",
        '-metadata', "album=$album",
        '-metadata', "date=$year",
        '-metadata', "track=$track_num",
        '-metadata:s:v', "comment=Cover (front)",
        '-id3v2_version', '3',
        '-write_id3v1', '1',
        '-codec', 'copy',
    );

    # Optional fields
    push @cmd, ('-metadata', "genre=$genre")   if $genre;
    push @cmd, ('-metadata', "comment=$comment") if $comment;

    push @cmd, $tempfile;

    print "Tagging: $filepath\n";
    system(@cmd) == 0 or warn "FFmpeg tagging failed for $filepath\n";

    rename $tempfile, $filepath or warn "Failed to rename $tempfile to $filepath\n";
}

print "Tagging completed!\n";

