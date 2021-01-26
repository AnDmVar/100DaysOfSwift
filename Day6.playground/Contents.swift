//Creating basic closures
let driving = {
    print("I'm driving in my car")
}
driving()

//Accepting parameters in a closure
let driving1 = { (place: String) in
    print("I'm going to \(place) in my car")
}
driving1("London")

//Returning values from a closure
let driving3 = { (place: String) in
    print("I'm going to \(place) in my car")
}
let drivingWithReturn = { (place: String) -> String in
    return "I'm going to \(place) in my car"
}
let message = drivingWithReturn("London")
print(message)

//Closures as parameters
let driving4 = {
    print("I'm driving in my car")
}
func travel(action: () -> Void) {
    print("I'm getting ready to go.")
    action()
    print("I arrived!")
}
travel(action: driving4)

//Trailing closure syntax
func travel1(action: () -> Void) {
    print("I'm getting ready to go.")
    action()
    print("I arrived!")
}
travel1() {
    print("I'm driving in my car")
}
travel1 {
    print("I'm driving in my car")
}

//Using closures as parameters when they accept parameters
func travel2(action: (String) -> Void) {
    print("I'm getting ready to go.")
    action("London")
    print("I arrived!")
}
travel2 { (place: String) in
    print("I'm going to \(place) in my car")
}

//Using closures as parameters when they return values
func travel3(action: (String) -> String) {
    print("I'm getting ready to go.")
    let description = action("London")
    print(description)
    print("I arrived!")
}
travel3 { (place: String) -> String in
    return "I'm going to \(place) in my car"
}

//Shorthand parameter names
func travel4(action: (String) -> String) {
    print("I'm getting ready to go.")
    let description = action("London")
    print(description)
    print("I arrived!")
}
travel4 { (place: String) -> String in
    return "I'm going to \(place) in my car"
}
travel4 { place -> String in
    return "I'm going to \(place) in my car"
}
travel4 { place in
    return "I'm going to \(place) in my car"
}
travel4 { place in
    "I'm going to \(place) in my car"
}
travel4 {
    "I'm going to \($0) in my car"
}

//Closures with multiple parameters
func travel5(action: (String, Int) -> String) {
    print("I'm getting ready to go.")
    let description = action("London", 60)
    print(description)
    print("I arrived!")
}
travel5 {
    "I'm going to \($0) at \($1) miles per hour."
}

//Returning closures from functions
func travel6() -> (String) -> Void {
    return {
        print("I'm going to \($0)")
    }
}
let result = travel6()
result("London")
let result2 = travel6()("London")

//Capturing values
func travel7() -> (String) -> Void {
    return {
        print("I'm going to \($0)")
    }
}
let result1 = travel7()
result1("London")
func travel8() -> (String) -> Void {
    var counter = 1

    return {
        print("\(counter). I'm going to \($0)")
        counter += 1
    }
}
result1("London")
result1("London")
result1("London")
