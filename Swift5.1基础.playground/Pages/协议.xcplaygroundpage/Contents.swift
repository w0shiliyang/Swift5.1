import Foundation
//: 协议
/// 协议可以用来定义方法、属性、下标的声明，协议可以被枚举、结构体、类遵守（多个协议之间用逗号隔开）
protocol Drawable {
    func draw()
    var x: Int { get set }
    var y: Int { get }
    subscript(index: Int) -> Int { get set }
}
protocol Test1 { }
protocol Test2 { }
protocol Test3 { }
class testClass: Test1, Test2, Test3 { }

/// 协议中定义方法时不能有默认值
/// 默认情况下，协议中定义的内容必须全部都实现
/// 也有方法办到只实现部分内容
//: 协议中的属性
/// 协议中定义属性时必须用var关键字
/// 实现协议时的属性权限要不小于协议中定义的属性权限
/// 协议定义get、set，用var存储属性或get、set计算属性去实现
/// 协议定义get，用任何属性都可以实现

class Person: Drawable {
    var x: Int = 0
    var y: Int = 0
    func draw() {
        print("Person draw")
    }
    subscript(index: Int) -> Int {
        set { }
        get { index }
    }
}

class Person2: Drawable {
    var x: Int {
        get { 0 }
        set { }
    }
    var y: Int { get { 0 } set {} }
    func draw() { print("Person draw") }
    subscript(index: Int) -> Int { get{ index } set{} } 
}
//:static、class
/// 为了保证通用，协议中必须用static定义类型方法、类型属性、类型下标
protocol Drawable1 {
    static func draw()
}

class Person3 : Drawable1 {
    class func draw() {
         print("person3 draw")
    }
}

class Person4 : Drawable1 {
    static func draw() {
        print("Person4 draw")
    }
}
//: mutating
/// 只有将协议中的实例方法标记为mutating
/// 才允许结构体、枚举的具体实现修改自身内存
/// 类在实现方法时不用加mutating，枚举、结构体才需要加mutating
protocol DrawableProtocol {
    mutating func draw()
}

class Size : DrawableProtocol {
    var width: Int = 0
    func draw() {
        width = 10
    }
}

struct Point : DrawableProtocol {
    var x: Int = 0
    mutating func draw() {
        x = 10
    }
}
//: init
/// 协议中还可以定义初始化器init
/// 非final类实现时必须加上required
protocol DrawableProtocol1 {
    init(x: Int, y: Int)
}

class PointClass : DrawableProtocol1 {
    required init(x: Int, y: Int) { }
}

final class SizeClass : DrawableProtocol1 {
    init(x: Int, y: Int) { }
}

/// 如果从协议实现的初始化器，刚好是重写了父类的指定初始化器
/// 那么这个初始化必须同时加required、override
protocol Liveable {
    init(age: Int)
}

class TestPerson {
    init(age: Int) {}
}

class Student : TestPerson, Liveable {
    required override init(age: Int) {
        super.init(age: age)
    }
}
//: init、init？、init！
/// 协议中定义的init？、init！，可以用init、init？、init！去实现
/// 协议中定义的init，可以用init、init！去实现
protocol Livable {
    init()
    init?(age: Int)
    init!(no: Int)
}

class Teacher: Livable {
    required init() {}
//    required init!() {}
    
    required init?(age: Int) {}
//    required init!(age: Int) {}
//    required init(age: Int) {}
    
    required init!(no: Int) {}
//    required init?(no: Int) {}
//    required init(no: Int) {}
}
//: 协议的继承
/// 一个协议可以继承其他协议
protocol Runable {
    func run()
}

protocol Livable1 : Runable {
    func breath()
}

class Person5 : Livable1 {
    func breath() {}
    func run() {}
}
//: 协议组合
/// 协议组合，可以包含1个类类型（最多1个）
protocol LivableTest {}
protocol RunnableTest {}
class PersonTest {}

// 接收PersonTest或者其子类的实例
func fn0(obj: PersonTest) {}
// 接收遵守LivableTest协议的实例
func fn1(obj: LivableTest) {}
// 接收同时遵守LivableTest、RunnableTest协议的实例
func fn2(obj: LivableTest & RunnableTest) {}
// 接收同时遵守LivableTest、RunnableTest协议、并且是PersonTEst或者其子类的实例
func fn3(obj: PersonTest & LivableTest & RunnableTest) {}

typealias RealPerson = PersonTest & LivableTest & RunnableTest
func fn4(obj: RealPerson) {}

