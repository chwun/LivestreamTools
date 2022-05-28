<?php

// prevent caching
header('Expires: Sun, 01 Jan 2014 00:00:00 GMT');
header('Cache-Control: no-store, no-cache, must-revalidate');
header('Cache-Control: post-check=0, pre-check=0', FALSE);
header('Pragma: no-cache');

// read video id from file
$filename = "data/videoId.txt";
$linkFile = fopen($filename, "r") or exit();
$videoId = fgets($linkFile);

// build and check url
$url = "https://www.youtube.com/watch?v=" . $videoId;
$url = filter_var($url, FILTER_SANITIZE_URL);

if (!filter_var($url, FILTER_VALIDATE_URL)) {
    exit();
}

// set redirect header
$locationHeader = "Location: " . $url;
header($locationHeader);

exit();
