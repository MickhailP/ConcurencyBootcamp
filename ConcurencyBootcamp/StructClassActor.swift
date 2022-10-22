//
//  StructClassActor.swift
//  ConcurencyBootcamp
//
//  Created by Миша Перевозчиков on 19.10.2022.
//

import SwiftUI

/*
 
 VALUE TYPES:
 - Struct, Enum, String, Int, Array...
 - Stored in STACK!
 - FASTER
 - THREAD SAFE by default
 - When you assign  or pass value type a new copy of data is created
 
 REFERENCE TYPE:
 - CLASS ACTOR Function
 - Stored in HEAP
 - Slower , but synchronised
 - NOT THREAD Safe by default
 - When you assign or pass reference type a new reference to original instance of data is created ( POINTERS )
 
 STACK:
 - Stores VALUES types
 - More faster than Heap
 - Variables allocated on the stack are stored directly in the memory, and access to this memory is really fast
 - Each thread has IT'S OWN STACK
 
 HEAP:
 - Store REFERENCE TYPE
 - Shared across Threads
 
 
 STRUCT
- Based on VALUES
- Can be MUTATED
- Stored in STACK!
 
 CLASS
- Based on REFERENCES (INSTANCES!)
- Stored in HEAP
- Can INHERIT from other Classes
 
 ACTOR
 - SAME as CLASS,  but THREAD SAFE!
 
 
WHEN TO USE WHICH:

 - STRUCT for DATA MODELS, VIEWS
 
 - CLASSES for VIEW Models,
 
 - ACTOR: SHARED DATA MANAGERS and DATA STORE
 
 */

class StructClassActorViewModel: ObservableObject {
    
    @Published var title: String = ""
    
    init() {
        print("View model INIT")
    }
    
}

struct StructClassActorHomeView: View {
    
    
    @State private var isActive: Bool = true
     
    var body: some View {
        StructClassActor(isActive: isActive)
            .onTapGesture {
                isActive.toggle()
            }
    }
}


struct StructClassActor: View {
    
    @StateObject var viewModel = StructClassActorViewModel()
    let isActive: Bool
    
    init(isActive: Bool) {
        self.isActive = isActive
        print("View INIT")
    }
    
    var body: some View {
        Text("Hello, World!")
            .frame(maxWidth: .infinity, maxHeight:  .infinity)
            .ignoresSafeArea()
            .background(isActive ? .red : .blue)
    }
        
}

struct StructClassActor_Previews: PreviewProvider {
    static var previews: some View {
        StructClassActor(isActive: true)
    }
}


//If you update Struct you actually create a new instance instead modifying it
//Immutable struct
struct CustomStruct {
    let title: String
    
    func updateTitle(_ title: String) -> CustomStruct {
        CustomStruct(title: title)
    }
}

struct MutatingStruct {
    private (set) var title: String
    
    init(title: String) {
        self.title = title
    }
    
    mutating func updateTitle(_ title: String) {
        self.title = title
    }
}

class MyClass {
    var title: String
    
    init(title: String) {
        self.title = title
    }
    
     func updateTitle(_ newTitle: String) {
        title = newTitle
    }
}

actor MyActor  {
    var title: String
    
    init(title: String) {
        self.title = title
    }
    
     func updateTitle(_ newTitle: String) {
        title = newTitle
    }
}

extension StructClassActor {
    
   private func actorTest() async{
        print("Actor test")
       
       let objectA = MyActor(title: "Title1")
       await print("Object A", objectA.title)
       
       print("Pass the REFERENCE to of object A to objet B")
       let objectB = objectA
       await print("Object B", objectB.title)
       
       //we can't update an actor outside of actor itself
//       objectB.title = "NEW Title"
       
       await objectB.updateTitle("Second Title")
       print("Object B title changed")
       
       await print("Object A", objectA.title)
       await print("Object B", objectB.title)
       
    }
}
