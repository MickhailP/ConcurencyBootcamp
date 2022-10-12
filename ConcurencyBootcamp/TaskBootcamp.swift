//
//  TaskBootcamp.swift
//  ConcurencyBootcamp
//
//  Created by Миша Перевозчиков on 12.10.2022.
//

import SwiftUI

class TaskVM: ObservableObject {
    
    @Published var image: UIImage?
    @Published var image2: UIImage?
    
    
    func fetchImage() async{
        try? await Task.sleep(nanoseconds: 2000000000)
        
        do {
            guard let url = URL(string: "https://loremflickr.com/320/240") else { return }
            let (data, _) = try await URLSession.shared.data(from: url)
            await MainActor.run(body: {
                self.image = UIImage(data: data)
                print("Image Returned")
            })
            
        } catch  {
            print(error.localizedDescription)
        }
    }
    
    func fetchImage2() async{
        
        do {
            guard let url = URL(string: "https://loremflickr.com/320/240") else { return }
            let (data, _) = try await URLSession.shared.data(from: url)
            await MainActor.run(body: {
                self.image2 = UIImage(data: data)
                print("Image Returned")
            })
        } catch  {
            print(error.localizedDescription)
        }
    }
}

struct TaskBootcampHOME: View {
    var body: some View {
        NavigationView {
            NavigationLink(destination: TaskBootcamp()) {
                Text("CLICK ME")
            }
        }
    }
}


struct TaskBootcamp: View {
    
    @StateObject private var vm = TaskVM()
    @State private var imageTask: Task<(), Never>? = nil

    
    var body: some View {
        VStack {
            if let image = vm.image {
                Image(uiImage: image)
            }
            if let image = vm.image2 {
                Image(uiImage: image)
            }
        }
        //AUTOMATICALLY CANCELS
        .task {
            await vm.fetchImage()
        }
//        .onDisappear {
//            imageTask?.cancel()
//        }
//        .onAppear{
//            imageTask =  Task {
//                await vm.fetchImage()
////                await vm.fetchImage2()
//            }
//
//            Task(priority: .high) {
//                print("HIGH")
//            }
//            Task(priority: .userInitiated) {
//                print("User Initiated")
//            }
//            Task(priority: .medium) {
//                print("Medium")
//            }
//            Task(priority: .low) {
//                print("LOW")
//            }
//            Task(priority: .utility) {
//                print("UTILITY")
//            }
//            Task(priority: .background) {
//                print("BACKGROUND")
//            }
//
//        }
    }
}

struct TaskBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        TaskBootcampHOME()
    }
}
