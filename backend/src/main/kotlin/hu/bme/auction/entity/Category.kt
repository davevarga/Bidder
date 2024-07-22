package hu.bme.auction.entity

import jakarta.persistence.*
import jakarta.validation.constraints.NotNull

@Entity
@Table(name = "categories")
open class Category() {
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE)
    @Column(name = "id", nullable = false)
    open var id: Long? = null

    @Column(name = "name", nullable = false)
    @NotNull(message = "Name is required")
    open var name: String? = null

    @OneToMany(mappedBy = "category", cascade = [CascadeType.ALL], orphanRemoval = true)
    open var items: MutableSet<Item> = mutableSetOf()

    constructor( name: String?) : this() {
        this.name = name
    }
}