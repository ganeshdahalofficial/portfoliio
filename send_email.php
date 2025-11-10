<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);

use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\SMTP;
use PHPMailer\PHPMailer\Exception;

require './phpmailer/Exception.php';
require './phpmailer/PHPMailer.php';
require './phpmailer/SMTP.php';

// Load environment variables
$dotenv = parse_ini_file('.env');

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    // Get form data
    $name = htmlspecialchars($_POST['name']);
    $email = htmlspecialchars($_POST['email']);
    $subject = htmlspecialchars($_POST['subject']);
    $message = htmlspecialchars($_POST['message']);
    
    try {
        $mail = new PHPMailer(true);
        
        // Server settings - USING ENVIRONMENT VARIABLES
        $mail->isSMTP();
        $mail->Host = $dotenv['SMTP_HOST'] ?? 'smtp.gmail.com';
        $mail->SMTPAuth = true;
        $mail->Username = $dotenv['SMTP_USERNAME'] ?? '';
        $mail->Password = $dotenv['SMTP_PASSWORD'] ?? '';
        $mail->SMTPSecure = $dotenv['SMTP_ENCRYPTION'] ?? PHPMailer::ENCRYPTION_STARTTLS;
        $mail->Port = $dotenv['SMTP_PORT'] ?? 587;
        
        // Validate required environment variables
        if (empty($dotenv['SMTP_USERNAME']) || empty($dotenv['SMTP_PASSWORD'])) {
            throw new Exception('SMTP configuration not set');
        }
        
        // Recipients
        $mail->setFrom($dotenv['SMTP_FROM_EMAIL'] ?? 'hello@portfolio.com', $dotenv['SMTP_FROM_NAME'] ?? 'Portfolio Contact');
        $mail->addAddress($dotenv['SMTP_TO_EMAIL'] ?? 'ganeshdahal201@gmail.com');
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
        error_log("Mailer Error: " . $e->getMessage());
        echo json_encode(['status' => 'error', 'message' => 'Message could not be sent. Please try again later.']);
    }
} else {
    echo json_encode(['status' => 'error', 'message' => 'Invalid request method.']);
}
?>