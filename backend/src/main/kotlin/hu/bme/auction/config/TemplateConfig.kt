package hu.bme.auction.config

import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration
import org.springframework.mail.SimpleMailMessage

@Configuration
class TemplateConfig {
    @Bean
    fun exampleNewsletterTemplate(): SimpleMailMessage {
        val template = SimpleMailMessage()
        template.subject = "Newsletter"
        template.text = """
                Hello %s, 
                
                This is an example newsletter message
            """.trimIndent()
        return template
    }
}