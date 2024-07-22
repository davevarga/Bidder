package hu.bme.auction.dto

class ItemWithDetailsDto {
    var id: Long = 0
    lateinit var name: String
    var ownerId:Long = 0
    lateinit var ownerName: String
    var highestBid: Int =0
    lateinit var highestBidderName: String
    lateinit var category: String
}