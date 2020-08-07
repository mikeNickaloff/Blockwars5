#ifndef GAMEENGINE_H
#define GAMEENGINE_H

#include <QObject>
#include <QQueue>
#include "blockevent.h"
#include <QVector>
#include <QQmlHelpersCommon.h>
#include <QQmlVarPropertyHelpers.h>
class Player;
class BlockEvent;
class BlockManager;
class IRCConnection;
class GameEngine : public QObject
{
    Q_PROPERTY (QString currentQueue READ getCurrentQueueString WRITE setCurrentQueueString NOTIFY currentQueueStringChanged)

    Q_OBJECT
    QML_WRITABLE_VAR_PROPERTY(int, moves_p1)
    QML_WRITABLE_VAR_PROPERTY(int, moves_p2)
    QML_WRITABLE_VAR_PROPERTY(QString, grid_p1)
    QML_WRITABLE_VAR_PROPERTY(QString, grid_p2)
    QML_WRITABLE_VAR_PROPERTY(QString, nickname_opponent)
    QML_WRITABLE_VAR_PROPERTY(QString, nickname_user)
    QML_WRITABLE_VAR_PROPERTY(QString, health_p1)
    QML_WRITABLE_VAR_PROPERTY(QString, health_p2)
    QML_WRITABLE_VAR_PROPERTY(QString, powerups_p1)
    QML_WRITABLE_VAR_PROPERTY(QString, powerups_p2)
    QML_WRITABLE_VAR_PROPERTY(QString, blocks_p1)
    QML_WRITABLE_VAR_PROPERTY(QString, blocks_p2)
    QML_WRITABLE_VAR_PROPERTY(bool, unlocked_drop_p1)
    QML_WRITABLE_VAR_PROPERTY(bool, unlocked_drop_p2)
    QML_WRITABLE_VAR_PROPERTY(bool, unlocked_move_p1)
    QML_WRITABLE_VAR_PROPERTY(bool, unlocked_move_p2)
    QML_WRITABLE_VAR_PROPERTY(bool, game_started)
    QML_WRITABLE_VAR_PROPERTY(QString, gameType)





public:
    GameEngine(QObject *parent = nullptr);
    QQueue<BlockEvent*> blockEventQueue;
    Q_INVOKABLE QString serialize();
    BlockManager* m_blockManager1;
    BlockManager* m_blockManager2;
    IRCConnection* m_connection;


    void handleLocalLaunch(QString i_uuid);
    void handleRemoteLaunch(QString i_uuid);


signals:
    void blockEventAdded( QString newEvent);
    void requestDeserializeBlockEvent(QString eventString);
    void blockEventRemoved();
    void currentQueueStringChanged(QString currentQueue);

    /* notifyPlayerField forwards commands sent externally to the gameEngine that are meant for
      the playerField only */
    void notifyPlayerField(QString target_nickname, QString command, QString args);


public slots:
    void init();
    void notifyQueueAddition(QString newEvent);
    void notifyQueueRemoval();
    void deserialize(QString i_str);
    Q_INVOKABLE void initUserPlayer();


    void parseLocalPlayerCommand(QString targetNick, QString command, QString args);
    void parseRemotePlayerCommand(QString targetNick, QString command, QString args);

    void parseLocalBlockManagerCommand(QString command, QString args);
    void parseRemoteBlockManagerCommand(QString command, QString args);
    void slotNotifyPlayerField(QString target_nickname, QString command, QString args);



private:
    QString _currentQueueString;
    QString getCurrentQueueString();
    Player* _local_bottom_player;
    Player* _local_top_player;
private slots:
    void setCurrentQueueString(QString newStr);

};

#endif // GAMEENGINE_H

