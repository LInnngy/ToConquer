//
//  TaskListView.swift
//  Orbital_20
//
//  Created by 张远星 on 18/6/20.
//  Copyright © 2020 zhangyuanxing. All rights reserved.
//

import SwiftUI

struct TaskListView: View {
    
    @ObservedObject var manage = Manage()
    @State var showCreation = false
    @State var TaskName = ""
    @State var dueDate = Date()
    @State var completeTime = ""
    @State var planDate = Date()
    
    var body: some View {
        ZStack {
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
                          Text("Mod")
                        }
                    }
                    .navigationBarTitle(Text("My Task List"))
                    .navigationBarItems(trailing: EditButton())
                }
            } else {
                
                Form {
                    TextField("New Task Name", text: $TaskName)
                    DatePicker("Due", selection: $dueDate)
                    TextField("Time to complete",text: $completeTime).keyboardType(.numberPad)
                    DatePicker("Plan Date",selection: $planDate)
                    
                    Section {
                        Button(action: {
                            self.manage.addTask(due: self.dueDate, self.TaskName, at: self.planDate, Int16(self.completeTime) ?? 0)
                        }) {
                            Text("save")
                        }
                    }
                }
                
            }
        }
    }
}

struct TaskListView_Previews: PreviewProvider {
    static var previews: some View {
        TaskListView()
    }
}
