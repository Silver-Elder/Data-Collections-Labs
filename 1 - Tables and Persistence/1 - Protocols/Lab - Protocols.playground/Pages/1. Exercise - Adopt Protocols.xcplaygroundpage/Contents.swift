/*:
## Exercise - Adopt Protocols: CustomStringConvertible, Equatable, and Comparable
 
 Create a `Human` class with two properties: `name` of type `String`, and `age` of type `Int`. You'll need to create a memberwise initializer for the class. Initialize two `Human` instances.
 */

import Foundation


class Human: CustomStringConvertible, Equatable, Comparable, Encodable {
    var description: String {
        "\(name) is \(age) years old."
    }
    // this 'CustomStringConvertible' protocol allows me to print a description of the name and age properties of my class. If I just try and print my instances of 'adam' and 'sterling' without using this protocol, I get "__lldb_expr_205.Human" as my printed reult
    
    static func == (lhs: Human, rhs: Human) -> Bool {
        lhs.name == rhs.name && lhs.name == rhs.name
    }
    // this 'Equetable' protocol allows me to check wheter one or more of my 'Human' properties are the same when comparing two 'Human' instances. If I try to printwhether my two instances of 'adam' and sterling' are not equal without using this protocol, I get an error "Binary operator '!=' cannot be applied to two 'Human2' operands".
    
    static func < (lhs: Human, rhs: Human) -> Bool {
        lhs.name < rhs.name
    }
    //This protocol allows the computer to compare whether one 'Human' instance is greater than another based on the 'Human's .name property. If I try and use the "sort(by:)" method on my 'sortedPeaple' constant (see line 70), without implementing this 'Comparable' protocol, I get an error on my 'sortedPeople' constant; "No exact matches in reference to operator function '>'".
    
    let name: String
    let age: Int
    
    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
}

let atlas = Human(name: "Atlas", age: 22)

let sterling = Human(name: "Sterling", age: 21)

let sterlingsClone = Human(name: "Sterling", age: 21)

let kyle = Human(name: "Kyle", age: 19)

let hallie = Human(name: "Hallie", age: 17)

//class Human2 {
//    let name: String
//    let age: Int
//
//    init(name: String, age: Int) {
//        self.name = name
//        self.age = age
//    }
//}
//
//let adam2 = Human2(name: "Adam", age: 22)
//let sterling2 = Human2(name: "Sterling", age: 21)
//print(adam2)
//print(sterling2)
//print(sterling2 != adam2)
//:  Make the `Human` class adopt the `CustomStringConvertible` protocol. Print both of your previously initialized `Human` objects.
// See line 6 and the variable on line 7-9

print(atlas)
print(sterling)
//:  Make the `Human` class adopt the `Equatable` protocol. Two instances of `Human` should be considered equal if their names and ages are identical to one another. Print the result of a boolean expression evaluating whether or not your two previously initialized `Human` objects are equal to eachother (using `==`). Then print the result of a boolean expression evaluating whether or not your two previously initialized `Human` objects are not equal to eachother (using `!=`).
// See line 6 and teh static fun on lines 11-13

print(sterling == atlas)
print(sterling != atlas)
print(sterling == sterlingsClone)
//:  Make the `Human` class adopt the `Comparable` protocol. Sorting should be based on age. Create another three instances of a `Human`, then create an array called `people` of type `[Human]` with all of the `Human` objects that you have initialized. Create a new array called `sortedPeople` of type `[Human]` that is the `people` array sorted by age.
let people: [Human] = [atlas, sterling, sterlingsClone, kyle, hallie]

let sortedPeople = people.sorted(by: <)
print(sortedPeople)
//:  Make the `Human` class adopt the `Codable` protocol. Create a `JSONEncoder` and use it to encode as data one of the `Human` objects you have initialized. Then use that `Data` object to initialize a `String` representing the data that is stored, and print it to the console.
let jsonEncoder = JSONEncoder()

if let jsonData = try? jsonEncoder.encode(sterling), let jsonString = String(data: jsonData, encoding: .utf8) {
    print(jsonString)
}

// If I try and run my code on lines 79-81 WITHOUT adding the 'Encoded' protocol to my my 'Human' class, I get the error "Instance method 'encode' requires that 'Human' conform to 'Encodable'". I didn't actually have to add any new code to the body of my 'Human' class, when I added the 'Encodable' protocol, though, so I'm not sure how the 'Encodable' protocol is actually set up.
/*:
page 1 of 5  |  [Next: App Exercise - Printable Workouts](@next)
 */
