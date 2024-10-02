# frozen_string_literal: true

def find_raisins(cake)
  raisins = []
  cake.each_with_index do |row, y|
    row.chars.each_with_index do |cell, x|
      raisins << [x, y] if cell == 'o'
    end
  end
  raisins
end

def one_raisin?(slice)
  raisins = slice.flat_map.with_index { |row, y| row.chars.map.with_index { |cell, x| [x, y] if cell == 'o' }.compact }
  raisins.size == 1
end

def slice(cake, raisins)
  rows, cols = cake.size, cake[0].size
  slices = []

  (1...rows).each do |i|
    upper_slice = cake[0...i]
    lower_slice = cake[i...rows]
    slices << [upper_slice, lower_slice] if one_raisin?(upper_slice) && one_raisin?(lower_slice)
  end

  (1...cols).each do |j|
    left_slice = cake.map { |row| row[0...j] }
    right_slice = cake.map { |row| row[j...cols] }
    slices << [left_slice, right_slice] if one_raisin?(left_slice) && one_raisin?(right_slice)
  end

  slices
end

def find_best(cake)
  raisins = find_raisins(cake)
  best_slices = nil

  slice(cake, raisins).each do |slices|
    if best_slices.nil? || slices.first[0].size > best_slices.first[0].size
      best_slices = slices
    end
  end

  best_slices
end

cake = %w[
  ........
  ..o.....
  ...o....
  ........
]

result = find_best(cake)
if result
  result.each_with_index do |slice, i|
    puts "Шматок #{i + 1}:"
    slice.each { |row| puts row }
    puts "----------"
  end
else
  puts "Помилка, неможливо знайти"
end
