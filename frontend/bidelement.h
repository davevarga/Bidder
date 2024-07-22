#ifndef BIDELEMENT_H
#define BIDELEMENT_H

#include <QObject>

class User;

class BidElement : public QObject
{
    Q_OBJECT

    // Item id in the database
    Q_PROPERTY(int itemIndex READ itemIndex WRITE setItemIndex NOTIFY itemIndexChanged)
    Q_PROPERTY(QString subject READ subject WRITE setSubject NOTIFY subjectChanged)
    Q_PROPERTY(QString supplier READ supplier WRITE setSupplier NOTIFY supplierChanged)
    Q_PROPERTY(double price READ price WRITE setPrice NOTIFY priceChanged)
    Q_PROPERTY(QString highestBidder READ highestBidder WRITE setHighestBidder NOTIFY highestBidderChanged)
    Q_PROPERTY(QString category READ category WRITE setCategory NOTIFY categoryChanged)

public:
    explicit BidElement(QObject *parent = nullptr);

    // Bid elements always have a supplier.
    BidElement(QString supplier, QObject *parent = nullptr);

    // Used for recognize the element on the backend.
    int itemIndex() const;
    void setItemIndex(int newItemIndex);

    // The main title of the bid element
    QString subject() const;
    void setSubject(const QString newSubject);

    // Name of user who published the bid
    QString supplier();
    void setSupplier(const QString newSupplier);

    // Current price of the bid
    double price() const;
    void setPrice(double newPrice);

    // the user name of the highest bidder
    QString highestBidder();
    void setHighestBidder(const QString newHighestBidder);

    QString category() const;
    void setCategory(const QString &newCategory);

public slots:
    //void changeItemPrice(const QString& newBidder, const double& newPrice);
    //void supplierNameChanged(const QString& newName);

signals:
    // Basic signals created by Q_PROPERTY
    void itemIndexChanged();
    void subjectChanged();
    void supplierChanged();
    void priceChanged();
    void highestBidderChanged();

    void categoryChanged();

protected:
    // Data references of class properties
    int m_itemIndex;
    QString m_subject;
    QString m_supplier;
    double m_price;
    QString m_highestBidder;

private:
    QString m_category;
};

#endif // BIDELEMENT_H
