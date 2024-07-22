#include <QNetworkReply>
#include <QUrlQuery>

#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QEventLoop>

#include "BidsList.h"
#include "BidElement.h"

BidsList::BidsList(QObject *parent)
    : QAbstractListModel{parent}
{}

/* Copy constructor needed for ListNetworkManager pass in parameter*/
BidsList::BidsList(BidsList &list) {bidsList = list.bidsList;}

/* Overrides abstract function of QAbstractItemModel. Returns the number of elements in the list
 * which our model is based. Creates coresponding ItemModel qml elements. */
int BidsList::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    return bidsList.length();
}

/* Overides abstract fuction of QAbstractItemModel. It serves to associate data element to qml item. */
QVariant BidsList::data(const QModelIndex &index, int role) const
{
    if(index.isValid() && index.row() >= 0 && index.row() < bidsList.length()) {
        BidElement* bid = bidsList[index.row()];
        switch((Role) role) {
            case ItemIndex: return bid->itemIndex();
            case Subject: return bid->subject();
            case Supplier: return bid->supplier();
            case Price: return bid->price();
            case HighestBidder: return bid->highestBidder();
            case Category: return bid->category();
        }
    }
    return {};
}

/* Creates aliases when using in qml code. the ByteArray type data will be
* references in qml code. The hash key is based on Role enum type*/
QHash<int, QByteArray> BidsList::roleNames() const
{
    QHash<int, QByteArray> result;
    result[ItemIndex] = "itemIndex";
    result[Subject] = "subjectName";
    result[Supplier] = "supplierName";
    result[Price] = "price";
    result[HighestBidder] = "highestBidderName";
    result[Category] = "category";
    return result;
}

/* Function is called remotely by backend.
 * Backend was called by add button, or any other reason, The callback red all form fields, after checking the validity.
 * Backend also checked the validity of input fields, such as duplicates.
 * In case of valid fields, the backend calles the function. */
void BidsList::addBid(
    const int userId,
    const QString &subject,
    const QString &supplier,
    const double price,
    const QString &highestBidder,
    const QString &category
    )
{
    //Check if backend allow insertion of element
    // Index works as an ID accross multiple lists
    if(reply) {
        reply->abort();
        reply->deleteLater();
        reply = nullptr;
    }

    QNetworkRequest request(itemsUrl);
    request.setHeader(QNetworkRequest::ContentTypeHeader,
                      "application/json");

    QJsonObject json;
    json.insert("title", subject);
    json.insert("startingBid", QString::number(price));
    json.insert("userId", QString::number(userId));
    json.insert("categoryName", category);

    QJsonDocument doc(json);
    QByteArray postData = doc.toJson();
    qDebug() << postData;

    reply = networkManager.post(request, postData);
    QObject::connect(reply, &QNetworkReply::finished, this, &BidsList::createElement);
}

/* Function is called remotely by backend
 * Backend was called by the remove button on the BidViewElement,
 * or any other reason. Although validity was checked we also check redundantly. */
void BidsList::removeBid(int index)
{
    // Find the element with the coresponding id. If doesnt exist nullptr
    BidElement* bid = findElementById(index);

    if (bid != nullptr) {
        int position = bidsList.indexOf(bid);
        beginRemoveRows(QModelIndex(), position, position);
        // Check if the backend allow the deletion of element

        // Remove from the list and log
        bidsList.removeAll(bid);

        qDebug() << "Removed bid item with --index:" << bid->itemIndex()
                 << " with --title: " << bid->subject()
                 << " number of total records are: " << bidsList.length();

        // Before deleting element deletion server request
        // SERVER REST API REQUEST 

        // Asyncronous call of delete, preventing memory leaking

        endRemoveRows();

        if(reply) {
            reply->abort();
            reply->deleteLater();
            reply = nullptr;
        }

        QNetworkRequest request(itemsUrl + "/" + QString::number(index));
        request.setHeader(QNetworkRequest::ContentTypeHeader,
                          "application/json");

        // The bid exist for sure. If it doesn't than it already doesnt exist.
        reply = networkManager.deleteResource(request);

        // Signal that the item has been removed from the list
        bid->deleteLater();
        emit elementRemoved(index);
    } else {
        // If the server or the index validity drops the procedure
        qDebug() << "Item removel with index: " << index << " was unsuccesful";
    }
}

/* Slot that doesn't seng more signal. Adds an already created and stored element
 * to another list. Element assembling should only be done once */
void BidsList::addBidElement(BidElement *element)
{   
    /* Redundant check if the element exist in the list.
     * Backend also checks the existance of sad element. */
    BidElement* check = findElementById(element->itemIndex());

    if(check == nullptr) {
        beginInsertRows(QModelIndex(), bidsList.length(), bidsList.length());

        // Insert into list
        bidsList.append(element);

        // Loging client side model logic before server request
        qDebug() << "Added bid item with --index:" << element->itemIndex()
                 << " with --title: " << element->subject()
                 << " number of total records are: " << bidsList.length();
        endInsertRows();

        // REST API SERVER REQUEST
    } else {
        qDebug() << "Element with --index:" << element->itemIndex()
                 << " and --title: " << element->subject()
                 << " already exist in the list ";
    }
}

/* In qml delegate items do not know their associate element in model.
 * Using the item id we can track delegate identity */
BidElement *BidsList::findElementById(int id)
{
    // find element with the specified id
    QList<BidElement*>::iterator i;
    for(i = bidsList.begin(); i != bidsList.end(); ++i) {
        BidElement* bid = *i;
        if(bid->itemIndex() == id)
            return bid;
    }
    qDebug() << "Element with --index: " << id << " not found";
    return nullptr;
}

/* Sends request on tha backend to create a mirror to the frontend element
 * ID's must match on backend and frontend -> we create the id on backend. */

