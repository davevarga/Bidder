package hu.bme.auction.controller

import hu.bme.auction.dao.CategoryRepository
import hu.bme.auction.dao.ItemRepository
import hu.bme.auction.dao.UserRepository
import hu.bme.auction.entity.Item
import hu.bme.auction.entity.User
import hu.bme.auction.service.UserService
import org.junit.jupiter.api.Assertions
import org.junit.jupiter.api.Test
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.context.SpringBootTest
import org.springframework.http.HttpStatus
import org.springframework.test.context.TestPropertySource

@SpringBootTest
@TestPropertySource(locations = ["classpath:application-test.properties"])
class BidControllerTest() {

    @Autowired
    private lateinit var userService: UserService

    @Autowired
    private lateinit var itemRepository: ItemRepository

    @Autowired
    private lateinit var categoryRepository: CategoryRepository

    @Autowired
    private lateinit var userRepository: UserRepository

    @Autowired
    private lateinit var bidController: BidController

    private lateinit var user: User
    private lateinit var item: Item

//    @BeforeEach
//    fun setUp() {
//        val u = User()
//        u.name = "Test user"
//        u.salt = "Test salt"
//        u.password = "Test password"
//        u.id = 1
//        u.fullName = "Test full name"
//        u.email = "t@t.h"
//        user = userRepository.save(u)
//
//        val c = Category()
//        c.name = "Test52"
//        val cat = categoryRepository.save(c)
//
//        val i = Item()
//        i.title = "Test"
//        i.category = cat
//        i.startingBid = 100
//        i.user = user
//        item = itemRepository.save(i)
//    }

    @Test
    fun testCreateBid() {
        val responseEntity = bidController.getAll()
        Assertions.assertEquals(HttpStatus.NOT_FOUND, responseEntity.statusCode)
    }
}