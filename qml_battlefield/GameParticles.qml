import QtQuick 2.4
import QtQuick.Particles 2.0


    ParticleSystem {
        id: particleSystem
        z: 2000
        anchors.fill: parent
        ImageParticle {
        objectName: "A"
        groups: [""]
        source: "qrc:///images/particles/metaldot.png"
        color: "#f1b065"
        colorVariation: 0
        alpha: 0.5
        alphaVariation: 0.5
        redVariation: 0
        greenVariation: 0
        blueVariation: 0
        rotation: 0
        rotationVariation: 101
        autoRotation: false
        rotationVelocity: 0
        rotationVelocityVariation: 268
        entryEffect: ImageParticle.Scale
        system: particleSystem
    }
//        ImageParticle {
//            id: smoke
//            system: particleSystem
//            width: 64
//            height: 64
//            groups: ["B"]
//            source: "qrc:///images/particles/particle.png"

//            colorVariation: 0
//            color: "#00111111"
//             entryEffect: ImageParticle.Fade
//             alpha: 1.0
//             opacity: 1.0
//        }

//        TrailEmitter {
//            id: fireSmoke
//            group: "B"
//            system: particleSystem
//            follow: ""
//            enabled: false
//            width: 128
//            height: 128
//            z: 140
//            emitRatePerParticle:1
//            lifeSpan: 1000
//            startTime: 0

//            velocity: PointDirection {y:47; yVariation: -7; xVariation: 30}
//            acceleration: PointDirection {xVariation: 0}

//            size: 100
//            sizeVariation: 10
//            endSize:25

//        }


//    Gravity {
//        objectName: ""
//     anchors.fill: parent
//        width: 400
//        height: 400
//        enabled: true
//        groups: [""]
//        whenCollidingWith: [""]
//        once: true
//        angle: 90
//        magnitude: 50
//        system: particleSystem
//        shape:
//            RectangleShape {}
//    }
    }

