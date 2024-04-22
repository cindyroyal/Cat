//
//  ContentView.swift
//  CatFact
//
//  Created by Royal, Cindy L on 4/21/24.
//

import SwiftUI

// Model for the Cat Fact
struct CatFact: Decodable {
    let fact: String
    let length: Int
}

// ViewModel to manage fetching the data
class CatFactViewModel: ObservableObject {
    @Published var fact: String = "Loading..."

    // Function to fetch a new fact
    func fetchCatFact() {
        guard let url = URL(string: "https://catfact.ninja/fact") else { return }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            // Check for errors, make sure we got data
            if let error = error {
                DispatchQueue.main.async {
                    self.fact = "Failed to load: \(error.localizedDescription)"
                }
                return
            }
            guard let data = data else {
                DispatchQueue.main.async {
                    self.fact = "No data received"
                }
                return
            }
            // Try to decode the data
            do {
                let decodedData = try JSONDecoder().decode(CatFact.self, from: data)
                DispatchQueue.main.async {
                    self.fact = decodedData.fact
                }
            } catch {
                DispatchQueue.main.async {
                    self.fact = "Error decoding data: \(error.localizedDescription)"
                }
            }
        }
        task.resume()
    }
}

// SwiftUI View
struct ContentView: View {
    @StateObject var viewModel = CatFactViewModel()

    var body: some View {
        VStack {
            Text(viewModel.fact)
                .padding()
            Button("Fetch New Fact") {
                viewModel.fetchCatFact()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .onAppear {
            viewModel.fetchCatFact()
        }
    }
}

#Preview {
    ContentView()
}
