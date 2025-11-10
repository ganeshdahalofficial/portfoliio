<?php
use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\SMTP;
use PHPMailer\PHPMailer\Exception;

require 'phpmailer/Exception.php';
require 'phpmailer/PHPMailer.php';
require 'phpmailer/SMTP.php';

$mail = new PHPMailer(true);

try {
    $mail->SMTPDebug = SMTP::DEBUG_SERVER;
    $mail->isSMTP();
    $mail->Host = 'smtp.gmail.com';
    $mail->SMTPAuth = true;
    $mail->Username = 'dahalbro200@gmail.com';
    $mail->Password = 'gntdpoznbcuyspkr';
    $mail->SMTPSecure = PHPMailer::ENCRYPTION_STARTTLS;
    $mail->Port = 587;
    
    $mail->setFrom('dahalbro200@gmail.com', 'Test');
    $mail->addAddress('ganeshdahal200@gmail.com');
    $mail->Subject = 'Test Email';
    $mail->Body = 'This is a test email';
    
    $mail->send();
    echo 'Email sent successfully';
} catch (Exception $e) {
    echo "Error: {$mail->ErrorInfo}";
}
?>