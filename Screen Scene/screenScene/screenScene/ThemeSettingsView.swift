import SwiftUI

struct ThemeSettingsView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    @AppStorage("selectedFont") private var selectedFont = "Arial"
    
    let fonts = ["Arial", "Helvetica", "Courier", "Times New Roman"]
    
    var body: some View {
        VStack {
            Text("Theme Settings")
                .font(.custom(selectedFont, size: 24))
                .fontWeight(.bold)
                .padding(.top)
            
            Toggle(isOn: $isDarkMode) {
                Text("Dark Mode")
                    .font(.custom(selectedFont, size: 18))
            }
            .padding()
            
            Text("Font Selection")
                .font(.custom(selectedFont, size: 18))
                .padding(.top)
            
            Picker("Select Font", selection: $selectedFont) {
                ForEach(fonts, id: \.self) { font in
                    Text(font)
                        .font(.custom(font, size: 18))
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            Spacer()
        }
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(radius: 10)
        .padding()
    }
}

#Preview {
    ThemeSettingsView()
}
