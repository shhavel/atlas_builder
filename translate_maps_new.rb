#!/usr/bin/env ruby
# encoding: utf-8
#require 'google_translate_scraper'
require_relative "google_translate_scraper/lib/google_translate_scraper"
require 'nokogiri'

class Interpreter
  class << self
    def translate_html(html, from, to='en')
      paragraphs = Nokogiri::HTML(html).css('p').map(&:text)
      translated_paragraphs = paragraphs.map{|p| translate_text(p, from, to) }
      return nil if translated_paragraphs.size != paragraphs.size
      '<p>' + translated_paragraphs.join("</p>\n<p>") + '</p>'
    end

    def translate_text(text, from, to='en')
      response = GoogleTranslateScraper.translate(source_language: from, target_language: to, search_text: text)
      response.translations.first.translated_text rescue nil
    end
  end
end

def write_collection(collection, collection_name, f)
  f.write("      ") if collection_name == 'maps'
  f.write("[")
  collection.each_with_index do |c, i|
    f.write("{")
    c.each_with_index do |(k, v), index|
      next if k == 'name_en'
      f.write(",") unless index == 0
      f.write("'#{k}'=>\"#{v.gsub('"', '\\"')}\"")
      if k == 'name_ua'
        f.write(",'name_en'=>\"#{c['name_en'].gsub('"', '\\"')}\"") if c['name_en']
      end
    end 
    f.write("}")
    f.write(",") unless i == collection.count - 1
  end
  if collection_name == 'categories'
    f.write("].each{|category| Category.create(category) }\n")
  elsif collection_name == 'maps'
    f.write("].each{|map| Map.create(map) }\n")
  end
end

from = 'uk'

from_name = "name_#{from == 'uk' ? 'ua' : from}"

####    .each{|category| Category.create(category) }

