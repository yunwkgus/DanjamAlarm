//
//  ContentView.swift
//  DanjamRenew
//
//  Created by jose Yun on 2023/10/07.
//


// 버튼 위치 어떻게 하지?
// 사진 앱 처럼, 클릭 했을 때 버튼 / 추가 정보 활성화 -> 일반적인 방식은 아님
//

// 연속 며칠 데이터 -> wake me up 버튼 자리에 정보 주기 / 앱 진입 시 정보 주기.

// 알람은 모바일 말고, 테블릿 형태로 화면 안 꺼지게. 은은하게 떠있을 수 있는. -> 앱 화면 자체가 조명..! + 버튼을 없애는 것도 그럴 수 있겠지 !

// standby mode
// 모니터 화면을 잘 안 끔. -> 자고 일어나서 바로 보기

// 집 불 켜기 끄기 .

// 달 -> 해 전환 포인트 유저가 캐치할 수 있도록 만들기

// 알람 어노잉 하지 않도록


import SwiftUI

struct ContentView: View {

    var notificationService: NotificationService = .init()
    @AppStorage("time") var time: Date = Date()
    
    @State var timer : Timer?
    
    @State var isNight: Bool = false
    @State var isAlarm: Bool = false
    @State var isPopover: Bool = true

    @AppStorage("streak") var streak: Int = 0
    
    var dateFormatter = DateFormatter()
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                P23_Waves().padding(.top, 350)
            }
            
            VStack(spacing: 0){
                
                HStack {
                    HStack(spacing: 0) {
                        Image(systemName: "sun.min.fill")
                            .font(.system(size: 25))
                            .foregroundColor(.white.opacity(0.98))
                            .bold()
                        
                        Text(" \(streak) days")
                            .font(.system(size: 25))
                            .bold()
                            .foregroundStyle(.white)
                        
                    }
                    .padding()
                    .overlay {
                        RoundedRectangle(cornerRadius: 100)
                            .stroke(lineWidth: 1.0)
                            .foregroundStyle(isNight ? .white.opacity(0.7) : .orange.opacity(0.7))
                    }
                    
                    Spacer()
                    
                    Button(action: { isAlarm.toggle() }) {
                        Image(systemName: "clock")
                            .font(.system(size: 25))
                            .foregroundColor(.white.opacity(0.98))
                            .bold()
                            .padding()
                            .background(isNight ? .white.opacity(0.6) : .orange.opacity(0.6))
                            .cornerRadius(100)
                    }
                    .opacity(isNight ? 0.0 : 1.0)
                }
                .opacity(isPopover ? 1.0 : 0.0)
                
                ZStack {
                        Image("moon")
                            .resizable()
                            .scaledToFit()
                            .shadow(color: .white, radius: 30)
                            .padding()
                            .padding()
                            .opacity(isNight ? 1.0 : 0.0)
                        
                    
                        Image("Sun")
                            .resizable()
                            .scaledToFit()
                            .shadow(color: .orange.opacity(0.5), radius: 30)
                            .scaledToFit()
                            .padding()
                            .padding()
                            .opacity(isNight ? 0.0 : 1.0)
                }.offset(y: isPopover ? 0: -50)
                
                Text("\(time.formatted(date: .omitted, time: .shortened))")
                    .bold()
                    .font(.system(size: 80))
                    .foregroundColor(.white)
                    .padding(.bottom)
                    .opacity(isPopover ? 1.0 : 0.0)
                
                Spacer()
                
                HStack {
                    
                    Button(action: {
                        withAnimation(.easeInOut) {
                            if !isNight {
                                setAlarm()
                                withAnimation(.easeInOut(duration: 1.0)) {
                                    isPopover = false
                                }
                            } else {
                                unsetAlarm()
                                isPopover = true
                            }
                            isNight.toggle()
                        }
                    }, label: {
                        Text(isNight ? "Cancel" : "On")
                            .font(.system(size: 30))
                            .bold()
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(.white)
                            .cornerRadius(100)
                    })
                }.opacity(isPopover ? 1.0 : 0.0)
                .foregroundColor(.teal)
            }
            .sheet(isPresented: $isAlarm) {
                AlarmView(isAlarm: $isAlarm, time: $time, alarmTime: Date())
                    .presentationBackground(.black.opacity(0.8))
            }
            .padding()

        }
        .background(isNight ? Color.black : Color.yellow)
        .onTapGesture {
            withAnimation(.easeInOut(duration: 1.0)) {
                isPopover.toggle()
            }
        }
        .onChange(of: self.time) { _ in
            self.streak = 0
        }
        .onAppear {
            self.notificationService.requestAuthorization()
        }
    }
    
    func unsetAlarm() {
        timer?.invalidate()
    }
    
    
    func setAlarm() {
        // 현재 시간 가져오기
        let currentTime = Date()
         
        let calendar = Calendar.current
        
        let currentMidnight = calendar.startOfDay(for: currentTime)
        
        // 선택한 알람 시간과 현재 시간과의 간격 계산
        let currentTimeDifference = currentTime.timeIntervalSince(currentMidnight) + 60
        
        let timeMidnight = calendar.startOfDay(for: time)
        
        let timeDifference = time.timeIntervalSince(timeMidnight)
        
        print(currentTimeDifference, timeDifference)
        
        let timerInterval = timeDifference > currentTimeDifference ? timeDifference - currentTimeDifference : (timeDifference - currentTimeDifference) + (60*60*24)
        
        print(timerInterval)

        // 타이머 설정
        timer = Timer.scheduledTimer(withTimeInterval: timerInterval, repeats: false) { timer in
            isPopover = true
            isNight.toggle()
            self.streak += 1
            self.notificationService.sendNotification()
            timer.invalidate()
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}

extension Date: RawRepresentable {
    public var rawValue: String {
        self.timeIntervalSinceReferenceDate.description
    }
    
    public init?(rawValue: String) {
        self = Date(timeIntervalSinceReferenceDate: Double(rawValue) ?? 0.0)
    }
}
