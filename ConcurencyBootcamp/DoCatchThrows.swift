//
//  DoCathThrows.swift
//  ConcurencyBootcamp
//
//  Created by Миша Перевозчиков on 11.10.2022.
//

import SwiftUI

//do-catch
//try
//throw

class DataManager {
    let isActive: Bool = true
    
    func getTitle() -> (title:String?, error: Error?) {
        if isActive {
            return ("NEW TEXT", nil)
        }else {
            return (nil, URLError(.badURL))
        }
        
    }
    func getTitle2() -> Result<String, Error> {
        if isActive {
            return .success("NEW TEXT")
        }else {
            return .failure(URLError(.badURL))
        }
    }
    
    func getTitle3() throws -> String {
//        if isActive {
//            return "NEW TEXT"
//        }else {
            throw URLError(.badURL)
//        }
    }
    
    func getTitle4() throws -> String {
        if isActive {
            return "NEW TEXT"
        }else {
            throw URLError(.badURL)
        }
    }
}
class DoCatchThrowsViewModel: ObservableObject {
    
    @Published var text: String = "Start here"
    let manager = DataManager()
    
    func fetchTitle() {
        
//        let newTitle = try? manager.getTitle3()
//
//        if let newTitle = newTitle {
//            self.text = newTitle
//        }
//
        do {
            let newTitle = try? manager.getTitle3()
            if let newTitle = newTitle {
                self.text = newTitle
            }
           
            
            let finalTitle = try manager.getTitle4()
            self.text = finalTitle
        } catch  {
            self.text = error.localizedDescription
        }
        
        let result = manager.getTitle2()
        
        switch result {
        case .success(let newTitle):
            self.text = newTitle
        case .failure(let error):
            self.text = error.localizedDescription
        }
        
        //FIRST VARIANT
        /*
        let returnedValue = manager.getTitle()
        if let newTitle = returnedValue.title {
            self.text = newTitle
        } else if let error = returnedValue.error{
            self.text = error.localizedDescription
        }
         */
    }
}

struct DoCatchThrows: View {
    
    @StateObject var vm = DoCatchThrowsViewModel()
    
    var body: some View {
        Text(vm.text)
            .foregroundColor(.white)
            .frame(width: 200, height: 200)
            .background(Color.blue)
            .onTapGesture {
                vm.fetchTitle()
            }
    }
}

struct DoCatchThrows_Previews: PreviewProvider {
    static var previews: some View {
        DoCatchThrows()
    }
}