/* User subscribes to a certain item. Sends Request to server in order to
 * mimic this behavour as well. The signal is captured by wathclist model.*/
void BidsList::subscribe(int index, int userId)
{
    BidElement* element = findElementById(index);
    if(element != nullptr) {
        // Signal to server to subscibe
        if(reply) {
            reply->abort();
            reply->deleteLater();
            reply = nullptr;
        }
        reply = networkManager.get(QNetworkRequest(itemsUrl + "/"
             + QString::number(index) + "/subscribe/" + QString::number(userId)));

        // Signal is received by watchlist object
        emit subscribedTo(element);
    }
}

void BidsList::placeBid(int index, double bid, int userId, QString userName)
{
    // Get the element in the list by using id
    BidElement* element = findElementById(index);

    // Logic is handled on the backend,
    if(reply) {
        reply->abort();
        reply->deleteLater();
        reply = nullptr;
    }


    QNetworkRequest request(bidUrl);
    request.setHeader(QNetworkRequest::ContentTypeHeader,
                              "application/json");

    QJsonObject json;
    json.insert("amount", bid);
    json.insert("userId", QString::number(userId));
    json.insert("itemId", index);

    QJsonDocument doc(json);
    QByteArray postData = doc.toJson();

    // Send request to server
    reply = networkManager.post(request, postData);

    // Wait for respnse to come, without blocking the UI
    QEventLoop loop;
    QObject::connect(reply, &QNetworkReply::finished, &loop, &QEventLoop::quit);
    loop.exec();

    // Lambda function that sees the elements ouside the scope
    if(reply->error() == QNetworkReply::NoError) {
        beginResetModel();

        element->setPrice(bid);
        element->setHighestBidder(userName);

        qDebug() << "Bid placed succesfully on item --index: " << element->itemIndex()
                << " -> new highest bid amount is: " << element->price()
                << " from --user: " << element->highestBidder();

        endResetModel();
        emit bidPlaced(element);
    } else if(reply->error() == QNetworkReply::InternalServerError) {
        qDebug() << "Bid amount on item --index: " << element->itemIndex()
                << "is to low: --amount: " << bid
                << " current bid: " << element->price()
                << " or item not found";
    }
}

/* Received data from server side, for initialization and refreshing */
void BidsList::parseData()
{
    if(reply->error() == QNetworkReply::NoError) {
        beginResetModel();

        // if reply is received redraw the model
        qDeleteAll(bidsList);
        bidsList.clear();

        // The data received from server has JSON format
        QByteArray data = reply->readAll();
        QJsonDocument jsonDocument = QJsonDocument::fromJson(data);

        // Dumping the results using QJson functionality
        QJsonArray results = jsonDocument.array();

        // Create QJson object to encapsulate single result
        for(const auto &result: results) {
            QJsonObject entry = result.toObject();

            // Creating element from information received from request
            BidElement* newServerElement = new BidElement(this);

            // All the parameters are valid.
            // Validity is checked before fucntion call, by event handler.
            newServerElement->setItemIndex(entry["id"].toInt());
            newServerElement->setSubject(entry["name"].toString());
            newServerElement->setSupplier(entry["ownerName"].toString());
            newServerElement->setPrice(entry["highestBid"].toDouble());
            newServerElement->setHighestBidder(entry["highestBidderName"].toString());
            newServerElement->setCategory(entry["category"].toString());

            // We add with this function, as this doesn't emit signals.
            // Therefore preventing situation where item insersion sends request to server
            addBidElement(newServerElement);
            emit elementAdded(newServerElement);
        }
        endResetModel();

    } else if (reply->error() == QNetworkReply::OperationCanceledError) {
        // If request was intentionally canceled we shouldn't worry
        qCritical() << "Server Request was intentionally canceled";
    }

    // Request is complete, stop searching
    reply->abort();
    reply->deleteLater();
    reply = nullptr;
}

void BidsList::createElement()
{
    if(reply->error() == QNetworkReply::NoError) {
        // Set the interval for the view element to process the request
        // Specify elements that need to be redrawn
        beginInsertRows(QModelIndex(), bidsList.length(), bidsList.length());
        BidElement* newItem = new BidElement(this);

        // The data received from server has JSON format
        QByteArray data = reply->readAll();
        QJsonDocument jsonDocument = QJsonDocument::fromJson(data);
        QJsonObject entry = jsonDocument.object();

        BidElement* newServerElement = new BidElement();
        newServerElement->setItemIndex(entry["id"].toInt());
        newServerElement->setSubject(entry["name"].toString());
        newServerElement->setSupplier(entry["ownerName"].toString());
        newServerElement->setPrice(entry["highestBid"].toDouble());
        newServerElement->setHighestBidder(entry["highestBidderName"].toString());
        newServerElement->setCategory(entry["category"].toString());

        // Add new element to the list
        bidsList << newServerElement;
        qDebug() << "Added bid item with --index:" << newServerElement->itemIndex()
                 << " with --title: " << newServerElement->subject()
                 << " number of total records are: " << bidsList.length();
        endInsertRows();
        emit elementAdded(newServerElement);

    } else if (reply->error() == QNetworkReply::OperationCanceledError) {
        // If request was intentionally canceled we shouldn't worry
        qCritical() << "Server Request was intentionally canceled";
    } else {
        // Other reason why request wasn received
        qCritical() << "Request received with error: " << reply->errorString();
    }
}

void BidsList::requestListInit()
{
    if(reply) {
        reply->abort();
        reply->deleteLater();
        reply = nullptr;
    }
    reply = networkManager.get(QNetworkRequest(itemsUrl));
    QObject::connect(reply, &QNetworkReply::finished, this, &BidsList::parseData);

}
