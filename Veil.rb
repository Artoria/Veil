module Veil
  
  Middles = {}
  
  def self.register(name, terminal, a, b)
    
    q = lambda{|a|
      middles = Middles[name] || []
      args = a
      middles.each{|x|
         args = x.call(args)
      }
      args
    }
    a.send :def_chain, b do |old, *args|
      terminal.call old, q, args
    end
  end
  
  def self.use(name, obj)
    Middles[name] ||= []
    Middles[name].push obj
    obj
  end
end

=begin

class DrawText
  def call(old_draw_text, app, a)
    u = case a.length
         when 2 then  [ [a[0], a[1], 0]    ]
         when 3 then  [ [a[0], a[1], a[2] ] ]
         when 5 then  [ [Rect.new(*a[0..3]), a[4], 0] ]
         when 6 then  [ [Rect.new(*a[0..3]), a[4], a[5] ] ]
         end
         
    m = app.call(u)
    m.each{|x|
      old_draw_text.call(*x)
    }
  end
end


class ReverseDraw
  def call(a)
    a.map{|u|
      [u[0], u[1].reverse, u[2]] 
    }
  end
end

Veil.register :drawtext, DrawText.new, Bitmap, :draw_text
Veil.use :drawtext, ReverseDraw.new

x = Sprite.new
x.bitmap = Bitmap.new(100, 100)
x.bitmap.draw_text(x.bitmap.rect, "Hello", 1)
[Graphics, Input, x].each(&:update) until false


=end
