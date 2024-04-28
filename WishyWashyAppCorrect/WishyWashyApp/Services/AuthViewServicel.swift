import Foundation
import FirebaseCore
import Firebase
import FirebaseFirestoreSwift

class AuthService: ObservableObject {
    
    static let shared = AuthService()
    @Published var userSession: FirebaseAuth.User?
    
    init() {
        self.userSession = Auth.auth().currentUser
    }
    
    @MainActor
    private func uploadUserData(id: String, fullname: String, email: String) async throws {
        let user = User(id: id, fullname: fullname, email: email, friendsIds: [], friendsRequestsID: [], isCurrentUser: true)
        guard let userData = try? Firestore.Encoder().encode(user) else { return }
        try await Firestore.firestore().collection("users").document(id).setData(userData)
        UserService.shared.currentUser = user
        // Create an empty friend requests array for the user
        let friendRequests = [User]() // Assuming User has an initializer without parameters
        try await Firestore.firestore().collection("userFriendRequests").document(id).setData(["requests": friendRequests])
    }
    
    @MainActor
    func createUser(email: String, password: String, fullname: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            try await uploadUserData(id: result.user.uid, fullname: fullname, email: email)
        } catch {
            print("Failed to create user: \(error.localizedDescription)")
        }
    }
    
    func login(email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            try await UserService.shared.fetchCurrentUser()
        } catch {
            print("Failed to login: \(error.localizedDescription)")
        }
    }
    
    func signout() {
        try? Auth.auth().signOut()
        self.userSession = nil
        UserService.shared.reset()
    }
}

class UserService: ObservableObject {
    
    @Published var currentUser: User?
    @Published var users: [User]?
    @Published var friends: [User]?
    @Published var friendsRequests: [User]?
    @Published var searchResults: [User]?
    @Published var friendsRequestsToMe: [User] = []
    static let shared = UserService()
    
    private let db = Firestore.firestore()
    
    init() {
        Task { try await fetchCurrentUser() }
    }
    
