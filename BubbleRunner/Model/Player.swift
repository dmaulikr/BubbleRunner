//
//  Player.swift
//  BubblePicker
//
//  Created by jlcardosa on 02/03/2017.
//  Copyright © 2017 jlcardosa. All rights reserved.
//

import Foundation

let playerNSUserDefaultKey = "playerDefault"
class Player : NSObject, NSCoding {
    
    var sound:Bool = false
    var maxScore:Int64 = 0
    
    private override init() {
        super.init()
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        self.init()
        maxScore = aDecoder.decodeInt64(forKey: "maxScore")
        sound = aDecoder.decodeBool(forKey: "sound")
    }
    
    public func encode(with aCoder: NSCoder){
        aCoder.encode(maxScore as Int64, forKey: "maxScore")
        aCoder.encode(sound as Bool, forKey:"sound")
    }
    
    public static func getInstance() -> Player {
        if let encodedData = UserDefaults.standard.object(forKey: playerNSUserDefaultKey) as? Data {
            return NSKeyedUnarchiver.unarchiveObject(with: encodedData) as! Player
        } else {
            return Player()
        }
    }
    
    public func save() {
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: self)
        UserDefaults.standard.set(encodedData, forKey: playerNSUserDefaultKey)
    }
    
    public func reset() {
        UserDefaults.standard.removeObject(forKey: playerNSUserDefaultKey)
        sound = false
        maxScore = 0
    }
}
