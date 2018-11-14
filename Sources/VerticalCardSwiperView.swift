// MIT License
//
// Copyright (c) 2017 Joni Van Roost
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import Foundation
import UIKit

/**
 The VerticalCardSwiperView is a subclass of `UICollectionView` that we use internally in the `VerticalCardSwiper`.
 This allows for custom implementations of the underlying `UICollectionView` so that we can simplify some usages.
 */
public class VerticalCardSwiperView: UICollectionView {
    
    /// A `Bool` that indicates if the `UICollectionView` is currently scrolling.
    public var isScrolling: Bool {
        return (self.isDragging || self.isTracking || self.isDecelerating)
    }
    
    /**
     Returns an array of indexes (as Int) that are currently visible in the `VerticalCardSwiperView`.
     This does not include cards that are behind the card that is in focus.
     - returns: An array of indexes (as Int) that are currently visible.
     */
    public var indexesForVisibleCards: [Int] {
        
        let lowestIndex = self.indexPathsForVisibleItems.min()?.row ?? 0
        
        // when first card is focussed, return as usual.
        if (visibleCells.count == 2 && lowestIndex == 0) {
            return self.indexPathsForVisibleItems.map({$0.row}).sorted()
        }
        
        var indexes: [Int] = []
        // Add each visible cell except the lowest one and return
        for cell in self.visibleCells {
            
            if let index = self.indexPath(for: cell)?.row, index != lowestIndex {
                indexes.append(index)
            }
        }
        return indexes.sorted()
    }
    
    /**
     Returns a reusable cell object located by its identifier.
     Call this method from your data source object when asked to provide a new cell for the VerticalCardSwiperView.
     This method dequeues an existing cell if one is available or creates a new one based on the class or nib file you previously registered.
     
     **Important**
     
     You must register a class or nib file using the register(\_:forCellWithReuseIdentifier:) or register(\_:forCellWithReuseIdentifier:) method before calling this method.
     
     If you registered a class for the specified identifier and a new cell must be created, this method initializes the cell by calling its init(frame:) method. For nib-based cells, this method loads the cell object from the provided nib file. If an existing cell was available for reuse, this method calls the cell’s prepareForReuse() method instead.
     
     - parameter identifier: The reuse identifier for the specified cell. This parameter must not be nil.
     
     - parameter index: The index specifying the location of the cell. The data source receives this information when it is asked for the cell and should just pass it along. This method uses the index to perform additional configuration based on the cell’s position in the VerticalCardSwiperView.
     */
    public func dequeueReusableCell(withReuseIdentifier identifier: String, for index: Int) -> UICollectionViewCell {
        return self.dequeueReusableCell(withReuseIdentifier: identifier, for: IndexPath(row: index, section: 0))
    }
}
