//
//  GameScene.swift
//  Project17
//
//  Created by An Var on 29.09.2021.
//

import SpriteKit
import SceneKit

var starfield: SKEmitterNode!
var player: SKSpriteNode!

var numRounds = 0
var scoreLabel: SKLabelNode!
var score = 0 {
    didSet {
        scoreLabel.text = "Score: \(score)"
    }
}

//В массиве possibleEnemies содержатся названия трех изображений, которые можно использовать как космический мусор в игре: мяч, молот и телевизор
let possibleEnemies = ["ball", "hammer", "tv"]
//IsGameOver - это простое логическое значение, которому будет присвоено значение true, когда прекратим увеличивать счет игрока.
var isGameOver = false
//Он отвечает за запуск кода по истечении определенного периода времени, один или несколько раз.
var gameTimer: Timer?
var time: Double = 1.0

var newGameButton = SKLabelNode(fontNamed: "Chalkduster")
var gameOverLabel = SKLabelNode(fontNamed: "Chalkduster")
var messageLabel = SKLabelNode(fontNamed: "Chalkduster")

class GameScene: SKScene, SKPhysicsContactDelegate {
    override func didMove(to view: SKView) {
        backgroundColor = .black

        
        starfield = SKEmitterNode(fileNamed: "starfield")!
        //starfield расположен в точке X: 1024 Y: 384, которая является правым краем экрана и находится на полпути вверх. Если бы вы обычно создавали такие частицы, это выглядело бы странно, потому что большая часть экрана не начиналась бы с частиц, а они просто текли бы справа
        starfield.position = CGPoint(x: 1024, y: 384)
        //с помощью метода эмиттера advanceSimulationTime () мы попросим SpriteKit смоделировать 10 секунд, проходящих в эмиттере, таким образом обновляя все частицы, как если бы они были созданы 10 секунд назад. Это приведет к заполнению нашего экрана звездными частицами.
        starfield.advanceSimulationTime(10)
        addChild(starfield)
        starfield.zPosition = -1

        player = SKSpriteNode(imageNamed: "player")
        player.position = CGPoint(x: 100, y: 384)
        //поскольку космический корабль имеет неправильную форму, и объекты в космосе также имеют неправильную форму, мы собираемся использовать попиксельное обнаружение столкновений. Это означает, что столкновения происходят не на основе прямоугольников и кругов, а на основе фактических пикселей одного объекта, соприкасающихся с фактическими пикселями другого.
        //Если что-то можно создать в виде прямоугольника или круга, вы должны сделать это, потому что это намного быстрее.
        player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.size)
        //Установлиавем contactTestBitMask для нашего игрока равной 1. Это будет соответствовать BitMask категории, которую мы установим для космического мусора позже, и это означает, что мы будем уведомлены, когда игрок столкнется с обломками.
        player.physicsBody?.contactTestBitMask = 1
        addChild(player)

        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.horizontalAlignmentMode = .left
        addChild(scoreLabel)

        score = 0

        //Установить гравитацию в 0
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        //устанавливает нашу текущую игровую сцену в качестве контактного делегата физического мира
        physicsWorld.contactDelegate = self
        
