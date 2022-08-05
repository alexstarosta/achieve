//
//  GoalsView.swift
//  Achieve
//
//  Created by swift on 2022-07-22.
//

import SwiftUI

extension Color {
    static let achieveColorLight = Color("AchieveColorLight")
    static let achieveColorHeavy = Color("AchieveColorHeavy")
}

func currentProgressTotal (_ activeGoals:[newGoalInfo] ) -> Double{
    var total: Double = 0
    for goal in activeGoals {
        if whatAmount(goal) != -1 {
            total += Double(whatAmount(goal))
        }
    }
    return total
}

func currentProgressStart (_ activeGoals:[newGoalInfo] ) -> Double {
    var total: Double = 0
    for goal in activeGoals {
        if whatAmount(goal) != -1 {
            total += Double(goal.startingNum)
        }
    }
    return total
}

func catagoryPrecedence(_ activeGoals:[newGoalInfo]) -> [Double] {
    var healthScore:Double = 0, educationScore:Double = 0, financialScore:Double = 0, relationsScore:Double = 0, personalScore:Double = 0, socialScore:Double = 0, lifestyleScore:Double = 0, othercatScore:Double = 0
    
    for goal in activeGoals {
        switch goal.catagory {
            case .health:
                healthScore += 1
            case .education:
                educationScore += 1
            case .financial:
                financialScore += 1
            case .personal:
                personalScore += 1
            case .social:
                socialScore += 1
            case .lifestyle:
                lifestyleScore += 1
            case .othercat:
                othercatScore += 1
            default:
                continue
        }
    }
    
    let totalGoals = Double(activeGoals.count)
    
    return [healthScore/totalGoals, educationScore/totalGoals, financialScore/totalGoals, relationsScore/totalGoals, personalScore/totalGoals, socialScore/totalGoals, lifestyleScore/totalGoals, othercatScore/totalGoals]
}

struct GoalsView: View {
    
    let screenWidth = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height
    let screenSize = UIScreen.main.bounds.size
    
    @EnvironmentObject var screenInfo: goalScreenInfo

