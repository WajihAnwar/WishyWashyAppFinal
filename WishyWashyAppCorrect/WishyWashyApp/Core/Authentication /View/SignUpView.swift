import SwiftUI

struct SignUpView: View {
    
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: SignUpModel

    
    init(viewModel: SignUpModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Text("WishyWashy Registration Page")
                    .font(Font.custom("Inter", size: 24).weight(.semibold))
                    .foregroundColor(.black)
                    .padding(.top,-1)
                
                Image("Logo")
                    .resizable()
                    .scaledToFill()
                    .foregroundColor(.clear)
                    .frame(width: 350, height: 250)
                    .padding(.top,25)
                
                VStack(alignment :.leading,spacing: 12) {
                    Text("What's your email address?(Must be valid @email)")
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
                    
                    Text("Please enter your full name ")
                        .foregroundColor(Color(.darkGray))
                        .fontWeight(.semibold)
                        .font(.footnote)
                    TextField("Fullname", text: $viewModel.fullname)
                        .textInputAutocapitalization(.never)
                        .font(.system(size: 14))
                        .padding(.vertical, 10)
                        .padding(.horizontal, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray, lineWidth: 1))
                    Text("Enter Password, must be 6 characters ")
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
                                     
                    SecureField("Confirm Password", text: $viewModel.confirmPassword)
                        .textInputAutocapitalization(.never)
                        .font(.system(size: 14))
                        .padding(.vertical, 10)
                        .padding(.horizontal, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray, lineWidth: 1))
                    
                }
                
                if !viewModel.password.isEmpty && !viewModel.confirmPassword.isEmpty {
                    if viewModel.password == viewModel.confirmPassword {
                        Image(systemName: "checkmark.circle.fill")
                            .imageScale(.large)
                            .fontWeight(.bold)
                            .foregroundColor(Color(.systemGreen))
                    } else {
                        Image(systemName: "xmark.circle.fill")
                            .imageScale(.large)
                            .fontWeight(.bold)
                            .foregroundColor(Color(.systemRed))
                    }
                }
                
                // Sign in button
                // Sign up button
                               Button {
                                   Task {
                                       do {
                                           try await self.viewModel.createUser()
                    
                                       } catch {
                                           print("Failed to create user: \(error.localizedDescription)")
                                       }
                                   }
                               } label: {
                                   HStack {
                                       Text("SIGN UP")
                                           .fontWeight(.semibold)
                                       Image(systemName: "arrow.right")
                                   }
                                   .foregroundColor(.white)
                                   .frame(width: UIScreen.main.bounds.width - 32, height: 48)
                               }
                               .background(Color.black)
                               .disabled(!formIsValid)
                               .opacity(formIsValid ? 1.0 : 0.5)
                               .cornerRadius(10)
                               .padding(.top)
                               
                               Spacer()
                               
                               Button {
                                   dismiss()
                               } label: {
                                   HStack(spacing: 2) {
                                       Text("Already have an account?")
                                       Text("Sign in")
                                           .fontWeight(.bold)
                                   }
                               }
                           }
                       }
                   
                   }
    
    var formIsValid: Bool {
        !viewModel.email.isEmpty &&
            viewModel.email.contains("@") &&
            !viewModel.password.isEmpty &&
            viewModel.password.count > 5 &&
            viewModel.confirmPassword == viewModel.password
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(viewModel: SignUpModel())
    }
}
