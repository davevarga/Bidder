#ifndef USER_H
#define USER_H

#include <QObject>
#include <QDebug>

#include "BidElement.h"

class User : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged)
    Q_PROPERTY(int id READ id WRITE setId NOTIFY idChanged FINAL)

public:
    explicit User(QObject *parent = nullptr);
    explicit User(User& user);

    QString name() const;
    void setName(const QString &newName);

    int id() const;
    void setId(int newId);

signals:
    void nameChanged();

    void idChanged();

private:
    QString m_name;
    int m_id;
};

#endif // USER_H
