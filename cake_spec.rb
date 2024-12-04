require_relative "./script.rb" # підключаємо файл з методом
require 'rspec'

RSpec.describe "split_cake" do
  context "Пиріг можливо розділити" do
    it "Діле пиріг" do
      input = ".oo.....\n........\n....o...\n........\n.....o..\n........"
      puts("пиріг:\n#{input}\n")
      expect { split_cake(input) }.not_to raise_error
    end

    it "Діле пиріг" do
      input = "........\n..o.....\n....o...\n........"
      puts("пиріг:\n#{input}\n")
      expect { split_cake(input) }.not_to raise_error
    end
  end

  context "Періг неможливо розділити" do
    it "не розділяє на рівні частини" do
      input = ".o.o....\n........\n....o..."
      puts("пиріг:\n#{input}\n")
      expect { split_cake(input) }.not_to raise_error
    end

    it "не розділяє, якщо немає ізюму" do
      input = "........\n........\n........"
      puts("пиріг:\n#{input}\n")
      expect { split_cake(input) }.not_to raise_error
    end
  end
end
