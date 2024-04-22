module FetchData

  private

  def fetch_data(path:, filename:)
    return get_data_from_file(filename) if cache_exists(filename)

    fetch_and_store(path: path, filename: filename)
  end

  def cache_exists(filename)
    File.exist?("data/#{filename}.json")
  end

  def get_data_from_file(filename)
    p "Returning cached data from #{filename}"
    JSON.parse(File.read("data/#{filename}.json"))
  end

  def fetch_and_store(path:, filename:)
    p "Fetching new data from #{path}..."
    response = @API.request("https://data.nif.no/api/v1/#{path}")
    data = response.body
    json = JSON.parse(data)

    p "Storing data points in file: #{filename}"
    store_as_json(json, filename)
    store_as_csv(json, filename)

    data
  end

  def store_as_json (json, filename)
    File.open("data/#{filename}.json", "w") do |f|
      f.write(json)
    end
  end

  def store_as_csv (json, filename)
    CSV.open("data/#{filename}.csv", "w") do |csv|
      csv << json.first.keys
      json.each do |hash|
        csv << hash.values
      end
    end
  end
end
