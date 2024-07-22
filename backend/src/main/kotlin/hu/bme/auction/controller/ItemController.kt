package hu.bme.auction.controller

import hu.bme.auction.dto.CreateItemDto
import hu.bme.auction.dto.ItemWithDetailsDto
import hu.bme.auction.entity.Item
import hu.bme.auction.service.ItemService
import org.slf4j.LoggerFactory
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping("/item")
class ItemController(val itemService: ItemService) {
    private val log = LoggerFactory.getLogger(javaClass)
    @GetMapping()
    fun getAll(): ResponseEntity<List<ItemWithDetailsDto>> {
        val items: List<Item> = itemService.getAll()
        if (items.isEmpty()) {
            return ResponseEntity(HttpStatus.NOT_FOUND)
        }
        val finalItems: List<ItemWithDetailsDto> = items.map {
            val itemWithDetailsDto = ItemWithDetailsDto()
            itemWithDetailsDto.id = it.id ?: 0
            itemWithDetailsDto.name = it.title ?: "No name"
            itemWithDetailsDto.ownerId = it.user?.id ?: 0
            itemWithDetailsDto.ownerName = it.user?.name ?: "No owner"
            itemWithDetailsDto.highestBid = it.bids.maxByOrNull { i -> i.amount?:0 }?.amount ?: it.startingBid
            itemWithDetailsDto.highestBidderName = it.bids.maxByOrNull { i-> i.amount?:0 }?.user?.name ?: it.user?.name ?: "No owner"
            itemWithDetailsDto.category = it.category?.name ?: "No category"
            itemWithDetailsDto
        }
        return ResponseEntity.ok(finalItems)
    }

    @GetMapping("/{id}")
    fun getOne(@PathVariable id: Long): ResponseEntity<Item> {
        val item: Item = itemService.getOne(id) ?: return ResponseEntity(HttpStatus.NOT_FOUND)
        item.user?.items = mutableSetOf()
        item.category?.items = mutableSetOf()
        return ResponseEntity.ok(item)
    }

    @PostMapping()
    fun create(@RequestBody i: CreateItemDto): ResponseEntity<ItemWithDetailsDto> {
        val cI = itemService.create(i)
        log.info("Item created: $cI")
        val itemWithDetailsDto = ItemWithDetailsDto()
        itemWithDetailsDto.id = cI.id ?: 0
        itemWithDetailsDto.name = cI.title ?: "No name"
        itemWithDetailsDto.ownerId = cI.user?.id ?: 0
        itemWithDetailsDto.ownerName = cI.user?.name ?: "No owner"
        itemWithDetailsDto.highestBid = cI.startingBid
        itemWithDetailsDto.highestBidderName = cI.user?.name ?: "No owner"
        itemWithDetailsDto.category = cI.category?.name ?: "No category"
        return ResponseEntity.ok(itemWithDetailsDto)
    }

    @PutMapping("/{id}")
    fun update(@PathVariable id: Long, @RequestBody item: Item): ResponseEntity<Item> {
        val newItem = itemService.update(id, item) ?: return ResponseEntity(HttpStatus.NOT_FOUND)
        log.info("Item updated: $newItem")
        return ResponseEntity.ok(newItem)
    }

    @DeleteMapping("/{id}")
    fun delete(@PathVariable id: Long):ResponseEntity<Unit>{
        log.info("Item deleted: $id")
        itemService.delete(id)
        return ResponseEntity.ok().build()
    }

    @GetMapping("/{itemId}/subscribe/{userId}")
    fun subscribeWatchlist(@PathVariable itemId: Long, @PathVariable userId: Long) {
        val subsribed = itemService.subscribeWatchlist(itemId, userId)
        if (subsribed == 1) log.info("User $userId subscribed to item $itemId")
        else if(subsribed == 2) log.info("User $userId unsubscribed from item $itemId")
    }
}