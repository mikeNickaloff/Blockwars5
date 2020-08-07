#ifndef BLOCKEVENT_H
#define BLOCKEVENT_H

#include <QObject>
#include <QtDebug>
#include <QString>
#include <QJSValue>
#include <QVariant>
class BlockEvent : public QObject
{
  Q_OBJECT

public:
  explicit BlockEvent(QObject *parent = nullptr, QString i_action = "wait", QStringList i_parameters = (QStringList() << "0"), bool i_isPublic = false);
  QStringList parameters() { return _parameters; }
  QString action() { return _action; }
  bool isPublic() { return _isPublic; }
  QString serialize();
 const QVariant operator=(BlockEvent* evt) { return QVariant::fromValue(evt->serialize()); }


signals:
  void eventStarted();
  void eventFinished();
  void requestAPISetGridState(QString i_state);
  void requestSendBlockEvent(QString blockEvent);
  void requestAPISetBlockState(int i_row, int i_col, QString i_state);
  void requestAPISetBlockColor(int i_row, int i_col, QString i_color);
  void requestAPIRemoveBlock(int i_row, int i_col);
  void requestAPICreateBlock(int i_row, int i_col);
    void requestAPIDropBlockDownOne(int i_row, int i_col);
    void requestAPISwapBlocks(int i_row1, int i_col1, int i_row2, int i_col2);
    void requestAPIMoveCompleted();
    void requestAPISync(QString);

public slots:
  void startEvent() { processEvent(); }
  void endEvent() { }

private:
  QString _action;
  QStringList _parameters;
  bool _isPublic;

private slots:
  void processEvent();

};

#endif // BLOCKEVENT_H
