//Creating your own classes
class Dog {
    var name: String
    var breed: String

    init(name: String, breed: String) {
        self.name = name
        self.breed = breed
    }
}
let poppy = Dog(name: "Poppy", breed: "Poodle")

//Class inheritance
class Dog1 {
    var name: String
    var breed: String

    init(name: String, breed: String) {
        self.name = name
        self.breed = breed
    }
}
class Poodle: Dog1 {
    init(name: String) {
        super.init(name: name, breed: "Poodle")
    }
}

//Overriding methods
class Dog2 {
    func makeNoise() {
        print("Woof!")
    }
}
class Poodle1: Dog2 {
    override func makeNoise() {
        print("Yip!")
    }
}
let poppy1 = Poodle1()
poppy1.makeNoise()

//Final classes
final class Dog3 {
    var name: String
    var breed: String

    init(name: String, breed: String) {
        self.name = name
        self.breed = breed
    }
}

//Copying objects
class Singer {
    var name = "Taylor Swift"
}
var singer = Singer()
print(singer.name)
var singerCopy = singer
singerCopy.name = "Justin Bieber"
print(singer.name)
struct Singer1 {
    var name = "Taylor Swift"
}

//Deinitializers
class Person {
    var name = "John Doe"

    init() {
        print("\(name) is alive!")
    }

    func printGreeting() {
        print("Hello, I'm \(name)")
    }
    deinit {
        print("\(name) is no more!")
    }
    
}
for _ in 1...3 {
    let person = Person()
    person.printGreeting()
}

//Mutability
class Singer2 {
    var name = "Taylor Swift"
}

let taylor2 = Singer2()
taylor2.name = "Ed Sheeran"
print(taylor2.name)

class Singer3 {
    let name = "Taylor Swift"
}
