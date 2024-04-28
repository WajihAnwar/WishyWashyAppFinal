import Foundation
import SwiftUI
import Combine

class FriendsViewModel: ObservableObject {
    
    @Published var friendsRequestsToMe: [User] = [] // Stores the list of friend requests sent to the current user

    private var cancellables = Set<AnyCancellable>()

    init() {
        // Simulate fetching friend requests sent to the current user (replace with actual logic)
        fetchFriendRequestsToMe()
    }
    
    func fetchFriendRequestsToMe() {
        // Simulated data
        friendsRequestsToMe = [
            User(id: "1", fullname: "Elsa", email: "fcwajih2000@gmail.com", friendsIds: [], friendsRequestsID: []),
            User(id: "2", fullname: "Alex", email: "alex@bowser@gmail.com", friendsIds: [], friendsRequestsID: []),
            User(id: "3", fullname: "Tiana", email: "wferraria2000@gmail.com", friendsIds: [], friendsRequestsID: [])
        ]
    }
}

