let data = try await fetchRawWeather(latitude: latitude, longitude: longitude)
let response = try JSONDecoder().decode(WeatherResponse.self, from: data)