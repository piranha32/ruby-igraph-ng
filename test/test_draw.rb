require 'igraph'
require 'cairo'

def draw_graph(layout,graph, outfile,width,height)
	format = Cairo::FORMAT_ARGB32
	vertices = graph.to_a
	
	surface = Cairo::ImageSurface.new(format, width, height)
	cr = Cairo::Context.new(surface)
	
	# fill background with white
	cr.set_source_rgba(1.0, 1.0, 1.0, 0.8)
	cr.paint
	
	max_x = layout.map{|a| a[0]}.max
	min_x = layout.map{|a| a[0]}.min
	max_y = layout.map{|a| a[1]}.max
	min_y = layout.map{|a| a[1]}.min
	
	x_var = max_x - min_x
	y_var = max_y - min_y
	
	#max_var = [x_var,y_var].max
	
	layout.each_with_index do |a,i|
	  x,y = *a
	
	  #x = (x - min_x)/max_var
	  #y = (y - min_y)/max_var
	  x = (x - min_x)/x_var
	  y = (y - min_y)/y_var
	  x *= (width)
	  y *= (height)
	
	  layout[i] = [x,y]
	
	  #puts "#{x} #{y}"
	
	end
	
	layout.each_with_index do |a,i|
	
	  v = vertices[i]
	  x,y = *a
	
	  cr.set_source_rgba(rand,rand,rand,0.5)
	  cr.circle(x,y,1).fill
	
	  graph.adjacent_vertices(v,IGraph::OUT).each do |w|
	    cr.move_to(x,y)
	    wx,wy = *layout[vertices.index(w)]
	    cr.line_to(wx,wy)
	    cr.stroke
	  end
	
	end
	
	cr.target.write_to_png(outfile)
end

width = 1000
height = 1000

g = IGraph::GenerateRandom.barabasi_game(100,3,false,false)



puts "Running layout_circle"
layout=g.layout_circle
draw_graph(layout.to_a, g, "test_layout_circle.png",width,height)

puts "Running layout_fruchterman_reingold"
layout=g.layout_fruchterman_reingold(10000, 0.01, 100, 0.1, 30, 1234)
draw_graph(layout.to_a, g, "test_layout_fruchterman_reingold.png",width,height)

puts "Running layout_random"
layout=g.layout_random
draw_graph(layout.to_a, g, "test_layout_random.png",width,height)

puts "Running layout_kamada_kawai"
layout=g.layout_kamada_kawai(1000,0.1,1000,0.5,2)
draw_graph(layout.to_a, g, "test_layout_kamada_kawai.png",width,height)

puts "Running layout_reingold_tilford"
layout=g.layout_reingold_tilford(0)
draw_graph(layout.to_a, g, "test_layout_reingold_tilford.png",width,height)

puts "Running layout_reingold_tilford_circular"
layout=g.layout_reingold_tilford_circular(0)
draw_graph(layout.to_a, g, "test_layout_reingold_tilford_circular.png",width,height)

puts "Running layout_grid_fruchterman_reingold"
layout=g.layout_grid_fruchterman_reingold(10000, 0.01, 100, 0.1, 30, 20, false)
draw_graph(layout.to_a, g, "test_layout_grid_fruchterman_reingold.png",width,height)

puts "Running layout_lgl"
layout=g.layout_lgl(10000, 0.01, 100, 0.1, 30, 20, 0)
draw_graph(layout.to_a, g, "test_.png",width,height)

puts "Running layout_random_3d"
layout=g.layout_random_3d
draw_graph(layout.to_a, g, "test_layout_random_3d.png",width,height)

puts "Running layout_sphere"
layout=g.layout_sphere
draw_graph(layout.to_a, g, "test_layout_sphere.png",width,height)

#Could not find params for which FR3D would work properly
#puts "Running layout_fruchterman_reingold_3d"
#layout=g.layout_fruchterman_reingold_3d(10000, 0.01, 100, 0.1, 30)
#require 'pry'
#binding.pry
#draw_graph(layout.to_a, g, "test_layout_fruchterman_reingold_3d.png",width,height)

puts "Running layout_kamada_kawai_3d"
layout=g.layout_kamada_kawai_3d(1000,0.1,1000,0.5,2)
draw_graph(layout.to_a, g, "test_layout_kamada_kawai_3d.png",width,height)


#layout   = g.send(ARGV.shift.to_sym,*ARGV.map{|a| eval(a)}).to_a
#layout_names=%w[layout_circle layout_grid_fruchterman_reingold layout_lgl
#		layout_reingold_tilford layout_fruchterman_reingold
#		layout_kamada_kawai layout_random
#		layout_reingold_tilford_circular layout_fruchterman_reingold_3d
#		layout_kamada_kawai_3d layout_random_3d layout_sphere]
#layout   = g.send(layout_names.shift.to_sym,*layout_names.map{|a| eval(a)}).to_a

#






