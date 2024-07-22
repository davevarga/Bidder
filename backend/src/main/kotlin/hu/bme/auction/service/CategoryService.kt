package hu.bme.auction.service

import hu.bme.auction.dao.CategoryRepository
import hu.bme.auction.entity.Category
import org.springframework.data.repository.findByIdOrNull
import org.springframework.stereotype.Service

@Service
class CategoryService(val categoryRepository: CategoryRepository) {

    /*
        * Get all categories from the database
        * @return List<Category> of all categories
     */
    fun getAll(): List<Category> {
        val cats = categoryRepository.findAll()
        cats.forEach{ cat ->
            cat.items= mutableSetOf()
        }
        return cats
    }

    /*
        * Get one category with the given id
        * @param id of the category to get
        * @return Category or null if the category does not exist
     */
    fun getOne(id: Long): Category? {
        return categoryRepository.findByIdOrNull(id)
    }

    /*
        * Create a category with the given category
        * @param category to create
        * @return Category
     */
    fun create(category: Category): Category {
        return categoryRepository.save(category)
    }

    /*
        * Update a category with the given id and category
        * @param id of the category to update
        * @param category to update
        * @return Category or null if the category does not exist
     */
    fun update(id: Long, cat: Category): Category? {
        val newCat = categoryRepository.findByIdOrNull(id) ?: return null
        cat.name?.let { newCat.name = it }
        return categoryRepository.save(newCat)
    }

    /*
        * Delete a category with the given id
        * @param id of the category to delete
     */
    fun delete(id: Long) {
        return categoryRepository.deleteById(id)
    }

    /*
        * Get a category by name or create a new one
        * @param name of the category to get or create
        * @return Category or null if the category does not exist
     */
    fun getByNameOrCreate(name: String): Category? {
        val cat = categoryRepository.findByName(name)
        return cat ?: categoryRepository.save(Category(name = name))
    }
}