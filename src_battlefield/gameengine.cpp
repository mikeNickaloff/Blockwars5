#include "gameengine.h"
#include "blockevent.h"
#include <QObject>
#include <QtDebug>
#include <QQueue>
#include <QMetaObject>
#include <QString>
#include <QMetaProperty>
#include "../src_input/player.h"
#include "blockmanager.h"
#include "../src_input/ircconnection.h"
GameEngine::GameEngine(QObject* parent ) : QObject(parent)
{

}

QString GameEngine::serialize()
{
    const QMetaObject* metaObject = this->metaObject();
    QVector<QPair<QString, QVariant> > properties;
    for(int i = metaObject->propertyOffset(); i < metaObject->propertyCount(); ++i) {
        properties << qMakePair<QString,QVariant>(QString::fromLatin1(metaObject->property(i).name()),metaObject->property(i).read(this));
    }

    QStringList rv;

    for (int i=0; i<properties.count(); i++) {
        QPair<QString, QVariant> p = properties.at(i);
        QString v = QString("%1|%2").arg(p.first).arg(p.second.toByteArray().data());
        rv << v;
    }
    return rv.join(",");

}

void GameEngine::handleLocalLaunch(QString i_uuid)
{

}

void GameEngine::handleRemoteLaunch(QString i_uuid)
{

}

void GameEngine::init()
{


  qDebug() << "Initialized Game Engine";
  qDebug() << serialize();
  this->initUserPlayer();

}

void GameEngine::notifyQueueAddition(QString newEvent)
{

}

void GameEngine::notifyQueueRemoval()
{
    emit this->blockEventRemoved();
}

void GameEngine::deserialize(QString i_str)
{
 QStringList i_str_list;
 i_str_list << i_str.split(",", Qt::SkipEmptyParts);
 for (QString str : i_str_list) {
    QStringList str_prop;
    str_prop << str.split("|");
    if (str_prop.length() == 2) {
        QString propName = str_prop.takeFirst();
        QString propVal = str_prop.takeFirst();
        this->setProperty(propName.toLocal8Bit().data(), QVariant::fromValue(propVal));
    }
 }
}

void GameEngine::initUserPlayer()
{
    m_blockManager1 = new BlockManager(this);
    m_blockManager2 = new BlockManager(this);
    m_connection = new IRCConnection(this);
    m_connection->connectToServer(this->property("gameType").toString());
    this->_local_bottom_player = new Player(this);
    this->connect(m_connection, SIGNAL(notifiedGameEngineFromServer(QString, QString, QString)), this, SLOT(parseLocalPlayerCommand(QString, QString, QString)));
    this->connect(m_connection, SIGNAL(notifiedGameEngineFromRemote(QString, QString, QString)), this, SLOT(parseRemotePlayerCommand(QString, QString, QString)));
    this->connect(m_blockManager1, SIGNAL(notifyGameEngine(QString,QString)), this, SLOT(parseLocalBlockManagerCommand(QString,QString)));
    this->connect(m_blockManager2, SIGNAL(notifyGameEngine(QString,QString)), this, SLOT(parseRemoteBlockManagerCommand(QString,QString)));

    //m_blockManager1->preFillBlocks();
    //this->_local_bottom_player->startHuman(this->property("gameType").toString());

    this->_local_top_player = new Player(this);
  //  this->_local_top_player->startAI();




}

