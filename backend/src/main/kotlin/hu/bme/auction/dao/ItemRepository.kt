package hu.bme.auction.dao

import hu.bme.auction.entity.Item
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository

@Repository
interface ItemRepository : JpaRepository<Item, Long>{
    fun findByCategoryId(categoryId: Long): List<Item>

    fun findWithBidsAndWatchlistsById(id: Long): Item?

}