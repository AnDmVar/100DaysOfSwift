//
//  GameScene.swift
//  Project11
//
//  Created by An Var on 01.06.2021.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var scoreLabel: SKLabelNode!
    var balls = ["ballBlue", "ballYellow", "ballPurple", "ballGrey", "ballRed", "ballCyan", "ballGreen"]
    var availableBallsLabel: SKLabelNode!
    
    var lifes = 5 {
        didSet {
            availableBallsLabel.text = "Available balls: \(lifes)"
        }
    }
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var editLabel: SKLabelNode!

    var editingMode: Bool = false {
        didSet {
            if editingMode {
                editLabel.text = "Done"
            } else {
                editLabel.text = "Edit"
            }
        }
    }
    
    override func didMove(to view: SKView) {
        // загружает изображение
        let background = SKSpriteNode(imageNamed: "background.jpg")
        // устанавливаем позицию изображения
        background.position = CGPoint(x: 512, y: 384)
        //делает фон менее восприимчивым к другим непрозрачным объектам (чаще всего применяется к фонам, чтобы сделать загрузку быстрее)
        background.blendMode = .replace
        //нарисовать изображение за всеми остальными предметами
        background.zPosition = -1
        //Чтобы добавить любой узел в текущий экран, используете метод addChild()
        addChild(background)
        // добавляет физическое тело ко всей сцене, которая является линией на каждом краю, эффективно действуя как контейнер для сцены
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsWorld.contactDelegate = self
        
        makeBouncer(at: CGPoint(x: 0, y: 0))
        makeBouncer(at: CGPoint(x: 256, y: 0))
        makeBouncer(at: CGPoint(x: 512, y: 0))
        makeBouncer(at: CGPoint(x: 768, y: 0))
        makeBouncer(at: CGPoint(x: 1024, y: 0))
        
        makeSlot(at: CGPoint(x: 128, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 384, y: 0), isGood: false)
        makeSlot(at: CGPoint(x: 640, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 896, y: 0), isGood: false)
        
        //Мы используем шрифт Chalkduster, затем выравниваем ярлык вправо и помещаем его на правом верхнем крае сцены.
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: 980, y: 700)
        addChild(scoreLabel)
        
        editLabel = SKLabelNode(fontNamed: "Chalkduster")
        editLabel.text = "Edit"
        editLabel.position = CGPoint(x: 80, y: 700)
        addChild(editLabel)
        
        availableBallsLabel = SKLabelNode(fontNamed: "Chalkduster")
        availableBallsLabel.text = "Available balls: 5"
        availableBallsLabel.position = CGPoint(x: 490, y: 700)
        addChild(availableBallsLabel)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // если экран был затронут берем первое из касаний
        if let touch = touches.first {
            // находим точку, где именно было произведено касание
            let location = touch.location(in: self)
            
            // генерирует объект красного цвета размером 64х64
            //let box = SKSpriteNode(color: UIColor.red, size: CGSize(width: 64, height: 64))
            // создает физическое тело к боксу (то есть у него теперь есть края, до которых можно "дотрагиваться")
            //box.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 64, height: 64))
            // добавляет созданный объект в место касания
            //box.position = location
            // показывает объект
            //addChild(box)
            
            let objects = nodes(at: location)

            if objects.contains(editLabel) {
                editingMode.toggle()
            } else {
                if editingMode {
                    let size = CGSize(width: Int.random(in: 16...128), height: 16)
                    let box = SKSpriteNode(color: UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1), size: size)
                    box.name = "box"
                    // вращение элемента вокруг своей оси
                    box.zRotation = CGFloat.random(in: 0...3)
                    box.position = location

                    box.physicsBody = SKPhysicsBody(rectangleOf: box.size)
                    box.physicsBody?.isDynamic = false

                    addChild(box)
                } else {
                    if lifes > 0 {
                        //let ball = SKSpriteNode(imageNamed: "ballRed")
                        //задает шар рандомного цвета
                        let ball = SKSpriteNode(imageNamed: balls.randomElement() ?? "ballRed")
                        // задаем имя
                        ball.name = "ball"
                        // создаем круглое физическое тело
                        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0)
                        // collisionBitMask означает на что мяч должен наткнуться (по умолчанию на все), contactTestBitMask означает о какие касаниях должен сообщать (по умолчанию ни о каких)
                        // Таким образом, устанавливая contactTestBitMask на значение collisionBitMask, мы говорим: "Расскажите мне о каждом столкновении."
                        ball.physicsBody!.contactTestBitMask = ball.physicsBody!.collisionBitMask
                        // устанавливаем значение, на сколько сильно объекn будет взаимодействовать с другими объектами
                        ball.physicsBody?.restitution = 0.4
                        // добавляет созданный объект в место касания
                        //ball.position = location
                        // добавляет созданный объект в место касания по x с верху экрана
                        ball.position = CGPoint(x: location.x, y: 768)
                        // показывает объект
                        addChild(ball)
                        lifes -= 1
                    }
                }
            }
            
