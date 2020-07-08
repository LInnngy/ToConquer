//
//  NewTaskView.swift
//  Orbital_20
//
//  Created by Jerry Lin on 23/6/20.
//  Copyright © 2020 Jerry Lin. All rights reserved.
//

import SwiftUI

struct NewTaskView: View {
    @Binding var showCreation: Bool
    @State var TaskName = ""
    @State var dueDate = Date()
    //    @State var planHour = 0
    //    @State var planMinutes = 0
    @State var planTime = ""
    @State var planDate = Date()
    @State var moduleName = ""
    @Environment(\.managedObjectContext) var context
    @FetchRequest(entity: Task.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Task.due, ascending: true)]) var assignmentList:FetchedResults<Task>
    @FetchRequest(entity: Module.entity(), sortDescriptors: []) var moduleList:FetchedResults<Module>
    var module:String?
    
    var body: some View {
        VStack {
            if module == nil {
                HStack {
                    Button(action:{
                        self.showCreation.toggle()
                    }) {
                        HStack {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.blue)
                                .frame(alignment:.leading)
                            Text("back")
                                .foregroundColor(.blue)
                                .frame(alignment:.leading)
                        }
                    }.frame(alignment:.leading)
                        .padding()
                    Spacer()
                }
            }
            Form {
                Section(header:Text(module == nil ? "Creating New Task" : "Creating new Task for \(module!)")) {
                    if module == nil {
                        TextField("Module Name",text: $moduleName)
                    }
                    TextField("New Task Name", text: $TaskName)
                    DatePicker("Due", selection: $dueDate,in:Date()...)
                    VStack {
                        Text("Pick your time for this assignment")
                        
                        //                TimePicker(planHour:self.$planHour,planMinutes:self.$planMinutes)
                        TextField("Minutes",text: $planTime).keyboardType(.numberPad)
                    }
                    
                    DatePicker("Plan Date",selection: $planDate,in: Date()...)
                }
                
                Section {
                    ZStack {
                        RoundedRectangle(cornerRadius: 5)
                            .foregroundColor(.blue)
                        
                        Button(action: {
                            self.addTask(due: self.dueDate, self.TaskName, at: self.planDate, Int16(self.planTime) ?? 0,for:self.moduleName)
                            self.showCreation.toggle()
                            
                        }) {
                            Text("save")
                                .foregroundColor(.black)
                        }
                    }
                }
            }
        }
    }
    
    private func addTask(due date:Date,_ name:String,at plan:Date,_ time:Int16,for module:String) {
        let newAssignment = Task(context: context)
        newAssignment.due = date
        newAssignment.name = name
        newAssignment.planDate = plan
        newAssignment.isComplete = false
        newAssignment.duration = time
        newAssignment.extendCount = 0
        if !self.haveMod(modname: module) {
            let newMod = Module(context: context)
            newMod.moduleName = module
            try? self.context.save()
        }
        newAssignment.modName = module
        
        
        
        try? self.context.save()
        
        //notification for due
        var daycomponent = DateComponents()
        daycomponent.day = -1
        let content = UNMutableNotificationContent()
        content.title = "\(module)"
        content.body = "\(name) due in one day"
        let calendar = Calendar.current
        let nextTriggerDay = calendar.date(byAdding: daycomponent, to: date)!
        let triggerComp = Calendar.current.dateComponents([.year,.month,.day], from: nextTriggerDay)
        //create trigger
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerComp, repeats: false)
        //create request
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.add(request, withCompletionHandler: nil)
        
        //notification for plan
        let content1 = UNMutableNotificationContent()
        content1.title = "\(module)"
        content1.body = "Time to start \(name)"
        let triggerComp1 = Calendar.current.dateComponents([.year,.month,.day], from: plan)
        let trigger1 = UNCalendarNotificationTrigger(dateMatching: triggerComp1, repeats: false)
        let id = UUID().uuidString
        let request1 = UNNotificationRequest(identifier: id, content: content, trigger: trigger1)
        notificationCenter.add(request1, withCompletionHandler: nil)
    }
    
    private func haveMod(modname:String) -> Bool {
        for index in self.moduleList.indices {
            if moduleList[index].moduleName == modname {
                return true
            }
        }
        return false
    }
}
