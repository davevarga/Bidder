package hu.bme.auction.entity

import jakarta.persistence.*
import jakarta.validation.constraints.NotNull

@Entity
@Table(name = "items")
open class Item {
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE)
    @Column(name = "id", nullable = false)
    open var id: Long? = null

    @Column(name = "title", nullable = false)
    @NotNull
    open var title: String? = null

    @Enumerated
    @Column(name = "quality", nullable = false)
    open var quality: Quality = Quality.NEW

    @Column(name = "payed", nullable = false)
    open var payed: Boolean = false

    @Column(name = "starting_bid", nullable = false)
    open var startingBid: Int = 0

    @ManyToOne(optional = false)
    @JoinColumn(name = "user_id", nullable = false)
    open var user: User? = null

    @OneToMany(cascade = [CascadeType.ALL], mappedBy = "item", orphanRemoval = true)
    open var bids: MutableSet<Bid> = mutableSetOf()

    @ManyToOne
    @JoinColumn(name = "category_id")
    @NotNull
    open var category: Category? = null

    @OneToMany(mappedBy = "item", cascade = [CascadeType.ALL], orphanRemoval = true)
    open var watchlists: MutableSet<Watchlist> = mutableSetOf()
}

enum class Quality {
    NEW, LIKENEW, USED
}