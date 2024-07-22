package hu.bme.auction.entity

import jakarta.persistence.*
import jakarta.validation.constraints.Positive
import java.time.OffsetDateTime

@Entity
@Table(name = "bids")
open class Bid {
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE)
    @Column(name = "id", nullable = false)
    open var id: Long? = null

    @Column(name = "issued_at", nullable = false)
    open var issuedAt: OffsetDateTime = OffsetDateTime.now()

    @Column(name = "amount", nullable = false)
    @Positive(message = "Amount must be positive")
    open var amount: Int? = null

    @ManyToOne(optional = false)
    @JoinColumn(name = "user_id", nullable = false)
    open var user: User? = null

    @ManyToOne(optional = false)
    @JoinColumn(name = "item_id", nullable = false)
    open var item: Item? = null
}