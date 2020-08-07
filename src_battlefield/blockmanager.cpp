#include "blockmanager.h"
#include <QUuid>
#include <QtDebug>
#include <QRandomGenerator>
#include <QThread>
#include <QChar>
#include "../simplecrypt.h"
BlockManager::BlockManager(QObject *parent) : QObject(parent)
{
numRows = 6;
numCols = 6;
m_colors << "steelblue" << "gold" << "firebrick" << "forestgreen" << "orange";
QList<bool>  destroyedVals;
destroyedVals << true << false;
QString uid = "0000";
int i=250;

for (QString color : m_colors) {
    for (int health=-1; health<999; health++) {
        QString src = QString("$%1$%2").arg(color).arg(health);
        i++;
        QChar chr(i);

        while (!chr.isPrint()) { i++; chr = QChar(i);

        }
        QString sym = QString("[%1]").arg(chr);
       // if ((i % 10000) == 0) { qDebug() << i << "Symbols" << src << sym;  }
        this->m_symbol_map[sym] = src;
        this->m_source_map[src] = sym;
    }
}

            for (int col=-1; col<numCols; col++) {

                for (int frozenRounds=0; frozenRounds<5; frozenRounds++) {
                    for (int burningRounds=0; burningRounds<5; burningRounds++) {
                        for (int invulnerableRounds=0; invulnerableRounds<5; invulnerableRounds++) {
                            for (bool isDestroyed : destroyedVals) {
                                 for (int row=-10; row<numRows; row++) {
                                for (QString color : m_colors) {
                                /* refernece */
//                                m_block_colors[uid] = color;
//                                m_block_health[uid] = health;
//                                this->m_block_cols[uid] =  col;
//                                this->m_block_rows[uid] = row;
//                                this->m_block_destroyed[uid] = isDestroyed;
//                                this->m_block_frozen_rounds[uid] = frozenRounds;
//                                this->m_block_burning_rounds[uid] = burningRounds;
//                                this->m_block_invulnerable_rounds[uid] = invulnerableRounds;
                                /* end */
                                QString src = QString("$%1$%2$%3$%4$%5$%6$").arg(row).arg(col).arg(frozenRounds).arg(burningRounds).arg(invulnerableRounds).arg(isDestroyed == true ? "true" : "false");
                                //qDebug() << "source: " << src;
                                i++;
                                QChar chr(i);

                                while (!chr.isPrint()) { i++; chr = QChar(i);

                                }
                                QString sym = QString("[%1]").arg(chr);
                               // if ((i % 10000) == 0) { qDebug() << i << "Symbols" << src << sym;  }
                                this->m_symbol_map[sym] = src;
                                this->m_source_map[src] = sym;

                            }
                        }
                    }

                }
            }

        }    
}
qDebug() << "Symbols added:" << m_symbol_map.size();


}

QStringList BlockManager::filterBlocksByRow(int rowNum)
{
    QStringList rv;
    QHash<QString,int>::const_iterator i = this->m_block_rows.constBegin();
    while (i != m_block_rows.constEnd()) {
        if (i.value() == rowNum) { rv << i.key(); }

        i++;
    }
    return rv;

}

QStringList BlockManager::filterBlocksByCol(int colNum)
{
    QStringList rv;
    QHash<QString,int>::const_iterator i = this->m_block_cols.constBegin();
    while (i != m_block_cols.constEnd()) {
        if (i.value() == colNum) { rv << i.key(); }

        i++;
    }
    return rv;

}

QList<int> BlockManager::mapBlocksToRows(QStringList blockList)
{
    QList<int> rv;
 for (QString str :   blockList) {
     rv << m_block_rows.value(str, -1);
 }
 return rv;
}

QList<int> BlockManager::mapBlocksToCols(QStringList blockList)
{
    QList<int> rv;
 for (QString str :   blockList) {
     rv << m_block_cols.value(str, -1);
 }
 return rv;
}

QStringList BlockManager::mapBlocksToColors(QStringList blockList)
{
    QStringList rv;
 for (QString str :   blockList) {
     rv << m_block_colors.value(str, "transparent");
 }
 return rv;
}

