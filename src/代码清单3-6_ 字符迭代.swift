let sentence = "Swift 6.2"

// String 遵循 Sequence,因此无需转换为数组即可遍历 Character
for char in sentence {
    print(char)
}

// enumerated() 同时给出索引与字符,适合需要位置信息的场景
for (index, char) in sentence.enumerated() {
    print("\(index): \(char)")
}