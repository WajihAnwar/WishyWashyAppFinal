
import Foundation
import Firebase

//User that is saved and formatted 
struct User: Identifiable, Hashable, Codable {
    let id: String
    var fullname: String
    let email: String
    var friendsIds: [String]
    var friendsRequestsID: [String]

     
    
    var initials: String {
        let formatter = PersonNameComponentsFormatter()
        if let components = formatter.personNameComponents(from: fullname) {
            formatter.style = .abbreviated
            return formatter.string(from: components)
        }
        
        return ""
    }
}

