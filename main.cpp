#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickWindow>
#include <QQmlContext>
#include <QSysInfo>
#include <QtDebug>
#include "src_input/player.h"
#include "src_network/zip.h"
#include "src_battlefield/internalgamegrid.h"
#include "src_battlefield/blockevent.h"
#include "src_battlefield/gameengine.h"
int main(int argc, char *argv[])
{


  QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
  QCoreApplication::setAttribute(Qt::AA_UseOpenGLES);

    QGuiApplication app(argc, argv);
  // QQuickWindow::setSceneGraphBackend(QSGRendererInterface::VulkanRhi);
    Zip* zip = new Zip;
    QQmlApplicationEngine engine;
    engine.addImportPath("qrc:///");
    qmlRegisterType<Player>("org.nodelogic.blockwars", 4, 0, "Player");
    qmlRegisterType<InternalGameGrid>("org.nodelogic.blockwars", 4, 0, "InternalGameGrid");
    qmlRegisterType<BlockEvent>("org.nodelogic.blockwars", 4, 0, "BlockEvent");
    qmlRegisterType<GameEngine>("org.nodelogic.blockwars", 4, 0, "GameEngine");
    engine.rootContext()->setContextProperty("PARTICLE_EXPLOSION_COUNT", QVariant::fromValue(PARTICLE_EXPLOSION_COUNT));
    engine.rootContext()->setContextProperty("BUILD_TYPE", QSysInfo::buildCpuArchitecture());
      engine.rootContext()->setContextProperty("Zip", zip);
    const QUrl url(QStringLiteral("qrc:/main.qml"));

    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
        &app, [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
