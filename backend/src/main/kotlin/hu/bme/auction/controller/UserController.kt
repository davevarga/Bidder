package hu.bme.auction.controller

import hu.bme.auction.dto.LoginUserDto
import hu.bme.auction.dto.RegisterUserDto
import hu.bme.auction.entity.User
import hu.bme.auction.service.UserService
import org.slf4j.LoggerFactory
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController

@RestController
@RequestMapping("/user")
class UserController(private val userService: UserService) {
    private val log = LoggerFactory.getLogger(javaClass)
    @PostMapping("/login")
    fun login(@RequestBody u: LoginUserDto): ResponseEntity<User>{
        val user: User? = userService.loginUser(u)
        if(user == null){
            log.debug("User login failed with email: ${u.email}")
            return ResponseEntity.badRequest().build()
        }
        log.info("User registered with email: ${user.email}")
        return ResponseEntity.ok(user)
    }

    @PostMapping("/register")
    fun register(@RequestBody u: RegisterUserDto): ResponseEntity<User>{
        val user = userService.registerUser(u)
        log.info("User logged in with email: ${user.email}")
        return ResponseEntity.ok(user)
    }

}