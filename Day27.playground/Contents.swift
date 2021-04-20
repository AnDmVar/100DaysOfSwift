import UIKit

class Singer {
    func playSong() {
        print("Shake it off!")
    }
}
func sing() -> () -> Void {
    let taylor = Singer()

    let singing = {
        taylor.playSong()
        return
    }

    return singing
}
let singFunction = sing()
singFunction()

//«Слабый» захват (weak capturing)
func sing1() -> () -> Void {
    let taylor = Singer()

    let singing = { [weak taylor] in
        taylor?.playSong()
        return
    }

    return singing
}
let singFunction1 = sing1()
singFunction1()

//«Бесхозный» захват (unowned capturing)
func sing2() -> () -> Void {
    let taylor = Singer()

    let singing = { [unowned taylor] in
        taylor.playSong()
        return
    }

    return singing
}
let singFunction2 = sing2()
    //singFunction2()

//Копирование замыканий и разделение захваченных значений
var numberOfLinesLogged = 0

let logger1 = {
    numberOfLinesLogged += 1
    print("Lines logged: \(numberOfLinesLogged)")
}

logger1()

let logger2 = logger1
logger2()
logger1()
logger2()

//В каких случаях использовать «сильный» захват, «слабый» и «бесхозный»
/* 1. Если вы уверены, что захваченное значение никогда не станет nil при выполнении замыкания, вы можете использовать «unowned capturing». Это нечастая ситуация, когда использование «слабого» захвата может вызвать дополнительные сложности, даже при использовании внутри замыкания guard let к слабо захваченному значению.
2. Если у вас случай цикла сильных ссылок (сущность А владеет сущностью B, а сущность B владеет сущностью А), то в одном из случаев нужно использовать «слабый» захват («weak capturing»). Необходимо принять во внимание, какая из двух сущностей будет освобождена первой, так что если view controller A представляет view controller B, то view controller B может содержать «слабую» ссылку назад к «А».
3. Если возможность цикла сильных ссылок исключена, вы можете использовать «сильный» захват («strong capturing»). Например, выполнение анимации не приводит к блокированию self внутри замыкания, содержащего анимацию, так что вы можете использовать «сильное» связывание.
4. Если вы не уверены, начните со «слабого» связывания и измените его только в случае необходимости.*/
