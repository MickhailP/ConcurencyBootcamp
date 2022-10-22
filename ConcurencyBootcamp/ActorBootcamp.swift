//
//  ActorBootcamp.swift
//  ConcurencyBootcamp
//
//  Created by Миша Перевозчиков on 20.10.2022.
//

import SwiftUI

class MyDataManager {
    static let instance = MyDataManager()
    
    private init() { }
    
    var data: [String] = []
    private let queue = DispatchQueue(label: "com.MyApp.MyDataManager")
    
    func getRandomData(completionHandler: @escaping (_ title: String?) -> Void)  {
        
        queue.async {
            self.data.append(UUID().uuidString)
            print(Thread.current)
            completionHandler( self.data.randomElement())
        }
    }
}

actor MyActorDataManager {
    static let instance = MyActorDataManager()
    
    private init() { }
    
    var data: [String] = []
    
    nonisolated let title = "Title"
    
    func getRandomData() -> String?  {
        
        self.data.append(UUID().uuidString)
        print(Thread.current)
        return self.data.randomElement()
        
    }
    
    //use this keyword to be able to call this function in not async environment
    nonisolated
    func showData() -> String {
        return "THIS is not isolated "
    }
}

struct HomeView: View {
    
    let manager = MyActorDataManager.instance
    
    @State private var text = ""
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack{
            Color.yellow.opacity(0.4).ignoresSafeArea()
            
            Text(text)
                .font(.title)
        }
        .onReceive(timer) { _ in
            let newText = manager.showData()
            
            Task {
                if let data =  await manager.getRandomData() {
                    await MainActor.run{
                        self.text = data
                    }
                }
            }
            
//            DispatchQueue.global(qos: .background).async {
//
//                manager.getRandomData { title in
//                    if let data = title {
//                        DispatchQueue.main.async {
//                            self.text = data
//                        }
//                    }
//                }
//            }
        }
    }
}

struct BrowseView: View {
    
    let manager = MyDataManager.instance
    
    @State private var text = ""
    let timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    
    
    var body: some View {
        ZStack{
            Color.blue.opacity(0.4).ignoresSafeArea()
            
            Text(text)
                .font(.title)
        }
        onReceive(timer) { _ in
            DispatchQueue.global(qos: .background).async {
                
                manager.getRandomData { title in
                    if let data = title   {
                        DispatchQueue.main.async {
                            self.text = data
                        }
                    }
                }
            }
        }
    }
}


struct ActorBootcamp: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            
            BrowseView()
                .tabItem {
                    Label("Browse", systemImage: "magnifyingglass")
                }
        }
    }
}

struct ActorBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        ActorBootcamp()
    }
}
