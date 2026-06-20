import Foundation

extension Int {
    var isEven: Bool {
        self % 2 == 0
    }
}

print(10.isEven)
print(7.isEven)