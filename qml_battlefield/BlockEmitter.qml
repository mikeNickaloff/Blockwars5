import QtQuick 2.0
import QtQuick.Particles 2.0

Emitter {
    objectName: "ParticleA"
    width: 10
    height: 15

    z: 2010
    enabled: false
    group: ""
    emitRate: 50
    maximumEmitted:7
    startTime: 0
    lifeSpan: 1000
    lifeSpanVariation: 500
    size: 80
    sizeVariation: 26
    endSize: 6
    velocityFromMovement: 817
    system: particleSystem
    velocity:
        AngleDirection {
            angle: -90
            angleVariation: 60
            magnitude: 0
            magnitudeVariation: 224
        }
    acceleration:
        CumulativeDirection {}
    shape:
        MaskShape {
            source: "qrc:///images/bignuke.png"
        }
}