//            let ball = SKSpriteNode(imageNamed: "ballRed")
//            // задаем имя
//            ball.name = "ball"
//            // создаем круглое физическое тело
//            ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0)
//            // collisionBitMask означает на что мяч должен наткнуться (по умолчанию на все), contactTestBitMask означает о какие касаниях должен сообщать (по умолчанию ни о каких)
//            // Таким образом, устанавливая contactTestBitMask на значение collisionBitMask, мы говорим: "Расскажите мне о каждом столкновении."
//            ball.physicsBody!.contactTestBitMask = ball.physicsBody!.collisionBitMask
//            // устанавливаем значение, на сколько сильно объекс будет взаимодействовать с другими объектами
//            ball.physicsBody?.restitution = 0.4
//            // добавляет созданный объект в место касания
//            ball.position = location
//            // показывает объект
//            addChild(ball)
        }
    }
    
    // первое имя (at) - то, которое вы используете при вызове метода, а второе имя (position) - то, которое вы используете внутри метода.
    func makeBouncer(at position: CGPoint) {
        // создаем вышибалу, который будет стоять на месте
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        //задаем позицию, которая передается в функцию
        bouncer.position = position
        //Если данное значение true, то объект перемещается с помощью физического симулятора на основе гравитации и столкновений. Когда она ложная (как мы ее устанавливаем), объект все еще сталкивается с другими вещами, но в результате он никогда не будет перемещаться.
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2.0)
        //говорим, чтобы предмет не двигался
        bouncer.physicsBody?.isDynamic = false
        // показывает объект
        addChild(bouncer)
    }
    
    func makeSlot(at position: CGPoint, isGood: Bool) {
        var slotBase: SKSpriteNode
        var slotGlow: SKSpriteNode

        if isGood {
            slotBase = SKSpriteNode(imageNamed: "slotBaseGood")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowGood")
            slotBase.name = "good"
        } else {
            slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowBad")
            slotBase.name = "bad"
        }

        slotBase.position = position
        slotGlow.position = position
        
        // создает физическое тело равное размеру slotBase (то есть у него теперь есть края, до которых можно "дотрагиваться")
        slotBase.physicsBody = SKPhysicsBody(rectangleOf: slotBase.size)
        //говорим, чтобы предмет не двигался при соприкосновении
        slotBase.physicsBody?.isDynamic = false
        
        addChild(slotBase)
        addChild(slotGlow)
        
        // Углы указаны в радианах, а не в градусах. 360 градусов равно значению 2 x Pi
        let spin = SKAction.rotate(byAngle: .pi, duration: 10)
        // метод повторения
        let spinForever = SKAction.repeatForever(spin)
        slotGlow.run(spinForever)
    }
    
    func collisionBetween(ball: SKNode, object: SKNode) {
        if object.name == "good" {
            destroy(object: ball)
            score += 1
            lifes += 1
        } else if object.name == "bad" {
            destroy(object: ball)
            score -= 1
        } else if object.name == "box" {
            destroy(object: object)
        }
    }

    func destroy(object: SKNode) {
        // Класс SKEmitterNode является новым и мощным: он предназначен для создания высокопроизводительных эффектов частиц в играх SpriteKit, и все, что вам нужно сделать, это предоставить ему имя файла частиц, которые вы разработали, и он сделает все остальное.
        if let fireParticles = SKEmitterNode(fileNamed: "FireParticles") {
            // помещаем элемент fireParticles на место объекта
                fireParticles.position = object.position
            // показываем на сцене
                addChild(fireParticles)
            }
        
        //удаляет объект с экрана
        object.removeFromParent()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }

        if nodeA.name == "ball" {
            collisionBetween(ball: nodeA, object: nodeB)
        } else if nodeB.name == "ball" {
            collisionBetween(ball: nodeB, object: nodeA)
        }
    }
}
