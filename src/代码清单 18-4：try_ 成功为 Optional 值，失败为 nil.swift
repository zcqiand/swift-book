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

let successfulResult = try? machine.buy(item: "Soda")
print("try? 成功结果：\(String(describing: successfulResult))")

let failedResult = try? machine.buy(item: "Water")
print("try? 失败结果：\(String(describing: failedResult))")

if failedResult == nil {
    print("try? 只留下 nil，没有保留缺货或余额不足的具体原因")
}