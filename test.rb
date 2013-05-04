h1 = {:stuff => [1,2,3]}
h2 = h1.dup
h2[:stuff].delete_at(0)

puts h1 #=> {:stuff=>[2, 3]}
puts h2 #=> {:stuff=>[2, 3]}
