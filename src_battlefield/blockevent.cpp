#include "blockevent.h"
#include <QDebug>


BlockEvent::BlockEvent(QObject *parent, QString i_action, QStringList i_parameters, bool i_isPublic)
{
  this->_action = i_action;
  this->_parameters << (QStringList() << i_parameters);

  this->_isPublic = i_isPublic;
}

QString BlockEvent::serialize()
{
  QString rv;
  rv = QString("%1!%2").arg(action()).arg(parameters().join(","));
  return rv;
}


void BlockEvent::processEvent()
{
//  qDebug() << "starting block event" << serialize();
  QStringList params; params << parameters();
  if (this->action() == "setGridState") { if (params.count() >= 1) { emit requestAPISetGridState(parameters().join("")); } }
  if (this->action() == "setBlockState") { if (params.count() >= 3) { int row = params.takeFirst().toInt(); int col = params.takeFirst().toInt(); QString i_state = params.join(""); emit this->requestAPISetBlockState(row, col, i_state); } }
  if (this->action() == "removeBlock") { if (params.count() >= 2) { emit this->requestAPIRemoveBlock(params.takeFirst().toInt(), params.takeFirst().toInt());  } }
  if (this->action() == "createBlock") { if (params.count() >= 2) { emit this->requestAPICreateBlock(params.takeFirst().toInt(), params.takeFirst().toInt());  } }
  if (this->action() == "setBlockColor") { if (params.count() >= 3) { int row = params.takeFirst().toInt(); int col = params.takeFirst().toInt(); QString i_color = params.join(""); emit this->requestAPISetBlockColor(row, col, i_color); } }
  if (this->action() == "dropBlockDownOne") { if (params.count() >= 2) { emit this->requestAPIDropBlockDownOne(params.takeFirst().toInt(), params.takeFirst().toInt());  } }
  if (this->action() == "swapBlocks") { if (params.count() >= 4) { emit this->requestAPISwapBlocks(params.takeFirst().toInt(), params.takeFirst().toInt(), params.takeFirst().toInt(), params.takeFirst().toInt());  } }
  if (this->action() == "sync") { if (params.count() > 0) { emit this->requestAPISync(params.join("")); } }
  if (this->action() == "moveCompleted") { emit this->requestAPIMoveCompleted(); }
  if (isPublic()) {
      requestSendBlockEvent(serialize());
    }
 this->endEvent();


}
