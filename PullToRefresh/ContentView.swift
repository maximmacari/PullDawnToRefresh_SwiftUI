//
//  ContentView.swift
//  PullToRefresh
//
//  Created by Maxim Macari on 06/11/2020.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Home()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Home: View {
    
    @State var arrData = ["Hello data 1", "Hello data 2","Hello data 3","Hello data 4","Hello data 5"]
    @State var refresh = Refresh(started: false, released: false)
    
    var body: some View{
        
        VStack(spacing: 0){
            HStack{
                Text("Maxim Macari")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .foregroundColor(.purple)
                
                Spacer()
                
                
            }
            .padding()
            .background(Color.white.ignoresSafeArea(.all, edges: .all))
            
            Divider()
            
            ScrollView(.vertical, showsIndicators: false, content: {
                
                //geometry readeere for calculating position
                GeometryReader{ geo -> AnyView in
                    
                    //print(geo.frame(in: .global).minY)
                    
                    DispatchQueue.main.async {
                        if refresh.startOffset == 0{
                            refresh.startOffset = geo.frame(in: .global).minY
                        }
                        
                        refresh.offset = geo.frame(in: .global).minY
                        
                        if refresh.offset - refresh.startOffset > 80 && !refresh.started {
                            refresh.started = true
                        }
                        
                        //cheking if refresh is started and drag is released
                        if refresh.startOffset == refresh.offset && refresh.started && !refresh.released {
                            withAnimation(Animation.linear){
                                refresh.released = true
                            }
                            updateData()
                        }
                        
                        //Cheking invalid update
                        if refresh.startOffset == refresh.offset && refresh.started && refresh.released && refresh.invalid {
                            refresh.invalid = false
                            updateData()
                        }
                        
                    }
                    
                    return AnyView(
                        Color.black
                            .frame(width: 0, height: 0)
                    )
                    
                }
                .frame(width: 0, height: 0)
                
                ZStack(alignment: Alignment(horizontal: .center, vertical: .top)) {
                    
                    if refresh.started && refresh.released {
                        ProgressView()
                            .offset(y: -35)
                    }else{
                        
                    
                    
                    //Arrow and indicator
                    Image(systemName: "arrow.down")
                        .font(.title2)
                        .foregroundColor(.gray)
                        .rotationEffect(.init(degrees: refresh.started ? 180 : 0))
                        .offset(y: -40)
                        .animation(.easeIn)
                        .opacity(refresh.offset != refresh.startOffset ? 1 : 0)
                    }
                    VStack{
                        ForEach(arrData, id: \.self){ data in
                            
                            HStack{
                                Text("\(data)")
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.black)
                                
                                
                            }
                            .padding()
                            
                        }
                    }
                    .background(Color.white)
                    
                  
                }
                .offset(y: refresh.released ? 40 : -10)
            })
        }
        .background(Color.black.opacity(0.06).ignoresSafeArea())
        
    }
    
    func updateData(){
        
        //Disabling invalid scroll when data is updating
        
        print("Updating data...")
        
        let timeFormatteer = DateFormatter()
        timeFormatteer.dateFormat = "HH:mm:ss"
        let strDate = timeFormatteer.string(from: Date())
        
        //Smooth animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            withAnimation(Animation.linear){
                if refresh.startOffset == refresh.offset {
                    arrData.append("Update data: " + strDate + "hs ")
                    refresh.released = false
                    refresh.started = false
                }else{
                    refresh.invalid = true
                }
                
                
            }
        }
    }
    
}


//Refresh model
struct Refresh {
    var startOffset: CGFloat = 0
    var offset: CGFloat = 0
    var started: Bool
    var released: Bool
    var invalid: Bool = false
}




