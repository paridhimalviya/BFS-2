//
//  CousinsInTheTree.swift
//  DSA-Practice
//
//  Created by Paridhi Malviya on 1/22/26.
//


/*
 Using BFS, when we take any element out of the queue, then chekc if it matches any of the element. If yes,
 check id they are from the same level - using size variable
 At 1 level, if we find only one node, then return false.
 If both nodes at a level, check parents if they are equal or not
 time compelxity - O(n), space compelxity -> O(2n) = O(n)
 */



class CousinsInTheTree {
    
    final class QueueUsingLL<T> {
        
        private final class LinkedListNode<T> {
            var value: T
            var next: LinkedListNode<T>?
            
            init(value: T) {
                self.value = value
            }
        }
        
        private var front: LinkedListNode<T>?
        private var rear: LinkedListNode<T>?
        private var count: Int = 0
        
        //MARK: - Enqueue
        func enqueue(_ value: T) {
            let newNode = LinkedListNode(value: value)
            if (rear == nil) {
                front = newNode
                rear = newNode
            } else {
                rear?.next = newNode
                rear = newNode
            }
            count += 1
        }
        
        //MARK: dequeue
        @discardableResult
        func dequeue() -> T? {
            guard let frontNode = front else {
                return nil
            }
            
            let value = frontNode.value
            front = frontNode.next
            if (front == nil) {
                rear = nil
            }
            count -= 1
            return value
        }
        
        //MARK: peek
        func peek() -> T? {
            return front?.value
        }
        
        //MAK: helpers
        var isEmpty: Bool {
            return count == 0
        }
        
        var size: Int {
            return count
        }
        
        init() {
            
        }
    }

    
    init() {
        
    }
    
   //time complexity - O(n), space complexity - O(n)
    //MARK: using BFS using parent queue
    func isCousins(_ root: TreeNode?, _ x: Int, _ y: Int) -> Bool {
        guard let root = root else {
            return false
        }
        //using BFS
        var nodeQueue = QueueUsingLL<TreeNode>()
        var parentQueue = QueueUsingLL<TreeNode>()
        
        nodeQueue.enqueue(root)
        let parentNode = TreeNode(val: -1, left: nil, right: nil)
        parentQueue.enqueue(parentNode)
        
        while (!nodeQueue.isEmpty) {
            let size = nodeQueue.size
            //processing the level
            var isFoundX: Bool = false
            var isFoundY = false
            var parentX: TreeNode!
            var parentY: TreeNode!
            for i in 0..<size {
                
                let removedElement = nodeQueue.dequeue()
                let parentOfRemovedOne = parentQueue.dequeue()
                
                if (removedElement?.val == x) {
                    isFoundX = true
                    parentX = parentOfRemovedOne!
                } else if (removedElement?.val == y) {
                    isFoundY = true
                    parentY = parentOfRemovedOne!
                }
                
                if let leftNode = removedElement?.left {
                    nodeQueue.enqueue(leftNode)
                    parentQueue.enqueue(removedElement!)
                }
                if let rightNode = removedElement?.right {
                    nodeQueue.enqueue(rightNode)
                    parentQueue.enqueue(removedElement!)
                }
            }
            if (isFoundX && isFoundY) {
                //If parent is different, it means they are cousins
                return parentX.val != parentY.val
            }
            
            if (isFoundX || isFoundY) {
                //because the level of both are different.
                return false
            }
        }
        return false
    }
    
    //MARK: BFS without using parent queue
    func isCousinsWithoutCreatingTheParentQueueBFS(root: TreeNode?, x: Int, y: Int) -> Bool {
        guard let root = root else {
            return false
        }
        var nodeQueue = QueueUsingLL<TreeNode>()
        nodeQueue.enqueue(root)
        while(!nodeQueue.isEmpty) {
            let size = nodeQueue.size
            var isFoundX = false
            var isFoundY = false
            for i in 0..<size {
                let removedElement = nodeQueue.dequeue()
                if (removedElement?.val == x) {
                    isFoundX = true
                }
                if(removedElement?.val == y) {
                    isFoundY = true
                }
                //below they are the children of same parent, so they can't be cousins.
                //because parent should not be the same to be cousins
                if (removedElement?.left?.val == x && removedElement?.right?.val == y) {
                    return false
                } else if (removedElement?.left?.val == y && removedElement?.right?.val == x) {
                    return false
                }
                if let leftChild = removedElement?.left {
                    nodeQueue.enqueue(leftChild)
                }
                if let rightChild = removedElement?.right {
                    nodeQueue.enqueue(rightChild)
                }
            }
            if (isFoundX && isFoundY) {
                //they are not siblings because wecould have caught them in above step when we were putting them in the queue,
                return true
            }
            if (isFoundX || isFoundY) {
                return false
            }
        }
        return false
    }
    
    //MARK: Using DFS - using parents variable
    var x_depth: Int = 0
    var y_depth: Int = 0
    var parentX: TreeNode?
    var parentY: TreeNode?
    func isCousinsUsingDFS(_ root: TreeNode?, _ x: Int, _ y: Int) -> Bool {
        dfs(root: root, level: 0, x: x, y: y, parent: nil)
        return (x_depth == y_depth) && (parentX?.val != parentY?.val)
    }

    func dfs(root: TreeNode?, level: Int, x: Int, y: Int, parent: TreeNode?)  {
        //base
        guard let root = root else {
            return
        }
        if (parentX != nil && parentY != nil) {
            return
        }

        //logic
        if (root.val == x) {
            x_depth = level
            parentX = parent
        }
        if (root.val == y) {
            y_depth = level
            parentY = parent
        }

        dfs(root: root.left, level: level + 1, x: x, y: y, parent: root)
       
        dfs(root: root.right, level: level + 1, x: x, y: y, parent: root)
    }
    
    //MARK: using DFS - without parents variables
    var flag = true

    func isCousinsDFSWihtoutParentsVars(_ root: TreeNode?, _ x: Int, _ y: Int) -> Bool {
        flag = true
        dfs2(root: root, level: 0, x: x, y: y)
        if (x_depth != y_depth) {
            flag = false
        }
        return flag
    }

    func dfs2(root: TreeNode?, level: Int, x: Int, y: Int)  {
        //base
        guard let root = root else {
            return
        }
        //logic
        if (root.val == x) {
            x_depth = level
        }
        if (root.val == y) {
            y_depth = level
        }
        if (root.left != nil && root.right != nil) {
            if ((root.left!.val == x && root.right!.val == y) || (root.left!.val == y && root.right!.val == x)) {
                flag = false
            }
        }

        dfs2(root: root.left, level: level + 1, x: x, y: y)
        dfs2(root: root.right, level: level + 1, x: x, y: y)
    }
}
