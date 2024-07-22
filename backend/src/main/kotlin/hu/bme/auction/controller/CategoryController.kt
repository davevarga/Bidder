package hu.bme.auction.controller

import hu.bme.auction.entity.Category
import hu.bme.auction.service.CategoryService
import org.slf4j.LoggerFactory
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping("/category")
class CategoryController(val categoryService: CategoryService) {
    private val log = LoggerFactory.getLogger(javaClass)
    @GetMapping()
    fun getAll(): ResponseEntity<List<Category>> {
        val lista: List<Category> = categoryService.getAll()
        if (lista.isEmpty()) {
            return ResponseEntity(HttpStatus.NOT_FOUND)
        }
        return ResponseEntity.ok(lista)
    }

    @GetMapping("/{id}")
    fun getOne(@PathVariable id: Long): ResponseEntity<Category> {
        val cat: Category = categoryService.getOne(id) ?: return ResponseEntity(HttpStatus.NOT_FOUND)
        return ResponseEntity.ok(cat)
    }

    @PostMapping()
    fun create(@RequestBody cat: Category): ResponseEntity<Category> {
        log.info("Category created: $cat")
        return ResponseEntity(categoryService.create(cat), HttpStatus.CREATED)
    }

    @PutMapping("/{id}")
    fun update(@PathVariable id: Long, @RequestBody cat: Category): ResponseEntity<Category> {
        val newCat = categoryService.update(id, cat) ?: return ResponseEntity(HttpStatus.NOT_FOUND)
        log.info("Category updated: $newCat")
        newCat.items = mutableSetOf()
        return ResponseEntity.ok(newCat)
    }

    @DeleteMapping("/{id}")
    fun delete(@PathVariable id: Long): ResponseEntity<Unit> {
        categoryService.getOne(id) ?: return ResponseEntity(HttpStatus.NOT_FOUND)
        log.info("Category deleted: $id")
        return ResponseEntity.ok(categoryService.delete(id))
    }
}