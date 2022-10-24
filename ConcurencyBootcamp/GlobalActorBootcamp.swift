//
//  GlobalActorBootcamp.swift
//  ConcurencyBootcamp
//
//  Created by Миша Перевозчиков on 22.10.2022.
//

import SwiftUI

@globalActor final class MyFirstGlobalActor {
    
    static var shared = MyNewDataManager()
    
}

actor MyNewDataManager {
    
    func getDataFromDataBase() -> [String] {
        return ["One", "Two", "Three"]
    }
}

@MainActor class GlobalActorViewModel: ObservableObject {
    
    @MainActor @Published var dataArray: [String] = []
    let manager = MyFirstGlobalActor.shared
    
//    nonisolatedw
    @MyFirstGlobalActor
    func getData()  {
        
        //HEAVY COMPLEX METHODS
        
        Task {
            let data = await manager.getDataFromDataBase()
            await MainActor.run(body: {
                self.dataArray = data

            })
        }
    }
}

struct GlobalActorBootcamp: View {
    
    @StateObject var vm = GlobalActorViewModel()
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(vm.dataArray, id: \.self) { data in
                    Text(data)
                        .font(.headline)
                }
            }
        }
        .task {
            await vm.getData()
        }
    }
}

struct GlobalActorBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        GlobalActorBootcamp()
    }
}
