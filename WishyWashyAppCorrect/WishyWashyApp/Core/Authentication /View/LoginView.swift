

import SwiftUI

struct LoginView_: View {
    
    @StateObject private var viewModel  = LoginViewModel()
    var formIsValid: Bool {
        return !viewModel.email.isEmpty || !viewModel.password.isEmpty
    }

    
    
    var body: some View {
        NavigationView{
            VStack{
                //image
                
                
                Text("WishyWashy ")
                    .font(Font.custom("Inter", size: 24).weight(.semibold))
                    .foregroundColor(.black)
                    .padding(.top,50)
                
                Image("Logo")
                    .resizable()
                    .scaledToFill()
                    .foregroundColor(.clear)
                    .frame(width:350, height:250)
                    .padding(.bottom,25)
                
                
                VStack(alignment :.leading,spacing: 12) {
                    Text("Enter in your email")
                        .foregroundColor(Color(.darkGray))
                        .fontWeight(.semibold)
                        .font(.footnote)
                    TextField("Email Address", text: $viewModel.email)
                        .textInputAutocapitalization(.never)
                        .font(.system(size: 14))
                        .padding(.vertical, 10)
                        .padding(.horizontal, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray, lineWidth: 1))
                    
                    Text("Enter in your password")
                        .foregroundColor(Color(.darkGray))
                        .fontWeight(.semibold)
                        .font(.footnote)
                    SecureField("Password", text: $viewModel.password)
                        .textInputAutocapitalization(.never)
                        .font(.system(size: 14))
                        .padding(.vertical, 10)
                        .padding(.horizontal, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray, lineWidth: 1))
                    
                }
                .padding(.horizontal)
                .padding(.top, 12)
                
                //Sign in button
                
                //Sign in button
                
                Button {
                    Task {
                        try await viewModel.login()
                        
                    }
                } label: {
                    HStack {
                        Text("Sign in ")
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.white)
                    .frame(width: UIScreen.main.bounds.width - 32, height: 48)
                }
                .background(Color.black) // Change background color to black
                .disabled(!formIsValid) // Disable the button based on form validity
                .opacity(formIsValid ? 1.0 : 0.5) // Adjust opacity based on form validity
                .cornerRadius(10)
                .padding(.top, 24)
                
                
                Button {
                  
                    
                    //}
                } label: {
                    HStack {
                        Text("Forgot Password ")
                            .fontWeight(.semibold)
                    }
                    .fontWeight(.bold)
                    .font(.system(size:15))
                }
                .padding(.top,5)
                
                
                
                
                //Sign up Button
                NavigationLink(destination: SignUpView(viewModel: SignUpModel())) {
                    Text("Dont have an account? ")
                    Text("Sign up")
                        .fontWeight(.bold)
                }
                .font(.system(size: 15))
                .navigationBarBackButtonHidden(true)
                .padding(.top, 100)
                
                
            }
        }
    }
}
        
        
 



struct LoginView_Previews : PreviewProvider{
    static var previews : some View {
        LoginView_()
    }
}

