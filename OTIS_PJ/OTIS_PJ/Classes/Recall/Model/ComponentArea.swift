//
//  ComponentArea.swift
//  OTIS_PJ
//
//  Created by sunze on 2017/2/26.
//  Copyright © 2017年 sunzeboy. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON


public protocol Storageable {
    
   static func storage(jsonData:JSON)
}


enum RecallModel {
    case recallCategory(item: RecallCategory)
    case componentArea(item: ComponentArea)
    case mainComponent(item: MainComponent)
    case subComponent(item: SubComponent)
    case defect(item: Defect)
}


class RecallCategory: Object,Storageable {
    dynamic var categoryId = 0
    dynamic var categoryName = ""
    dynamic var categoryShortName = ""
    dynamic var categoryNameZh = ""
    override static func primaryKey() -> String? {
        return "categoryId"
    }
//    let areas = List<ComponentArea>()
  static func storage(jsonData: JSON) {
        var categories = [RecallCategory]()
        
        for (_,subJson):(String, JSON) in jsonData {
            let categry = RecallCategory()
            categry.categoryId = subJson["categoryId"].int!
            categry.categoryName = subJson["categoryName"].string!
            categry.categoryShortName = subJson["categoryShortName"].string!
            categry.categoryNameZh = subJson["categoryNameZh"].string!
            categories.append(categry)
        }
        let realm = try! Realm()
        try! realm.write {
            realm.add(categories, update: true)

        }
        let categor = realm.objects(RecallCategory.self)
        print(categor)
    }
    
}

class ComponentArea: Object,Storageable {
    dynamic var areaID = 0
    dynamic var areaName = ""
    dynamic var areaShortName = ""
    dynamic var areaNameZh = ""
    override static func primaryKey() -> String? {
        return "areaID"
    }
//    let mainComponents = List<MainComponent>()
    static func storage(jsonData: JSON) {
        var areas = [ComponentArea]()
        
        for (_,subJson):(String, JSON) in jsonData {
            let area = ComponentArea()
            area.areaID = subJson["areaID"].int!
            area.areaName = subJson["areaName"].string!
            area.areaShortName = subJson["areaShortName"].string!
            area.areaNameZh = subJson["areaNameZh"].string!
            areas.append(area)
        }
        let realm = try! Realm()
        try! realm.write {
            realm.add(areas, update: true)
        }
        let categor = realm.objects(ComponentArea.self)
        print(categor)
    }

}

class MainComponent: Object,Storageable {
    dynamic var mainID = 0
    dynamic var mainCode = ""
    dynamic var mainName = ""
    dynamic var mainShortName = ""
    dynamic var mainNameZh = ""
    dynamic var areaID = 0
    override static func primaryKey() -> String? {
        return "mainID"
    }
    
//    let areas = List<ComponentArea>()
    
    static func storage(jsonData: JSON) {
        var mains = [MainComponent]()
        
        for (_,subJson):(String, JSON) in jsonData {
            let main = MainComponent()
            main.mainID = subJson["mainID"].int!
            main.mainCode = subJson["mainCode"].string!
            main.mainName = subJson["mainName"].string!
            main.mainShortName = subJson["mainShortName"].string!
            main.mainNameZh = subJson["mainNameZh"].string!
            main.areaID = subJson["areaID"].int!
            mains.append(main)
        }
        let realm = try! Realm()
        try! realm.write {
            realm.add(mains, update: true)
        }
        let categor = realm.objects(MainComponent.self)
        print(categor)
    }
    
}


class SubComponent: Object,Storageable {
    dynamic var subID = 0
    dynamic var subCode = ""
    dynamic var subName = ""
    dynamic var subShortName = ""
    dynamic var subNameZh = ""
    dynamic var mainCode = ""
    override static func primaryKey() -> String? {
        return "subID"
    }
    //    let areas = List<ComponentArea>()
    
    static func storage(jsonData: JSON) {
        var subs = [SubComponent]()
        
        for (_,subJson):(String, JSON) in jsonData {
            let sub = SubComponent()
            sub.subID = subJson["subID"].int!
            sub.subCode = subJson["subCode"].string!
            sub.subName = subJson["subName"].string!
            sub.subShortName = subJson["subShortName"].string!
            sub.subNameZh = subJson["subNameZh"].string!
            sub.mainCode = subJson["mainCode"].string!
            subs.append(sub)
        }
        let realm = try! Realm()
        try! realm.write {
            realm.add(subs, update: true)
        }
        let categor = realm.objects(SubComponent.self)
        print(categor)
    }
}


class Defect: Object,Storageable {
    dynamic var defectID = 0
    dynamic var defectCode = ""
    dynamic var defectName = ""
    dynamic var defectShortName = ""
    dynamic var defectNameZh = ""
    dynamic var subCode = ""
    override static func primaryKey() -> String? {
        return "defectID"
    }
    //    let areas = List<ComponentArea>()
    static func storage(jsonData: JSON) {
        var defects = [Defect]()
        
        for (_,subJson):(String, JSON) in jsonData {
            let defect = Defect()
            defect.defectID = subJson["defectID"].int!
            defect.defectCode = subJson["defectCode"].string!
            defect.defectName = subJson["defectName"].string!
            defect.defectShortName = subJson["defectShortName"].string!
            defect.defectNameZh = subJson["defectNameZh"].string!
            defect.subCode = subJson["subCode"].string!
            defects.append(defect)
        }
        let realm = try! Realm()
        try! realm.write {
            realm.add(defects, update: true)
        }
        let categor = realm.objects(Defect.self)
        print(categor)
    }
    
}

