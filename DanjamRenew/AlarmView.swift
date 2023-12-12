//
//  AlarmView.swift
//  DanjamRenew
//
//  Created by jose Yun on 2023/10/07.
//

import SwiftUI

struct AlarmView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @Binding var isAlarm: Bool
    @Binding var time: Date
    @State var alarmTime: Date
    
    @State private var selectedSound: Sound = Sound.nothing
    @State private var selectedVibration = Vibration.nothing
    
    var body: some View {
        NavigationView {
            VStack(spacing: 50) {
                List {
                RoundedRectangle(cornerRadius: 20.0)
                    .foregroundStyle(.clear)
                    .frame(height: UIScreen.main.bounds.height * 0.2)
                    .overlay {
                        DatePicker("", selection: $alarmTime, displayedComponents: .hourAndMinute)
                            .datePickerStyle(WheelDatePickerStyle())
//                            .labelsHidden()
                    }
                    .padding()
                    .listRowBackground(Color.black.opacity(0.8))
                        
                        Picker("Sound", selection: $selectedSound) {
                            ForEach(Sound.allCases) { Text($0.rawValue.capitalized) }
                        }
                        .pickerStyle(.inline)
                        .listRowBackground(Color.black.opacity(0.8))
                        
                        Picker("Vibration", selection: $selectedVibration) {
                            ForEach(Vibration.allCases) { Text($0.rawValue.capitalized) }
                        }
                        .pickerStyle(.inline)
                        .listRowBackground(Color.black.opacity(0.8))
                    }
                    .accentColor(.teal)
                    .scrollContentBackground(.hidden)

            }
            .onAppear {
                self.alarmTime = self.time
            }
            .toolbar {
                ToolbarItemGroup(placement: .topBarLeading){
                    Button(action: { isAlarm.toggle() } ) {
                        Text("Cancel")
                            .bold()
                            .font(.system(size: 25))
                    }
                }
                
                ToolbarItemGroup(placement: .topBarTrailing){
                    Button(action: { 
                        self.time = self.alarmTime
                        isAlarm.toggle() } ) {
                        Text("Save")
                            .bold()
                            .font(.system(size: 25))
                    }
                }

            }
            .tint(.teal)
        }
    }
}

struct AlarmView_Previews: PreviewProvider {
    static var previews: some View {
        AlarmView(isAlarm: .constant(true), time: .constant(.now), alarmTime: Date())
    }
}

enum Sound: String, Identifiable, CaseIterable {
    case nothing, sun, moon
      var id: Self { self }
}

enum Vibration: String, Identifiable, CaseIterable {
    case nothing, mist, wind, thunder
    var id: Self { self }
}
