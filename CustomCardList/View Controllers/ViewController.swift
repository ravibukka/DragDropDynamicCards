//
//  ViewController.swift
//  CustomCardList
//
//  Created by RavikumarBukka on 04/10/18.
//  Copyright © 2018 RavikumarBukka. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    

    
    var sourceArrayString = [
        "There is no time after In catch the wind rafter Those hours are just here to drift Inside and outside time's swift",
        "I don't know why it's like this Coming and going always on For everything works like a bliss.",
        "Until it's almost gone",
        "My heart reaches out to you Trying to love and to go",
        "With every turning and blue As it shall always know.",
        "There is no time after",
        "- only this Wasting every minute and hour.",
        "ords that are coming to miss Feelings that reach out and vower Love that is like ours still In evenings and morning to fulfill.",
        "Till the woe is gone To give and teach.",
        "And life is ready To lead from here In this rime.",
        "Far out The sky.",
        "And my heart craves The silvery swan."
    ]
    
    let columnLayout = ColumnFlowLayout(
        cellsPerRow: 2,
        minimumInteritemSpacing: 10,
        minimumLineSpacing: 10,
        sectionInset: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    )
    
//    fileprivate var longPressGesture: UILongPressGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.collectionViewLayout = columnLayout
        collectionView?.contentInsetAdjustmentBehavior = .always
        collectionView?.register(Cell.self, forCellWithReuseIdentifier: "Cell")
        
//        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongGesture(gesture:)))
//        collectionView.addGestureRecognizer(longPressGesture)
        
        collectionView.dragInteractionEnabled = true
        collectionView.dropDelegate = self
        collectionView.dragDelegate = self
        collectionView.reorderingCadence = .fast
    }
    
    
    //MARK: Private Methods
    

    ///
    /// - Parameters:
    ///   - coordinator: coordinator obtained from performDropWith: UICollectionViewDropDelegate method
    ///   - destinationIndexPath: indexpath of the collection view where the user drops the element
    ///   - collectionView: collectionView in which reordering needs to be done.
    private func reorderItems(coordinator: UICollectionViewDropCoordinator, destinationIndexPath: IndexPath, collectionView: UICollectionView)
    {
        var items = coordinator.items
        if items.count == 1, let item = items.first, let sourceIndexPath = item.sourceIndexPath
        {
            var dIndexPath = destinationIndexPath
            if dIndexPath.row >= collectionView.numberOfItems(inSection: 0)
            {
                dIndexPath.row = collectionView.numberOfItems(inSection: 0) - 1
            }
            collectionView.performBatchUpdates({

                    sourceArrayString.remove(at: sourceIndexPath.row)
                    sourceArrayString.insert(item.dragItem.localObject as! String, at: dIndexPath.row)
                    collectionView.deleteItems(at: [sourceIndexPath])
                    collectionView.insertItems(at: [dIndexPath])
            })
            coordinator.drop(items.first!.dragItem, toItemAt: dIndexPath)
        }
    }
    

    ///
    /// - Parameters:
    ///   - coordinator: coordinator obtained from performDropWith: UICollectionViewDropDelegate method
    ///   - destinationIndexPath: indexpath of the collection view where the user drops the element
    ///   - collectionView: collectionView in which reordering needs to be done.
    private func copyItems(coordinator: UICollectionViewDropCoordinator, destinationIndexPath: IndexPath, collectionView: UICollectionView)
    {
        collectionView.performBatchUpdates({
            var indexPaths = [IndexPath]()
            for (index, item) in coordinator.items.enumerated()
            {
                let indexPath = IndexPath(row: destinationIndexPath.row + index, section: destinationIndexPath.section)

                    sourceArrayString.insert(item.dragItem.localObject as! String, at: indexPath.row)

                indexPaths.append(indexPath)
            }
            collectionView.insertItems(at: indexPaths)
        })
    }
    
    
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout()
        super.viewWillTransition(to: size, with: coordinator)
        
        if UIDevice.current.orientation.isPortrait {
            print("Portrait")
            let columnLayout  = ColumnFlowLayout(
                cellsPerRow: 2,
                minimumInteritemSpacing: 10,
                minimumLineSpacing: 10,
                sectionInset: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            )
            collectionView?.collectionViewLayout = columnLayout
        }
        else {
            print("Landscape")
             let columnLayout = ColumnFlowLayout(
                cellsPerRow: 3,
                minimumInteritemSpacing: 10,
                minimumLineSpacing: 10,
                sectionInset: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            )
            collectionView?.collectionViewLayout = columnLayout
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

//extension UICollectionView {
//    func setItemsInRow(items: Int) {
//        if let layout = self.collectionViewLayout as? UICollectionViewFlowLayout {
//            let contentInset = self.contentInset
//            let itemsInRow: CGFloat = CGFloat(items);
//            let innerSpace = layout.minimumInteritemSpacing * (itemsInRow - 1.0)
//            let insetSpace = contentInset.left + contentInset.right + layout.sectionInset.left + layout.sectionInset.right
//            let width = floor((CGRectGetWidth(frame) - insetSpace - innerSpace) / itemsInRow);
//            layout.itemSize = CGSizeMake(width, width)
//        }
//    }
//}

// MARK: - UICollectionViewDataSource Methods
extension ViewController : UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return sourceArrayString.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! Cell
        cell.label.text = sourceArrayString[indexPath.row]
        return cell

    }
}

// MARK: - UICollectionViewDragDelegate Methods
extension ViewController : UICollectionViewDragDelegate
{
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem]
    {
        let item = collectionView == self.collectionView ? self.sourceArrayString[indexPath.row] : self.sourceArrayString[indexPath.row]
        let itemProvider = NSItemProvider(object: item as NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = item
        return [dragItem]
    }
    
    func collectionView(_ collectionView: UICollectionView, itemsForAddingTo session: UIDragSession, at indexPath: IndexPath, point: CGPoint) -> [UIDragItem]
    {
        let item = collectionView == self.collectionView ? self.sourceArrayString[indexPath.row] : self.sourceArrayString[indexPath.row]
        let itemProvider = NSItemProvider(object: item as NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = item
        return [dragItem]
    }
    
    func collectionView(_ collectionView: UICollectionView, dragPreviewParametersForItemAt indexPath: IndexPath) -> UIDragPreviewParameters?
    {

        return nil
    }
}

// MARK: - UICollectionViewDropDelegate Methods
extension ViewController : UICollectionViewDropDelegate
{
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool
    {
        return session.canLoadObjects(ofClass: NSString.self)
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal
    {

            if collectionView.hasActiveDrag
            {
                return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
            }
            else
            {
                return UICollectionViewDropProposal(operation: .copy, intent: .insertAtDestinationIndexPath)
            }

    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator)
    {
        let destinationIndexPath: IndexPath
        if let indexPath = coordinator.destinationIndexPath
        {
            destinationIndexPath = indexPath
        }
        else
        {
            // Get last index path of table view.
            let section = collectionView.numberOfSections - 1
            let row = collectionView.numberOfItems(inSection: section)
            destinationIndexPath = IndexPath(row: row, section: section)
        }
        
        switch coordinator.proposal.operation
        {
        case .move:
            self.reorderItems(coordinator: coordinator, destinationIndexPath:destinationIndexPath, collectionView: collectionView)
            break
            
        case .copy:
            self.copyItems(coordinator: coordinator, destinationIndexPath: destinationIndexPath, collectionView: collectionView)
            
        default:
            return
        }
    }
}



