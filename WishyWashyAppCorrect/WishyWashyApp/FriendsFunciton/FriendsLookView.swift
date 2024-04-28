import SwiftUI

struct FriendLookView: View {
    @StateObject private var userService = UserService.shared
    private var user: User
    @State private var isAccepted: Bool = false
    @State private var isDeclined: Bool = false

    init(user: User) {
        self.user = user
    }

    var body: some View {
        if !isDeclined {
            HStack {
                VStack(alignment: .leading, spacing: 8) { // Adjust spacing here
                    Text(user.fullname ?? "")
                        .font(Font.custom("Inter", size: 16).weight(.medium))
                        .fontWeight(.semibold)
                        .fixedSize(horizontal: false, vertical: true) // Allow text to wrap

                    // Show the "Added Friend" bar if accepted
                    if isAccepted {
                        Text("Added Friend")
                            .foregroundColor(.blue)
                            .font(Font.custom("Inter", size: 16).weight(.medium))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                            .transition(.move(edge: .leading)) // Apply transition for smooth appearance
    
                    }
                }

                Spacer(minLength: 5) // Pushes the accept/decline buttons to the end of the HStack

                // Show accept/decline buttons if not yet accepted or declined
                if !isAccepted && !isDeclined {
                    HStack(spacing: 2) { // Increased spacing between buttons
                        Button {
                            Task {
                                do {
                                    // Accept action
                                   // try await userService.acceptFriendRequest(from: user)
                                    isAccepted = true
                                } catch {
                                    print("Error accepting friend request: \(error.localizedDescription)")
                                }
                            }
                        } label: {
                            Text("Accept")
                                .foregroundColor(.white)
                                .frame(width: 100, height: 32)
                                .background(.green)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .disabled(isAccepted || isDeclined)

                        Divider()

                        Button {
                            Task {
                                do {
                                    // Decline action
                                    //try await userService.rejectFriendRequest(from: user)
                                    isDeclined = true
                                } catch {
                                    print("Error rejecting friend request: \(error.localizedDescription)")
                                }
                            }
                        } label: {
                            Text("Decline")
                                .foregroundColor(.white)
                                .frame(width: 100, height: 32)
                                .background(.red)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .disabled(isAccepted || isDeclined)
                    }
                    .padding(.horizontal) // Add horizontal padding
                }
            }
            .padding(.horizontal)
            .opacity(isAccepted ? 0.5 : 1.0)
            .onAppear {
                // Refresh data when the view appears
                refreshData()
            }
        } else {
            EmptyView() // Hide the view if the friend request is declined
        }
    }
    
    // Function to refresh data
    private func refreshData() {
        // Reset isDeclined state to ensure proper refreshing
        isDeclined = false
    }
}

struct FriendLookView_Previews: PreviewProvider {
    static var previews: some View {
        FriendLookView(user: User(id: "1", fullname: "Wajih", email: "fcwajih2000@gmail.com", friendsIds: [], friendsRequestsID: []))
    }
}
