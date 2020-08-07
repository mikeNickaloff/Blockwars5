#include "zip.h"
#include <QCryptographicHash>
#include <QUuid>

Zip::Zip(QObject *parent) : QObject(parent)
{

}

QString Zip::compress(QString input)
{
  QString rv = QString::fromLocal8Bit(input.toLocal8Bit().toBase64());
  //return input;
  return rv;
}

QString Zip::decompress(QString input)
{
  QString rv = QString::fromLocal8Bit(QByteArray::fromBase64((input.toLocal8Bit())));
  //return input;
  return rv;
}

QString Zip::randomString(int i_length)
{
  QString rv;
  QUuid uuid;
  QByteArray ba = uuid.createUuid().toByteArray();
  QCryptographicHash hash(QCryptographicHash::Sha1);
  hash.addData(ba);
  rv = QString::fromLocal8Bit(hash.result().toHex());
  rv.truncate(i_length);
  while (rv.length() < i_length) {
      ba = uuid.createUuid().toByteArray();
       hash.addData(ba);
        rv.append(QString::fromLocal8Bit(hash.result().toHex()));
        rv.truncate(i_length);
    }
  return rv;

}
