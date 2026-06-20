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
            throw VendingError.outOfStock
        }

        let itemPrice = prices[item, default: 0]
        if depositedCoins < itemPrice {
            throw VendingError.insufficientFunds(coinsNeeded: itemPrice - depositedCoins)
        }

        inventory[item] = availableCount - 1
        depositedCoins -= itemPrice
        return item
    }
}

func attemptPurchase(item: String, on machine: VendingMachine) {
    do {
        let itemName = try machine.buy(item: item)
        print("[成功] 商品：\(itemName)")
    } catch VendingError.outOfStock {
        print("[失败] reason=outOfStock message=商品已售罄")
    } catch VendingError.insufficientFunds(let coinsNeeded) {
        print("[失败] reason=insufficientFunds message=余额不足，还需 \(coinsNeeded) 个硬币")
    } catch {
        print("[失败] reason=unknown detail=\(error)")
    }
}

let successMachine = VendingMachine(
    inventory: ["Soda": 1],
    prices: ["Soda": 5],
    depositedCoins: 5
)

let outOfStockMachine = VendingMachine(
    inventory: ["Water": 0],
    prices: ["Water": 3],
    depositedCoins: 5
)

let lowMoneyMachine = VendingMachine(
    inventory: ["Juice": 2],
    prices: ["Juice": 6],
    depositedCoins: 3
)

attemptPurchase(item: "Soda", on: successMachine)
attemptPurchase(item: "Water", on: outOfStockMachine)
attemptPurchase(item: "Juice", on: lowMoneyMachine)