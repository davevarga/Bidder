#ifndef BIDSLIST_H
#define BIDSLIST_H

#include <QObject>
#include <QAbstractListModel>
#include <QQmlEngine>
#include <QNetworkReply>

#include "BidElement.h"

namespace {
    const QString &itemsUrl = "http://152.66.183.96:8080/item";
    const QString &bidUrl = "http://152.66.183.96:8080/bid";
}

/* Istenosztályként müködik, minden funkció megvalósitásáért felel.
 * Ha többet tudnák foglalkozni akkor delegálnánk a felelőséget az adott elemnre. */
class BidsList : public QAbstractListModel
{
    Q_OBJECT
    QML_ELEMENT

public:
    // Data element on which the model is based.s
    QList<BidElement*> bidsList;

    // Used for referencing data type elements as qml properties
    enum Role {
        ItemIndex = Qt::UserRole + 1,
        Subject,
        Supplier,
        Price,
        HighestBidder,
        Category
        //Picture
    };
    explicit BidsList(QObject *parent = nullptr);

    //Copy constructor needed
    explicit BidsList(BidsList& list);

    // Initialize list from server
    void requestListInit();

    // Inherited from QAbstractListModel
    virtual int rowCount(const QModelIndex &parent) const override;
    virtual QVariant data(const QModelIndex &index, int role) const override;
    virtual QHash<int, QByteArray> roleNames() const override;

public slots:
    // Called from the backend by event handlers.
    // Returns if the addition vas succesful
    // Function only used if item is created locally.
    void addBid(
        const int userId,
        const QString& subject,
        const QString& supplier,
        const double price,
        const QString& highestBidder,
        const QString& category
    );
    void removeBid(int index);

    // Adding new element to the list
    // Use this function if you add an existing element to a new list
    void addBidElement(BidElement* element);

    // Subscribe to element with given index
    void subscribe(int index, int userId);

    // Place bid on element with given index
    /* Request to the server to place a bid that is that high. */
    void placeBid(int index, double bid, int userId, QString userName);

    // Parse data from server
    void parseData();

    // Create new element
    void createElement();

signals:
    // QAbstractItemModel interface

    // ads the specified element to the notification list
    // Returns if the update on the list was succesful
    void elementAdded(BidElement* element);
    void elementRemoved(int index);

    // Subscribe to the element.
    void subscribedTo(BidElement* element);

    // Bid placed succesfully on element.
    void bidPlaced(BidElement* element);

protected:
    // Search element in list with given id
    BidElement* findElementById(int id);

private:
    QNetworkAccessManager networkManager;
    QNetworkReply* reply = nullptr;

};

#endif // BIDSLIST_H
