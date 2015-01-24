require './splogtash.rb'

use Rack::ShowExceptions

run SplogtashWeb.new
