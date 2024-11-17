import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var context
    @Query private var items: [Movie]
    
    @State private var newMovieName: String = ""
    @State private var newMovieDate: Date = Date()
    @State private var newMovieGenre: String = "Action"
    
    @State private var editingMovie: Movie? = nil
    @State private var updatedMovieName: String = ""
    @State private var updatedMovieDate: Date = Date()
    @State private var updatedMovieGenre: String = ""
    
    @State private var isAddMoviePopupVisible: Bool = false
    
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    
    @AppStorage("isDarkMode") private var isDarkMode = false
    @AppStorage("selectedFont") private var selectedFont = "Arial"
    
    let genres = ["Action", "Comedy", "Drama", "Horror", "Romance", "Sci-Fi", "Thriller", "Fantasy", "Documentary"]
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Movie Wishlist")
                    .font(.custom(selectedFont, size: 26))
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .padding(.top)
                
                List {
                    ForEach(items) { item in
                        HStack {
                            Text(item.name)
                                .font(.custom(selectedFont, size: 18))
                                .foregroundColor(.primary)
                            
                            Spacer()
                            
                            Text(item.genre)
                                .font(.custom(selectedFont, size: 16))
                                .foregroundColor(.gray)
                                .italic()
                            
                            Button {
                                startEditing(item)
                            } label: {
                                Image(systemName: "pencil")
                                    .foregroundColor(.accentColor)
                                    .padding(5)
                                    .background(Circle().fill(Color.red.opacity(0.2)))
                            }
                        }
                    }
                    .onDelete { indexes in
                        for index in indexes {
                            deleteItem(items[index])
                        }
                    }
                }
                .padding(.horizontal)
                .listStyle(PlainListStyle())
                
                if !isAddMoviePopupVisible && editingMovie == nil {
                    Button(action: {
                        isAddMoviePopupVisible.toggle()
                    }) {
                        Text("Add New Movie")
                            .font(.headline)
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding(.top)
                    }
                    .padding(.bottom, 20)
                }
                
                if isAddMoviePopupVisible {
                    VStack(spacing: 20) {
                        Text("Add a New Movie")
                            .font(.custom(selectedFont, size: 22))
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                            .padding(.top)

                        TextField("Enter movie name", text: $newMovieName)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                            .padding(.horizontal)
                        
                        DatePicker("Release Date", selection: $newMovieDate, displayedComponents: .date)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                            .padding(.horizontal)
                        
                        Picker("Select Genre", selection: $newMovieGenre) {
                            ForEach(genres, id: \.self) { genre in
                                Text(genre).tag(genre)
                            }
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        .padding(.horizontal)
                        
                        Button(action: addItem) {
                            Text("Add Movie")
                                .font(.headline)
                                .padding()
                                .background(Color.red)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .padding(.top)
                        }
                        
                        Button(action: { isAddMoviePopupVisible.toggle() }) {
                            Text("Close")
                                .font(.headline)
                                .padding()
                                .foregroundColor(.red)
                        }
                    }
                    .padding(.bottom)
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(radius: 10)
                    .padding()
                    .transition(.move(edge: .bottom))
                }
                
                if let movieToEdit = editingMovie {
                    VStack {
                        Text("Update Movie")
                            .font(.custom(selectedFont, size: 22))
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                            .padding(.top)
                        
                        TextField("Update movie name", text: $updatedMovieName)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                            .padding(.horizontal)
                        
                        DatePicker("Update Release Date", selection: $updatedMovieDate, displayedComponents: .date)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                            .padding(.horizontal)
                        
                        Picker("Select Genre", selection: $updatedMovieGenre) {
                            ForEach(genres, id: \.self) { genre in
                                Text(genre).tag(genre)
                            }
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        .padding(.horizontal)
                        
                        Button(action: { updateItem(movieToEdit) }) {
                            Text("Save Changes")
                                .font(.headline)
                                .padding()
                                .background(Color.red)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .padding(.top)
                        }
                        
                        Button(action: cancelEditing) {
                            Text("Cancel")
                                .font(.headline)
                                .padding()
                                .foregroundColor(.red)
                        }
                    }
                    .padding(.bottom)
                }
            }
            .background(Color(.systemBackground))
            .cornerRadius(15)
            .shadow(radius: 10)
            .padding()
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Notification"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
            .preferredColorScheme(isDarkMode ? .dark : .light)
            .navigationBarItems(trailing: NavigationLink(destination: ThemeSettingsView()) {
                Image(systemName: "gear")
                    .foregroundColor(.red) 
            })
        }
    }
    
    func addItem() {
        if items.contains(where: { $0.name.lowercased() == newMovieName.lowercased() }) {
            alertMessage = "A movie with the same name already exists."
            showAlert = true
            return
        }
        
        guard !newMovieName.isEmpty, !newMovieGenre.isEmpty else { return }
        
        let item = Movie(name: newMovieName, releaseDate: newMovieDate, genre: newMovieGenre)
        context.insert(item)
        
        newMovieName = ""
        newMovieDate = Date()
        newMovieGenre = "Action"
        
        isAddMoviePopupVisible = false
        
        alertMessage = "Movie has been successfully added."
        showAlert = true
    }
    
    func deleteItem(_ item: Movie) {
        context.delete(item)
    }
    
    func startEditing(_ item: Movie) {
        editingMovie = item
        updatedMovieName = item.name
        updatedMovieDate = item.releaseDate
        updatedMovieGenre = item.genre
        
        isAddMoviePopupVisible = false
    }
    
    func updateItem(_ item: Movie) {
        item.name = updatedMovieName
        item.releaseDate = updatedMovieDate
        item.genre = updatedMovieGenre
        
        try? context.save()
        
        alertMessage = "Movie has been successfully updated."
        showAlert = true
        
        cancelEditing()
    }
    
    func cancelEditing() {
        editingMovie = nil
        updatedMovieName = ""
        updatedMovieDate = Date()
        updatedMovieGenre = ""
    }
}

#Preview {
    ContentView()
}
