//
//  AsyncPublisherBT.swift
//  ConcurencyBootcamp
//
//  Created by Миша Перевозчиков on 24.10.2022.
//

import SwiftUI
import Combine

class AsyncDataManager {
    
    @Published var data: [String] = []
    
    func getData() async {
        
        data.append("Apple")
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        data.append("Banana")
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        data.append("Orange")
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        data.append("Cucumber")
        try? await Task.sleep(nanoseconds: 2_000_000_000)
    }
    
}

class AsyncPublisherBTViewModel: ObservableObject {
    
   @MainActor @Published var dataArray: [String] = []
    let manager = AsyncDataManager()
    var cancellables = Set<AnyCancellable>()
    
    init() {
        addSubscriber()
    }
    
    private func addSubscriber() {
        
        Task {
            for await value in manager.$data.values {
                await MainActor.run(body: {
                    self.dataArray = value
                })
            }
             
        }
        
        //Combine more complex code
//        manager.$data
//            .receive(on: DispatchQueue.main)
//            .sink { dataArray in
//                self.dataArray = dataArray
//            }
//            .store(in: &cancellables)
//
    }
    
    func start() async {
        await manager.getData()
    }
}

struct AsyncPublisherBT: View {
    
    @StateObject private var vm = AsyncPublisherBTViewModel()
    
    var body: some View {
        VStack {
            ForEach(vm.dataArray, id: \.self) { str in
                Text(str)
            }
        }
        .task {
            await vm.start()
        }
    }
}

struct AsyncPublisherBT_Previews: PreviewProvider {
    static var previews: some View {
        AsyncPublisherBT()
    }
}
