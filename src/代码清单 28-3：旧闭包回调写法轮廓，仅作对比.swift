URLSession.shared.dataTask(with: request) { data, response, error in
    if let error {
        print("请求失败：\(error.localizedDescription)")
        return
    }

    guard let httpResponse = response as? HTTPURLResponse else {
        print("响应无效")
        return
    }

    guard 200..<300 ~= httpResponse.statusCode else {
        print("状态码异常：\(httpResponse.statusCode)")
        return
    }

    guard let data else {
        print("没有拿到 Data")
        return
    }

    print("响应字节数：\(data.count)")
}.resume()