package hu.bme.auction.service

import org.springframework.mail.SimpleMailMessage
import org.springframework.mail.javamail.JavaMailSender
import org.springframework.stereotype.Service

@Service
class EmailSenderService(private val emailSender: JavaMailSender, private val template: SimpleMailMessage){
    /*
        * Send an email with the given subject and text to the target email
        * @param subject of the email
        * @param text of the email
        * @param targetEmail to send the email to
     */
    fun sendEmail(subject: String,text: String,targetEmail: String) {
        val message = SimpleMailMessage()
        message.subject = subject
        message.text = text
        message.setTo(targetEmail)

        emailSender.send(message)
    }

    /*
        * Send an email with the given name to the target email using the template
        * @param name to use in the template
        * @param targetEmail to send the email to
     */
    fun sendEmailUsingTemplate(name: String,targetEmail: String) {
        val message = SimpleMailMessage(template)
        val text = template.text
        message.text = text!!.format(name)
        message.setTo(targetEmail)
        emailSender.send(message)
    }

    /*
        * Send an email for a new bid on an item
        * @param itemName of the item
        * @param currentPrise of the item
        * @param targetEmail to send the email to
     */
    fun sendEmailForNewBid(itemName: String, currentPrise: Int, targetEmail: String) {
        val message = SimpleMailMessage()
        message.subject = "New bid on $itemName"
        message.text = """
            Hello, 
            There is a new bid on $itemName. The current price is $currentPrise.
        """.trimIndent()
        message.setTo(targetEmail)
        emailSender.send(message)
    }
}