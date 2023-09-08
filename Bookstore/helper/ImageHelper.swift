//
//  ImageHelper.swift
//  Bookstore
//
//  Created by Jing Wei on 08/09/2023.
//

import Foundation

func GetImagePath(filename:String) -> URL
{
    let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let cacheFile = dir.appendingPathComponent(filename)
    return cacheFile
}