QString BlockManager::mapColorsToCheckTable(QStringList colorList, QString color)
{
    QString rv;
    for (QString str : colorList) {
        if (str == color) {
            rv.append(1);
        } else {
         rv.append(0);
        }
    }
    return rv;
}

QStringList BlockManager::filterDuplicateStrings(QStringList stringList)
{
    QStringList rv;
    for (QString str : stringList) {
        if (!rv.contains(str)) { rv << str; }
    }
    return rv;
}

QString BlockManager::serialize(QString uuid)
{
    QString rv;
    rv = QString("%1$%2$%3$%4$%5$%6$%7$%8$%9$%10").arg(uuid).arg(m_block_colors.value(uuid)).arg(m_block_health.value(uuid)).arg(m_block_rows.value(uuid)).arg(m_block_cols.value(uuid)).arg(m_block_frozen_rounds.value(uuid)).arg(m_block_burning_rounds.value(uuid)).arg(m_block_invulnerable_rounds.value(uuid)).arg(m_block_destroyed.value(uuid) == true ? "true" : "false").arg(m_block_hero.value(uuid));

    return rv;
}

QString BlockManager::serialize()
{
    return serialize(m_block_ids.values());

}

QString BlockManager::serialize(QStringList ids)
{
    QStringList rv;
    for (QString uuid : ids) {
        rv << serialize(uuid);

    }
   // SimpleCrypt crypto(Q_UINT64_C(0x0c2ad4a4acb9f023)); //some random number

    //return QString::fromLocal8Bit(crypto.encryptToString(rv.join("#")).toLocal8Bit().toBase64());
    return QString::fromLocal8Bit(rv.join("#").toLocal8Bit().toBase64());
}

QString BlockManager::serializeRow(int row)
{
    return serialize(filterBlocksByRow(row));
}

QString BlockManager::serializeRows(QList<int> rows)
{
    QStringList ids;
    for (int i : rows) {
     ids << filterBlocksByRow(i);
    }
    return serialize(ids);
}

void BlockManager::deserialize(QString _serialdata)
{
 //   SimpleCrypt crypto(Q_UINT64_C(0x0c2ad4a4acb9f023)); //some random number
   // QString serialdata = crypto.decryptToString(QString::fromLocal8Bit(QByteArray::fromBase64(_serialdata.toLocal8Bit())));
     QString serialdata = QString::fromLocal8Bit(QByteArray::fromBase64(_serialdata.toLocal8Bit()));

    qDebug() << "Decompressed Serial Data" << serialdata;
    QStringList serialList;
    serialList << serialdata.split("#", Qt::SkipEmptyParts);
    for (QString str : serialList) {
        QStringList params;
        params << str.split("$", Qt::SkipEmptyParts);
        int i = 0;
        while (m_block_ids.keys().contains(i)) {
            i++;
        }
        if (params.count() >= 10) {
            QString id = params.takeFirst();
            bool sendFieldAnnouncement = false;
            if (!m_block_ids.values().contains(id)) { sendFieldAnnouncement = true; this->m_block_ids[i] = id; }

            this->m_block_colors[id] = params.takeFirst();
            this->m_block_health[id] = params.takeFirst().toInt();
            this->m_block_rows[id] = params.takeFirst().toInt();
            this->m_block_cols[id] = params.takeFirst().toInt();
            this->m_block_frozen_rounds[id] = params.takeFirst().toInt();
            this->m_block_burning_rounds[id] = params.takeFirst().toInt();
            this->m_block_invulnerable_rounds[id] = params.takeFirst().toInt();

            // this is to fix a bug where the blocks
            // would receive conflicting serialized
            // data sometimes out of sync
            bool will_destroy = params.takeFirst() == "true" ? true : false;
            if (m_block_destroyed[id] == true) {

                will_destroy = true;
            } else {
                if (will_destroy) {
                    destroyBlock(id);
                }
            }
            this->m_block_destroyed[id] = will_destroy;

            this->m_block_hero[id] = params.takeFirst();
            if (sendFieldAnnouncement) {
                emit this->notifyGameEngine("createBlockInField", serialize(id));
                emit this->notifyGameEngine("updateBlockField", serialize(id));
            } else {
                emit this->notifyGameEngine("updateBlockField", serialize(id));

            }
        } else {
         qDebug() << "Serial string too  few parameters";
        }
    }
}

