//
//  AsyncAwaitBootcamp.swift
//  ConcurencyBootcamp
//
//  Created by Миша Перевозчиков on 12.10.2022.
//

import SwiftUI

class AsyncAwaitViewModel: ObservableObject {
    
    @Published var dataArray: [String] = []
    
    func addTitle() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.dataArray.append("Title 1: \(Thread.current)")
            
        }
    }
    
    func addTitle2() {
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
            let title2 = "Title 2 : \(Thread.current)"
            
            
            DispatchQueue.main.async {
                self.dataArray.append(title2)
            }
        }
    }
    
    func addAuthor() async {
        let author1 = "Author 1: \(Thread.current)"
        self.dataArray.append(author1)
        
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        
        let author2 = "Author 2: \(Thread.current)"
        await MainActor.run(body: {
            self.dataArray.append(author2)
             
            let author3 = "Author 3: \(Thread.current)"
            self.dataArray.append(author3)

        })
        await self.doSomething()
    }
    
    func doSomething() async {
        try? await Task.sleep(nanoseconds: 2_000_000_000)

        let something1 = "Something 1: \(Thread.current)"
        await MainActor.run(body: {
            self.dataArray.append(something1)
            
            let something2 = "Something 2: \(Thread.current)"
            self.dataArray.append(something2)
        })
    }
}

struct AsyncAwaitBootcamp: View {
    
    @StateObject private var vm = AsyncAwaitViewModel()
    
    var body: some View {
        VStack{
            ForEach(vm.dataArray, id: \.self) { data in
                Text(data)
            }
        }
        .onAppear{
//            vm.addTitle()
//            vm.addTitle2()
            Task {
                await vm.addAuthor()
            }
            
        }
    }
}

struct AsyncAwaitBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        AsyncAwaitBootcamp()
    }
}
