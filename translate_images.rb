#!/usr/bin/env ruby
# encoding: utf-8
#require 'google_translate_scraper'
require_relative "google_translate_scraper/lib/google_translate_scraper"
require 'xml' # libxml-ruby

class Interpreter
  class << self
    def translate_text(text, from, to='en')
      response = GoogleTranslateScraper.translate(source_language: from, target_language: to, search_text: text)
      response.translations.first.translated_text #rescue nil
    end
  end
end

from = 'ru'
to = 'en'

from_dir = from == 'uk' ? 'ua' : from

to_dir = "/Users/alex/workspace/atlas/app/Map/pictures_list/#{to}"
Dir.mkdir(to_dir) unless Dir.exist?(to_dir)

Dir["/Users/alex/workspace/atlas/app/Map/pictures_list/#{from_dir}/*.xml"].each do |f|
  ok = true
  xml = File.open(f, "r:UTF-8"){|f| f.read }

  xml_doc = XML::Parser.string(xml).parse

  if (title = xml_doc.find('//List').first.attributes['Title'])
    title_to = Interpreter.translate_text(title, from, to)
    ok = false unless title_to
    xml_doc.find('//List').first.attributes['Title'] = title_to
  end

  xml_doc.find('//List/Item').each do |item|
    caption_to = Interpreter.translate_text(item.attributes['Caption'], from, to)
    ok = false unless caption_to
    item.attributes['Caption'] = caption_to
  end

  if ok
    #f_ua = f.split('/').insert(-2, 'ua').join('/')
    f_to = f.sub("/#{from_dir}/", "/#{to}/")
    File.open(f_to, 'w:UTF-8') { |f| f.write(xml_doc.to_s) }
  else
    puts f
  end
end
