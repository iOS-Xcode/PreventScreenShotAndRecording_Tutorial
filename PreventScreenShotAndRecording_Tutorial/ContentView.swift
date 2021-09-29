//
//  ContentView.swift
//  PreventScreenShotAndRecording_Tutorial
//
//  Created by Seokhyun Kim on 2021-09-29.
//

import SwiftUI

struct AlertData: Identifiable {
    var id: UUID
    let title: String
    let message: String
    
    init(title: String = "Hello", message: String = "You did sceenshot") {
        self.id = UUID()
        self.title = title
        self.message = message
    }
}

struct ContentView: View {
    var body: some View {
        //메인 컨텐트 뷰
        MainView()
        //블럭 뷰
        BlockView()
    }
}

struct MainView: View {
    var body: some View {
        VStack {
            Text("This is MainView")
                .font(.largeTitle)
                .foregroundColor(.white)
                .padding()
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
        .background(Color.blue)
        .edgesIgnoringSafeArea(.all)
    }
}

struct BlockView: View {
    //ios 시스템에서는 시스템 이벤트를 알려준다. - 노티피케이션 센타
    //노티피케이션 => publisher로 받을 수 있다.
    //SwiftUI에서는 publisher이벤트를 onReceive로 받는다.
    
    @State private var alertData: AlertData?
    
    //녹화중 여부
    @State var isRecordingScreen = false
    
    var body: some View {
        ZStack {
            if isRecordingScreen {
                Color.white
                Text("Recording!!!!!")
                    .font(.largeTitle)
                    .padding()
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIScreen.capturedDidChangeNotification), perform: { _ in
            print("UIScreen.main.isCaptured: \(UIScreen.main.isCaptured)")
            isRecordingScreen = UIScreen.main.isCaptured
            print(isRecordingScreen ? "start recording" : "stop recording")
        })
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.userDidTakeScreenshotNotification), perform: { _ in
            print("Did screenshot")
            alertData = AlertData()
        })
        .edgesIgnoringSafeArea(.all)
        .alert(item: $alertData, content: { alertData in
            Alert(title: Text(alertData.title), message: Text(alertData.message), dismissButton: Alert.Button.cancel(Text("Close")))
        })
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
