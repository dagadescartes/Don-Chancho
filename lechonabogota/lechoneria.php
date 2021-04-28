<?php


require("class.phpmailer.php");
require("class.smtp.php");

// Valores enviados desde el formulario
if ( !isset($_POST["Name"]) ||  !isset($_POST["Email"])  ||  !isset($_POST["Message"]) ) {
    die ("Es necesario completar todos los datos del formulario");
}
$nombre = $_POST["Name"];$telefono = $_POST["Phone"];
$correo = $_POST["Email"];
$mensaje = $_POST["Message"];
$destinatario = "elmarranitotolimense@gmail.com";
// Datos de la cuenta de correo utilizada para enviar vía SMTP
$smtpHost = "smtp.gmail.com";  // Dominio alternativo brindado en el email de alta 
$smtpUsuario = "elmarranitotolimense@gmail.com";  // Mi cuenta de correo
$smtpClave = "Marranito2020";  // Mi contraseña




$mail = new PHPMailer();
$mail->IsSMTP();
$mail->SMTPAuth = true;
$mail->Port = 587; 
$mail->IsHTML(true); 
$mail->CharSet = "utf-8";

// VALORES A MODIFICAR //
$mail->Host = $smtpHost; 
$mail->Username = $smtpUsuario; 
$mail->Password = $smtpClave;


$mail->From = $email; // Email desde donde envío el correo.
$mail->FromName = $nombre;
$mail->AddAddress($destinatario); // Esta es la dirección a donde enviamos los datos del formulario

$mail->Subject = "Cotización Página Lechonería El Marranito"; // Este es el titulo del email.
$mensajeHtml = nl2br($mensaje);
$mail->Body = "
<html> 


<body> 

<h1>Nueva Cotización desde el formulario de contacto Lechonería El Marranito</h1>

<p>Esta es la Informacion enviada por el usuario de Lechonería El Marranito:</p>

<p>Nombre: {$nombre}</p>
<p>Correo: {$correo}</p><p>Telèfono: {$telefono}</p>
<p>>Mensaje: {$mensaje}</p>

</body> 

</html>

<br />"; // Texto del email en formato HTML
$mail->AltBody = "{$mensaje} \n\n "; // Texto sin formato HTML
// FIN - VALORES A MODIFICAR //

$mail->SMTPOptions = array(
    'ssl' => array(
        'verify_peer' => false,
        'verify_peer_name' => false,
        'allow_self_signed' => true
    )
);

$estadoEnvio = $mail->Send(); 
if($estadoEnvio){
    header("location:../../index.html");
} else {
    echo "Ocurrió un error inesperado.";
}







?>

