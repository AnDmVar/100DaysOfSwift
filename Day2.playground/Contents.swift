import UIKit

// MARK: Arrays - массивы

/*
 Массив (Array) — это упорядоченная коллекция однотипных элементов, для доступа к которым используются целочисленные индексы.
 */

let john = "John Lennon"
let paul = "Paul McCartney"
let george = "George Harrison"
let ringo = "Ringo Starr"
let beatles = [john, paul, george, ringo]

//доступ к элементам массива
beatles[1]

// неизменяемый массив с элементами типа String
let alphabetArray = ["a", "b", "c"]
// изменяемый массив с элементами типа Int
var mutableArray = [2, 4, 8]

// создание массива с помощью передачи списка значений
let newAlphabetArray = Array(arrayLiteral: "a", "b", "c")
newAlphabetArray

// создание массива с помощью оператора диапазона
let lineArray = Array(0...9)
lineArray

//Создание массива с повторяющимися значениями
let repeatArray = Array(repeating: "Ура", count: 3)
repeatArray

// изменение элемента массива
mutableArray[1] = 16

var stringsArray = ["one", "two", "three", "four"]
// изменение нескольких элементов
stringsArray[1...2] = ["five"]
stringsArray

// объявляем массив с пустым значением с помощью переданного значения
let emptyArray: [String] = [] // []
// объявляем массив с пустым значением с помощью специальной функции
let anotherEmptyArray = [String]() // []
// создание пустого многомерного массива
let emptyMArray: [[Int]] = []

//слияние нескольких массивов
// создаем три массива
let charsOne = ["a", "b", "c"]
let charsTwo = ["d", "e", "f"]
let charsThree = ["g", "h", "i"]
// создаем новый слиянием двух
var alphabet = charsOne + charsTwo
// сливаем новый массив с третьим
alphabet += charsThree
alphabet

//многомерные массивы
var arrayOfArrays = [[1,2,3], [4,5,6], [7,8,9]]
// получаем вложенный массив
arrayOfArrays[2]
// получаем элемент вложенного массива
arrayOfArrays[2][1]





// MARK: Sets - Множества (Наборы)

/*
Множество (Set) — это неупорядоченная коллекция уникальных элементов. В отличие от массивов, у элементов множества нет четкого порядка следования, важен лишь факт наличия некоторого значения в множестве. Определенное значение элемента может существовать в нем лишь единожды, то есть каждое значение в пределах одного множества должно быть уникальным.
 */

let mySet: Set<Int> = [1,5,0]
let mySet1 = Set<Int>(arrayLiteral: 5,66,12)
let mySet2 = Set(arrayLiteral: 5,66,12)
let mySet3: Set = [1,5,0]
let colors = Set(["red", "green", "blue"])
let colors2 = Set(["red", "green", "blue", "red", "blue"])

// создание пустого множества
let emptySet = Set<String>()
var musicStyleSet: Set<String> = []
// множество со значениями
var setWithValues: Set<String> = ["хлеб", "овощи"]
// удаление всех элементов множества
setWithValues = []
setWithValues // Set([])

//добавление нового элемента
musicStyleSet.insert("Jazz")
//удаление всех элементов множества
musicStyleSet.removeAll()

// проверка существования значения во множестве
colors2.contains("Funk")

//сортировка множества
let setOfNums: Set = [1,10,2,5,12,23]
let sortedArray = setOfNums.sorted()





// MARK: Tuples - Кортежи

/*
 Кортеж (tuple) — это объект, который группирует значения различных типов в пределах одного составного значения. При этом у вас есть возможность обратиться к каждому элементу кортежа напрямую, по его идентификатору (индексу).
 */

var name = (first: "Taylor", last: "Swift")
// объявление кортежа с явно заданным типом
let myProgramStatus: (statusCode: Int, statusText: String, statusConnect: Bool) = (200, "In Work", true)
myProgramStatus

//Доступ к элементам кортежа через индексы
myProgramStatus.0
name.0
name.first

//Доступ к элементам кортежа через имена
myProgramStatus.statusCode

// запись значения кортежа в переменные
let (statusCode, statusText, statusConnect) = myProgramStatus
// вывод информации
print("Код ответа — \(statusCode)")
print("Текст ответа — \(statusText)")
print("Связь с сервером — \(statusConnect)")

//запись значения необходимого значения кортежа
let (statusCode2, _, _) = myProgramStatus
statusCode2

var someTuple = (200, true)
// изменение значения отдельного элемента
someTuple.0 = 404
someTuple.1 = false





