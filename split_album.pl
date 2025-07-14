#!/usr/bin/perl
use strict;
use warnings;

# Usage: 
# ./script.pl <album.mp3> <timestamps.txt> [output_dir]

# splits a long mp3 file into smaller mp3 files (e.g. an album into individual songs)
# expects a tracklist.txt file with lines in the following format:
# 0:00:00 AUTHOR - TITLE

# -----------------------------------------------------------------------------
# Helper Functions

# Convert HH:MM:SS or MM:SS to total seconds
sub to_seconds {
    my ($time_str) = @_;
    my @parts = reverse split /:/, $time_str;
    my $seconds = 0;
    $seconds += $parts[0] if $parts[0];
    $seconds += $parts[1] * 60 if $parts[1];
    $seconds += $parts[2] * 3600 if $parts[2];
    return $seconds;
}

# Slugify to snake_case
sub slugify {
    my ($text) = @_;
    $text =~ s/[^\w]+/_/g;
    $text =~ s/_+/_/g;
    $text =~ s/^_|_$//g;
    return lc $text;
}

# -----------------------------------------------------------------------------
# Main Function

sub main {
    # Get inputs from cmdline
    my ($input_mp3, $tracklist, $output_dir) = @ARGV;

    if (not defined $input_mp3 or not defined $tracklist){ 
        die "Usage: $0 <album.mp3> <timestamps.txt> [output_dir]\n";
    }

    $output_dir //= 'output';
    mkdir $output_dir unless -d $output_dir;
    
    # Read and parse the tracklist
    open my $fh, '<', $tracklist or die "Can't open $tracklist: $!";
    my @entries;

    while (<$fh>) {
        chomp;
        if (/^(\d{1,2}:\d{2}(?::\d{2})?)\s+(.*)$/) {
            my ($ts, $label) = ($1, $2);
            push @entries, { time => $ts, label => $label };
        } else {
            warn "Skipping unrecognized line: $_\n";
        }
    }
    close $fh;
    
    # Loop over entires. Call FFMPEG to create the MP3 files:
    for (my $i = 0; $i < @entries; $i++) {
        my $start = $entries[$i]{time};
        my $label = $entries[$i]{label};
        my $start_sec = to_seconds($start);

        my $duration = '';
        if ($i < $#entries) {
            my $end_sec = to_seconds($entries[$i+1]{time});
            $duration = $end_sec - $start_sec;
        }

        my $slug = slugify($label);
        my $track_num = sprintf("%02d", $i+1);
        my $output_file = "$output_dir/track_${track_num}_${slug}.mp3";

        my @cmd = (
            'ffmpeg', '-v', 'quiet', '-y',
            '-i', $input_mp3,
            '-ss', $start,
            ($duration > 0 ? ('-t', $duration) : ()),
            '-acodec', 'copy',
            $output_file
        );

        print "Exporting: $output_file\n";
        print join(" ", @cmd), "\n\n";

        system(@cmd) == 0 or warn "FFmpeg failed for $output_file\n";
    }

    print("Completed!\n");
}

main();

