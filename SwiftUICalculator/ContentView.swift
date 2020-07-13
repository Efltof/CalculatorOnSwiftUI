//
//  ContentView.swift
//  SwiftUICalculator
//
//  Created by Александр Кондрашин on 14.01.2020.
//  Copyright © 2020 Alexander Kondrashin. All rights reserved.
//

import SwiftUI

var prevNumber : Float = 0.0

enum CalculatorButton : String {

    case zero,one,two,three,four,five,six,seven,eight,nine
    case equals,plus,minus,multiply,devide
    case ac,plusMinus,percent
    case decimal
    
    var backgroundColor : Color {
        switch self {
        case .zero,.one,.two,.three,.four,.five,.six,.seven ,.eight ,.nine,.decimal:
            return Color(.darkGray)
        case .ac,.plusMinus,.percent :
            return Color(.lightGray)
        default:
            return Color(.orange)
        }
    }

    
    var foregroundColor : Color {
        return .white
    }
    
    var buttonWidth : CGFloat {
        switch self {
        case .zero:
            return (UIScreen.main.bounds.width - 4 * 12) / 4 * 2
        default:
            return (UIScreen.main.bounds.width - 5 * 12) / 4
        }
    }
    
    var title : String {
        
        switch self {
            
        case .zero: return "0"
        case .one: return "1"
        case .two: return "2"
        case .three: return "3"
        case .four: return "4"
        case .five: return "5"
        case .six: return "6"
        case .seven: return "7"
        case .eight: return "8"
        case .nine: return "9"
        case .equals: return "="
        case .plusMinus: return "+/-"
        case .multiply: return "X"
        case .percent: return "%"
        case .plus: return "+"
        case .minus: return "-"
        case .decimal: return "."
        case .devide: return "/"
        default:
            return "AC"
        }
    }
}

class GlobalEnvironment : ObservableObject {
    
    @Published var display = ""
    @Published var devideActive = false
    @Published var multiplyActive = false
    @Published var minusActive = false
    @Published var plusActive = false
    
    
    func foregroundColor(calculatorButton: CalculatorButton) -> Color {
        switch calculatorButton {
        case .devide:
            return devideActive ? .orange : .white
        case .multiply:
            return multiplyActive ? .orange : .white
        case .minus:
            return minusActive ? .orange : .white
        case .plus:
            return plusActive ? .orange : .white
        default:
            return .white
        }
    }
    
    
    func backgroundColor(calculatorButton: CalculatorButton) -> Color {
        switch calculatorButton {
        case .zero,.one,.two,.three,.four,.five,.six,.seven ,.eight ,.nine,.decimal:
            return Color(.darkGray)
        case .ac,.plusMinus,.percent :
            return Color(.lightGray)
        case .devide:
            return devideActive ? .white : .orange
        case .multiply:
                return multiplyActive ? .white : .orange
        case .minus:
                return minusActive ? .white : .orange
        case .plus:
                return plusActive ? .white : .orange
        default:
            return Color(.orange)
        }
    }
    
    func actionsOff() {
        devideActive = false
        multiplyActive = false
        minusActive = false
        plusActive = false
    }
    
    func receiveInput(calculatorButton: CalculatorButton) {
        
        switch calculatorButton {
        case .zero,.one,.two,.three,.four,.five,.six,.seven ,.eight ,.nine:
            self.display.append(calculatorButton.title)
            
        case .ac:
            self.display = ""
            prevNumber = 1
            actionsOff()
            
        case .decimal:
            guard !self.display.contains(".") else { return }
            self.display = self.display + "."
        case .plusMinus:
            if self.display.first != "-" {
                self.display = "-" + self.display
            } else {
                self.display.removeFirst(1)
            }
            
        case .percent:
            guard display != "" else {return}
            self.display = String(Float(self.display)! / 100)

        case .devide:
            guard display != "" else {return}
            prevNumber = Float(self.display)!
            self.display = ""
            devideActive.toggle()
            
        case .multiply:
            guard display != "" else {return}
            prevNumber = Float(self.display)!
            self.display = ""
            multiplyActive.toggle()
            
        case .minus:
            guard display != "" else {return}
            prevNumber = Float(self.display)!
            self.display = ""
            minusActive.toggle()
            
        case .plus:
            guard display != "" else {return}
            prevNumber = Float(self.display)!
            self.display = ""
            plusActive.toggle()
            
        case .equals:
            guard display != "" else {return}
            var currentNumber = Float(self.display)!
            
            if devideActive == true {
                self.display = devide(a: prevNumber, b: currentNumber)
            }
            if multiplyActive == true {
                self.display = multiply(a: prevNumber, b: currentNumber)
            }
            if minusActive == true {
                self.display = minus(a: prevNumber, b: currentNumber)
            }
            if plusActive == true {
                self.display == plus(a: prevNumber, b: currentNumber)
            }
            
            actionsOff()
            
            
        default:
            break
        }
        
    }
}
func devide(a : Float, b : Float) -> String {
    return  String(a / b)
}
func multiply(a: Float, b : Float) -> String {
    return String(a * b)
}
func minus(a: Float, b : Float) -> String {
    return String(a - b)
}
func plus(a: Float, b : Float) -> String {
    return String(a + b)
}

//MAIN VIEW
struct ContentView: View {
    
    @EnvironmentObject var env: GlobalEnvironment
    
    let buttons : [[CalculatorButton]] = [
        [.ac,.plusMinus,.percent,.devide],
        [.seven,.eight,.nine ,.multiply],
        [.four,.five,.six,.minus],
        [.one,.two,.three,.plus],
        [.zero,.decimal,.equals]
    ]
    

    var body: some View {
        ZStack(alignment: .bottom) {
            Color.black.edgesIgnoringSafeArea(.all)

            VStack(spacing: 12) {
                
                    HStack {
                        Spacer()
                        Text(env.display).foregroundColor(.white).font(.system(size: 70))
                    }.padding()
                
                ForEach(buttons, id: \.self) { row in
                            HStack(spacing: 12) {
                                ForEach(row, id: \.self) { button in
                                    CalculatorButtonView(button: button)
                                }
                            }
                        }
                }.padding(.bottom)
            }
        }
}

struct CalculatorButtonView: View {
    
    var button: CalculatorButton
    
    @EnvironmentObject var env: GlobalEnvironment
    
    
    var body: some View {
        Button(action: {
            self.env.receiveInput(calculatorButton: self.button)
            
        }) {
            Text(button.title)
            .font(.system(size: 32))
                .frame(width: button.buttonWidth, height: (UIScreen.main.bounds.width - 5 * 12) / 4)
                .foregroundColor(env.foregroundColor(calculatorButton: button))
                .background(env.backgroundColor(calculatorButton: button))
                .cornerRadius(button.buttonWidth)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(GlobalEnvironment())
    }
}
