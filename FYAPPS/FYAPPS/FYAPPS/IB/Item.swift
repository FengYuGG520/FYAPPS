//
//	Item.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class Item : NSObject, NSCoding{

	var regionId : Int!// 省份Id
	var regionName : String!// 省份名
	var items : [Item]!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		regionId = dictionary["region_id"] as? Int
		regionName = dictionary["region_name"] as? String
		items = [Item]()
		if let itemsArray = dictionary["items"] as? [[String:Any]]{
			for dic in itemsArray{
				let value = Item(fromDictionary: dic)
				items.append(value)
			}
		}
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if regionId != nil{
			dictionary["region_id"] = regionId
		}
		if regionName != nil{
			dictionary["region_name"] = regionName
		}
		if items != nil{
			var dictionaryElements = [[String:Any]]()
			for itemsElement in items {
				dictionaryElements.append(itemsElement.toDictionary())
			}
			dictionary["items"] = dictionaryElements
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         regionId = aDecoder.decodeObject(forKey: "region_id") as? Int
         regionName = aDecoder.decodeObject(forKey: "region_name") as? String
         items = aDecoder.decodeObject(forKey :"items") as? [Item]

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if regionId != nil{
			aCoder.encode(regionId, forKey: "region_id")
		}
		if regionName != nil{
			aCoder.encode(regionName, forKey: "region_name")
		}
		if items != nil{
			aCoder.encode(items, forKey: "items")
		}

	}

}
