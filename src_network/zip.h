#ifndef ZIP_H
#define ZIP_H

#include <QObject>

class Zip : public QObject
{
  Q_OBJECT
public:
  explicit Zip(QObject *parent = nullptr);
  Q_INVOKABLE QString compress(QString input);
  Q_INVOKABLE QString decompress(QString input);
  Q_INVOKABLE QString randomString(int i_length);

};

#endif // ZIP_H
