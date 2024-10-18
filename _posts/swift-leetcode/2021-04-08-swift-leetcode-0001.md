---
title: LeetCode - 两数之和
date: 2021-04-08 12:00:00 +0800
tags: [Swift, LeetCode, 算法, 数据结构, 数组]
categories: [代码人生, LeetCode]
---

题目链接：[两数之和](https://leetcode-cn.com/problems/two-sum/)

## 主要思路

遍历数组，并且使用 map 存储 target - nums[i] 的值

## 代码实现

```swift
/**
 * 时间复杂度: O(n), 空间复杂度: O(n)
 */
class Solution {
    func twoSum(_ nums: [Int], _ target: Int) -> [Int] {
        var dict = [Int: Int]()
        for (i, num) in nums.enumerated() {
            if let lastIndex = dict[target - num] {
                return [lastIndex, i]
            }
            dict[num] = i
        }
        fatalError("No valid outputs")
    }
}
```