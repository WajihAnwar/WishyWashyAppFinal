import SwiftUI
import Combine

class GroupsViewModel: ObservableObject {
    @Published var groupUsers: [User] = [] // Stores the list of users for the group
    var searchText: String = "" {
        didSet {
            objectWillChange.send()
        }
    }

    private var cancellables = Set<AnyCancellable>()

    init() {
        // Initialize groupUsers with some data (replace with actual data)
        fetchGroupUsers()
    }

    func fetchGroupUsers() {
        // Simulated data
        groupUsers = [
            User(id: "1", fullname: "Alex", email: "groupuser1@example.com", friendsIds: [], friendsRequestsID: [])
        ]
    }
}
