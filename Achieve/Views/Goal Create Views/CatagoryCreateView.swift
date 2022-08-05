//
//  CatagoryCreateView.swift
//  Achieve
//
//  Created by swift on 2022-07-24.
//

import SwiftUI

struct CatagoryCreateView: View {
    
    let screenWidth = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height
    let screenSize = UIScreen.main.bounds.size
    
    @EnvironmentObject var goalInfo: newGoalInfo
    @EnvironmentObject var screenInfo: goalScreenInfo
    
    @State var catagoryError = false
    @State var sendNextView = false
    
    @State var dropDownOpen = false
    @State var enableDirection = false
    
    fileprivate func prepairPicker() {
        if goalInfo.goalSpecs.selectedTimeSpec != -1 {
            goalInfo.selectedPicker = 1
        } else if goalInfo.goalSpecs.selectedAmountSpec != -1 {
            goalInfo.selectedPicker = 2
        }
        if goalInfo.goalSpecs.selfDirected == true {
            goalInfo.selectedPicker = 3
        }
    }
    
    var body: some View {
        VStack {
            VStack (alignment: .leading) {
                VStack (alignment: .leading){
                    Text("Goal Catagory")
                        .font(.title2.bold())
                        .padding(.bottom, 2)
                    
                    Text("It's important to know what type of goal you are completing. Select a category that fits your goals needs.")
                        .font(.callout)
                        .padding(.bottom, 10)
                        .fixedSize(horizontal: false, vertical: true)
                }
                
                ZStack {
                    
                    RoundedRectangle(cornerRadius: 100)
                        .frame(width: screenWidth/1.15+6, height: 45, alignment: .center)
                        .foregroundStyle(achieveStyleSimple)
                        .foregroundStyle(.ultraThinMaterial)
                    
                    RoundedRectangle(cornerRadius: 100)
                        .frame(width: screenWidth/1.15, height: 40, alignment: .center)
                        .foregroundStyle(Color(UIColor.systemBackground))
                        .foregroundStyle(.ultraThinMaterial)
                    
                    HStack {
                        if goalInfo.catagory != nil {
                            Text("\(goalInfo.catagory!.symbol)")
                                .bold()
                        } else {
                            Text("\(Image(systemName: "flag.fill"))")
                                .foregroundColor(.secondary)
                        }
                        
                        if goalInfo.catagory != nil {
                            Text("\(goalInfo.catagory!.title)")
                                .bold()
                        } else {
                            Text("Select a catagory...")
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Button {
                            dropDownOpen.toggle()
                            catagoryError = false
                            enableDirection = false
                        } label: {
                            if dropDownOpen == false {
                                Text("\(Image(systemName: "chevron.right"))")
                            } else {
                                Text("\(Image(systemName: "chevron.down"))")
                            }
                        }
                    }
                    .frame(width: screenWidth*0.8, alignment: .center)
                    
                    RoundedRectangle(cornerRadius: 100)
                        .frame(width: screenWidth/1.15, height: 40, alignment: .center)
                        .opacity(0.00001)
                        .foregroundStyle(.ultraThinMaterial)
                        .onTapGesture {
                            withAnimation(.easeOut){ dropDownOpen.toggle()}
                            catagoryError = false
                        }
                    
                }
                
                if catagoryError == true {
                    Text("\(Image(systemName: "exclamationmark.circle.fill")) Please select a catagory")
                        .font(.caption)
                        .foregroundColor(.red)
                }
                
                ZStack {
                    if dropDownOpen == true {
                        VStack {
                            Spacer()
                            ForEach(0...predictCatagory(goalInfo.title).count-1, id: \.self ) { index in
                                Button {
                                    goalInfo.catagory = predictCatagory(goalInfo.title)[index]
                                    if goalInfo.catagory != nil {
                                        goalInfo.directionsForUser = findDirectionsForUser(goalInfo.catagory!, goalInfo.title)
                                    }
                                }
                            label: {
                                HStack {
                                    Spacer()
                                    Text ("\(predictCatagory(goalInfo.title)[index].symbol)")
                                        .font(.body)
                                    Text ("\(predictCatagory(goalInfo.title)[index].title)")
                                        .bold()
                                    Spacer()
                                }
                            }
                            .buttonStyle(.bordered)
                            .background(goalInfo.catagory == predictCatagory(goalInfo.title)[index] ? Color.accentColor : Color(UIColor.systemBackground))
                            .cornerRadius(30)
                            .foregroundColor(goalInfo.catagory == predictCatagory(goalInfo.title)[index] ? Color(UIColor.systemBackground) : .accentColor)
                                
                            }
                        }
                    }
                    
                    VStack (alignment: .leading) {
                        HStack {
                            Text("Goal Direction")
                                .font(.title2.bold())
                                .padding(.vertical, 2)
                            
                            Text("beta")
                                .font(.caption.bold())
                                .padding(.vertical, 2)
                                .offset(x: -2, y: 5)
                                .foregroundColor(.achieveColorHeavy)
                            
                            Spacer()
                            
                            Toggle ("", isOn: $enableDirection)
                                .labelsHidden()
                                .tint(.accentColor)
                            
                        }
                        .frame(width: screenWidth*0.88)
                        
                        Text("Not sure exactly what goal you have in mind? Below are various reccomendations made just to fit your needs!")
                            .font(.callout)
                            .padding(.bottom, 1)
                            .fixedSize(horizontal: false, vertical: true)
                                            
                        if enableDirection && dropDownOpen == false {
                            ZStack {
                                if goalInfo.catagory != nil && goalInfo.catagory != .othercat {
                                    RoundedRectangle(cornerRadius: 25)
                                        .frame(width: screenWidth/1.15+6, height: 205, alignment: .bottom)
                                        .foregroundStyle(!dropDownOpen ? achieveStyleSimple : LinearGradient(colors: [Color(UIColor.systemBackground)], startPoint: .bottom, endPoint: .bottom))
                                        .foregroundStyle(.ultraThinMaterial)
                                    
                                    RoundedRectangle(cornerRadius: 22)
                                        .frame(width: screenWidth/1.15, height: 200, alignment: .bottom)
                                        .foregroundStyle(Color(UIColor.systemBackground))
                                        .foregroundStyle(.ultraThinMaterial)
                                
                                    Picker("Direction Selection", selection: $goalInfo.directionIndex) {
                                        ForEach(0..<(goalInfo.directionsForUser?.count ?? 0), id: \.self ) { index in
                                            Text("\(goalInfo.directionsForUser![index])")
                                                .bold()
                                                .font(.body)
                                            }
                                        }
                                        .pickerStyle(.wheel)
                                                                        
                                } else if goalInfo.catagory == .othercat {
                                    Text("\(Image(systemName: "exclamationmark.circle.fill")) Select a specific catagory to view goal directions.")
                                        .font(.caption)
                                        .foregroundColor(.red)
                                        .offset(x: 0, y: -10)
                                } else {
                                    Text("\(Image(systemName: "exclamationmark.circle.fill")) Please select a catagory to use Goal Direction.")
                                        .font(.caption)
                                        .foregroundColor(.red)
                                        .offset(x: 0, y: -10)
                                }
                                
                            }
                            .padding(.top)
                        }
                    }
                    .opacity(dropDownOpen ? 0 : 1)
                    .offset(x: 0, y: 40)
                    
                }
            }
            
            Button(action: {
                if goalInfo.catagory == nil {
                    catagoryError = true
                } else {
                    if enableDirection == false {
                        goalInfo.directionIndex = -1
                    }
                    sendNextView = true
                }
                if goalInfo.title != "" && goalInfo.catagory != nil && goalInfo.directionIndex != -1 {
                    goalInfo.goalSpecs = addDirectionalValues(goalInfo.title, goalInfo.catagory!, goalInfo.directionIndex)
                }
                
                prepairPicker()
                
            }) {
                Text("Continue")
                    .frame(width: screenWidth*0.425*2.125 - 100, height: 40)
                    .background (LinearGradient(gradient: Gradient(colors: [.accentColor, .achieveColorHeavy]), startPoint: .topLeading, endPoint: .bottomTrailing))
                    .foregroundColor(Color(UIColor.systemBackground))
                    .cornerRadius(40)
                    .font(.body.bold())
                    .padding(.bottom)
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
            .ignoresSafeArea(.keyboard)
            
        }
        .frame(width: screenWidth*0.85)
        
        .navigationBarItems(trailing:
                                Button(action: {
            UIApplication.shared.windows.first?.rootViewController?.dismiss(animated: true)
        }) {
            Text("Cancel")
        })
        
        .background(
            NavigationLink(
                destination: SpecificationsCreateView(),
                isActive: $sendNextView,
                label: { EmptyView() })
        )
        .preferredColorScheme(screenInfo.darkMode ? .dark : .light)
    }
}

struct CatagoryCreateView_Previews: PreviewProvider {
    static let goalInfo = newGoalInfo()
    static let screenInfo = goalScreenInfo()
    static var previews: some View {
        NavigationView {
            CatagoryCreateView()
        }
        .environmentObject(goalInfo)
        .environmentObject(screenInfo)
    }
}
