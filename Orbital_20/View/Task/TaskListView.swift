//
//  TaskListView.swift
//  Orbital_20
//
//  Created by 张远星 on 18/6/20.
//  Copyright © 2020 zhangyuanxing. All rights reserved.
//

import SwiftUI

struct TaskListView: View {
    
    @Environment(\.managedObjectContext) var context
    @FetchRequest(entity: Task.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Task.due, ascending: true)]) var assignmentList:FetchedResults<Task>
    @FetchRequest(entity: Module.entity(), sortDescriptors: []) var moduleList:FetchedResults<Module>
    @State var showCreation = false
    
    
    var body: some View {
        VStack {
            //Navigation view
            if !self.showCreation {
                NavigationView {
                    List {
                        Section(header: Text ("Add new task")) {
                            HStack {
                                Button(action: {
                                    self.showCreation.toggle()
                                }) {
                                    Image(systemName: "plus.circle.fill")
                                        .foregroundColor(.green)
                                        .imageScale(.large)
                                }
                            }
                        }.font(.headline)
                        
                        
                        
                        Section(header: Text("Tasks")) {
                            ForEach(self.assignmentList,id:\.self) {assignment in
                                ZStack {
                                    if assignment.name != nil {
                                        NavigationLink(destination:StudyView(task: assignment)) {
                                            SingleTaskView(task: assignment,isComplete: assignment.isComplete)
                                        }
                                    }
                                }
                            }.onDelete(perform: deleteTask)
                            
                        }
                        
                    }
                    
                }
                .navigationBarTitle(Text("My Task List"))
                .navigationBarItems(trailing: EditButton())
            } else {
                NewTaskView(showCreation: self.$showCreation)
            }
        }
    }
    
    //TODO:Update deletask(delete from module)
    private func deleteTask(indexSet:IndexSet) {
        for index in indexSet {
            let itemToDelete = assignmentList[index]
            context.delete(itemToDelete)
        }
        
        
        try? self.context.save()
    }
}

struct TaskListView_Previews: PreviewProvider {
    static var previews: some View {
        TaskListView()
    }
}