    @State var showingCreateSequence = false
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                VStack (alignment: .leading) {
                    
                    Text("Overview")
                        .padding(.top, 10)
                        .font(.title2.bold())
                    
                    HStack (spacing: 20) {
                        ZStack (alignment: .leading) {
                            RoundedRectangle(cornerRadius: 25, style: .circular)
                                .frame(width: screenWidth*0.425, height: screenWidth*0.425)
                                .padding(.bottom, 10)
                                .foregroundColor(.gray.opacity(0.25))
                                .foregroundStyle(.ultraThinMaterial)
                            
                            ZStack {
                                CircularProgressView(progress: screenInfo.progressionStart/screenInfo.progressionEnd)
                                    .frame(width: screenWidth*0.15)
                                    .offset(x: screenWidth*0.04, y: -screenWidth*0.12)
                                
                                Text("\(Image(systemName: "flag.fill"))")
                                    .offset(x: screenWidth*0.04, y: -screenWidth*0.12)
                                    .font(.title3.bold())
                            }
                            
                            Text("Progress")
                                .offset(x: screenWidth*0.03, y: 15)
                                .font(.body.bold())
                            
                            if (screenInfo.progressionStart/screenInfo.progressionEnd).isNaN {
                                Text("100%")
                                    .offset(x: screenWidth*0.03, y: 45)
                                    .font(.largeTitle.bold())
                            } else {
                            Text(String(format: "%.f", screenInfo.progressionStart/screenInfo.progressionEnd * 100) + "%")
                                .offset(x: screenWidth*0.03, y: 45)
                                .font(.largeTitle.bold())
                            }
                        }
                        
                        ZStack (alignment: .center) {
                            RoundedRectangle(cornerRadius: 25, style: .circular)
                                .frame(width: screenWidth*0.425, height: screenWidth*0.425, alignment: .leading)
                                .padding(.bottom, 10)
                                .foregroundColor(.gray.opacity(0.25))
                                .foregroundStyle(.ultraThinMaterial)
                            
                            Text(String(screenInfo.activeGoalsArray.count))
                                .offset(x: 0, y: -25)
                                .font(.custom("activeGoalsFont", fixedSize: 90).bold())
                            
                            Text("Active Goals")
                                .offset(x: 0, y: 50)
                                .font(.body.bold())
                            
                            ZStack (alignment: .leading) {
                                Rectangle()
                                    .frame(width: CGFloat(screenWidth*0.35), height: 10, alignment: .center)
                                    .foregroundColor(.gray.opacity(0.75))
                                    .cornerRadius(20)
                                    .offset(x: 0, y: 30)
                                
                                if screenInfo.catagoryScores.isEmpty == false && screenInfo.activeGoalsArray.count != 0 {
                                    CatagoryProgressView(values: screenInfo.catagoryScores)
                                }
                                
                            }
                        }
                    }
                    
                    if screenInfo.firstTime {
                        ZStack (alignment: .center) {
                            RoundedRectangle(cornerRadius: 25, style: .circular)
                                .frame(width: screenWidth*0.425*2.125, height: screenWidth*0.425, alignment: .leading)
                                .padding(.bottom, 10)
                                .foregroundColor(.gray.opacity(0.2))
                                .foregroundStyle(.ultraThinMaterial)
                            
                            Text("Click below or click on the plus in the right corner to create a new goal.")
                                .font(.body.bold())
                                .frame(width: screenWidth*0.425*2 - 19)
                                .multilineTextAlignment(.center)
                                .offset(x: 0, y: -35)
                            
                            Button {showingCreateSequence = true}
                                label: {
                            Text("Get Started")
                                .frame(width: screenWidth*0.425*2.125 - 100, height: 40)
                                .background (LinearGradient(gradient: Gradient(colors: [.accentColor, .achieveColorHeavy]), startPoint: .topLeading, endPoint: .bottomTrailing))
                                .foregroundColor(.white)
                                .cornerRadius(40)
                                .font(.body.bold())
                                .offset(x: 0, y: 30)
                            }
                        }
                    }
                    if screenInfo.activeGoalsArray.isEmpty == false {
                        ForEach(0...screenInfo.activeGoalsArray.count-1, id: \.self) { index in
                            if screenInfo.activeGoalsArray[index].isDeleted == false {
                                NewGoalView(info: screenInfo.activeGoalsArray[index])
                            }
                        }
                    }
                    if screenInfo.completedForToday.isEmpty == false {
                        
                        withAnimation(.easeIn) {
                            Text("Completed Goals Today")
                                .padding(.top, 10)
                                .font(.title2.bold())
                        }
                        
                        ForEach(0...screenInfo.completedForToday.count-1, id: \.self) { index in
                            if screenInfo.completedForToday[index].isDeleted == false {
                                withAnimation(.easeIn) {
                                    NewGoalView(info: screenInfo.completedForToday[index])
                                }
                            }
                        }
                    }
                }
                .sheet(isPresented: $screenInfo.showWelcomeScreen) {
                    WelcomeView()
                }
                .sheet(isPresented: $showingCreateSequence) {
                    RootCreateView()
                }
                .sheet(isPresented: $screenInfo.showingGoalCompleted) {
                    CompleteView(goalInfo: screenInfo.latestCompleteInfo, bottomTextType: screenInfo.latestCompleteTextType)
                }
            }
            .navigationTitle("Goals")
            .navigationBarItems(trailing:
                                    Button(action: {
                showingCreateSequence = true
            }) {
                Text("\(Image(systemName: "plus"))")
            }
            )
        }
        .preferredColorScheme(screenInfo.darkMode ? .dark : .light)
    }
}

struct GoalsView_Previews: PreviewProvider {
    static let screenInfo = goalScreenInfo()
    static var previews: some View {
        GoalsView()
            .environmentObject(screenInfo)
    }
}
