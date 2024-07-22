package hu.bme.auction.controller

import hu.bme.auction.entity.Category
import org.junit.jupiter.api.Test
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.context.SpringBootTest
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.test.context.TestPropertySource
import org.springframework.test.util.AssertionErrors.assertEquals

@SpringBootTest
@TestPropertySource(locations = ["classpath:application-test.properties"])
class CategoryControllerTest {
    @Autowired
    private lateinit var categoryController: CategoryController

    @Test
    fun testGetCategories() {
        categoryController.create(Category("Test"))
        val responseEntity2 : ResponseEntity<List<Category>> = categoryController.getAll()
        assertEquals("Error with getAll status",HttpStatus.OK, responseEntity2.statusCode)
    }

    @Test
    fun testCreateCategory() {
        val category = Category()
        category.name = "Test"
        val responseEntity: ResponseEntity<Category> = categoryController.create(category)
        assertEquals("Error with creation status",HttpStatus.CREATED, responseEntity.statusCode)
    }

    @Test
    fun testGetCategory() {
        val created = categoryController.create(Category("Test"))
        val responseEntity = categoryController.getOne(created.body!!.id!!)
        assertEquals("Error with getOne status",HttpStatus.OK, responseEntity.statusCode)
    }

    @Test
    fun testDeleteCategory() {
        val created = categoryController.create(Category("Test"))
        val responseEntity = categoryController.delete(created.body!!.id!!)
        assertEquals("Error with delete status",HttpStatus.OK, responseEntity.statusCode)
        val res2 = categoryController.delete(-1)
        assertEquals("Error with delete status",HttpStatus.NOT_FOUND, res2.statusCode)
    }

    @Test
    fun testUpdateCategory() {
        val responseEntity = categoryController.update(-1, Category("NewTest"))
        assertEquals("Error with update status",HttpStatus.NOT_FOUND, responseEntity.statusCode)
        val created = categoryController.create(Category("Test"))
        val responseEntity2 = categoryController.update(created.body!!.id!!, Category("NewTest"))
        assertEquals("Error with update status",HttpStatus.OK, responseEntity2.statusCode)
    }
}