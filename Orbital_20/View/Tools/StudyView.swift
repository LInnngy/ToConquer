//
//  StudyView.swift
//  Orbital_20
//
//  Created by 张远星 on 18/6/20.
//  Copyright © 2020 zhangyuanxing. All rights reserved.
//

import SwiftUI

struct StudyView: View {
    
    @ObservedObject var task:Task
    @State var date = Date()
    
    var body: some View {
        ZStack {
            
            //background
//            Rectangle()
//                .foregroundColor(Color.black)
//                .edgesIgnoringSafeArea(.all)
//
//            Rectangle()
//                .foregroundColor(Color.white)
//                .rotationEffect(Angle(degrees: 45))
//                .edgesIgnoringSafeArea(.vertical)
//
            //elements of interfaces
            VStack {
                
                VStack {
                    Text(task.name ?? "")
                    .font(.title)
                
                
                    Text(task.modName ?? "")
                    .font(.subheadline)
                }
                
                //End time
                HStack {
                    Image(systemName: "star.fill").foregroundColor(.yellow)
                    
                    // TODO: set the time according to user's choice
                    Text("End at \(self.timeString(date:Date(timeIntervalSinceNow: TimeInterval(self.task.duration * 60))))")
                                        
                    Image(systemName: "star.fill").foregroundColor(.yellow)
                }.scaleEffect(2)
                    .padding()
                
                //Spacer()
                
                //ClockView
//                Text("\(timeString(date: date))").bold().scaleEffect(2)
//                    .onAppear(perform: {let _ = self.updateTimer})
                
                
                //Timer
                TimerView(timerManager: TimerManager(task:self.task)).padding()
            }
        }
    }
    
    var timeFormat: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm a"
        return formatter
    }

    func timeString(date: Date) -> String {
        let time = timeFormat.string(from: date)
        return time
    }

//    var updateTimer: Timer {
//         Timer.scheduledTimer(withTimeInterval: 1, repeats: true,
//                              block: {_ in
//                                 self.date = Date()
//                               })
//    }
    
}



//struct StudyView_Previews: PreviewProvider {
//    static var previews: some View {
//        StudyView()
//    }
//}
