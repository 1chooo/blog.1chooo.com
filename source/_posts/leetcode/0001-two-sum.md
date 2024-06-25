---
title: "LeetCode 0001. Two Sum - Hash Map Solution | Go, Python, C++"
categories: Leetcode
date: 2024-06-25 00:00:00
tags: 
- Go
- Python
- Leetcode
- Array
- Hash Table
cover: /images/cover/leetcode/0001-two-sum.png
mathjax: true
---

Link 👉🏻 [1. Two Sum](https://leetcode.com/problems/two-sum/)

### Description


Given an array of integers `nums` and an integer `target`, *return indices of the two numbers such that they add up to `target`*.

You may assume that each input would have exactly one solution, and you may not use the same element twice.

You can return the answer in any order.

**Example 1:**
- Input: `nums = [2,7,11,15], target = 9`
- Output: `[0,1]`
- Explanation: `Because nums[0] + nums[1] == 9, we return [0, 1].`

**Example 2:**
- Input: `nums = [3,2,4], target = 6`
- Output: `[1,2]`

**Example 3:**
- Input: `nums = [3,3], target = 6`
- Output: `[0,1]`

**Constraints:**

- <code>2 <= nums.length <= 10<sup>4</sup></code>
- <code>-10<sup>9</sup> <= nums[i] <= 10<sup>9</sup></code>
- <code>-10<sup>9</sup> <= target <= 10<sup>9</sup></code>
- <code>Only one valid answer exists.</code>

**Follow-up:** Can you come up with an algorithm that is less than <code>O(n<sup>2</sup>)</code> time complexity?

### Intuition

Use HashMap to keep numbers and their indices we found.


{% notel blue Note %}
Create a Hash Table in `GO` with `make` function <sup>[Golang Maps](https://www.geeksforgeeks.org/golang-maps/)</sup>, and use `map[key] = value` to set the value of the key.

```go
numMap := make(map[int]int)
```

{% endnotel %}


{% notel blue Note %}

**How to Work with maps?** <sup>[Go maps in action#Working with maps](https://go.dev/blog/maps)</sup>

A two-value assignment tests for the existence of a key:

```go
i, ok := m["route"]
```

In this statement, the first `value (i)` is assigned the value stored under the key "route". If that key doesn't exist, i is the value type's zero `value (0)`. The second `value (ok)` is a `bool` that is true if the key exists in the map, and false if not.

To test for a key without retrieving the value, use an underscore in place of the first value:

```go
_, ok := m["route"] 
```

To iterate over the contents of a map, use the range keyword:

```go
for key, value := range m {
    fmt.Println("Key:", key, "Value:", value)
}
```

{% endnotel %}

### Approach

1. Traverse the `nums` array and store the difference between the `target` and the current `number` as the `key` and the `index` as the `value` in the HashMap.
2. If the current `number` is already in the HashMap, return the `index` of the current `number` and the `index` stored in the HashMap.
3. We still need to return an empty array if there is no solution.


### Complexity
- Time complexity: $O(n)$

- Space complexity: $O(n)$

### Code

{% tabs First unique name %}
<!-- tab Go-->

```go
func twoSum(nums []int, target int) []int {
    hashMap := make(map[int]int)

    for i, num := range nums {
        if j, ok := hashMap[num]; ok {
            return []int{j, i}
        }
        hashMap[target - num] = i
    }

    return []int{}
}
```
<!-- endtab -->
 
<!-- tab Python-->
 
```python
class Solution:
    def twoSum(self, nums: List[int], target: int) -> List[int]:
        hMap = {}
        
        for i in range(len(nums)):
            if nums[i] in hMap:
                return [hMap[nums[i]], i]
            else:
                hMap[target - nums[i]] = i

        return []
```
<!-- endtab -->

<!-- tab C++-->
 
```cpp
class Solution {
public:
    vector<int> twoSum(vector<int>& nums, int target) {
        unordered_map<int, int> hashMap;

        for (int i = 0; i < nums.size(); ++i) {
            int num = nums[i];
            if (hashMap.find(num) != hashMap.end()) {
                return {hashMap[num], i};
            }
            hashMap[target - num] = i;
        }

        return {};
    }
};
```
<!-- endtab -->
 
{% endtabs %}


