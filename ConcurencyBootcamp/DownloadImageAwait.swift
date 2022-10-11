//
//  DownloadImageAwait.swift
//  ConcurencyBootcamp
//
//  Created by Миша Перевозчиков on 11.10.2022.
//

import SwiftUI
import Combine


class DownloadImageAsyncImageLoader {
    
    let url: URL = URL(string: "https://loremflickr.com/320/240")!
    
    func handleOutput(data: Data?, response: URLResponse?) -> UIImage? {
        guard
            let data = data,
            let image = UIImage(data: data),
            let response = response as? HTTPURLResponse,
            (200...300).contains(response.statusCode)
        else {
            return nil
        }
        return image
    }
    
    func downloadWithEscaping(completionHandler: @escaping (_ image: UIImage?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            
            let image = self?.handleOutput(data: data, response: response)
            completionHandler(image, error)
            
        }
        .resume()
    }
    
    func downloadWithCombine() -> AnyPublisher<UIImage?, Error> {
        URLSession.shared.dataTaskPublisher(for: url)
            .map(handleOutput)
            .mapError { $0 } //Transform URLError to regular Error
            .eraseToAnyPublisher()
    }
    
    func downloadAsync() async throws -> UIImage? {
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url, delegate: nil)
            let image = handleOutput(data: data, response: response)
            return image
        } catch  {
            throw error
        }
        
    }
}

class DownloadImageAwaitViewModel: ObservableObject {
    
    @Published var image: UIImage?
    
    var cancellables = Set<AnyCancellable>()
    
    let loader = DownloadImageAsyncImageLoader()
    
    func fetchImage() async {
        //        self.image = UIImage(systemName: "heart.fill")
        
        //MARK: ESCAPING
//        loader.downloadWithEscaping { [weak self] image, error in
//            DispatchQueue.main.async {
//                self?.image = image
//            }
        //MARK: COMBINE
//        loader.downloadWithCombine()
//            .receive(on: DispatchQueue.main)
//            .sink { _ in
//
//            } receiveValue: { [weak self] image in
//                self?.image = image
//            }
//            .store(in: &cancellables)

        //MARK: ASYNC
        let image = try? await loader.downloadAsync()
        await MainActor.run{
            self.image = image
        }
     
    }
}


struct DownloadImageAwait: View {
    
    @StateObject var vm = DownloadImageAwaitViewModel()
    
    var body: some View {
        ZStack {
            if let image = vm.image {
                Image(uiImage: image)
            }
        }
        .onAppear{
            Task {
               await vm.fetchImage()
            }
        }
    }
}

struct DownloadImageAwait_Previews: PreviewProvider {
    static var previews: some View {
        DownloadImageAwait()
    }
}
