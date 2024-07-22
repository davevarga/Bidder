package hu.bme.auction.controller

import hu.bme.auction.dao.CategoryRepository
import hu.bme.auction.dao.UserRepository
import hu.bme.auction.dto.CreateItemDto
import hu.bme.auction.entity.Category
import hu.bme.auction.entity.User
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.Test
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.context.SpringBootTest
import org.springframework.http.HttpStatus
import org.springframework.test.context.TestPropertySource
import org.springframework.test.util.AssertionErrors.assertEquals

@SpringBootTest
@TestPropertySource(locations = ["classpath:application-test.properties"])
class ItemControllerTest() {
    @Autowired private lateinit var itemController: ItemController
    @Autowired private lateinit var userRepository: UserRepository
    @Autowired private lateinit var categoryRepository: CategoryRepository

    private lateinit var user: User
    private lateinit var cat: Category
    @BeforeEach
    fun setUp() {
        val u = User()
        u.name = "Test user"
        u.salt = "Test salt"
        u.password = "Test password"
        u.id = 1
        u.fullName = "Test full name"
        u.email = "t@t.h"
        user = userRepository.save(u)
        val c = Category()
        c.name = "Test"
        cat = categoryRepository.save(c)
    }
    @Test
    fun testGetItems() {
        val responseEntity = itemController.getAll()
        assertEquals("Problem with get items",HttpStatus.NOT_FOUND, responseEntity.statusCode)
    }
    @Test
    fun testCreateItem() {
        val i = CreateItemDto()
        i.title = "Test item2"
        i.startingBid = 100
        i.userId = user.id!!
        i.categoryName = "Teest"
        val responseEntity = itemController.create(i)
        assertEquals("Problem with create an item",HttpStatus.OK, responseEntity.statusCode)
    }

    @Test
    fun testGetItem() {
        val responseEntity = itemController.getOne(-1)
        assertEquals("Problem with get one item", HttpStatus.NOT_FOUND, responseEntity.statusCode)
        val i = CreateItemDto()
        i.title = "Test item2"
        i.startingBid = 100
        i.userId = user.id!!
        i.categoryName = "Teest"
        val item = itemController.create(i)
        val responseEntity2 = itemController.getOne(item.body!!.id)
        assertEquals("Problem with get one item", HttpStatus.OK, responseEntity2.statusCode)
    }

    @Test
    fun testDeleteItem() {
        val responseEntity = itemController.delete(-1)
        assertEquals("Problem with delete item", HttpStatus.OK, responseEntity.statusCode)
    }
}