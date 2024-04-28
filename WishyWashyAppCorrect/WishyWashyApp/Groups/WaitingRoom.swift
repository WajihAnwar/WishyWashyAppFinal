import SwiftUI

struct WaitingRoom: View {
    var groupName: String
    var invitedMembers: [User]

    var body: some View {
        VStack {
            HStack(spacing:25){
                TabView(title: "Friend", backgroundColor: .gray)
                TabView(title: "Groups", backgroundColor: .gray.opacity(0.5), isGroupsTab: true)
            }
            .padding(.horizontal)
            .padding(.top,20)
            Divider()
            // Display group name
            Text("Group Name: \(groupName)")
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(20)
                .textFieldStyle(PlainTextFieldStyle())
                .padding(.horizontal)
            HStack {
                Text("Shrek")
                    .padding(.leading,50)
                Text("Leader") // Display status
                    .padding(.horizontal, 20)
                    .padding(.vertical, 0)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(20)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding(.horizontal)
            }
            .padding(.leading, 50)
            // Display invited members with status
            ScrollView {
                VStack(alignment: .leading, spacing: 15) {
                    Text("Invited Members:")
                        .padding(.trailing,100)
                        .padding(.horizontal)
                        .padding(.leading, 120)
                    
                    ForEach(invitedMembers) { user in
                        HStack {
                            Text(user.fullname)
                            Text(" - Pending") // Display status
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(20)
                                .textFieldStyle(PlainTextFieldStyle())
                                .padding(.horizontal)
                        }
                        .padding(.leading, 50)
                    }
                }
                .frame(maxHeight: 200) // Adjust height as needed
                .padding(.top, 10)
            }

            // Button for action
            Button(action: {
                // Action for the button
            }) {
                Text("Let's Start Deciding with your Group")
                    .foregroundColor(.white)
                    .font(Font.custom("Inter", size: 20).weight(.medium))
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
                    .background(Color.black)
                    .cornerRadius(20)
            }
            .padding(.top)
            Spacer()
            
            // Navigation links
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
                .frame(maxHeight: 100)
            }
            .padding(.top, 40)
            .padding(.horizontal, 24)
            .padding(.leading, 110)
        }
        .padding(.top, 40)
        .navigationBarBackButtonHidden(true)
    }
}

struct WaitingRoom_Previews: PreviewProvider {
    static var previews: some View {
        WaitingRoom(groupName: "Your Group Name", invitedMembers: [])
    }
}
