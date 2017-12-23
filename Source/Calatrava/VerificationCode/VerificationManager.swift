//
//  VerificationManager.swift
//  Calatrava
//
//  Created by 郑宇琦 on 2017/12/23.
//

import Foundation

struct VerificationItem {
    var identifier: String
    var timeout: TimeInterval
    var question: String
    var answer: String
}

class VerificationManager {
    
    static internal var verification = Dictionary<String, VerificationItem>.init()
    static internal var lastCheckTime: TimeInterval = 0
    
    static func generateCode() -> (identifier: String, question: String) {
        checkListIfNeed()
        let funcs = [generateCodeNum, generateCodeMath]
        return funcs.rand()()
    }
    
    static internal func generateCodeNum() ->(identifier: String, question: String) {
        let identifier = String(Int(Date.init().timeIntervalSince1970 * 1000))
        var (equation, _, nums) = generateEquation()
        
        let num = rand(10)
        let funcs: Array<((Int)->Bool)> = [
            { $0 == num },
            { $0 > num },
            { $0 < num },
        ]
        let funcNum = rand(funcs.count)
        nums = nums.filter(funcs[funcNum])
        
        let msg_a = ["输入", "给出", "数出"]
        let msg_b = ["下列", "下面", "这个"]
        let msg_c = ["式子", "算式", "等式", "四则运算"]
        let msg_d = ["等于", "大于", "小于"]
        let msg_e = ["的个数", "出现的次数"]
        let question = "请\(msg_a.rand())\(msg_b.rand())\(msg_c.rand())\(equation)中数字\(msg_d[funcNum])\(num)\(msg_e.rand())"

        let item = VerificationItem.init(identifier: identifier, timeout: Date.init().timeIntervalSince1970 + 180, question: question, answer: "\(nums.count)")
        verification[identifier] = item

        return (identifier, question)
    }
    
    static internal func generateCodeMath() -> (identifier: String, question: String) {
        let identifier = String(Int(Date.init().timeIntervalSince1970 * 1000))
        let (equation, answer, _) = generateEquation()
        
        let msg_a = ["输入", "给出", "得出", "计算", "算出"]
        let msg_b = ["下列", "下面", "这个"]
        let msg_c = ["式子", "算式", "等式", "四则运算"]
        let msg_d = ["答案", "值", "结果"]
        let question = "请\(msg_a.rand())\(msg_b.rand())\(msg_c.rand())\(equation)的\(msg_d.rand())"
        
        let item = VerificationItem.init(identifier: identifier, timeout: Date.init().timeIntervalSince1970 + 180, question: question, answer: "\(answer)")
        verification[identifier] = item
        
        return (identifier, question)
    }
    
    static internal func generateEquation() -> (equation: String, answer: String, nums: [Int]) {
        let numTable = [
            ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"],
            ["０", "１", "２", "３", "４", "５", "６", "７", "８", "９"],
            ["零", "一", "二", "三", "四", "五", "六", "七", "八", "九"],
            ["零", "壹", "贰", "叁", "肆", "伍", "陆", "柒", "捌", "玖"],
            ["⓪", "①", "②", "③", "④", "⑤", "⑥", "⑦", "⑧", "⑨"],
            ]
        let signTable = [
            ["+", "-"],
            ["＋", "－"],
            ["加", "减"],
            ["➕", "➖"],
            ]
        let calculateFuncs: Array<((Int, Int)->Int)> = [
            { $0 + $1 },
            { $0 - $1 },
            { $0 * $1 },
        ]
        // 2 ~ 4 个数
        let numOfNum = rand(3) + 1
        var answer = rand(10)
        var nums = [answer]
        var question = "\(answer)"
        for _ in 0..<numOfNum {
            let num = rand(10)
            nums.append(num)
            let sign = rand(signTable[0].count)
            answer = calculateFuncs[sign](answer, num)
            question = "\(question)\(signTable.rand()[sign])\(numTable.rand()[num])"
        }
        
        return (question, "\(answer)", nums)
    }
    
    static func checkCode(identifier: String, answer: String) -> Bool {
        checkListIfNeed()
        guard let item = verification[identifier] else {
            return false
        }
        verification[identifier] = nil
        return item.answer == answer
    }
    
    static internal func rand(_ to: Int) -> Int {
        return Int(arc4random() % UInt32(to))
    }
        
    static internal func checkListIfNeed() {
        let now = Date.init().timeIntervalSince1970
        guard now > lastCheckTime * 5 else {
            return
        }
        lastCheckTime = now
        verification.forEach {
            if ($0.value.timeout >= now) {
                verification[$0.value.identifier] = nil
            }
        }
    }
}
