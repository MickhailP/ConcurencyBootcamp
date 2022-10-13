//
//  AsyncLet.swift
//  ConcurencyBootcamp
//
//  Created by Миша Перевозчиков on 13.10.2022.
//

import SwiftUI

class TaskGroupDataManager{
    
    let urlString = "https://loremflickr.com/320/240"
    
    func fetchImagesAsyncLet() async throws-> [UIImage]{
        async let fetchImage1 = fetchImage(url: urlString)
        async let fetchImage2 = fetchImage(url: urlString)
        async let fetchImage3 = fetchImage(url: urlString)
        async let fetchImage4 = fetchImage(url: urlString)
        
        let (image1, image2, image3, image4) = await (try fetchImage1, try fetchImage2, try fetchImage3, try fetchImage4)
        
        return [image1, image2, image3, image4]
        
    }
    
    func fetchImagesTaskGroup () async throws-> [UIImage]{
        
        let urlStrings: [String] = [
            "https://loremflickr.com/320/240",
            "https://loremflickr.com/320/240",
            "https://loremflickr.com/320/240",
            "https://loremflickr.com/320/240",
            "https://loremflickr.com/320/240"
        ]
        
        return try await withThrowingTaskGroup(of: UIImage?.self) { group in
            var images: [UIImage] = []
            images.reserveCapacity(urlStrings.count)
            
            urlStrings.forEach { url in
                group.addTask {
                    try? await self.fetchImage(url: url)
                }
            }
           
           
            
            for try await image in group {
                if let image = image {
                    images.append(image)
                }
            }
            return images
        }
    }
    
    
    private func fetchImage(url: String ) async throws -> UIImage {
        guard let url = URL(string: url) else {
            throw URLError(.badURL)
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let image = UIImage(data: data) {
                return image
            } else {
                throw URLError(.badURL)
                
            }
        } catch  {
            throw error
        }
    }
    
}

class TaskGroupBootcampViewModel: ObservableObject {
    @Published  var images: [UIImage] = []
    let manager = TaskGroupDataManager()
    
    func getImages() async {
        if let images = try? await manager.fetchImagesAsyncLet() {
            self.images.append(contentsOf: images)
        }
    }
}
 
struct AsyncLet: View {
    
    @StateObject private var vm = TaskGroupBootcampViewModel()
    
    @State private var images: [UIImage] = []
    let gridColumns = [GridItem(.flexible()), GridItem(.flexible())]
    let url = URL(string: "https://loremflickr.com/320/240")!
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: gridColumns) {
                    ForEach(images, id: \.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                    }
                }
                
                LazyVGrid(columns: gridColumns) {
                    ForEach(vm.images, id: \.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                    }
                }
            }
            .navigationTitle("Async let and Task group")
            .task {
                await vm.getImages()
            }
            .onAppear{
                Task {
                    do {
                        async let fetchImage1 = fetchImage()
                        async let fetchImage2 = fetchImage()
                        async let fetchImage3  = fetchImage()
                        
                        let (image1, image2, image3) = await (try fetchImage1, try fetchImage2, try fetchImage3)
                        self.images.append(contentsOf: [image1, image2, image3 ])
                        
                        //                        let image1 = try await fetchImage()
                        //                        self.images.append(image1)
                        //
                        //                        let image2 = try await fetchImage()
                        //                        self.images.append(image2)
                        //
                        //                        let image3 = try await fetchImage()
                        //                        self.images.append(image3)
                        //
                        //                        let image4 = try await fetchImage()
                        //                        self.images.append(image4)
                        //
                        //                        let image5 = try await fetchImage()
                        //                        self.images.append(image5)
                    } catch{
                        
                    }
                }
            }
        }
    }
    
    func fetchImage() async throws -> UIImage {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let image = UIImage(data: data) {
                return image
            } else {
                throw URLError(.badURL)
                
            }
        } catch  {
            throw error
        }
    }
}

struct AsyncLet_Previews: PreviewProvider {
    static var previews: some View {
        AsyncLet()
    }
}
