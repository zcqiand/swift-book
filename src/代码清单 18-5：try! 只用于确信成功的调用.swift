import Foundation

enum VendingError: Error { case outOfStock; case insufficientFunds(coinsNeeded: Int) }

class VendingMachine {
    var inventory: [String: Int]
    var prices: [String: Int]
    var depositedCoins: Int

    init(inventory: [String: Int], prices: [String: Int], depositedCoins: Int) {
        self.inventory = inventory
        self.prices = prices
        self.depositedCoins = depositedCoins
    }

    func buy(item: String) throws -> String {
        let availableCount = inventory[item, default: 0]
        if availableCount <= 0 { throw VendingError.outOfStock }

        let itemPrice = prices[item, default: 0]
        if depositedCoins < itemPrice {
            throw VendingError.insufficientFunds(coinsNeeded: itemPrice - depositedCoins)
        }

        inventory[item] = availableCount - 1
        depositedCoins -= itemPrice
        return item
    }
}

let machine = VendingMachine(
    inventory: ["Soda": 1, "Water": 0],
    prices: ["Soda": 5, "Water": 3],
    depositedCoins: 5
)

// 这里提前保证 Soda 有库存且余额足够，所以示例可以安全运行。
let itemName = try! machine.buy(item: "Soda")
print("try! 购买成功：\(itemName)")

// 下面两行故意保留为注释：Water 库存为 0，buy(item:) 会 throw。
// 如果取消注释，try! 会把抛出的错误变成运行时崩溃。
// 不建议伪造精确崩溃原文；不同 Swift 版本、运行环境和上下文可能略有差异。
// let crashedItemName = try! machine.buy(item: "Water")
// print(crashedItemName)