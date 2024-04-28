import SwiftUI

struct FriendsView: View {
    var body: some View {
        NavigationView {
            ZStack {
                // Friends title text
                Text("Friends")
                    .font(.custom("Inter", size: 16))
                    .lineSpacing(24)
                    .foregroundColor(.black)
                    .offset(x: -3, y: -300) // Adjust positioning as needed
                
                // Action buttons with proper destinations
                VStack(spacing: 30) {
                    NavigationLink(destination: FindFriendsView()) {
                        ActionButton(text: "Find Your Friend")
                    }
                    
                    NavigationLink(destination: GroupsView()) {
                        ActionButton(text: "Groups")
                    }
                    .padding(.bottom,10)
                }
                .offset(y:-160)
                
                // Placeholder image for the friends section (replace with actual content)
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 350, height: 280)
                    .background(
                        Image("Logo")
                            .resizable()
                    )
                    .offset(x: -5, y: 100) // Adjust positioning as needed
                
                // Friends category buttons
                CategoryButtons()
                    .offset(x: -10, y: -345) // Adjust positioning as needed
                
                
                
                // Home Button
                NavigationLink(destination: HomePage()) {
                    Image(systemName: "house.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 50)
                        .foregroundColor(.black)
                }
                .padding(.top,700)
                .navigationBarBackButtonHidden(true)
                // Profile Settings Button
                NavigationLink(destination: ProfileView()) {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 50)
                        .foregroundColor(.black)
                }
                .navigationBarBackButtonHidden(true)
                .padding(.horizontal, 100)
                .padding(.top,700 )
                .offset(x: 150, y: 0)
            }
  
            }
            
            
            

            .frame(width: 375, height: 812)
            .background(Color.white)
            .navigationBarTitle("", displayMode: .inline) // Hide navigation bar title
            .navigationBarBackButtonHidden(true) // Hide navigation back button
            
        }
    }


// Struct for action buttons with centered text
struct ActionButton: View {
    let text: String

    var body: some View {
        Text(text)
            .font(Font.custom("Inter", size: 35).weight(.medium))
            .lineSpacing(24)
            .foregroundColor(.white)
            .frame(width: 300, height: 56) // Center text horizontally
            .padding(EdgeInsets(top: 18, leading: 40, bottom: 18, trailing: 40))
            .background(Color.black)
            .cornerRadius(100)
            .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.05), radius: 2, x: 0, y: 1)
    }
}

// Struct for individual button items within the category buttons
struct ButtonItem: View {
    let text: String
    let backgroundColor: Color
    let textColor: Color

    var body: some View {
        Text(text)
            .font(Font.custom("Inter", size: 14).weight(.medium))
            .lineSpacing(19.60)
            .foregroundColor(textColor)
            .padding(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
            .background(backgroundColor)
            .cornerRadius(20)
    }
}

struct Friends_Previews: PreviewProvider {
    static var previews: some View {
        FriendsView()
    }
}

// Struct for friends category buttons with navigation links
struct CategoryButtons: View {
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
          
            // Friends Tab button with navigation (replace destination if needed)
            NavigationLink(destination: FindFriendsView()) {
                ButtonItem(text: "Find Friend", backgroundColor: Color(red: 0.96, green: 0.96, blue: 0.96), textColor: .black)
            }
            // Group button with navigation (replace destination if needed)
            NavigationLink(destination: GroupsView()) {
                ButtonItem(text: "Group", backgroundColor: Color(red: 0.96, green: 0.96, blue: 0.96), textColor: .black)
            }
        }
        .padding(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
    }
}
