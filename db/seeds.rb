require "csv"
products_file = Rails.root.join("db", "data", "products.csv")

CSV.foreach(products_file, headers: true, header_converters: :symbol, converters: :all) do |row|
  data = Hash[row.headers.zip(row.fields)]
  puts data
  Product.create(data)
end

categorizations_file = Rails.root.join("db", "data", "categorizations.csv")

CSV.foreach(categorizations_file, headers: true, header_converters: :symbol, converters: :all) do |row|
  data = Hash[row.headers.zip(row.fields)]
  puts data
  Categorization.create(data)
end

product_categorizations_file = Rails.root.join("db", "data", "product_categorizations.csv")

CSV.foreach(product_categorizations_file, headers: true, header_converters: :symbol, converters: :all) do |row|
  data = Hash[row.headers.zip(row.fields)]
  puts data
  product = Product.find_by(name: data[:product_name])
  categorization = Categorization.find_by(name: data[:categorization_name])
  if !product.nil? && !categorization.nil? && categorization.products.where(name: data[:product_name]).empty?
    product.categorizations << categorization
    product.save
  end
end
