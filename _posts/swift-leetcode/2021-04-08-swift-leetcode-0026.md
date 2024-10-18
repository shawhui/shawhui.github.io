---
title: LeetCode - 删除有序数组中的重复项
date: 2021-04-08 12:00:00 +0800
tags: [Swift, LeetCode, 算法, 数据结构, 数组]
categories: [代码人生, LeetCode]
---

题目链接：[删除有序数组中的重复项](https://leetcode.com/problems/remove-duplicates-from-sorted-array)

## 主要思路

定义一个索引index, 遍历数组过程中与该索引的值进行对比，如果不一致，则修改对应索引的值

## 代码实现

```swift
/**
 * 时间复杂度: O(n), 空间复杂度: O(1)
 */
class Solution {
    func removeDuplicates(_ nums: inout [Int]) -> Int {
        guard nums.count > 0 else {
            return 0
        }
        var index = 0
        for num in nums where num != nums[index] {
            index += 1
            nums[index] = num
        }
        return index + 1
    }
}
```