void BlockManager::destroyBlock(QString uuid)
{
    this->m_block_destroyed[uuid] = true;
    this->m_block_rows[uuid] = -10;
    preFillBlocks();
}

void BlockManager::preFillBlocks()
{
    bool reCheck = false;
    for (int u=numRows; u>=0; u--) {
        if (checkAndDropRow(u)) { reCheck = true; };
    }
    while (reCheck) {
      bool _reCheck = false;
            for (int u=numRows; u>=0; u--) {
                if (checkAndDropRow(u)) { _reCheck = true; };
            }
            if (!_reCheck) { reCheck = false; }
    }

    QString newData = serialize();

            emit notifyGameEngine("ANNOUNCEBLOCKS", serialize());
QStringList matches;
matches << findMatchingBlocks();

for (QString str : matches) {
    destroyBlock(str);


}
if (matches.length() > 0) {
               emit notifyGameEngine("ANNOUNCEBLOCKS", serialize());
    preFillBlocks();
}





}

bool BlockManager::checkAndDropRow(int rowNum)
{
    bool reCheck = false;
    if (rowNum > 0) {
        QStringList rowBelow;
        rowBelow << this->filterBlocksByRow(rowNum - 1);
        QList<int> nonEmptyColsBelow;
        nonEmptyColsBelow << this->mapBlocksToCols(rowBelow);
        if (nonEmptyColsBelow.count() < numCols) { reCheck = true; }
        if (rowNum < numRows) {
            QStringList rowCurrent;
            rowCurrent << this->filterBlocksByRow(rowNum);
            for (QString str : rowCurrent) {
                if ( ! nonEmptyColsBelow.contains(m_block_cols.value(str, -2))) {
                    m_block_rows[str] = rowNum - 1;
                    emit this->notifyGameEngine("updateBlockField", serialize(str));
                }
            }

        } else {
            if (rowNum == numRows) {
                for (int u=0; u<numCols; u++) {
                    if ( ! nonEmptyColsBelow.contains(u)) {
                        createBlock(u);

                    }

                }
                // create block if empty cell exists

            }
        }
    } else {
        if (rowNum == 0) {
            //do nothing
        }
    }
    return reCheck;
}

void BlockManager::createBlock(int colNum)
{
    QStringList colors;
    colors << m_colors;
    QString uuid = QUuid::createUuid().toString().section("-", 1, 1);
    int i;
    i = 0;
    while (m_block_ids.keys().contains(i)) {
        i++;
    }
    quint32 v = QRandomGenerator::global()->bounded(colors.length());
    this->m_block_ids[i] = uuid;
    this->m_block_cols[uuid] =  colNum;
    this->m_block_rows[uuid] = numRows - 1;
    this->m_block_colors[uuid] = colors.at(v);
    this->m_block_health[uuid] = 5;
    this->m_block_destroyed[uuid] = false;
    this->m_block_frozen_rounds[uuid] = 0;
    this->m_block_burning_rounds[uuid] = 0;
    this->m_block_invulnerable_rounds[uuid] = 0;
    this->m_block_hero[uuid] = "none";
 emit this->notifyGameEngine("createBlockInField", serialize(uuid));
  //  qDebug() << "Created Block" << serialize(uuid);
}

QStringList BlockManager::swapBlocks(QString args)
{
    QStringList params;
    params << args.split(" ", Qt::SkipEmptyParts);
    int oldRow = params.takeFirst().toInt();
    int oldCol = params.takeFirst().toInt();
    int newRow = params.takeFirst().toInt();
    int newCol = params.takeFirst().toInt();
    QString oldUuid = findFirstUuidAtPosition(oldRow, oldCol);
    QString newUuid = findFirstUuidAtPosition(newRow, newCol);
    if ((oldUuid != "")  && (newUuid != "")) {
        m_block_rows[newUuid] = oldRow;
        m_block_rows[oldUuid] = newRow;
        m_block_cols[newUuid] = oldCol;
        m_block_cols[oldUuid] = newCol;


        QStringList uuids;
        uuids << oldUuid << newUuid;;
        emit this->notifyGameEngine("updateBlockField", serialize(oldUuid));
        emit this->notifyGameEngine("updateBlockField", serialize(newUuid));
        return uuids;
    }
    return QStringList();
}

