#ifndef BLOCKDATA_H
#define BLOCKDATA_H

#include <QObject>
#include <QHash>
class BlockManager : public QObject
{
    Q_OBJECT
public:
    explicit BlockManager(QObject *parent = nullptr);
    QHash<int, QString> m_block_ids;
    QHash<QString, QString> m_block_colors;
    QHash<QString, int> m_block_health;
    QHash<QString, int> m_block_rows;
    QHash<QString, int> m_block_cols;
    QHash<QString, int> m_block_frozen_rounds;
    QHash<QString, int> m_block_burning_rounds;
    QHash<QString, int>  m_block_invulnerable_rounds;
    QHash<QString, bool>  m_block_destroyed;
    QHash<QString, QString> m_block_hero;
    QHash<QString, QString> m_symbol_map;
    QHash<QString, QString> m_source_map;
    QStringList filterBlocksByRow(int rowNum);
    QStringList filterBlocksByCol(int colNum);
    QList<int> mapBlocksToRows(QStringList blockList);
    QList<int> mapBlocksToCols(QStringList blockList);
    QStringList mapBlocksToColors(QStringList blockList);
    QString mapColorsToCheckTable(QStringList colorList,QString color);
    QStringList filterDuplicateStrings(QStringList stringList);
    int numRows;
    int numCols;
   QString serialize(QString uuid);
   QString serialize();
   QString serialize(QStringList ids);
   QString serializeRow(int row);
   QString serializeRows(QList<int> rows);
   QString lastSyncedSerialData;
   QString findFirstUuidAtPosition(int row, int col);
   QStringList m_colors;
   QString encodeSerialData(QString serialdata);
   QString decodeSerialData(QString encodedData);
signals:
    void notifyGameEngine(QString command, QString args);
public slots:
    void preFillBlocks();
    bool checkAndDropRow(int rowNum);
    void createBlock(int colNum);
    void deserialize(QString serialdata);
    void destroyBlock(QString uuid);
     QStringList swapBlocks(QString args);
     QStringList findMatchingBlocks();


};

#endif // BLOCKDATA_H
