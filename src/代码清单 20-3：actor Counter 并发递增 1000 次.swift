import Foundation

actor Counter {
    private var count = 0

    func increment() {
        count += 1
    }

    func value() -> Int {
        count
    }
}

Task {
    let counter = Counter()

    await withTaskGroup(of: Void.self) { group in
        for _ in 1...1000 {
            group.addTask {
                await counter.increment()
            }
        }
    }

    print(await counter.value())
}