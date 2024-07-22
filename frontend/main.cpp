#include <QGuiApplication>
#include <QIcon>
#include <QQmlApplicationEngine>
#include <QWindow>

#include "User.h"
#include "BidsList.h"

void istantiateLists(QGuiApplication& gui);

int main(int argc, char *argv[])
{

#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;

    // Inicializaljuk az adatokat:
    istantiateLists(app);

    const QUrl url(QStringLiteral("qrc:/Bidder/qml/Main.qml"));
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}

void istantiateLists(QGuiApplication& gui) {
    // Register user for qml code.
    // Needed for referencing the currently logged in user name
    User* user = new User(&gui);
    user->setId(1);
    user->setName("Pityu");
    qmlRegisterSingletonInstance("com.User",1,0, "User", user);

    BidsList* exploreList = new BidsList(&gui);
    qmlRegisterSingletonInstance("com.model.ExploreList",1,0, "ExploreList", exploreList);

    BidsList* watchList = new BidsList(&gui);
    qmlRegisterSingletonInstance("com.model.WatchList",1,0, "WatchList", watchList);

    BidsList* owngoodsList = new BidsList(&gui);
    qmlRegisterSingletonInstance("com.model.OwnGoods",1,0, "OwnGoods", owngoodsList);

    BidsList* bidsList = new BidsList(&gui);
    qmlRegisterSingletonInstance("com.model.BidsList",1,0, "BidsList", bidsList);

    // Ha új elemet hozunk létre akkor a mindekinek megjelenjen
    QObject::connect(owngoodsList, &BidsList::elementAdded,
                     exploreList, &BidsList::addBidElement);

    // Ha kitörlöljük a saját hirdetésünket akkor semmisüljon meg publikusan is
    QObject::connect(owngoodsList, &BidsList::elementRemoved,
                     exploreList, &BidsList::removeBid);

    // Ha egy hirdetés megsemmisült, nem kaphatunk rolla értesítést.
    QObject::connect(exploreList, &BidsList::elementRemoved,
                     watchList, &BidsList::removeBid);

    // Ha egy hirdetés megsemmisült akkor a licitünk is eltűnik.
    QObject::connect(exploreList, &BidsList::elementRemoved,
                     bidsList, &BidsList::removeBid);

    // Ha feliratkozunk egy licitre akkor jelenjen meg a watchlistbenn
    QObject::connect(exploreList, &BidsList::subscribedTo,
                     watchList, &BidsList::addBidElement);

    // Ha licitalunk a főoldalon akkor a tét jelenjen meg a licit ablakban
    QObject::connect(exploreList, &BidsList::bidPlaced,
                     bidsList, &BidsList::addBidElement);

    // Ha licitálunk egy watchlistben lévő tétre akkor is jelenjen meg a licitbe
    QObject::connect(watchList, &BidsList::bidPlaced,
                     bidsList, &BidsList::addBidElement);

    // Inicializalaskor feltolti a tulajdonos listajat is
    QObject::connect(exploreList, &BidsList::elementAdded,
                     [=](BidElement* element)
    {
        if(element->supplier() == user->name()) {
            owngoodsList->addBidElement(element);
        }

    });

    // Inicializalaskor feltolti a tulajdonos listajat is
    QObject::connect(exploreList, &BidsList::elementAdded,
                     [=](BidElement* element)
    {
        if(element->highestBidder() == user->name()
            && element->supplier() != user->name()) {
            bidsList->addBidElement(element);
        }
    });

    /// Initialize network access
    exploreList->requestListInit();
}
