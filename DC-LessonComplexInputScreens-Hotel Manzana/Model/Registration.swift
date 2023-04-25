//
//  Registration.swift
//  DC-LessonComplexInputScreens-Hotel Manzana
//
//  Created by Антон Адамсон on 26.04.2023.
//

import Foundation

struct Registration {
    var firstName: String
    var lastName: String
    var emailAddress: String
    
    var checkInDate: Date
    var checkOutDate: Date
    var numberOfAdults: Int
    var numberOfChildren: Int
    
    var wifi: Bool
    var roomType: RoomType
}