    @MainActor
    func fetchCurrentUser() async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let snapshot = try await Firestore.firestore().collection("users").document(uid).getDocument()
        self.currentUser = try snapshot.data(as: User.self)
        try await fetchFriends()
        try await fetchFriendRequests()
    }
    
    @MainActor
    func fetchUsers() async throws -> [User] {
        guard let currentUid = Auth.auth().currentUser?.uid else { return [] }
        let snapshot = try await Firestore.firestore().collection("users").getDocuments()
        let users = snapshot.documents.compactMap({try? $0.data(as: User.self)})
        return users.filter({ $0.id != currentUid })
    }
    
    @MainActor
    func fetchFriends() async throws {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        let snapshot = try await Firestore.firestore().collection("friends").document(currentUid).getDocument()
        self.friends = try snapshot.data(as: [User].self)
    }
    
    @MainActor
    func fetchFriendRequests() async throws {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        // Fetch the friend requests document for the current user
        let snapshot = try await Firestore.firestore().collection("userFriendRequests").document(currentUid).getDocument()
        
        if let requestData = snapshot.data()?["requests"] as? [[String: Any]] {
            // Convert requestData into User objects
            let requests = requestData.compactMap { data -> User? in
                // Convert data into User object
                // Example:
                guard let id = data["id"] as? String, let fullname = data["fullname"] as? String else {
                    print("Invalid user data")
                    return nil
                }
                return User(id: id, fullname: fullname, email: "", friendsIds: [], friendsRequestsID: [], isCurrentUser: false)
            }
            // Update the array of friend requests
            self.friendsRequests = requests
        } else {
            // If no requests are found, set the property to an empty array
            self.friendsRequests = []
        }
    }

    
    func reset() {
        self.currentUser = nil
        self.friends = nil
        self.friendsRequests = nil
    }
    
    @MainActor
    func sendFriendRequest(to user: User) async throws {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        // Fetch existing friend requests sent by the current user
        let documentRef = Firestore.firestore().collection("userFriendRequests").document(currentUid)
        let documentSnapshot = try await documentRef.getDocument()
        guard var requests = documentSnapshot.data()?["requests"] as? [[String: Any]] else {
            print("Failed to fetch friend requests")
            return
        }
        
        // Check if the request already exists
        if requests.contains(where: { $0["id"] as? String == user.id }) {
            // If the request already exists, return without creating a new one
            return
        }
        
        // Add user to friend requests
        requests.append(["id": user.id, "fullname": user.fullname]) // Assuming User has `id` and `fullname` properties
        
        do {
             try await documentRef.setData(["requests": requests])
             
             // Update friendsRequestsToMe locally to reflect the sent request
            let newRequest = User(id: user.id, fullname: user.fullname, email: "", friendsIds: [], friendsRequestsID: [], isCurrentUser: true)
            self.friendsRequestsToMe.append(newRequest)
            
            print("Friend request sent successfully to: \(user.fullname)")
         } catch {
             print("Error sending friend request: \(error.localizedDescription)")
             // Handle error in UI or display message
         }
    }

    @MainActor
    func acceptFriendRequest(from user: User) async throws {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        // Remove friend request
        var requests = self.friendsRequests ?? []
        requests.removeAll(where: { $0.id == user.id })
        self.friendsRequests = requests
        
        // Add user to friend list
        var currentFriends = self.friends ?? []
        currentFriends.append(user)
        self.friends = currentFriends
        
        // Update friend list in Firestore
        try await Firestore.firestore().collection("friends").document(currentUid).setData(from: currentFriends)
    }
    
    @MainActor
    func rejectFriendRequest(from user: User) async throws {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        // Remove friend request locally
        var requests = self.friendsRequests ?? []
        requests.removeAll(where: { $0.id == user.id })
        self.friendsRequests = requests
        
        // Encode remaining friend requests to a dictionary
        let requestData = try requests.map { try Firestore.Encoder().encode($0) }
        
        // Update friend requests in Firestore
        try await Firestore.firestore().collection("userFriendRequests").document(currentUid).setData(["requests": requestData])
        
        // Delete the corresponding document in the userFriendRequests collection
        try await Firestore.firestore().collection("userFriendRequests").document(user.id).delete()
    }
    
    @MainActor
    func fetchFriendRequestsToMe() async {
        guard let currentUid = Auth.auth().currentUser?.uid else {
            print("Error: Current user ID is nil.")
            return
        }
        
        do {
            let snapshot = try await Firestore.firestore().collection("userFriendRequests").document(currentUid).getDocument()
            
            if let requestData = snapshot.data()?["requests"] as? [[String: Any]] {
                var currentUserRequests: [User] = []
                
                for data in requestData {
                    guard let id = data["id"] as? String,
                          let fullname = data["fullname"] as? String,
                          let isCurrentUser = data["isCurrentUser"] as? Bool,
                          isCurrentUser,
                          let email = data["email"] as? String else {
                        print("Invalid friend request data")
                        continue
                    }
                    
                    // Create a User object for the request
                    let requestUser = User(id: id, fullname: fullname, email: email, friendsIds: [], friendsRequestsID: [], isCurrentUser: isCurrentUser)
                    
                    // Check if the request is intended for the current user
                    if requestUser.friendsRequestsID.contains(currentUid) {
                        currentUserRequests.append(requestUser)
                    }
                }
                
                // Update the friendsRequestsToMe property with the filtered requests
                self.friendsRequestsToMe = currentUserRequests
            } else {
                // If no requests are found, set the property to an empty array
                self.friendsRequestsToMe = []
            }
        } catch {
            print("Error fetching friend requests to me: \(error.localizedDescription)")
        }
        
    }
    @MainActor
        func searchUsers(query: String) async throws {
            // Perform the search operation here
            // Use Firestore queries or any other method to search for users based on the query
            // For example, you can use Firestore query to search for users whose names contain the query string
            let querySnapshot = try await Firestore.firestore()
                .collection("users")
                .whereField("fullname", isGreaterThanOrEqualTo: query)
                .whereField("fullname", isLessThan: query + "\u{f8ff}") // Unicode character used for range queries
                .getDocuments()
            
            // Convert query snapshot to array of User objects
            let users = querySnapshot.documents.compactMap { document -> User? in
                // Attempt to decode each document into a User object
                do {
                    return try document.data(as: User.self)
                } catch {
                    print("Error decoding user: \(error.localizedDescription)")
                    return nil
                }
            }
            
            // Update the searchResults property with the search results
            self.searchResults = users
            
        }
    }

