//: Playground - noun: a place where people can play

import UIKit

let formatter = NSDateFormatter()
formatter.dateStyle = NSDateFormatterStyle.MediumStyle
formatter.timeStyle = NSDateFormatterStyle.MediumStyle

let s = formatter.stringFromDate(NSDate())
