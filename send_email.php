<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);

use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\SMTP;
use PHPMailer\PHPMailer\Exception;

// FIXED PATHS - remove the /src/ part
require './phpmailer/Exception.php';
require './phpmailer/PHPMailer.php';
require './phpmailer/SMTP.php';

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    // Get form data
    $name = htmlspecialchars($_POST['name']);
    $email = htmlspecialchars($_POST['email']);
    $subject = htmlspecialchars($_POST['subject']);
    $message = htmlspecialchars($_POST['message']);
    
    try {
        $mail = new PHPMailer(true);
        
        // Server settings
        $mail->isSMTP();
        $mail->Host = 'smtp.gmail.com';
        $mail->SMTPAuth = true;
        $mail->Username = 'dahalbro200@gmail.com';
        $mail->Password = 'gntdpoznbcuyspkr';
        $mail->SMTPSecure = PHPMailer::ENCRYPTION_STARTTLS;
        $mail->Port = 587;
        
        // Recipients
        $mail->setFrom('hello@portfolio.com', 'Portfolio Contact');
        $mail->addAddress('ganeshdahal201@gmail.com');
        $mail->addReplyTo($email, $name);
        
        // Content
        $mail->isHTML(true);
        $mail->Subject = "Portfolio Contact: " . $subject;
        $mail->Body = "
            <h3>New Contact Form Submission</h3>
            <p><strong>Name:</strong> {$name}</p>
            <p><strong>Email:</strong> {$email}</p>
            <p><strong>Subject:</strong> {$subject}</p>
            <p><strong>Message:</strong></p>
            <p>{$message}</p>
        ";
        
        $mail->send();
        echo json_encode(['status' => 'success', 'message' => 'Message sent successfully!']);
        
    } catch (Exception $e) {
        echo json_encode(['status' => 'error', 'message' => 'Message could not be sent. Please try again later.']);
    }
} else {
    echo json_encode(['status' => 'error', 'message' => 'Invalid request method.']);
}
?>