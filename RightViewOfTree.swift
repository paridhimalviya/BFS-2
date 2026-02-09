//
//  RightViewOfTree.swift
//  DSA-Practice
//
//  Created by Paridhi Malviya on 1/20/26.
//

/*
 Right view of tree -
 BFS - level order traversal. print the last element i each level.
 
 do DFS,
 firstly maintain level in recursion paramter.
 1. make list of lists. print last element at each level.
 2. overwrtting somehting- O(1), pushing to list O(1)
 preorder, left and right.... maintain a list and insert element corresponding to each level. keep overwritting
 
 do right traversla first. Dont replace earlier level's values.
 
 O(n), O(h)
 */

/*
 we are gven 2 nodes. Check whether they are cousins or not.
 
 */

class RightViewOfTree {
    
    //using DFS - first right call, without replacement
    var result = [Int]()
    func rightSideView(_ root: TreeNode?) -> [Int] {
        dfs(root, level: 0, result: &result)
        return result
    }

    func dfs(_ root: TreeNode?, level: Int, result: inout [Int]) {
        //base case
        guard let root = root else {
            return
        }

        //logic
        if (level == result.count) {
            result.append(root.val)
        }
        dfs(root.right, level: level + 1, result: &result)
        dfs(root.left, level: level + 1, result: &result)
    }
    
    
    //using DFS - first left call, with replacement
    var result2 = [Int]()

    func rightSideView2(_ root: TreeNode?) -> [Int] {
        dfs(root, level: 0, result: &result2)
        return result2
    }

    func dfs2(_ root: TreeNode?, level: Int, result: inout [Int]) {
        //base case
        guard let root = root else {
            return
        }

        //logic
        if (level == result2.count) {
            result.append(root.val)
        } else {
            result[level] = root.val
        }
        dfs(root.right, level: level + 1, result: &result2)
        dfs(root.left, level: level + 1, result: &result2)
    }

    
    //MARK: - using BFS
    func rightSideViewBFS(_ root: TreeNode?) -> [Int] {
        guard let root = root else {
            return []
        }
        var result = [Int]()
        var queue = QueueUsingLL<TreeNode>()
        queue.enqueue(root)

        while(!queue.isEmpty) {
            let size = queue.size

            for i in 0..<size {
                let dequeued = queue.dequeue()
                guard let dequeued = dequeued else {
                    continue
                }
                //if i == 0, condition will print the left side of tree
                if (i == size - 1) {
                    result.append(dequeued.val)
                }

                if let leftNode = dequeued.left {
                    queue.enqueue(leftNode)
                }
                if let rightNode = dequeued.right {
                    queue.enqueue(rightNode)
                }
            }
        }
        return result
    }
}
