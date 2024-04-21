
# Define the sender, recipient, subject, and body of the email
$senderEmail = "radhikan@epiqinfo.com"
$senderPassword = "EPIQrad#28"
$recipientEmail = "tejasa@epiqinfo.com,radhikan@epiqinfo.com"
#$subject = "Test Email"
$subject = $args[0]
#$body = "This is a test email sent using PowerShell."
$body = $args[1], $args[2]

# Create a SMTP client object and specify Gmail's SMTP server details
$smtpServer = "smtp-mail.outlook.com"
$smtpPort = 587
$smtp = New-Object System.Net.Mail.SmtpClient($smtpServer, $smtpPort)
$smtp.EnableSsl = $true
$smtp.Credentials = New-Object System.Net.NetworkCredential($senderEmail, $senderPassword)

# Create a new email message
$mailMessage = New-Object System.Net.Mail.MailMessage
$mailMessage.From = $senderEmail
$mailMessage.To.Add($recipientEmail)
$mailMessage.Subject = $subject
$mailMessage.Body = $body
#$mailMessage.Body = $args[0]

# Send the email
$smtp.Send($mailMessage)

# Clean up
$mailMessage.Dispose()
$smtp.Dispose()

