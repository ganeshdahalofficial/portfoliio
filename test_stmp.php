<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);

// Test basic PHP
echo "PHP is working<br>";

// Test file permissions
echo "File permissions OK<br>";

// Test SMTP connection
$smtp = 'smtp.gmail.com';
$port = 587;

$connection = @fsockopen($smtp, $port, $errno, $errstr, 10);
if ($connection) {
    echo "SMTP connection to $smtp:$port SUCCESS<br>";
    fclose($connection);
} else {
    echo "SMTP connection FAILED: $errstr ($errno)<br>";
}

// Test if we can resolve DNS
if (gethostbyname($smtp) !== $smtp) {
    echo "DNS resolution OK<br>";
} else {
    echo "DNS resolution FAILED<br>";
}
?>