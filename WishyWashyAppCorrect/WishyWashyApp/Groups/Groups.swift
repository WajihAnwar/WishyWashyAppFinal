import SwiftUI

struct GroupsView: View {
    @ObservedObject private var userService: UserService = UserService.shared
    @State private var searchText: String = ""
    @State private var groupName: String = ""
    @State private var showAlert = false // Track whether to show the alert
    @State private var invitedMembers: [User] = [] // Track invited members
    @State private var isSendInviteEnabled = false // Track whether the "Send Invite" button should be enabled
    @ObservedObject private var viewModel = GroupsViewModel()

    // Function to check if the form is valid
    private func isFormValid() -> Bool {
        return groupName.count >= 5 && !groupName.isEmpty && !searchText.isEmpty && !(userService.searchResults?.isEmpty ?? true)
    }

    var body: some View {
        NavigationView {
            VStack {
                HStack(spacing:25){
                    TabView(title: "Friend", backgroundColor: .gray)
                    TabView(title: "Groups", backgroundColor: .gray.opacity(0.5), isGroupsTab: true)
                }
                .padding(.horizontal)
                .padding(.top,20)
                Divider()
                
                HStack {
                    TextField("Group Name, must be 5 characters", text: $groupName)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(20)
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding(.horizontal)
                }
                .padding(.top)
                .padding(.horizontal)
                Divider()
                
                HStack {
                    TextField("Search", text: $searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                        .onChange(of: searchText) { newValue in
                            Task {
                                do {
                                    if newValue.isEmpty {
                                        userService.searchResults = nil
                                    } else {
                                        try await userService.searchUsers(query: newValue)
                                    }
                                    isSendInviteEnabled = isFormValid()
                                } catch {
                                    print("Error searching users: \(error.localizedDescription)")
                                }
                            }
                        }
                    
                    Button(action: {
                        // Perform the action only if the form is valid
                        if isFormValid() {
                            Task {
                                do {
                                    try await userService.searchUsers(query: searchText)
                                    invitedMembers.append(contentsOf: userService.searchResults ?? [])
                                    showAlert = true
                                } catch {
                                    print("Error searching users: \(error.localizedDescription)")
                                }
                            }
                        }
                    }) {
                        Image(systemName: "magnifyingglass")
                            .font(.title)
                            .padding(.horizontal)
                    }
                    .disabled(!isFormValid()) // Disable the button if the form is not valid
                }
                .padding(.top)
                .padding(.horizontal)
                
                if let searchResults = userService.searchResults {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 5) {
                            ForEach(searchResults) { user in
                                HStack {
                                    Text(user.fullname)
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                    Spacer()
                                    Button(action: {
                                        // Action for sending invite
                                        Task {
                                            do {
                                                try await userService.sendInvite(to: user)
                                                invitedMembers.append(user)
                                                showAlert = true
                                            } catch {
                                                print("Error sending invite: \(error.localizedDescription)")
                                            }
                                        }
                                    }) {
                                        Text("Send Invite")
                                            .foregroundColor(.blue)
                                            .opacity(isSendInviteEnabled ? 1.0 : 0.5)
                                            .disabled(!isSendInviteEnabled)
                                    }
                
                                    .padding(.horizontal)
                                    .onTapGesture {
                                        Task {
                                            do {
                                                try await userService.sendInvite(to: user)
                                                invitedMembers.append(user)
                                                showAlert = true
                                            } catch {
                                                print("Error sending invite: \(error.localizedDescription)")
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.top)
                    .frame(maxHeight: .infinity)
                    .padding(.bottom, 10)
                }
                
                Spacer()
                
                .frame(maxHeight: 150)
                
                NavigationLink(destination: WaitingRoom(groupName: groupName, invitedMembers: invitedMembers)) {
                    Text("Let's go wait in the waiting room")
                        .foregroundColor(.white)
                        .font(Font.custom("Inter", size: 20).weight(.medium))
                        .padding(.vertical, 10)
                        .padding(.horizontal, 20)
                        .background(Color.black)
                        .cornerRadius(20)
                }

                .padding(.bottom, 20)
                Divider()
                Text("Group Invites Below")
                
                ForEach(viewModel.groupUsers) { user in
                    HStack {
                        Text(user.fullname) // Assuming 'fullname' is a property representing the user's name
                        Spacer()
                        NavigationLink(destination: WaitingRoomForOthers()) {
                            Text("Accept")
                                .foregroundColor(.white)
                                .font(Font.custom("Inter", size: 10).weight(.medium))
                                .padding(.vertical, 10)
                                .padding(.horizontal, 20)
                                .background(Color.green)
                                .cornerRadius(20)
                        }
                        .padding(.trailing, 10)
                        .onTapGesture {
                            invitedMembers.append(user)
                        }
                        
                        Button(action: {
                                   // Remove the user from invitedMembers
                            if let index = invitedMembers.firstIndex(where: { $0.id == user.id }) {
                                                invitedMembers.remove(at: index)
                                            }
                                        }) {
                                   Text("Decline")
                                       .foregroundColor(.white)
                                       .font(Font.custom("Inter", size: 10).weight(.medium))
                                       .padding(.vertical, 10)
                                       .padding(.horizontal, 20)
                                       .background(Color.red)
                                       .cornerRadius(20)
                               }
                           }
                           .padding(.horizontal)
                       }

                
                Divider()
                
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 350, height: 200)
                    .background(
                        Image("Logo")
                            .resizable()
                    )
                    .offset(x: 4, y: 10)
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
                    .navigationBarBackButtonHidden(true)
                    
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
                .padding(.top, 40)
                .padding(.horizontal, 24)
                .padding(.leading, 110)
            }
            .padding(.top, -30)
        }
        .navigationBarBackButtonHidden(true)
        .alert(isPresented: Binding(
                get: { showAlert && isFormValid() },
                set: { showAlert = $0 && isFormValid() })
        ) {
            Alert(title: Text("Sent Friend Invite for Group"))
        }
    }
}

#if DEBUG
struct GroupsView_Previews: PreviewProvider {
    static var previews: some View {
        GroupsView()
    }
}
#endif
