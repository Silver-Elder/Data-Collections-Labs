/*:
## App Exercise - Printable Workouts

 >These exercises reinforce Swift concepts in the context of a fitness tracking app.
 
 The `Workout` objects you have created so far in app exercises don't show a whole lot of useful information when printed to the console. They also aren't very easy to compare or sort. Throughout these exercises, you'll make the `Workout` class below adopt certain protocols that will solve these issues.
 */
class Workout: CustomStringConvertible, Equatable, Comparable, Codable{
    
    var distance: Double
    var time: Double
    var identifier: Int
    
    init(distance: Double, time: Double, identifier: Int) {
        self.distance = distance
        self.time = time
        self.identifier = identifier
    }
    
    var description: String {
        "Workout \(identifier): You ran \(distance) miles in \(time) minutes."
    }
    
    static func == (lhs: Workout, rhs: Workout) -> Bool {
        lhs.identifier == rhs.identifier
    }
    
    static func < (lhs: Workout, rhs: Workout) -> Bool {
        lhs.identifier < rhs.identifier
    }

}

//:  Make the `Workout` class above conform to the `CustomStringConvertible` protocol so that printing an instance of `Workout` will provide useful information in the console. Create an instance of `Workout`, give it an identifier of 1, and print it to the console.
let myFirstWorkout = Workout(distance: 3, time: 30, identifier: 1)
print(myFirstWorkout)
//:  Make the `Workout` class above conform to the `Equatable` protocol. Two `Workout` objects should be considered equal if they have the same identifier. Create another instance of `Workout`, giving it an identifier of 2, and print a boolean expression that evaluates to whether or not it is equal to the first `Workout` instance you created.
let mySecondWorkout = Workout(distance: 1, time: 10, identifier: 2)
print(myFirstWorkout == mySecondWorkout)
/*:
 Make the `Workout` class above conform to the `Comparable` protocol so that you can easily sort multiple instances of `Workout`. `Workout` objects should be sorted based on their identifier. 
 
 Create three more `Workout` objects, giving them identifiers of 3, 4, and 5, respectively. Then create an array called `workouts` of type `[Workout]` and assign it an array literal with all five `Workout` objects you have created. Place these objects in the array out of order. Then create another array called `sortedWorkouts` of type `[Workout]` that is the `workouts` array sorted by identifier. 
 */
let myThirdWorkout = Workout(distance: 2, time: 20, identifier: 3)
let myFourhtWorkout = Workout(distance: 4, time: 40, identifier: 4)
let myFifthWorkout = Workout(distance: 5, time: 50, identifier: 5)

let workouts: [Workout] = [myFourhtWorkout, myFirstWorkout, myThirdWorkout, mySecondWorkout, myFifthWorkout]

let sortedWorkouts = workouts.sorted(by: <)

print(sortedWorkouts)
//:  Make `Workout` adopt the `Codable` protocol so you can easily encode `Workout` objects as data that can be stored between app launches. Use a `JSONEncoder` to encode one of your `Workout` instances. Then use the encoded data to initialize a `String`, and print it to the console.
import Foundation

let jsonEncoder = JSONEncoder()

if let jsonData = try? jsonEncoder.encode(myFirstWorkout), let jsonString = String(data: jsonData, encoding: .utf8) {
    print(jsonString)
}

/*:
[Previous](@previous)  |  page 2 of 5  |  [Next: Exercise - Create a Protocol](@next)
 */
