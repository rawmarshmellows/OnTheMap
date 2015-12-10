//
//  ModelData.swift
//  OnTheMap
//
//  Created by Kevin Lu on 10/12/2015.
//  Copyright © 2015 Kevin Lu. All rights reserved.
//

import Foundation

class ModelData {
    var studentsInformation : [StudentInformation]
    var userInformation : StudentInformation?
    
    init() {
        self.studentsInformation = [StudentInformation]()
        self.userInformation = StudentInformation(studentInformation: nil)
    }
    class func sharedData() -> ModelData {
        struct Singleton {
            static var sharedData = ModelData()
        }
        return Singleton.sharedData
    }
    func sortStudentInformation() {
        
    }
}