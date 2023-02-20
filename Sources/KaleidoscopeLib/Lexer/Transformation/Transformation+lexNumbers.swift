extension Transformation {
    static let lexNumbers = Transformation { string -> Token? in
        var buffer = ""
        
        guard
            let firstChar = string.first,
            firstChar.isPartOf(.decimalDigits)
        else {
            return nil
        }

        buffer.append(firstChar)
        string = string.dropFirst()

        while true {
            guard
                let next = string.first,
                next.isPartOf(.decimalDigits)
            else {
                break
            }

            buffer.append(next)
            string = string.dropFirst()
        }

        if let separator = string.first, separator == "." {
            let ogString = string
            string = string.dropFirst()
            
            if let nextDigit = string.first, nextDigit.isPartOf(.decimalDigits) {
                buffer.append(".")
                buffer.append(nextDigit)
                string = string.dropFirst()
                
                while true {
                    guard
                        let next = string.first,
                        next.isPartOf(.decimalDigits)
                    else {
                        break
                    }
                    
                    buffer.append(next)
                    string = string.dropFirst()
                }
            } else {
                string = ogString
            }
        }

        guard let number = Double(buffer) else {
            fatalError("Lexer Error: \(#function): internal error.")
        }

        return .number(number)
    }
}
