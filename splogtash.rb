#!/usr/bin/env ruby
require 'rubygems'
require 'sinatra/base'
require 'uri'
require 'json'

class SplogtashWeb < Sinatra::Base
  helpers do
      def h(text)
          Rack::Utils.escape_html(text)
      end
      def get_converted(input)
        # load lucene map
        lucene_file = File.read('./helpers/lucene.json')
        lucene_hash = JSON.parse(lucene_file)
        lucene = lucene_hash["lucene"]
        pre_lucene = lucene_hash["pre_lucene"]

        # initialize variables
        lucenyze = Array.new
        queries = Array.new
        rtg = String.new
        inputs = String.new

        # pre-tokenizing processing
        inputs << input
          temp_var = String.new
          temp_var = inputs
          pre_lucene.each {|f, u| temp_var.gsub!(f, u)}

        # post processing
        inputs.split.each do |query|
          queries << query
        end
        queries.each do |q|
          temp_var = String.new
          temp_var = q.dup
          lucene.each {|f, u| temp_var.gsub!(f, u)}
          case temp_var
          when /AND/
               temp_var = temp_var.delete('"')
          when /!/
               temp_var = temp_var.delete("!").insert(0, "-")
          when /\//
               temp_var = temp_var.gsub!("/","\\\/")
          end
          lucenyze << temp_var
        end
        rtg << lucenyze.join(' ')
        return rtg
      end
  end
  get '/' do
    @title = "splogtash"
    erb :index
  end

  post '/search' do
    @title = "splogtash"
    @query = params[:query]
    @input = get_converted(@query)
    @escaped_input = @input.dup.gsub!('"','\"')
    erb :search
  end

end
