//: Playground - noun: a place where people can play

import UIKit
import MapKit
import XCPlayground

let CellIdentifier = "earthquake"

struct Earthquake {
    let label: String
    let magnitude: Double
}

class EarthquakeTableViewCell: UITableViewCell {

    var earthquake: Earthquake? {
        didSet {
            updateUI()
        }
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func updateUI() {
        textLabel?.text = earthquake?.label
        detailTextLabel?.text = "\(earthquake?.magnitude)"
    }

    override func prepareForReuse() {
        textLabel?.text = ""
        detailTextLabel?.text = ""
    }
}

class ListData: NSObject, UITableViewDataSource {

    let data: [Earthquake] = [
        Earthquake(label: "Lakeview, Oregon", magnitude: 2.89),
        Earthquake(label: "Homer, Alaska", magnitude: 2.9),
        Earthquake(label: "Hachijo-jima, Japan", magnitude: 4.6)
    ]

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier) as! UITableViewCell
        cell.textLabel?.text = "Hello"
        return cell
    }
}

let view = UIView(frame: CGRectMake(0, 0, 320, 600))
view.backgroundColor = UIColor.lightGrayColor()
view.setTranslatesAutoresizingMaskIntoConstraints(false)
XCPShowView("view", view)


// mark - Map

let map = MKMapView()
map.setTranslatesAutoresizingMaskIntoConstraints(false)
let center = CLLocationCoordinate2DMake(0, 0)
let span = MKCoordinateSpanMake(1, 1)
map.region = MKCoordinateRegionMake(center, span)

view.addSubview(map)

// map left and right
view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|[map]|", options: NSLayoutFormatOptions(0), metrics: nil, views: ["map": map]))

// map top
view.addConstraint(NSLayoutConstraint(item: view, attribute: .Top, relatedBy: .Equal, toItem: map, attribute: .Top, multiplier: 1, constant: 0))

// map bottom
view.addConstraint(NSLayoutConstraint(item: view, attribute: .CenterY, relatedBy: .Equal, toItem: map, attribute: .Bottom, multiplier: 1, constant: 0))


// mark - List

let list = UITableView(frame: CGRectZero, style: .Plain)
list.registerClass(UITableViewCell.self, forCellReuseIdentifier: CellIdentifier)
let data = ListData()
list.dataSource = data
list.setTranslatesAutoresizingMaskIntoConstraints(false)

view.addSubview(list)

// list left and right
view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|[list]|", options: NSLayoutFormatOptions(0), metrics: nil, views: ["list": list]))

// list top
view.addConstraint(NSLayoutConstraint(item: list, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .CenterY, multiplier: 1, constant: 0))

// list bottom
view.addConstraint(NSLayoutConstraint(item: list, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1, constant: 0))


// mark - SHAKE!

let viewsToShake = [list]

let animator = UIDynamicAnimator(referenceView: view)

let collisionBehavior = UICollisionBehavior(items: viewsToShake)
let padding: CGFloat = -10
collisionBehavior.setTranslatesReferenceBoundsIntoBoundaryWithInsets(UIEdgeInsetsMake(padding, padding, padding, padding))
animator.addBehavior(collisionBehavior)

let elasticBehavior = UIDynamicItemBehavior(items: viewsToShake)
elasticBehavior.elasticity = 0.7
animator.addBehavior(elasticBehavior)

let gravityBehavior = UIGravityBehavior(items: viewsToShake)
gravityBehavior.gravityDirection = CGVectorMake(1.0, 0.0)
animator.addBehavior(gravityBehavior)
