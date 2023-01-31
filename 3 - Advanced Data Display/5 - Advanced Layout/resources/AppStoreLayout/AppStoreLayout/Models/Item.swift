
import Foundation

enum Item: Hashable {
    case app(App)
    case category(StoreCategory)
    
    var app: App? {
        if case .app(let app) = self {
            return app
        } else {
            return nil
        }
    }
    
    var category: StoreCategory? {
        if case .category(let category) = self {
            return category
        } else {
            return nil
        }
    }
    
    static let promotedApps: [Item] = [
        .app(App(promotedHeadline: "Now Trending", title: " Trending Game Title", subtitle: "Trending Game Description", price: 3.99)),
        .app(App(promotedHeadline: "Limited Time", title: " LimitedGame Title", subtitle: "Limited Game Description", price: nil)),
        .app(App(promotedHeadline: "New Update", title: "Updated Game Title", subtitle: "Updated Game Description", price: nil)),
        .app(App(promotedHeadline: "Just Released", title: " Released Game Title", subtitle: "Released Game Description", price: nil))
    ]
    
    static let popularApps: [Item] = [
        .app(App(promotedHeadline: nil, title: "Game Title1", subtitle: "Game Description 1", price: nil)),
        .app(App(promotedHeadline: nil, title: "Game Title 2", subtitle: "Game Description 2", price: 2.99)),
        .app(App(promotedHeadline: nil, title: "Game Title 3", subtitle: "Game Description 3", price: nil)),
        .app(App(promotedHeadline: nil, title: "Game Title 4", subtitle: "Game Description 4", price: 9.99)),
        .app(App(promotedHeadline: nil, title: "Game Title 5", subtitle: "Game Description 5", price: nil)),
        .app(App(promotedHeadline: nil, title: "Game Title 6", subtitle: "Game Description 6", price: nil)),
        .app(App(promotedHeadline: nil, title: "Game Title 7", subtitle: "Game Description 7", price: 6.99)),
        .app(App(promotedHeadline: nil, title: "Game Title 8", subtitle: "Game Description 8", price: nil)),
    ]
    
    static let essentialApps: [Item] = [
        .app(App(promotedHeadline: nil, title: "Game Title 1", subtitle: "Game Description 1", price: 0.99)),
        .app(App(promotedHeadline: nil, title: "Game Title 2", subtitle: "Game Description 2", price: nil)),
        .app(App(promotedHeadline: nil, title: "Game Title 3", subtitle: "Game Description 3", price: 3.99)),
        .app(App(promotedHeadline: nil, title: "Game Title 4", subtitle: "Game Description 4", price: 0.99)),
        .app(App(promotedHeadline: nil, title: "Game Title 5", subtitle: "Game Description 5", price: 4.99)),
        .app(App(promotedHeadline: nil, title: "Game Title 6", subtitle: "Game Description 6", price: 0.99)),
        .app(App(promotedHeadline: nil, title: "Game Title 7", subtitle: "Game Description 7", price: 0.99)),
    ]

    static let categories: [Item] = [
        .category(StoreCategory(name: "AR Games")),
        .category(StoreCategory(name: "Indie")),
        .category(StoreCategory(name: "Strategy")),
        .category(StoreCategory(name: "Racing")),
        .category(StoreCategory(name: "Puzzle")),
        .category(StoreCategory(name: "Board")),
        .category(StoreCategory(name: "Family")),
    ]
}
