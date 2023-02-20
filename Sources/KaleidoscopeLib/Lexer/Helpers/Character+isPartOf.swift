import Foundation

extension Character {
    /// Indicates whether the given character set contains this character.
    func isPartOf(_ set: CharacterSet) -> Bool {
        return String(self).rangeOfCharacter(from: set) != nil
    }
}
