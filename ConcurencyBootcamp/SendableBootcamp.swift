//
//  SendableBootcamp.swift
//  ConcurencyBootcamp
//
//  Created by Миша Перевозчиков on 24.10.2022.
//

import SwiftUI

actor CurrentDataManager {
    
    func updateDatabase(user: MyUserInfo) {
        
    }
}

struct MyUserInfo: Sendable {
    
    let name: String
}

final class MuClassUserInfo: @unchecked Sendable {
    private var name: String
    
    let queue = DispatchQueue(label: "my.first")
    
    init(name: String) {
        self.name = name
    }
}


class SendableBootcampViewModel {
    
    let dataManager = CurrentDataManager()
    
    func updateCurrentUserInfo() async {
        let info = MyUserInfo(name: "BOB")
        
        await dataManager.updateDatabase(user: info)
    }
}

struct SendableBootcamp: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct SendableBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        SendableBootcamp()
    }
}
