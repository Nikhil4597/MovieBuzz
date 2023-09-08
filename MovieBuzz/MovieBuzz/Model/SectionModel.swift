//
//  TableSectionModel.swift
//  MovieBuzz
//
//  Created by ROHIT MISHRA on 31/08/23.
//

import Foundation

/// Class representing a section within the data model.
class SectionModel {
    var sectionType: SectionType
    var itemType: [ItemType]
    var opened: Bool

    init(sectionType: SectionType, itemType: [ItemType], opened: Bool) {
        self.sectionType = sectionType
        self.itemType = itemType
        self.opened = opened
    }
}
