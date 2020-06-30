require 'openstudio'

# Helper to load a model in one line
def osload(path)
	translator = OpenStudio::OSVersion::VersionTranslator.new
	ospath = OpenStudio::Path.new(path)
	model = translator.loadModel(ospath)
	if model.empty?
		raise "Path '#{path}' is not a valid path to an OpenStudio Model"
	else
		model = model.get
	end
	return model
end

def match_blocks(model)
	spaces = model.getSpaces
	outside_spaces = []
	spaces.each do |space|
		space.surfaces.each do |surface|
			if (surface.outsideBoundaryCondition == "Outdoors" ||
					surface.outsideBoundaryCondition == "Ground")
				outside_spaces << space
				break
			end
		end
	end

	n = outside_spaces.size

	boundingBoxes = []
	(0...n).each do |i|
		boundingBoxes[i] = outside_spaces[i].transformation * outside_spaces[i].boundingBox
	end

	(0...n).each do |i|
		(i+1...n).each do |j|
			next if not boundingBoxes[i].intersects(boundingBoxes[j])
			outside_spaces[i].intersectSurfaces(outside_spaces[j])
			outside_spaces[i].matchSurfaces(outside_spaces[j])
		end #j
	end #i
end


#----- Main testing starts here

osm_path = 'C:/git/stack_overflow_questions/unmet_hours/surface_matching/before_matching.osm'

model = osload(osm_path)

# Match and intersect surfaces
match_blocks(model)

File.open("after_matching.osm", 'w') {|f| f.write(model)}