        //указываете пять параметров: сколько секунд вы хотите, чтобы задержка была, какой объект должен быть сообщен при срабатывании таймера, какой метод должен быть вызван для этого объекта при срабатывании таймера, любой контекст, который вы хотите предоставить, и должно ли время повторяться.
        //интервал таймера 0,35 секунды, чтобы он создавал около трех врагов в секунду
        //scheduleTimer () не только создает таймер, но и запускает его немедленно.
        //gameTimer = Timer.scheduledTimer(timeInterval: 0.35, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
        startTimer()
    }
    
    func newGame() {
        player = SKSpriteNode(imageNamed: "player")
        player.position = CGPoint(x: 100, y: 384)
        //поскольку космический корабль имеет неправильную форму, и объекты в космосе также имеют неправильную форму, мы собираемся использовать попиксельное обнаружение столкновений. Это означает, что столкновения происходят не на основе прямоугольников и кругов, а на основе фактических пикселей одного объекта, соприкасающихся с фактическими пикселями другого.
        //Если что-то можно создать в виде прямоугольника или круга, вы должны сделать это, потому что это намного быстрее.
        player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.size)
        //Установлиавем contactTestBitMask для нашего игрока равной 1. Это будет соответствовать BitMask категории, которую мы установим для космического мусора позже, и это означает, что мы будем уведомлены, когда игрок столкнется с обломками.
        player.physicsBody?.contactTestBitMask = 1
        addChild(player)

        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.horizontalAlignmentMode = .left
        addChild(scoreLabel)

        score = 0
        time = 1
        isGameOver = false

        //Установить гравитацию в 0
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        //устанавливает нашу текущую игровую сцену в качестве контактного делегата физического мира
        physicsWorld.contactDelegate = self
        
        //указываете пять параметров: сколько секунд вы хотите, чтобы задержка была, какой объект должен быть сообщен при срабатывании таймера, какой метод должен быть вызван для этого объекта при срабатывании таймера, любой контекст, который вы хотите предоставить, и должно ли время повторяться.
        //интервал таймера 0,35 секунды, чтобы он создавал около трех врагов в секунду
        //scheduleTimer () не только создает таймер, но и запускает его немедленно.
        //gameTimer = Timer.scheduledTimer(timeInterval: 0.35, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
        startTimer()
    }
    
    func startTimer() {
        gameTimer = Timer.scheduledTimer(timeInterval: time, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
    }
    
    @objc func createEnemy() {
        numRounds += 1
        
        guard let enemy = possibleEnemies.randomElement() else { return }

        let sprite = SKSpriteNode(imageNamed: enemy)
        sprite.position = CGPoint(x: 1200, y: Int.random(in: 50...736))
        addChild(sprite)

        sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
        sprite.physicsBody?.categoryBitMask = 1
        sprite.physicsBody?.velocity = CGVector(dx: -500, dy: 0)
        sprite.physicsBody?.angularVelocity = 5
        //linearDamping и angularDamping = 0, что означает, что движение и вращение объекта никогда не будут замедляться со временем.
        sprite.physicsBody?.linearDamping = 0
        sprite.physicsBody?.angularDamping = 0
        
        if numRounds >= 20 {
            gameTimer?.invalidate()
            time -= 0.01
            startTimer()
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        for node in children {
            if node.position.x < -300 {
                node.removeFromParent()
            }
        }

        if !isGameOver {
            score += 1
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        var location = touch.location(in: self)

        if location.y < 100 {
            location.y = 100
        } else if location.y > 668 {
            location.y = 668
        }

        player.position = location
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if !isGameOver {
            gameOver("You crashed")
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !isGameOver {
            gameOver("""
            You took your finger
               off the screen!
            """)
        } else {
            let touch = touches.first
            let touchLocation = touch!.location(in: self)
            if newGameButton.contains(touchLocation) {
                gameOverLabel.removeFromParent()
                messageLabel.removeFromParent()
                newGameButton.removeFromParent()
                scoreLabel.isHidden = true
                newGame()
            }
        }
    }
    
    func gameOver(_ text: String) {
        let explosion = SKEmitterNode(fileNamed: "explosion")!
        explosion.position = player.position
        addChild(explosion)

        player.removeFromParent()
        gameTimer?.invalidate()
        isGameOver = true
        
        gameOverLabel.fontSize = 120
        gameOverLabel.text = "Game Over"
        gameOverLabel.horizontalAlignmentMode = .center
        gameOverLabel.position = CGPoint(x: 512, y: 600)
        gameOverLabel.zPosition = 1
        addChild(gameOverLabel)
        
        
        messageLabel.fontSize = 60
        messageLabel.fontColor = .red
        messageLabel.text = text
        messageLabel.numberOfLines = 0
        messageLabel.horizontalAlignmentMode = .center
        messageLabel.verticalAlignmentMode = .center
        messageLabel.position = CGPoint(x: 512, y: gameOverLabel.position.y - 150)
        messageLabel.zPosition = 1
        addChild(messageLabel)
        
        scoreLabel.fontName = "Chalkduster"
        scoreLabel.fontSize = 60
        scoreLabel.text = "Score: \(score)"
        scoreLabel.horizontalAlignmentMode = .center
        scoreLabel.position = CGPoint(x: 512, y: messageLabel.position.y - 150)
        scoreLabel.zPosition = 1
        
        newGameButton.fontSize = 40
        newGameButton.text = "New Game"
        newGameButton.fontColor = .green
        newGameButton.horizontalAlignmentMode = .center
        newGameButton.position = CGPoint(x: 512, y: scoreLabel.position.y - 150)
        newGameButton.zPosition = 1
        addChild(newGameButton)
    }
}
