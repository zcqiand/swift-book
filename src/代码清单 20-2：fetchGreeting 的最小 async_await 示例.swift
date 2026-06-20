import Foundation

func fetchGreeting() async -> String {
    "Hello async"
}

Task {
    let message = await fetchGreeting()
    print(message)
}