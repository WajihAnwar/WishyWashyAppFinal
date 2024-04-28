import SwiftUI
import Firebase
import FirebaseFirestoreSwift
import FirebaseCore

struct ProfileView: View {

    @StateObject var userService = UserService.shared
    @State private var isHomepageActive = false
    var body: some View {
    
            ZStack() {
                VStack(alignment: .leading, spacing: 20) {
                    
                    HStack(alignment: .top, spacing: 10) {
                        Text("Name")
                            .font(Font.custom("Inter", size: 16).weight(.medium))
                                                   .lineSpacing(19.60)
                                                   .foregroundColor(.black)
                                               Text(userService.currentUser?.fullname ?? "")
                                                   .font(Font.custom("Inter", size: 16))
                                                   .lineSpacing(19.60)
                                                   .foregroundColor(.black)
                                           }
                                           HStack {
                                               Text("Email")
                                                   .font(Font.custom("Inter", size: 16).weight(.medium))
                                                   .lineSpacing(19.60)
                                                   .foregroundColor(.black)
                                               Text(userService.currentUser?.email ?? "")
                                                   .font(Font.custom("Inter", size: 16))
                                                   .lineSpacing(19.60)
                                                   .foregroundColor(.black)
                                           }
                    HStack { // HStack to put "Change Modes" text and tabs on the same line
                        Text("Change Modes")
                            .font(Font.custom("Inter", size: 16).weight(.medium))
                            .lineSpacing(19.60)
                            .foregroundColor(.black)
                        Text("Dark")
                            .font(.caption)
                            .padding(.horizontal, 40)
                            .padding(.vertical, 10)
                            .background(Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 10), style: FillStyle())
                        Text("Light")
                            .font(.caption)
                            .padding(.horizontal, 40)
                            .padding(.vertical, 10)
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color.black))
                            .foregroundColor(.white)
                    }
                    HStack {
                        Text("Change Text Size")
                            .font(Font.custom("Inter", size: 16).weight(.medium))
                            .lineSpacing(19.60)
                            .foregroundColor(.black)
                        Text("Small")
                            .font(.caption)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 10), style: FillStyle())
                        Text("Medium")
                            .font(.caption)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color.black))
                            .foregroundColor(.white)
                        Text("Large")
                            .font(.caption)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 10), style: FillStyle())
                    }
                }
                .padding(.top,-200)
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Circle()
                            .foregroundColor(.blue)
                            .frame(width: 100, height: 100)
                            .overlay(
                                Image(systemName: "person.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.white)
                            )
                            .padding(.top, -700)
                        Spacer()
                    }
                }
                
                Spacer()
                Image("Logo")
                    .resizable()
                    .scaledToFill()
                    .foregroundColor(.clear)
                    .frame(width:350, height:250)
                    .padding(.top, 250)
                
                HStack{
                    NavigationLink(destination: HomePage()) {
                        Image(systemName: "house.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 50)
                            .foregroundColor(.black)
                    }
                    .navigationBarBackButtonHidden(true) // Hide back button for Home
                }
                .padding(.top,700)
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            AuthService.shared.signout()
                        }) {
                            Text("Sign Out")
                                .foregroundColor(.white)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(Color.red)
                                .cornerRadius(8)
                        }
                        .padding(.trailing, 20)
                        .padding(.top, -740)
                    }
                }
            }
        }
    }


struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
