import SwiftUI

struct FindFriendsView: View {
    @ObservedObject private var userService: UserService = UserService.shared
    @State private var searchText: String = ""
    @State private var showAlert = false // Track whether to show the alert
    @State private var refreshFlag = false
    @ObservedObject private var viewModel = FriendsViewModel()
    var body: some View {
        NavigationView {
            VStack {
                HStack(spacing: 25) {
                    TabView(title: "Friend", backgroundColor: .gray)
                    TabView(title: "Groups", backgroundColor: .gray.opacity(0.5), isGroupsTab: true)

                        }
                     
                        .padding(.horizontal)
                
                Divider()
                
                HStack {
                    TextField("Search for User", text: $searchText)
                        .font(Font.custom("Inter", size: 16).weight(.medium))
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                        .onChange(of: searchText) { newValue in
                            Task {
                                do {
                                    if newValue.isEmpty {
                                        // Clear search results if search text is empty
                                        userService.searchResults = nil
                                    } else {
                                        try await userService.searchUsers(query: newValue)
                                    }
                                } catch {
                                    print("Error searching users: \(error.localizedDescription)")
                                }
                            }
                           
                        }
                    
                    
                    Button {
                    
                        

                           }label: {
                        Image(systemName: "magnifyingglass")
                            .font(.title)
                            .padding(.horizontal)
                    }
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text("Friend Request Sent"))
                    }
                }
                .padding(.top)
                .padding(.horizontal)
                Spacer()
                
                    .padding(.top,5)
                ScrollView {
                    VStack(alignment: .leading, spacing: 10) {
                        // Display search results
                        if let searchResults = userService.searchResults {
                            ForEach(searchResults) { user in
                                HStack {
                                    Text(user.fullname ?? "")
                                        .font(Font.custom("Inter", size: 20).weight(.medium))
                                        .fontWeight(.semibold)
                                    Spacer()
                                    Button(action: {
                                        // Send friend request when "Yes" is clicked
                                        Task {
                                            do {
                                                try await userService.sendFriendRequest(to: user)
                                                // Fetch friend requests again to update the UI
                                                try await userService.fetchFriendRequestsToMe()
                                                // Set showAlert to true to display the alert
                                                showAlert = true
                                            } catch {
                                                print("Error sending friend request: \(error.localizedDescription)")
                                            }
                                        }
                                    }) {
                                        Text("Yes")
                                            .foregroundColor(.white)
                                            .font(Font.custom("Inter", size: 20).weight(.medium))
                                            .padding(.vertical, 8)
                                            .padding(.horizontal, 20)
                                            .background(Color.green)
                                            .cornerRadius(10)
                                    }
                                    Button(action: {
                                        // Remove user from search results when "No" is clicked
                                        if let index = searchResults.firstIndex(of: user) {
                                            userService.searchResults?.remove(at: index)
                                        }
                                    }) {
                                        Text("No")
                                            .foregroundColor(.white)
                                            .font(Font.custom("Inter", size: 20).weight(.medium))
                                            .padding(.vertical, 8)
                                            .padding(.horizontal, 20)
                                            .background(Color.red)
                                            .cornerRadius(10)
                                    }
                                }
                                .padding(.vertical, 8)
                            }
                        }
                    }
                    .padding(.horizontal)
                    // Move the Divider up between search results and friend requests
                }
                .padding(.top, -20)
                Divider()

                
                VStack(alignment: .leading, spacing: 15) {
                    Text("Friend Requests Sent to You")
                        .font(.headline)
                        .padding(.horizontal)
                        .padding(.leading,50)
                    ForEach(viewModel.friendsRequestsToMe) { user in
                        FriendLookView(user: user)
                            .padding(.leading,50)
                    }
                    Divider()
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 350, height: 250)
                        .background(
                            Image("Logo")
                                .resizable()
                        )
                        .offset(x: 40, y: 10) // Adjust positioning as needed
                        .navigationBarBackButtonHidden(true)
                    
                    
                    
                    HStack {
                        Spacer()
                        
                        NavigationLink(destination: HomePage()) {
                            Image(systemName: "house.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 100, height: 50)
                                .foregroundColor(.black)
                        }
                        .navigationBarBackButtonHidden(true) // Hide back button for Home
                        
                        Spacer().frame(width: 50)
                        
                        NavigationLink(destination: ProfileView()) {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 100, height: 50)
                                .foregroundColor(.black)
                        }
                        .navigationBarBackButtonHidden(true)
                        
                        Spacer()
                    }
                    .padding(.top,40)
                    .padding(.horizontal, 24)
        
                    .padding(.leading,110)
                }
                .padding(.top,40)
                
            }
            .navigationBarBackButtonHidden(true) // Hide back button for the entire view
        }
        .navigationBarBackButtonHidden(true) // Hide back button for the entire view
     }

 }


struct TabView: View {
    private var title: String
    private var backgroundColor: Color // Background color for the tab
    private var isGroupsTab: Bool // Flag to indicate if this is the "Groups" tab
    
    init(title: String, backgroundColor: Color, isGroupsTab: Bool = false) {
        self.title = title
        self.backgroundColor = backgroundColor
        self.isGroupsTab = isGroupsTab
    }

    var body: some View {
        if isGroupsTab {
            NavigationLink(destination: GroupsView()) {
                tabContent.foregroundColor(.black)
            }
        } else {
            tabContent
        }
    }
    
    private var tabContent: some View {
        Text(title)
            .font(Font.custom("Inter", size: 16).weight(.medium))
            .padding(.horizontal, 10) // Adjust the horizontal padding
            .padding(.vertical, 5) // Adjust the vertical padding
            .background(backgroundColor) // Set background color
            .clipShape(RoundedRectangle(cornerRadius: 10), style: FillStyle())
    }
}

#if DEBUG
struct FindFriendsView_Previews: PreviewProvider {
    static var previews: some View {
        FindFriendsView()
    }
}
#endif
