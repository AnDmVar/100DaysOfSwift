//
//  WhackSlot.swift
//  Project14
//
//  Created by An Var on 09.09.2021.
//

import SpriteKit
import UIKit

class WhackSlot: SKNode {
    
    var isVisible = false
    var isHit = false
    var charNode: SKSpriteNode!
    
    func configure(at position: CGPoint) {
        self.position = position

        let sprite = SKSpriteNode(imageNamed: "whackHole")
        addChild(sprite)
        
        //Сначала мы создаем новый SKCropNode и размещаем его немного выше, чем сам слот. Число 15 не случайно - это точное количество точек, необходимое для того, чтобы узел обрезки идеально совпадал с графикой отверстий.
        let cropNode = SKCropNode()
        cropNode.position = CGPoint(x: 0, y: 15)
        //Мы также присваиваем узлу кадрирования значение zPosition, равное 1, помещая его перед другими узлами, что предотвращает его появление за отверстием.
        cropNode.zPosition = 1
        cropNode.maskNode = SKSpriteNode(imageNamed: "whackMask")

        //Затем мы создаем узел персонажа, давая ему изображение «penguinGood»
        charNode = SKSpriteNode(imageNamed: "penguinGood")
        //Это установлено на -90, что намного ниже отверстия, как если бы пингвин правильно прятался
        charNode.position = CGPoint(x: 0, y: -90)
        charNode.name = "character"
        //узел символа добавлен к узлу кадрирования, а узел кадрирования был добавлен в слот. Это связано с тем, что узел обрезки обрезает только узлы, которые находятся внутри него, поэтому нам нужна четкая иерархия: слот имеет отверстие и узел обрезки как дочерние элементы, а узел обрезки имеет узел символа как дочерний.
        cropNode.addChild(charNode)

        addChild(cropNode)
    }
    
    func show(hideTime: Double) {
        if isVisible { return }
        
        charNode.xScale = 1
        charNode.yScale = 1

        charNode.run(SKAction.moveBy(x: 0, y: 80, duration: 0.05))
        isVisible = true
        isHit = false

        if Int.random(in: 0...2) == 0 {
            charNode.texture = SKTexture(imageNamed: "penguinGood")
            charNode.name = "charFriend"
        } else {
            charNode.texture = SKTexture(imageNamed: "penguinEvil")
            charNode.name = "charEnemy"
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + (hideTime * 3.5)) { [weak self] in
            self?.hide()
        }
        
        if let spark = SKEmitterNode(fileNamed: "mud") {
            spark.position = charNode.position
            addChild(spark)
        }
        
    }
    func hide() {
        if !isVisible { return }

        charNode.run(SKAction.moveBy(x: 0, y: -80, duration: 0.05))
        isVisible = false
    }
    func hit() {
        isHit = true
        
        //SKAction.wait (forDuration :) создает действие, ожидающее в течение периода времени, измеряемого в секундах.
        let delay = SKAction.wait(forDuration: 0.25)
        let hide = SKAction.moveBy(x: 0, y: -80, duration: 0.5)
        //Чтобы завершить этот проект, нам все еще нужно сделать два основных компонента: позволить игроку нажать на пингвина, чтобы набрать очки, а затем позволить игре закончиться через некоторое время. Прямо сейчас это никогда не заканчивается, поэтому, когда popupTime становится все меньше и меньше, это означает, что игра станет невозможной через несколько минут.
        let notVisible = SKAction.run { [unowned self] in self.isVisible = false }
        //SKAction.sequence () принимает массив действий и выполняет их по порядку. Каждое действие не будет выполняться, пока не завершится предыдущее.
        charNode.run(SKAction.sequence([delay, hide, notVisible]))
        
        if let spark = SKEmitterNode(fileNamed: "spark") {
            spark.position = charNode.position
            addChild(spark)
        }
    }
}
