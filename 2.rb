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

xml = File.open("/Users/alex/workspace/atlas_builder/Contents.xml").read
@xml_doc = XML::Parser.string(xml).parse

#[{'sign'=>"global",'name_ua'=>"Історія України 11 клас",'name_ru'=>"История Украины 11 класс"}]
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

attr_corrections = { 'text'=>'summary', 'pictures'=>'pictures_list', 'legend'=>'legend', 'questions'=>'questionnaire' }

maps = []
@xml_doc.find('//Contents/ContentsItem/ContentsItem').each do |m|
  map = {
    'category_sign' => "global",
    'name_ua' => m.get('DisplayName'),
    'file' => m.find('MainContentElement').first.attributes['Value']
  }
  m.find('AdditionalContentElements/ContentElement').each do |el|
    k = attr_corrections[el.attributes['Name']]
    map[k] = el.attributes['Value'] if k
  end
  maps << map
end

write_collection(maps, 'maps')