void GameEngine::parseLocalPlayerCommand(QString targetNick, QString command, QString args)
{
    if ((command.startsWith("setGameEngineProperty!")) || (command.startsWith("setEngineProperty!"))) {
        QStringList cmd_params = command.split("!", Qt::SkipEmptyParts);
        if (cmd_params.length() > 1) {
            QString cmd_prop = cmd_params.takeAt(1);
            this->setProperty(cmd_prop.toLocal8Bit(), QVariant::fromValue(args));
            qDebug() << "Set Engine property: " << cmd_prop << " ... to .." << args;

            if (cmd_prop == "unlocked_drop_p1") {
                if (args == "true") {
                    m_blockManager1->preFillBlocks();
                       m_connection->sendMessageToGame(QString("%1 %2 %3").arg("BLOCKMANAGERDESERIALIZE").arg(this->property("nickname_user").toString()).arg(m_blockManager1->serialize()));
                }
            }
            if (cmd_prop == "unlocked_move_p1") {
                if (args == "true") {
                    this->setProperty("moves_p1", QVariant::fromValue(3));
                    this->setProperty("moves_p2", QVariant::fromValue(0));
                } else {
                       this->setProperty("moves_p2", QVariant::fromValue(3));
                    this->setProperty("moves_p1", QVariant::fromValue(0));
                }
            }

            ///qDebug() << serialize();
        }
    }
    if (command == "START") {
        setProperty("game_started", QVariant::fromValue(true));
        if (this->property("game_started").toBool()) {
          //  m_blockManager1->preFillBlocks();

        }
    }
    if (command == "ANNOUNCEBLOCKS") {
           m_connection->sendMessageToGame(QString("%1 %2 %3").arg("BLOCKMANAGERDESERIALIZE").arg(this->property("nickname_user").toString()).arg(m_blockManager1->serialize()));
        ///m_connection->sendMessageToGame(QString("%1 %2 %3").arg("BLOCKMANAGERDESERIALIZE").arg(this->property("nickname_user").toString()).arg(m_blockManager1->serialize()));
//        while (i < m_blockManager1->numRows) {
//            QList<int> rowsToEncode;
//            rowsToEncode << i;
//            this->_local_bottom_player->recvCommand("BLOCKS", m_blockManager1->serializeRows(rowsToEncode));
//            i++;
//        }
    }
    //

    if (command == "createBlockInField") {

        emit this->notifyPlayerField(this->property("nickname_user").toString(), command, args);
     //   this->m_connection->sendMessageToGame(QString("%1 %2").arg(command).arg(QString("%1 %2").arg(this->property("nickname_user").toString()).arg(args)));


    }
     if (command == "updateBlockField") {
           emit this->notifyPlayerField(this->property("nickname_user").toString(), command, args);

         //this->m_connection->sendMessageToGame(QString("%1 %2").arg(command).arg(QString("%1 %2").arg(this->property("nickname_user").toString()).arg(args)));
     }
     if (command == "swap") {
         if (this->property("unlocked_move_p1").toString() == "true" ? true : false) {
             QStringList uuids;
             uuids << m_blockManager1->swapBlocks(args);

             m_connection->sendMessageToGame(QString("%1 %2 %3").arg("BLOCKMANAGERDESERIALIZE").arg(this->property("nickname_user").toString()).arg(m_blockManager1->serialize(uuids)));
         } else {
             QStringList params;
             params << args.split(" ", Qt::SkipEmptyParts);
             if (params.length() >= 2) {
                 int oldRow = params.takeFirst().toInt();
                 int oldCol = params.takeFirst().toInt();
                 emit this->notifyPlayerField(this->property("nickname_user").toString(), "updateBlockField", m_blockManager1->serialize(m_blockManager1->findFirstUuidAtPosition(oldRow, oldCol)));
             }
             //m_connection->sendMessageToGame(QString("%1 %2 %3").arg("BLOCKMANAGERDESERIALIZE").arg(this->property("nickname_user").toString()).arg(m_blockManager1->serialize()));
         }
     }

     if (command == "moveMade") {
         this->setProperty("moves_p1", QVariant::fromValue((this->property("moves_p1").toInt() - 1)));
         m_connection->sendMessageToGame(QString("%1 %2").arg("MOVEMADE").arg(this->property("nickname_user").toString()));
     }
     if (command == "destroyedBlock") {
         QStringList uuids;
         uuids << args;
         m_blockManager1->destroyBlock(args);
          m_connection->sendMessageToGame(QString("%1 %2 %3").arg("BLOCKMANAGERDESERIALIZE").arg(this->property("nickname_user").toString()).arg(m_blockManager1->serialize(uuids)));
      //   m_connection->sendMessageToGame(QString("%1 %2 %3").arg("BLOCKMANAGERDESERIALIZE").arg(this->property("nickname_user").toString()).arg(m_blockManager1->serialize(uuids)));
     }
if (command == "launch") {

}




}

void GameEngine::parseRemotePlayerCommand(QString targetNick, QString command, QString args)
{
    if ((command.startsWith("setGameEngineProperty!")) || (command.startsWith("setEngineProperty!"))) {
        QStringList cmd_params = command.split("!", Qt::SkipEmptyParts);
        if (cmd_params.length() > 1) {
            QString cmd_prop = cmd_params.takeAt(1);
            this->setProperty(cmd_prop.toLocal8Bit(), QVariant::fromValue(args));
            qDebug() << "Set Engine property: " << cmd_prop << " ... to .." << args;


//            if (cmd_prop == "unlocked_drop_p1") {
//                if (args == "true") {
//                    m_blockManager1->preFillBlocks();
//                }


            }
    }
            if (command == "BLOCKS") { this->m_blockManager2->deserialize(args); }

            if (command == "createBlockInField") {

                emit this->notifyPlayerField(targetNick, command, args);




            }
             if (command == "updateBlockField") {
                   emit this->notifyPlayerField(targetNick, command, args);

             }

             if (command == "BLOCKMANAGERDESERIALIZE") {
                 qDebug() << "Game Engine Got command" << command << "For" << targetNick << "::" << args;
                 m_blockManager2->deserialize(args);
             }




}

void GameEngine::parseLocalBlockManagerCommand(QString command, QString args)
{
    this->parseLocalPlayerCommand(this->property("nickname_user").toString(), command, args);
}
void GameEngine::parseRemoteBlockManagerCommand(QString command, QString args)
{
    QString targetNick = this->property("nickname_opponent").toString();
    //this->parseRemotePlayerCommand(this->property("nick_opponent").toString(), command, args);
    if (command == "createBlockInField") {

        emit this->notifyPlayerField(targetNick, command, args);




    }
     if (command == "updateBlockField") {
           emit this->notifyPlayerField(targetNick, command, args);

     }

}

void GameEngine::slotNotifyPlayerField(QString target_nickname, QString command, QString args)
{
    emit this->notifyPlayerField(target_nickname, command, args);
}




QString GameEngine::getCurrentQueueString()
{
  return this->_currentQueueString;
}

void GameEngine::setCurrentQueueString(QString newStr)
{
this->_currentQueueString = newStr;
//  emit this->currentQueueStringChanged(newStr);
}
