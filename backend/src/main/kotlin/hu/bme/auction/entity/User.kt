package hu.bme.auction.entity

import jakarta.persistence.*
import jakarta.validation.constraints.Email
import jakarta.validation.constraints.NotNull

@Entity
@Table(name = "users")
open class User {
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE)
    @Column(name = "id")
    open var id: Long? = null

    @Column(name = "name", nullable = false)
    @NotNull(message="Name must be provided")
    open var name: String? = null

    @Column(name = "full_name", nullable = false)
    @NotNull
    open var fullName: String? = null

    @Column(name = "email", nullable = false, unique = true)
    @Email(message = "Email must be valid")
    open var email: String? = null

    @Column(name = "salt")
    open var salt: String? = null

    @Column(name = "password")
    open var password: String? = null

    @Enumerated
    @Column(name = "role")
    open var role: Role = Role.USER

    @OneToMany(mappedBy = "user", cascade = [CascadeType.ALL], orphanRemoval = true)
    open var items: MutableSet<Item> = mutableSetOf()

    @OneToMany(mappedBy = "user", cascade = [CascadeType.ALL], orphanRemoval = true)
    open var bids: MutableSet<Bid> = mutableSetOf()

    @OneToMany(mappedBy = "user", cascade = [CascadeType.ALL], orphanRemoval = true)
    open var watchlists: MutableSet<Watchlist> = mutableSetOf()
}

enum class Role {
    ADMIN, MODERATOR, USER
}