categories = [{'sign'=>"french_revolution",'name_ua'=>"Французька революція кінця XVIII ст.",'name_ru'=>"Французская революция конца XVIII в."},{'sign'=>"napoleon",'name_ua'=>"Правління Наполеона Бонапарта. Перша імперія у Франції",'name_ru'=>"Правление Наполеона Бонапарта. Первая империя во Франции"},{'sign'=>"countries_of_europe",'name_ua'=>"Країни Європи у 1815–1847 рр.",'name_ru'=>"Страны Европы в 1815-1847 гг"},{'sign'=>"revolution_in_europe",'name_ua'=>"Революції 1848–1849 рр. у Європі",'name_ru'=>"Революции 1848-1849 гг в Европе"},{'sign'=>"italy_and_germany",'name_ua'=>"Утворення національних держав в Італії та Німеччині. Центральна Європа в 1860–1870-ті роки",'name_ru'=>"Образование национальных государств в Италии и Германии. Центральная Европа в 1860-1870-е годы"},{'sign'=>"international_relations_19",'name_ua'=>"Міжнародні відносини у 1840–1860-их роках",'name_ru'=>"Международные отношения в 1840-1860-х годах"},{'sign'=>"usa",'name_ua'=>"США у першій половині XIX ст. Громадянська війна (1861–1865 рр.)",'name_ru'=>"США в первой половине XIX в. Гражданская война (1861-1865 гг)"},{'sign'=>"russian_empire_19",'name_ua'=>"Російська імперія в XIX ст.",'name_ru'=>"Российская империя в XIX в."},{'sign'=>"international_relations_20",'name_ua'=>"Міжнародні відносини наприкінці XIX ст. – на початку XX ст.",'name_ru'=>"Международные отношения в конце XIX в. - В начале XX ст."},{'sign'=>"america",'name_ua'=>"Країни Америки наприкінці XIX – на початку XX ст.",'name_ru'=>"Страны Америки в конце XIX - начале XX в."},{'sign'=>"russian_empire_20",'name_ua'=>"Російська імперія наприкінці XIX – на початку XX ст.",'name_ru'=>"Российская империя в конце XIX - начале XX в."},{'sign'=>"asia",'name_ua'=>"Країни Азії наприкінці XIX ст. – на початку XX ст.",'name_ru'=>"Страны Азии в конце XIX в. - В начале XX ст."}]
maps = [{'category_sign'=>"french_revolution",'name_ua'=>"Французька революція кінця XVIII ст. Війни Франції у період директорії та консульства",'name_ru'=>"Французская революция конца XVIII в. Войны Франции в период директории и консульства",'file'=>"1",'summary'=>"1",'legend'=>"Main",'pictures_list'=>"1",'questionnaire'=>"1"},{'category_sign'=>"napoleon",'name_ua'=>"Війни наполеонівської Франції",'name_ru'=>"Войны наполеоновской Франции",'file'=>"2",'summary'=>"2",'legend'=>"Main",'pictures_list'=>"2",'questionnaire'=>"2"},{'category_sign'=>"countries_of_europe",'name_ua'=>"Країни Європи у 1815–1847 роках",'name_ru'=>"Страны Европы в 1815-1847 годах",'file'=>"3",'summary'=>"3",'legend'=>"Main",'pictures_list'=>"3",'questionnaire'=>"3"},{'category_sign'=>"revolution_in_europe",'name_ua'=>"Революції 1848–1849 років у Європі",'name_ru'=>"Революции 1848-1849 годов в Европе",'file'=>"4",'summary'=>"4",'legend'=>"Main",'pictures_list'=>"4",'questionnaire'=>"4"},{'category_sign'=>"italy_and_germany",'name_ua'=>"Утворення національних держав в Італії та Німеччині. Центральна Європа в 1860–1870-ті роки",'name_ru'=>"Образование национальных государств в Италии и Германии. Центральная Европа в 1860-1870-е годы",'file'=>"5",'summary'=>"5",'legend'=>"Main",'pictures_list'=>"5",'questionnaire'=>"5"},{'category_sign'=>"international_relations_19",'name_ua'=>"Світ у 1840–1860-их роках. Утворення незалежних держав у Латинській Америці",'name_ru'=>"Мир в 1840-1860-х годах. Образование независимых государств в Латинской Америке",'file'=>"6-7",'summary'=>"6",'legend'=>"Main",'pictures_list'=>"6",'questionnaire'=>"6"},{'category_sign'=>"usa",'name_ua'=>"Громадянська війна у США (1861–1865 рр.). Зростання території США",'name_ru'=>"Гражданская война в США (1861-1865 гг.) Рост территории США",'file'=>"8",'summary'=>"7",'legend'=>"Main",'pictures_list'=>"7",'questionnaire'=>"7"},{'category_sign'=>"russian_empire_19",'name_ua'=>"Російська імперія у XIX ст. Російська експансія на Кавказі",'name_ru'=>"Российская империя в XIX в. Российская экспансия на Кавказе",'file'=>"9",'summary'=>"8",'legend'=>"Main",'pictures_list'=>"8",'questionnaire'=>"8"},{'category_sign'=>"international_relations_20",'name_ua'=>"Країни Європи у другій половині XIX – на початку XX ст.",'name_ru'=>"Страны Европы во второй половине XIX - начале XX в.",'file'=>"10",'summary'=>"9",'legend'=>"Main",'pictures_list'=>"9",'questionnaire'=>"9"},{'category_sign'=>"international_relations_20",'name_ua'=>"Світ у 1879–1914 роках. Англо-Бурська війна 1899–1902 рр.",'name_ru'=>"Мир в 1879-1914 годах. Англо-бурской войны 1899-1902 гг",'file'=>"14-15",'summary'=>"9",'legend'=>"Main",'pictures_list'=>"9",'questionnaire'=>"9"},{'category_sign'=>"america",'name_ua'=>"Країни Латинської Америки наприкінці XIX – на початку XX ст.",'name_ru'=>"Страны Латинской Америки в конце XIX - начале XX в.",'file'=>"11",'summary'=>"10",'legend'=>"Main",'pictures_list'=>"10",'questionnaire'=>"10"},{'category_sign'=>"russian_empire_20",'name_ua'=>"Російська імперія на початку XX ст. Азійська частина Росії",'name_ru'=>"Российская империя в начале XX в. Азиатская часть России",'file'=>"16",'summary'=>"11",'legend'=>"Main",'pictures_list'=>"11",'questionnaire'=>"11"},{'category_sign'=>"asia",'name_ua'=>"Країни Південної та Східної Азії наприкінці XIX – на початку XX ст.",'name_ru'=>"Страны Южной и Восточной Азии в конце XIX - начале XX в.",'file'=>"12",'summary'=>"12",'legend'=>"Main",'pictures_list'=>"12",'questionnaire'=>"12"},{'category_sign'=>"asia",'name_ua'=>"Країни Близького і Середнього Сходу наприкінці XIX – на початку XX ст. Балканські війни 1912–1913 років",'name_ru'=>"Страны Ближнего и Среднего Востока в конце XIX - начале XX в. Балканские войны 1912-1913 годов",'file'=>"13",'summary'=>"12",'legend'=>"Main",'pictures_list'=>"12",'questionnaire'=>"12"}]


File.open("CATEGORIES_AND_MAPS.rb", 'w') do |f|
  categories.each{|c| c['name_en'] = Interpreter.translate_text(c[from_name], from); puts c[from_name]; puts c['name_en']; }
  write_collection(categories, 'categories', f)

  maps.each{|m| m['name_en'] = Interpreter.translate_text(m[from_name], from); puts m[from_name]; puts m['name_en']; }
  write_collection(maps, 'maps', f)
end

####  Translate to en texts, images, surveys, categories & maps



