//: Playground - noun: a place where people can play

import UIKit

let formatter = NSDateFormatter()
formatter.dateStyle = NSDateFormatterStyle.MediumStyle
formatter.timeStyle = NSDateFormatterStyle.MediumStyle

let s = formatter.stringFromDate(NSDate())

let offset = 1437759413400.0

let n = NSNumber(double: offset)

let date = NSDate(timeIntervalSince1970: n.doubleValue / 1000)
