//Setting 
import SwiftUI

struct Settings: View {
    let imageName:String
    let title : String
    let tintColor : Color
    
    var body: some View {
        HStack(spacing :12){
            Image(systemName: imageName)
                .imageScale(.small)
                .font(.title)
                .foregroundColor(tintColor)
            Text(title)
                .font(.subheadline)
                .foregroundColor(.black)
        }
    }
}

struct Settings_Previews:PreviewProvider{
    static var previews : some View {
        Settings(imageName: "gear", title: "Version", tintColor: Color(.systemGray))
    }
}
