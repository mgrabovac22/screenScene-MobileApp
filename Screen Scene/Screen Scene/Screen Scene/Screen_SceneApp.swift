import SwiftUI
import SwiftData

@main
struct MovieApp: App {
    @StateObject var movieManager = MovieManager(context: DataController.shared.context)

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(movieManager)
        }
    }
}

struct ContentView: View {
    @EnvironmentObject var movieManager: MovieManager
    @State private var title = ""
    @State private var year = ""
    @State private var genre = ""
    @State private var description = ""

    var body: some View {
        NavigationView {
            VStack {
                // Form for adding a new movie
                Form {
                    TextField("Title", text: $title)
                    TextField("Year", text: $year)
                        .keyboardType(.numberPad)
                    TextField("Genre", text: $genre)
                    TextField("Description", text: $description)
                }
                .padding()
                
                Button("Add Movie") {
                    guard let yearInt = Int(year) else { return }
                    movieManager.addMovie(title: title, year: yearInt, genre: genre, description: description)
                    // Clear form after adding
                    title = ""
                    year = ""
                    genre = ""
                    description = ""
                }
                .padding()
                
                List(movieManager.movies, id: \.id) { movie in
                    VStack(alignment: .leading) {
                        Text(movie.title).font(.headline)
                        Text("Year: \(movie.year)")
                        if let genre = movie.genre {
                            Text("Genre: \(genre)")
                        }
                        if let description = movie.description {
                            Text(description)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                    .onTapGesture {
                        movieManager.deleteMovie(movie: movie)
                    }
                }
            }
            .navigationBarTitle("Movies")
        }
    }
}
