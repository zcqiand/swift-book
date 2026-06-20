import Foundation

func runARCDemo() {
    func demonstrateStrongReferenceCycle() {
        final class Person {
            let name: String
            var apartment: Apartment?

            init(name: String) {
                self.name = name
                print("创建住户：\(name)")
            }

            deinit {
                print("释放住户：\(name)")
            }
        }

        final class Apartment {
            let unit: String
            var tenant: Person?

            init(unit: String) {
                self.unit = unit
                print("创建公寓：\(unit)")
            }

            deinit {
                print("释放公寓：\(unit)")
            }
        }

        let resident = Person(name: "Taylor")
        let home = Apartment(unit: "3A")

        resident.apartment = home
        home.tenant = resident

        print("强引用循环已建立：Person 和 Apartment 互相持有")
    }

    func demonstrateWeakReferenceBreaksCycle() {
        final class Person {
            let name: String
            var apartment: Apartment?

            init(name: String) {
                self.name = name
                print("创建住户：\(name)")
            }

            deinit {
                print("释放住户：\(name)")
            }
        }

        final class Apartment {
            let unit: String

            // Apartment 只知道住户是谁，不应该反过来拥有住户。
            weak var tenant: Person?

            init(unit: String) {
                self.unit = unit
                print("创建公寓：\(unit)")
            }

            deinit {
                print("释放公寓：\(unit)")
            }
        }

        let resident = Person(name: "Jordan")
        let home = Apartment(unit: "4B")

        resident.apartment = home
        home.tenant = resident

        print("weak 引用已建立：Apartment 不再强持有 Person")
    }

    print("开始演示强引用循环")
    demonstrateStrongReferenceCycle()
    print("离开强引用循环函数后，没有看到 Taylor 和 3A 的 deinit，说明它们被引用环困住")

    print("开始演示 weak 打破循环")
    demonstrateWeakReferenceBreaksCycle()
    print("离开 weak 示例函数后，Jordan 和 4B 已经释放")
}

runARCDemo()