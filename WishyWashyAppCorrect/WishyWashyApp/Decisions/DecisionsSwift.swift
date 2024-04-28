import SwiftUI

struct DecisionsView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Title
                Text("Decisions")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 20)  // Add padding at the top to move the title closer to the top of the screen
                
                Spacer()
                
                VStack(spacing: 20) {
                    // Subtitle for past decisions
                    Text("View Past Decisions")
                        .font(.subheadline)
                    
                    // Row with buttons for Food and Activities decisions
                    HStack(spacing: 20) {
                        // Food (Decisions) button
                        NavigationLink(destination: RestaurantView()) {
                            Text("Food (Decisions)")
                                .padding()
                                .background(Color.black)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        
                        // Activities (Decisions) button
                        NavigationLink(destination: ActivitiesView()) {
                            Text("Activities (Decisions)")
                                .padding()
                                .background(Color.black)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                                .lineLimit(1)  // Ensures the text stays on one line
                        }
                    }
                    
                    // Subtitle for previous ratings
                   // Text("Previous Ratings")
                    //   .font(.subheadline)
                    
                    // Row with buttons for Food and Activities ratings
                    /*HStack(spacing: 20) {
                        // Food (Ratings) button
                        NavigationLink(destination: Text("Food (Ratings)")) {
                            Text("Food (Ratings)")
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        
                        // Activities (Ratings) button
                        /*NavigationLink(destination: Text("Activities (Ratings)")) {
                            Text("Activities (Ratings)")
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }*/
                    }*/
                    Spacer()
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 350, height: 480)
                        .background(
                            Image("Logo")
                                .resizable()
                        )
                        .offset(x: -5, y: 1) // Adjust positioning as needed
                    HStack {
                        
                            Spacer()
                            // Home Button
                            NavigationLink(destination: HomePage()) {
                                Image(systemName: "house.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 100, height: 50)
                                    .foregroundColor(.black)
                            }
                            .padding(.vertical, 8)
                            .padding(.trailing, 8)
                            .navigationBarBackButtonHidden(true)
                            
                            Spacer()
                            
                            // Profile Settings Button
                            NavigationLink(destination: ProfileView()) {
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 100, height: 50)
                                    .foregroundColor(.black)
                            }
                            .padding(.vertical, 8)
                            .padding(.leading,10)
                            .navigationBarBackButtonHidden(true)
                            
                            Spacer()
                        }
                        .padding(.leading, 100)
                    }
                }
            .navigationBarBackButtonHidden(true) // Hide the back button
            }
            .navigationBarBackButtonHidden(true) // Hide the back button
        }
  
    }

struct DecisionsView_Previews: PreviewProvider {
    static var previews: some View {
        DecisionsView()
    }
}
