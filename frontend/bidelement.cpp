#include "BidElement.h"

BidElement::BidElement(QObject *parent)
{}

BidElement::BidElement(QString supplier, QObject *parent)
{
    m_supplier = supplier;
}

// Property getters
int BidElement::itemIndex() const{return m_itemIndex;}
QString BidElement::subject() const{return m_subject;}
QString BidElement::supplier() {return m_supplier;}
double BidElement::price() const{return m_price;}
QString BidElement::highestBidder() {return m_highestBidder;}

// Property setters
void BidElement::setSubject(const QString newSubject){m_subject = newSubject;}
void BidElement::setSupplier(const QString newSupplyer){m_supplier = newSupplyer;}

/* Validity of price change is analized on the backend, because there can be
 simultanious price changes, and admins can set price to be lower */
void BidElement::setPrice(double newPrice)
{
    m_price = newPrice;
    emit priceChanged();
}

/* Highest bidder changes only if the price changes. This is also handled
 * and validated by backend.*/
void BidElement::setHighestBidder(const QString newHighestBidder)
{
    m_highestBidder = newHighestBidder;
    emit highestBidderChanged();
}

/**/
QString BidElement::category() const
{
    return m_category;
}

void BidElement::setCategory(const QString &newCategory)
{
    m_category = newCategory;
    emit categoryChanged();
}

/* S upplier name changed. User object invokes it when it's name changess
 * Normal fuction does not define item change usage, only admin can will use it. */
void BidElement::setItemIndex(int newItemIndex)
{
    m_itemIndex = newItemIndex;
    emit itemIndexChanged();
}
