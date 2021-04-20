//Initializers
struct User {
    var username: String
}
var user = User(username: "twostraws")
struct User1 {
    var username: String

    init() {
        username = "Anonymous"
        print("Creating a new user!")
    }
}
var user1 = User1()
user1.username = "twostraws"

//Referring to the current instance
struct Person {
    var name: String

    init(name: String) {
        print("\(name) was born!")
        self.name = name
    }
}

//Lazy properties
struct FamilyTree {
    init() {
        print("Creating family tree!")
    }
}
struct Person1 {
    var name: String
    var familyTree = FamilyTree()

    init(name: String) {
        self.name = name
    }
}

var ed = Person1(name: "Ed")
var familyTree = FamilyTree()
ed.familyTree

//Static properties and methods
struct Student {
    var name: String

    init(name: String) {
        self.name = name
    }
}

let ed1 = Student(name: "Ed")
let taylor = Student(name: "Taylor")
struct Student1 {
    static var classSize = 0
    var name: String

    init(name: String) {
        self.name = name
        Student1.classSize += 1
    }
}
print(Student1.classSize)

//Access control
struct Person2 {
    var id: String

    init(id: String) {
        self.id = id
    }
}

let ed2 = Person2(id: "12345")
struct Person3 {
    private var id: String

    init(id: String) {
        self.id = id
    }
}
struct Person4 {
    private var id: String

    init(id: String) {
        self.id = id
    }

    func identify() -> String {
        return "My social security number is \(id)"
    }
}
