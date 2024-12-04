def split_cake(input)
  # Розбиваємо вхідний текстовий пиріг на масив символів
  cake = input.split("\n").map { |row| row.chars }

  # Знаходимо координати всіх ізюминок у пирозі
  raisins = find_raisins(cake)

  # Перевіряємо, чи кількість ізюму відповідає умові
  if raisins.size <= 1 || raisins.size > 10
    puts "кількість ізюму виходить за межі умови (1-10)"
    return
  end

  # Загальна кількість точок пирога
  total_size = cake.size * cake[0].size
  piece_size = total_size / raisins.size

  # Мітки для відслідковування прив'язаних до шматка точок пирога (двом. масив)
  belongs = Array.new(cake.size) { Array.new(cake[0].size, false) }

  pieces = []

  # Проходимо по кожному ізюму і шукаємо шматок, до якого він належить
  raisins.each do |(x, y)|
    piece = find_piece(x, y, cake, piece_size, belongs)
    if piece
      pieces << piece
    end
  end

  if pieces.size != raisins.size
    puts "неможливо розділити"
    return
  end

  puts "розділені шматки пирога:"
  pieces.each { |piece| print_piece(piece) }
end

def find_raisins(cake)
  # Повертає координати всіх ізюминок у вигляді масиву [x, y]
  raisins = []
  cake.each_with_index do |row, x|
    row.each_with_index do |p, y|
      raisins << [x, y] if p == "o"
    end
  end
  raisins
end

# знаходимо шматок пирога, що містить ізюм з коорд x,y та має заданий розмір, перебираємо всі можливі
# варіанти розмірів та положень шматків пирога, щоб знайти правильний шматок
def find_piece(x, y, cake, piece_size, belongs)
  # Перебираємо всі можливі висоти і ширини шматка(усі можливі варіанти розмірів шматків)
  (1..cake.size).each do |height|
    (1..cake[0].size).each do |width|
      # Пропускаємо, якщо розмір шматка не відповідає потрібному
      next unless width * height == piece_size

      # Перевіряємо всі можливі верхні ліві кути шматка(поч. точки т.к. координати)
      (0..(cake.size - height)).each do |start_x|
        # Пропускаємо, якщо ізюм не входить у висоту шматка
        next unless (start_x...(start_x + height)).include?(x)

        (0..(cake[0].size - width)).each do |start_y|
          # Пропускаємо, якщо ізюм не входить у ширину шматка
          next unless (start_y...(start_y + width)).include?(y)

          # Перевіряємо, чи доступний цей шматок
          if available_piece?(start_x, start_y, width, height, cake, belongs)
            # Позначаємо шматок як зайнятий і повертаємо його
            write_belongs(start_x, start_y, width, height, belongs)
            return get_piece(start_x, start_y, width, height, cake)
          end
        end
      end
    end
  end
  nil
end

def available_piece?(start_x, start_y, width, height, cake, belongs)
  count_raisins = 0

  # Перевіряємо всі клітини у заданому прямокутнику
  (start_x...(start_x + height)).each do |i|
    (start_y...(start_y + width)).each do |j|
      # Якщо клітина вже зайнята, шматок недоступний
      return false if belongs[i][j]

      # Рахуємо кількість ізюмів у шматку
      count_raisins += 1 if cake[i][j] == "o"
    end
  end

  # вважається доступним, якщо тільки один ізюм
  count_raisins == 1
end

def write_belongs(start_x, start_y, width, height, belongs)
  # Позначаємо всі клітини шматка як прив'язані до шматка
  (start_x...(start_x + height)).each do |i|
    (start_y...(start_y + width)).each do |j|
      belongs[i][j] = true
    end
  end
end

def get_piece(start_x, start_y, width, height, cake)
  # отримуємо шматок із пирога (матриці)
  (start_x...(start_x + height)).map do |i|
    cake[i][start_y...(start_y + width)]
  end
end

def print_piece(piece)
  piece.each { |row| puts row.join }
  puts ",\n"
end
