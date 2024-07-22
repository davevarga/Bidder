package hu.bme.auction.entity

import jakarta.persistence.*

@Entity
@Table(name = "watchlists")
open class Watchlist() {
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE)
    @Column(name = "id", nullable = false)
    open var id: Long? = null

    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false)
    open var user: User? = null

    @ManyToOne
    @JoinColumn(name = "item_id", nullable = false)
    open var item: Item? = null



//    constructor(user: User, item: Item) : this() {
//        this.user = user
//        this.item = item
//    }
}