#!/usr/bin/env ruby
require 'pry'


module Splogtash
  module Helpers
    class ConvertHelper
 
      def print(input)
        puts input
      end     

      def get_converted(input)
        lucene = {'/data/syslog/current/web/info.log' => 'web_info_log AND',
                  '/data/syslog/current/web/access.log' => 'web_access_log AND',
                  '=' => ':','source' => 'type', 'uri' => 'request_uri', 
                  'http_response' => 'reponse'}
        
        # initialize variables
        #input = String.new(ARGV[0])
        lucenyze = Array.new
        queries = Array.new
        rtg = String.new
        
        ARGV.each do |query| 
          queries << query
        end
        
        queries.each do |q|
          temp_var = String.new
          temp_var = q.dup
          lucene.each {|f, u| temp_var.gsub!(f, u)}
          case temp_var
          when /!/
               temp_var = temp_var.delete("!").insert(0, "-")
          when /\//
               tempvar = temp_var.gsub!("/","\\\/")
          end
          lucenyze << temp_var
        end
        
        rtg = lucenyze.join(' ')
        
        puts rtg
      end
    end
  end
end

