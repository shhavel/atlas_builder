#!/usr/bin/env ruby
# encoding: utf-8
#require 'google_translate_scraper'
require_relative "google_translate_scraper/lib/google_translate_scraper"
require 'nokogiri'
require 'ostruct'
class String
  def blank?
    self =~ /\A\s+\Z/m
  end
end

class Interpreter
  class << self
    def translate_html(html, from, to='en')
      #paragraphs = Nokogiri::HTML(html).css('p').map(&:text)
      #translated_paragraphs = paragraphs.map{|p| translate_text(p, from, to) }
      #return nil if translated_paragraphs.size != paragraphs.size
      #'<p>' + translated_paragraphs.join("</p>\n<p>") + '</p>'

      paragraphs = html.split("\n").reject{|p| p.blank? }.map do |p|
        p.strip!
        p =~ /((?:<[^\/<>]+>)*)[^<>]*((?:<\/[^<>]+>)*)/
        open_tag = $1
        close_tag = $2
        OpenStruct.new(text: p.gsub(/<[^<>]+>/, ''), open_tag: open_tag, close_tag: close_tag) 
      end
      translated_paragraphs = paragraphs.map do |p|
        OpenStruct.new(text: (p.text.blank? ? '' : translate_text(p.text, from, to)), open_tag: p.open_tag, close_tag: p.close_tag) 
      end
      return nil if translated_paragraphs.size != paragraphs.size
      translated_paragraphs.map do |p|
        p.open_tag + p.text + p.close_tag
      end.join("\n") + "\n"
    end

    def translate_text(text, from, to='en')
      response = GoogleTranslateScraper.translate(source_language: from, target_language: to, search_text: text)
      response.translations.first.translated_text #rescue nil
    end
  end
end

from = 'uk'
to = 'en'

from_dir = from == 'uk' ? 'ua' : from

to_dir = "/Users/alex/workspace/atlas/app/Map/summary/#{to}"
Dir.mkdir(to_dir) unless Dir.exist?(to_dir)

Dir["/Users/alex/workspace/atlas/app/Map/summary/#{from_dir}/*.htm"].each do |f|
  #html = File.read(f)
  html = File.open(f, "r:UTF-8"){|f| f.read }
  html.gsub!('&ndash;', '–') #  long – normal -
  html.gsub!('&rsquo;', "'")
  html.gsub!('&lsquo;', "'")
  html.gsub!('км&sup2;', 'кв. км')
  html.gsub!('км &sup2;', 'кв. км')
  html.gsub!('&deg;', '°')
  html.gsub!('&frac34;', '3/4') # ¾
  html.gsub!('&frac14;', '1⁄4') # ¼

  if html_to = Interpreter.translate_html(html, from, to)
    #f_ua = f.split('/').insert(-2, 'ua').join('/')
    f_to = f.sub("/#{from_dir}/", "/#{to}/")
    File.open(f_to, 'w:UTF-8') { |f| f.write(html_to) }
  else
    puts f
  end
end

####    Translate to en texts, images, surveys, maps



