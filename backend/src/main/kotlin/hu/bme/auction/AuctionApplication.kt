package hu.bme.auction

import hu.bme.auction.dao.CategoryRepository
import hu.bme.auction.entity.Category
import jakarta.annotation.PostConstruct
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.runApplication
import org.springframework.scheduling.annotation.EnableScheduling

@SpringBootApplication
@EnableScheduling
class AuctionApplication {
	@Autowired private lateinit var categoryRepository: CategoryRepository
	private val logger = LoggerFactory.getLogger(javaClass)
	@PostConstruct
	fun testComponents() {
		val cat = Category("Ruha")
		categoryRepository.save(cat)

		val readCat = categoryRepository.findByName("Ruha")
		assert(readCat != null && readCat.name == cat.name)


		logger.info("Application started and start tests run successfull")
		assert(logger.isInfoEnabled)
	}

}
fun main(args: Array<String>) {
	runApplication<AuctionApplication>(*args)
}