QStringList BlockManager::findMatchingBlocks()
{
    QStringList rv;
    for (int i=0; i<numRows; i++) {
        QStringList currentRowUids;
        currentRowUids << this->filterBlocksByRow(i);
        QStringList currentRowColors;
        currentRowColors << mapBlocksToColors(currentRowUids);
        for (QString color : m_colors) {
            QString checkTable;
            checkTable = this->mapColorsToCheckTable(currentRowColors, color);
            if (checkTable.indexOf("111111") > -1) {
                checkTable.replace("111111", "m");

            }
            if (checkTable.indexOf("11111") > -1) {
                checkTable.replace("11111", "m");

            }
            if (checkTable.indexOf("1111") > -1) {
                checkTable.replace("1111", "m");

            }
            if (checkTable.indexOf("111") > -1) {
                checkTable.replace("111", "m");

            }
            QStringList checkTableResults;
            checkTableResults << checkTable.split("", Qt::SkipEmptyParts);
            for (int u=0; u<checkTableResults.length(); u++) {
                if (checkTableResults.at(u) == "m") {
                    if (currentRowUids.length() > u) {

                        rv << currentRowUids.at(u);
                    }
                }
            }
        }
    }
    /* columns */
    for (int i=0; i<numCols; i++) {
        QStringList currentRowUids;
        currentRowUids << this->filterBlocksByCol(i);
        QStringList currentRowColors;
        currentRowColors << mapBlocksToColors(currentRowUids);
        for (QString color : m_colors) {
            QString checkTable;
            checkTable = this->mapColorsToCheckTable(currentRowColors, color);
            if (checkTable.indexOf("111111") > -1) {
                checkTable.replace("111111", "m");

            }
            if (checkTable.indexOf("11111") > -1) {
                checkTable.replace("11111", "m");

            }
            if (checkTable.indexOf("1111") > -1) {
                checkTable.replace("1111", "m");

            }
            if (checkTable.indexOf("111") > -1) {
                checkTable.replace("111", "m");

            }
            QStringList checkTableResults;
            checkTableResults << checkTable.split("", Qt::SkipEmptyParts);
            for (int u=0; u<checkTableResults.length(); u++) {
                if (checkTableResults.at(u) == "m") {
                    if (currentRowUids.length() > u) {

                        rv << currentRowUids.at(u);
                    }
                }
            }
        }
    }
    return this->filterDuplicateStrings(rv);
}

QString BlockManager::findFirstUuidAtPosition(int row, int col)
{
    QStringList rowUuids = filterBlocksByRow(row);
    QStringList colUuids = filterBlocksByCol(col);
    for (QString uuid  : rowUuids) {
        if (colUuids.contains(uuid)) {
            return uuid;
        }
    }
    qDebug() << "FindUuidByPos::ERROR" << "NO UUID AT " << row << col;
    return "";
}

QString BlockManager::encodeSerialData(QString serialdata)
{
    QString rv = serialdata;
    QHash<QString,QString>::const_iterator i = this->m_source_map.constBegin();
    int numReplacements = 0;
    while (i != m_source_map.constEnd()) {
        if (numReplacements == 2) { break; }
        QString src = i.key();
        QString sym = i.value();
        if (rv.indexOf(src) != -1) {
            QString nrv = rv.replace(src, sym, Qt::CaseInsensitive);
            rv = nrv;
            numReplacements++;
        }

        i++;
    }
    return rv;
}

QString BlockManager::decodeSerialData(QString encodedData)
{
    QHash<QString,QString>::const_iterator i = this->m_source_map.constBegin();
    int numReplacements = 0;
    QString rv = encodedData;
    while (i != m_source_map.constEnd()) {

        QString src = i.key();
        QString sym = i.value();
        if (rv.indexOf(sym) != -1) {
            QString nrv = rv.replace(sym, src, Qt::CaseSensitive);
            rv = nrv;
        }

        i++;
    }
return rv;
}
