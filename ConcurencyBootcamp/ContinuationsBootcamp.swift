//
//  ContinuationsBootcamp.swift
//  ConcurencyBootcamp
//
//  Created by Миша Перевозчиков on 15.10.2022.
//

import SwiftUI

class ContinuationsBootcampNetworkManager {
    
    func getData(url: URL) async throws -> Data {
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            return data
        } catch  {
            throw error
        }
    }
    
    //YOU MUST RESUME CONTINUATION at least ONCE in ANY SITUATION
    func getData2(url: URL) async throws -> Data {
        return try await withCheckedThrowingContinuation { continuation in
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    continuation.resume(returning: data)
                } else if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(throwing: URLError(.badURL))
                }
            }
            .resume()
        }
    }
    
    func getImageFromDatabase() async -> UIImage {
         return await withCheckedContinuation{ continuation in
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                let image = UIImage(systemName: "heart.fill")!
                continuation.resume(returning: image)
                
            }
        }
    }
}

class ContinuationsBootcampViewModel: ObservableObject {
    
    @Published var image: UIImage?
    let networkManager = ContinuationsBootcampNetworkManager()
    
    func getImage() async {
        guard let url = URL(string: "https://loremflickr.com/320/240") else { return }
        
        do {
            let data = try await networkManager.getData(url: url)
            if let image = UIImage(data: data) {
                await MainActor.run(body: {
                    self.image = image
                })
            }
        } catch  {
            print(error.localizedDescription)
        }
    }
    
    func getImage2() async {
        self.image = await networkManager.getImageFromDatabase()
    }
}

struct ContinuationsBootcamp: View {
    
    @StateObject var vm = ContinuationsBootcampViewModel()
    
    var body: some View {
        ZStack{
            
        }
        .task {
            await vm.getImage()
        }
    }
}

struct ContinuationsBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        ContinuationsBootcamp()
    }
}
