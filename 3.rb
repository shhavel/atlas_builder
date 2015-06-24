#!/usr/bin/env ruby
# encoding: utf-8
require 'xml'
require 'date'
require 'google_translate_scraper'
class LibXML::XML::Node
  def get(f)
    find(f).first.content if find(f).first
  end
end

class Interpreter
  class << self
    def translate_text(text, from='ru', to='uk')
      response = GoogleTranslateScraper.translate(source_language: from, target_language: to, search_text: text)
      response.translations.first.translated_text #rescue nil
    end
  end
end


def write_collection(collection, collection_name)
  File.open("#{collection_name}.rb", 'w') do |f|
    f.write("#{collection_name} = [\n")
    collection.each do |c|
      f.write("  {\n")
      c.each do |k, v|
        f.write("    '#{k}'=>\"#{v.gsub('"', '\\"')}\",\n")
        if k == 'name_ua'
          v_tr = Interpreter.translate_text(v, 'uk', 'ru')
          f.write("    'name_ru'=>\"#{v_tr.gsub('"', '\\"')}\",\n")
        end
      end 
      f.write("  },\n")
    end
    f.write("]\n")
  end
end

maps = [{'category_sign'=>"global",'name_ua'=>"ДЕРЖАВНІ СИМВОЛИ УКРАЇНИ",'file'=>"01",'summary'=>"01",'pictures_list'=>"01",'questionnaire'=>"01"},{'category_sign'=>"global",'name_ua'=>"КУЛЬТУРНА СПАДЩИНА НАРОДУ",'file'=>"02_03",'summary'=>"02",'pictures_list'=>"02",'questionnaire'=>"01"},{'category_sign'=>"global",'name_ua'=>"ЗОРЯНЕ НЕБО ПІВНІЧНОЇ ПІВКУЛІ. СОНЯЧНА СИСТЕМА",'file'=>"04_05",'summary'=>"0304",'pictures_list'=>"03",'questionnaire'=>"01"},{'category_sign'=>"global",'name_ua'=>"ЗЕМЛЯ – ПЛАНЕТА СОНЯЧНОЇ СИСТЕМИ. ГЛОБУС – МОДЕЛЬ ЗЕМЛІ. РІЧНИЙ РУХ ЗЕМЛІ. ДОБОВИЙ РУХ ЗЕМЛІ",'file'=>"06",'questionnaire'=>"01"},{'category_sign'=>"global",'name_ua'=>"ГОРИЗОНТ. ПОЛОЖЕННЯ СОНЦЯ НА НЕБОСХИЛІ В РІЗНІ ПОРИ РОКУ",'file'=>"07",'questionnaire'=>"01"},{'category_sign'=>"global",'name_ua'=>"ПОНЯТТЯ СТОРІН ГОРИЗОНТУ. ОРІЄНТУВАННЯ НА МІСЦЕВОСТІ",'file'=>"08",'questionnaire'=>"01"},{'category_sign'=>"global",'name_ua'=>"ПОНЯТТЯ ПРО ПЛАН. ПОНЯТТЯ ПРО МАСШТАБ",'file'=>"09",'questionnaire'=>"01"},{'category_sign'=>"global",'name_ua'=>"ФІЗИЧНА КАРТА ПІВКУЛЬ",'file'=>"10_11",'questionnaire'=>"01"},{'category_sign'=>"global",'name_ua'=>"ПРИРОДНІ ЗОНИ І ТВАРИННИЙ СВІТ ЗЕМЛІ",'file'=>"12_13",'pictures_list'=>"07",'questionnaire'=>"01"},{'category_sign'=>"global",'name_ua'=>"ФІЗИЧНА КАРТА УКРАЇНИ. ФОРМИ ЗЕМНОЇ ПОВЕРХНІ",'file'=>"14_15",'summary'=>"05",'pictures_list'=>"05",'questionnaire'=>"01"},{'category_sign'=>"global",'name_ua'=>"ПРИРОДНІ ЗОНИ УКРАЇНИ. РОСЛИННИЙ І ТВАРИННИЙ СВІТ",'file'=>"16_17",'summary'=>"06",'pictures_list'=>"06",'questionnaire'=>"01"},{'category_sign'=>"global",'name_ua'=>"НАСЕЛЕННЯ УКРАЇНИ. ЗЕМЛІ Й ОБЛАСТІ",'file'=>"18_19",'questionnaire'=>"01"},{'category_sign'=>"global",'name_ua'=>"ГОСПОДАРСТВО УКРАЇНИ",'file'=>"20",'questionnaire'=>"01"}]
write_collection(maps, 'maps')
