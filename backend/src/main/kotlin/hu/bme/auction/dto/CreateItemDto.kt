package hu.bme.auction.dto

class CreateItemDto {
    var title: String? = null
//    var quality:  = null
    var payed: Boolean = false
    var startingBid: Int = 0
    var userId: Long = 0
    lateinit var categoryName: String
}