// MARK: Arrays vs sets vs tuples
let address = (house: 555, street: "Taylor Swift Avenue", city: "Nashville") //Tuple
let set = Set(["aardvark", "astronaut", "azalea"]) //Set
let pythons = ["Eric", "Graham", "John", "Michael", "Terry", "Terry"] //Array





// MARK: Dictionaries - Словари
/*
Словарь — это неупорядоченная коллекция элементов, для доступа к значениям которых используются специальные индексы, называемые ключами, уникальные для словаря значения, определяемое при инциализации самостоятельно. Каждый элемент словаря — это пара «ключ — значение.
 */
let dictionary = [
    "one":"один",
    "two": "два",
    "three":"три"
]
dictionary
dictionary["one"]

let heights = [
    "Taylor Swift": 1.78,
    "Ed Sheeran": 1.73
]
heights["Taylor Swift"]

Dictionary(dictionaryLiteral: (100, "Сто"), (200, "Двести"), (300, "Триста"))

// базовая коллекция кортежей (пар значений)
let baseCollection = [(2, 5), (3, 6), (1, 4)]
// создание словаря на основе базовой коллекции
let newDictionary = Dictionary(uniqueKeysWithValues: baseCollection)
newDictionary
newDictionary[1]
newDictionary[2]

/*
Результирующий словарь содержит в качестве ключей первый элемент каждой пары значений (каждого кортежа) базовой коллекции, а в качестве значений — второй элемент каждой пары значений.
*/

// Словарь с типом данных [Int:String]
let codeDesc = [
    200: "success",
    300: "warning",
    400: "error"
]
type(of: codeDesc)

//явное задание типа словаря
let dictOne: Dictionary<Int,Bool> = [
    100: false,
    200: true,
    400: true
]
var dictTwo: [String:String] = [
    "Jonh":"Dave",
    "Eleonor":"Green"
]

//получение значений словаря
dictTwo["Jonh"]
//изменение значений словаря
dictTwo["Jonh"] = "Bob"

//добавление нового элемента
dictTwo["Dod"] = "Sem"
dictTwo

//удаление элемента
dictTwo["Jonh"] = nil
dictTwo.removeValue(forKey: "Eleonor")

//создание пустого словаря
let emptyDictionary: [String:Int] = [:]
let anotherEmptyDictionary = Dictionary<String,Int>()

//получение всех ключей
dictOne.keys
//получение всех значений
dictOne.values





// MARK: Enumerations - Перечисления
/*
 Перечисление (enum) — это тип данных, содержащий множество альтернативных значений, каждое из которых может быть проинициализировано некоторому параметру.
 */
enum Result {
    case success
    case failure
}
let result4 = Result.failure

enum CurrencyUnit {
    case rouble
    case euro
}
var roubleCurrency: CurrencyUnit = .rouble
var otherCurrency = CurrencyUnit.euro
// поменяем значение одного из параметров на другой член перечисления
otherCurrency = .rouble

enum AdvancedCurrencyUnit1 {
    case rouble([String], String)
    case euro([String], String)
}

// дополненное перечисление
enum AdvancedCurrencyUnit {
    
    // страны, использующие доллар
    enum DollarCountries {
        case usa
        case canada
        case australia
    }
    
    case rouble(сountries: [String], shortName: String)
    case euro(сountries: [String], shortName: String)
    case dollar(nation: DollarCountries, shortName: String)
}
var dollarCurrency: AdvancedCurrencyUnit = .dollar( nation: .usa, shortName: "USD" )
let euroCurrency: AdvancedCurrencyUnit =  .euro(сountries: ["German", "France"], shortName: "EUR")

switch dollarCurrency {
case .rouble:
    print("Рубль")
case .euro(let countries, let shortname):
    print("Евро. Страны: \(countries). Краткое наименование: \(shortname)")
case .dollar(let nation, let shortname):
    print("Доллар \(nation). Краткое наименование: \(shortname)")
}

//задания связанных значений членов перечисления
enum Smile: String {
    case joy = ":)"
    case laugh = ":D"
    case sorrow = ":("
    case surprise = "o_O"
    
    //вычисляемое свойство
    var description: String { return self.rawValue }
}
let iAmHappy = Smile.joy
iAmHappy.rawValue
let mySmile: Smile = .sorrow
mySmile.description





// MARK: Enum associated values
enum Activity1 {
    case bored
    case running
    case talking
    case singing
}

enum Activity {
    case bored
    case running(destination: String)
    case talking(topic: String)
    case singing(volume: Int)
}
let talking = Activity.talking(topic: "football")





// MARK: Enum raw values
//если указать 1ое значение цифрой, то все остальные будут увеличиваться на 1
enum Planet: Int {
    case mercury = 1
    case venus
    case earth
    case mars
}
let earth = Planet(rawValue: 2)
earth
