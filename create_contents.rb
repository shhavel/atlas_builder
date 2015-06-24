#!/usr/bin/env ruby
# encoding: utf-8
categories = [{'sign'=>"global",'name_ru'=>"География Крыма",'name_ua'=>"Географія Криму"}]
maps = [{'category_sign'=>"global",'name_ru'=>"Крым из космоса",'name_ua'=>"Крим з космосу",'file'=>"6",'summary'=>"6",'pictures_list'=>"1"},{'category_sign'=>"global",'name_ru'=>"Административно-территориальное деление",'name_ua'=>"Адміністративно-територіальний поділ",'file'=>"8",'summary'=>"8"},{'category_sign'=>"global",'name_ru'=>"Физическая карта. Черное и Азовское моря",'name_ua'=>"Фізична карта. Чорне та Азовське моря",'file'=>"10",'summary'=>"10",'pictures_list'=>"1"},{'category_sign'=>"global",'name_ru'=>"Древний Крым",'name_ua'=>"Древній Крим",'file'=>"12_1",'summary'=>"12",'pictures_list'=>"1"},{'category_sign'=>"global",'name_ru'=>"Средневековый Крым",'name_ua'=>"Середньовічний Крим",'file'=>"12_2",'summary'=>"12",'pictures_list'=>"1"},{'category_sign'=>"global",'name_ru'=>"Тектоника",'name_ua'=>"Тектоніка",'file'=>"19",'summary'=>"19",'pictures_list'=>"2"},{'category_sign'=>"global",'name_ru'=>"Основные виды минеральных ресурсов. Природные ресурсы подземных вод",'name_ua'=>"Основні види мінеральних ресурсів. Природні ресурси підземних вод",'file'=>"24",'summary'=>"24",'pictures_list'=>"2"},{'category_sign'=>"global",'name_ru'=>"Иностранный туризм",'name_ua'=>"Іноземний туризм",'file'=>"67_1",'summary'=>"67_1",'pictures_list'=>"4"},{'category_sign'=>"global",'name_ru'=>"Природно-заповедные территории",'name_ua'=>"Природно-заповідні території",'file'=>"75_1",'summary'=>"75_1",'pictures_list'=>"5"}]


File.open("contents_ru.txt", 'w') do |f|
  f.write("Всего карт: #{maps.size}\n")
  categories.each do |c|
    f.write("====================\n")
    f.write("= #{c['name_ru']} =\n")
    f.write("====================\n")
    maps.select{|m| m['category_sign'] == c['sign']}.each do |m|
      f.write("#{m['name_ru']}\n")
    end
  end
end


File.open("contents_ua.txt", 'w') do |f|
  f.write("Всього карт: #{maps.size}\n")
  categories.each do |c|
    f.write("====================\n")
    f.write("= #{c['name_ua']} =\n")
    f.write("====================\n")
    maps.select{|m| m['category_sign'] == c['sign']}.each do |m|
      f.write("#{m['name_ua']}\n")
    end
  end
end
