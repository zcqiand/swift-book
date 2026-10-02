let frontendSkills: Set<String> = ["HTML", "CSS", "JavaScript", "Swift"]
let backendSkills: Set<String> = ["Swift", "Python", "SQL", "JavaScript"]

// intersection 求交集：两组都掌握的技能
let commonSkills = frontendSkills.intersection(backendSkills)
print("共同技能（交集）: \(commonSkills.sorted())")
// 输出: 共同技能（交集）: ["JavaScript", "Swift"]

// union 求并集：两组技能合并后自动去重
let allSkills = frontendSkills.union(backendSkills)
print("全部技能（并集）: \(allSkills.sorted())")
// 输出: 全部技能（并集）: ["CSS", "HTML", "JavaScript", "Python", "SQL", "Swift"]

// subtracting 求差集：前端独有的技能
let onlyFrontend = frontendSkills.subtracting(backendSkills)
print("仅前端独有（差集）: \(onlyFrontend.sorted())")
// 输出: 仅前端独有（差集）: ["CSS", "HTML"]