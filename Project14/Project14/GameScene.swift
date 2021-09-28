//
//  GameScene.swift
//  Project14
//
//  Created by An Var on 09.09.2021.
//

import SpriteKit

var slots = [WhackSlot]()
var gameScore: SKLabelNode!
var popupTime = 0.85
//счетчик раундов
var numRounds = 0

var score = 0 {
    didSet {
        gameScore.text = "Score: \(score)"
    }
}

class GameScene: SKScene {
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "whackBackground")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)

        gameScore = SKLabelNode(fontNamed: "Chalkduster")
        gameScore.text = "Score: 0"
        gameScore.position = CGPoint(x: 8, y: 8)
        gameScore.horizontalAlignmentMode = .left
        gameScore.fontSize = 48
        addChild(gameScore)
        
        for i in 0 ..< 5 { createSlot(at: CGPoint(x: 100 + (i * 170), y: 410)) }
        for i in 0 ..< 4 { createSlot(at: CGPoint(x: 180 + (i * 170), y: 320)) }
        for i in 0 ..< 5 { createSlot(at: CGPoint(x: 100 + (i * 170), y: 230)) }
        for i in 0 ..< 4 { createSlot(at: CGPoint(x: 180 + (i * 170), y: 140)) }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.createEnemy()
        }
    }

    func createEnemy() {
        //Каждый раз, когда вызывается createEnemy (), мы собираемся добавить 1 к свойству numRounds. Когда оно будет больше или равно 30, мы закончим игру: спрячем все слоты, покажем спрайт «Игра окончена», затем выйдем из метода.
        numRounds += 1

        if numRounds >= 30 {
            for slot in slots {
                slot.hide()
            }

            let gameOver = SKSpriteNode(imageNamed: "gameOver")
            gameOver.position = CGPoint(x: 512, y: 384)
            gameOver.zPosition = 1
            addChild(gameOver)
            
            let scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
            scoreLabel.fontSize = 60
            scoreLabel.text = "Score: \(score)"
            scoreLabel.horizontalAlignmentMode = .center
            scoreLabel.position = CGPoint(x: 512, y: 300)
            scoreLabel.zPosition = 1
            addChild(scoreLabel)
            
            gameScore.isHidden = true
            
            run(SKAction.playSoundFileNamed("GameOver.wav", waitForCompletion: false))

            return
        }
        
        popupTime *= 0.991

        slots.shuffle()
        slots[0].show(hideTime: popupTime)

        if Int.random(in: 0...12) > 4 { slots[1].show(hideTime: popupTime) }
        if Int.random(in: 0...12) > 8 {  slots[2].show(hideTime: popupTime) }
        if Int.random(in: 0...12) > 10 { slots[3].show(hideTime: popupTime) }
        if Int.random(in: 0...12) > 11 { slots[4].show(hideTime: popupTime)  }

        let minDelay = popupTime / 2.0
        let maxDelay = popupTime * 2
        let delay = Double.random(in: minDelay...maxDelay)

        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            self?.createEnemy()
        }
        
    }
    
    func createSlot(at position: CGPoint) {
        let slot = WhackSlot()
        slot.configure(at: position)
        addChild(slot)
        slots.append(slot)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)
        
        for node in tappedNodes {
            //Он получает родительский элемент родительского узла и приводит его как WhackSlot. Эта строка необходима, потому что игрок нажал на узел спрайта пингвина, а не на слот - нам нужно получить родительский узел пингвина, который является узлом обрезки, внутри которого он находится, а затем получить родительский узел узла обрезки, которым является WhackSlot. объект, что и делает этот код.
            guard let whackSlot = node.parent?.parent as? WhackSlot else { continue }
            if !whackSlot.isVisible { continue }
            if whackSlot.isHit { continue }
            whackSlot.hit()

            if node.name == "charFriend" {
                score -= 5

                //метод SKAction playSoundFileNamed (), который воспроизводит звук и, возможно, ожидает, пока звук закончится, прежде чем продолжить
                run(SKAction.playSoundFileNamed("whackBad.caf", waitForCompletion: false))
            } else if node.name == "charEnemy" {
                //установливаем свойства xScale и yScale нашего узла персонажа, чтобы плохой персонаж уменьшился, как если бы он был поражен.
                whackSlot.charNode.xScale = 0.85
                whackSlot.charNode.yScale = 0.85
                score += 1

                run(SKAction.playSoundFileNamed("whack.caf", waitForCompletion: false))
            }
        }
    }
}
