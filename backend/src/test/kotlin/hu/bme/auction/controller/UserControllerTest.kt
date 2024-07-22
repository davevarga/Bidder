package hu.bme.auction.controller

import hu.bme.auction.dto.LoginUserDto
import hu.bme.auction.dto.RegisterUserDto
import org.junit.jupiter.api.Test
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.context.SpringBootTest
import org.springframework.http.HttpStatus
import org.springframework.test.context.TestPropertySource
import org.springframework.test.util.AssertionErrors.assertEquals

@SpringBootTest
@TestPropertySource(locations = ["classpath:application-test.properties"])
class UserControllerTest() {

    @Autowired
    private lateinit var userController: UserController

    @Test
    fun testRegisterAndLoginUser() {
        val u = RegisterUserDto()
        u.name = "Elek"
        u.email = "test@test.com"
        u.password = "password"
        u.fullName = "Elek Teszt"
        val responseEntity = userController.register(u)
        assertEquals("Problem with user reg",HttpStatus.OK, responseEntity.statusCode)
        val uL = LoginUserDto()
        uL.email = u.email!!
        uL.password = u.password!!
        val res2 = userController.login(uL)
        assertEquals("Problem with user login",HttpStatus.OK, res2.statusCode)
        uL.password = "wrong password"
        val res3 = userController.login(uL)
        assertEquals("Problem with user login",HttpStatus.BAD_REQUEST, res3.statusCode)
    }

    @Test
    fun testLoginUnsuccessful() {
        val uL = LoginUserDto()
        uL.email = "ilyen biztos nincs"
        uL.password = "ilyen biztos nincs"
        val res2 = userController.login(uL)
        assertEquals("Problem with unsuccessfull login", HttpStatus.BAD_REQUEST, res2.statusCode)
    }
}