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

        if availableCount <= 0 {
            // 缺货不是“返回 nil”，而是一个明确失败原因。
            throw VendingError.outOfStock
        }

        let itemPrice = prices[item, default: 0]

        if depositedCoins < itemPrice {
            let coinsNeeded = itemPrice - depositedCoins
            // 关联值把“还差几个硬币”随错误一起抛出去。
            throw VendingError.insufficientFunds(coinsNeeded: coinsNeeded)
        }

        inventory[item] = availableCount - 1
        depositedCoins -= itemPrice
        return item
    }
}

let machine = VendingMachine(
    inventory: ["Soda": 2, "Water": 1],
    prices: ["Soda": 5, "Water": 3],
    depositedCoins: 8
)

do {
    let itemName = try machine.buy(item: "Soda")
    print("购买成功：\(itemName)")
    print("剩余硬币：\(machine.depositedCoins)")
} catch {
    print("购买失败：\(error)")
}