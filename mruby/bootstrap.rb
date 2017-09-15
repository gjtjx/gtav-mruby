
module GTAV

  class BoxedObject < Array
    def initialize(*args)
      __load(args)
    end
    def inspect
      "#{self.class.to_s.gsub("GTAV::","")}(#{self.map{|i| i.inspect}.join(", ")})"
    end
    def to_s
      inspect
    end
  end

  class Vector3 < BoxedObject
    def __load(*value)
      self.replace(value)
    end
    def x; self[0]; end
    def y; self[1]; end
    def z; self[2]; end
    def x=(v); self[0] = v; end
    def y=(v); self[1] = v; end
    def z=(v); self[2] = v; end
  end

  class BoxedObjectInt < BoxedObject
    def __load(value)
      self.replace([value])
    end
    def to_i; self[0]; end
  end

  class Entity < BoxedObjectInt; end
  class Player < BoxedObjectInt; end
  class Ped < BoxedObjectInt; end
  class Vehicle < BoxedObjectInt; end
  class Object < BoxedObjectInt; end
  class Pickup < BoxedObjectInt; end
  class Blip < BoxedObjectInt; end
  class Any < BoxedObjectInt; end

  class Hash < BoxedObjectInt; end
  class ScrHandle < BoxedObjectInt; end
  class Cam < BoxedObjectInt; end

  class Script
    def initialize(*); end
    def tick; end
  end

  # gets called every engine tick by script.cpp
  def self.tick(*args)
    puts "Bootstrapped GTAV.tick, ensure a runtime is loaded"
  end

  def self.on_error(exception)
    puts "#{exception.class} - #{exception.message}"
    puts "#{exception.backtrace.inspect}"
    exception.backtrace.each do |bt|
      puts bt
    end
  end

  @@filenames = {}
  def self.load_script(filename)
    puts "GTAV.load_script(#{filename.inspect})"
    @@filenames[filename] = true
    begin
      GTAV.load(filename)
    rescue => ex
      on_error(ex)
    end
  end

end

class CallLimitExceeded < StandardError; end

CONFIG = {}
GTAV.load_script("./mruby/config.rb")

GTAV.load_script("./mruby/runtime.rb")
