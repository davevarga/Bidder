package hu.bme.auction.service

import hu.bme.auction.dao.BidRepository
import hu.bme.auction.dao.ItemRepository
import hu.bme.auction.dao.UserRepository
import hu.bme.auction.dto.CreateBidDto
import hu.bme.auction.entity.Bid
import org.springframework.data.repository.findByIdOrNull
import org.springframework.stereotype.Service

@Service
class BidService(
    val bidRepository: BidRepository,
    val itemRepository: ItemRepository,
    val emailSenderService: EmailSenderService,
    private val userRepository: UserRepository
) {
    /*
        * Get all bids from the database
        * @return List<Bid> of all bids
     */
    fun getAll(): List<Bid> {
        val bids = bidRepository.findAll()
        bids.forEach {
            it.item?.bids = mutableSetOf()
            it.user?.bids = mutableSetOf()
            it.user?.items = mutableSetOf()
            it.item?.user = null
            it.item?.category?.items = mutableSetOf()
        }
        return bids
    }

    /*
        * Get one bid with the given id
        * @param id of the bid to get
        * @return Bid or null if the bid does not exist
     */
    fun getOne(id: Long): Bid? {
        return bidRepository.findByIdOrNull(id)
    }

    /*
        * Create a bid with the given bid
        * @param bid to create
        * @return Bid or null if the item or user does not exist
     */
    fun create(bid: CreateBidDto): Bid {
        val item = itemRepository.findByIdOrNull(bid.itemId) ?: throw IllegalArgumentException("Item not found")
        if(item.startingBid >= bid.amount) throw IllegalArgumentException("Bid amount must be greater than the starting bid")
        item.bids.forEach { if (it.amount!! >= bid.amount) throw IllegalArgumentException("Bid amount must be greater than the current highest bid") }
        val user = userRepository.findByIdOrNull(bid.userId) ?: throw IllegalArgumentException("User not found")

        val newBid = Bid()
        newBid.amount = bid.amount
        newBid.item = item
        newBid.user = user

        item.watchlists.forEach {
            emailSenderService.sendEmailForNewBid(item.title!!, bid.amount, it.user!!.email!!)
        }

        val cBid = bidRepository.save(newBid)
        cBid.item?.bids = mutableSetOf()
        cBid.user?.bids = mutableSetOf()
        cBid.user?.items = mutableSetOf()
        cBid.user?.watchlists = mutableSetOf()
        cBid.item?.user = null
        cBid.item?.category?.items = mutableSetOf()
        return cBid
    }

    /*
        * Update a bid with the given id
        * @param id of the bid to update
        * @param bid to update
        * @return Bid or null if the bid does not exist
     */
    fun update(id: Long, bid: Bid): Bid? {
        val newBid = bidRepository.findByIdOrNull(id) ?: return null
        bid.amount?.let { newBid.amount = it }
        bid.user?.let { newBid.user = it }
        bid.item?.let { newBid.item = it }
        return bidRepository.save(newBid)
    }

    /*
        * Delete a bid with the given id
        * @param id of the bid to delete
     */
    fun delete(id: Long) {
        return bidRepository.deleteById(id)
    }
}