//: CaseIterable
/// 让枚举遵守CaseIterable协议，可以实现遍历枚举值
enum Season: CaseIterable {
    case spring, summer, autumn, winter
}

let seasons = Season.allCases
print(seasons.count) // 4
for season in seasons {
    print(season)
} // spring summer autum winter

//: CustomStringConvertible
/// 遵循CustomStringConvertible、CustomDebugStringConvertible协议,都可以自定义实例的打印字符串
class TestPerson1 : CustomStringConvertible, CustomDebugStringConvertible {
    var age = 0
    var description: String { "person_\(age)" }
    var debugDescription: String {"debug_person_\(age)"}
}
var person = TestPerson1()
print(person) // person_0
debugPrint(person) // debug_person_0
/// print调用的是CustomStringConvertible协议的description
/// debugPrint、 po调用的是CustomDebugStringConvertible协议的debugDescription

//: Any、AnyObject
/// Swift提供了2中特殊的类型： Any、AnyObject
/// Any： 可以代表任意类型（枚举、结构体、类、也包括函数类型）
/// AnyObject：可以代表任意类类型（在协议后面写上：AnyObject代表只有类能遵守这个协议）
/// 在协议后面写上：class也代表只有类能遵守这个协议

var stu: Any = 10
stu = "Jack"
stu = Student(age: 10)
// 创建1个能存放任意类型的数组
// var data = Array<Any>()

var data = [Any]()
data.append(1)
data.append(3.14)
data.append(stu)
data.append("Jack")
data.append({10})

//: is、as?、as!、 as
/// is用来判断是否为某种类型，as用来强制类型转换
protocol RunnableTest2 { func run() }
class PersonTest2 {}
class StudentTest2 : PersonTest2, RunnableTest {
    func run () {
        print("Stundet run")
    }
    func study() {
        print("Student study")
    }
}

var stu1: Any = 10
print(stu1 is Int)
stu1 = "Jack"
print(stu1 is String)
stu1 = StudentTest2()
print(stu1 is PersonTest2) // true
print(stu1 is StudentTest2) // true
print(stu1 is RunnableTest2) // true

stu1 = 10
(stu1 as? StudentTest2)?.study() // 没有调用study
stu1 = StudentTest2()
(stu1 as? StudentTest2)?.study() // Student study
(stu1 as! StudentTest2).study() // Student study
(stu1 as? RunnableTest2)?.run() // Student run

var data1 = [Any]()
data1.append(Int("123") as Any)

var d = 10 as Double
print(d) // 10.0

//: X.self、X.Type、AnyClass
/// X.self是一个元类型（metadata）的指针，metadata存放着类型相关信息
/// X.self属于X.Type类型

class PersonTest3 {}
class StudentTest3 : PersonTest3 {}
var perType: PersonTest3.Type = PersonTest3.self
var stuType: StudentTest3.Type = StudentTest3.self
perType = StudentTest3.self

var anyType: AnyObject.Type = PersonTest3.self
anyType = StudentTest3.self

//public typealias AnyClass = AnyObject.Type
var anyType2: AnyClass = PersonTest3.self
anyType2 = StudentTest3.self

var per = PersonTest3()
perType = type(of: per)
print(PersonTest3.self == perType)

//: 元类型的应用
class Animal { required init() {} }
class Cat : Animal {}
class Dog : Animal {}
class Pig : Animal {}

func create(_ clses: [Animal.Type]) -> [Animal] {
    var arr = [Animal]()
    for cls in clses {
        arr.append(cls.init())
    }
    return arr
}
print(create([Cat.self, Dog.self, Pig.self]))

print(class_getInstanceSize(Cat.self)) // 16
print(class_getSuperclass(Cat.self)!) // Animal
print(class_getSuperclass(Animal.self)!) // Swift._SwiftObject

//: Self
/// Self代表当前类型
class PersonTest4 {
    var age = 1
    static var count = 2
    func run() {
        print(self.age) // 1
        print(Self.count) // 2
    }
}

/// Self一般用作返回值类型，限定返回值跟方法调用者必须是同一类型（也可以作为参数类型）
protocol Runnable {
    func test() -> Self
}
class PersonTest5 : Runnable {
    required init () {}
    func test() -> Self { type(of: self).init() }
}
class StudentTest5 : PersonTest5 {}

var p = PersonTest5()
// Person
print(p.test())

var stuTest = StudentTest5()
// Student
print(stuTest.test())

//: [错误处理](@next)
