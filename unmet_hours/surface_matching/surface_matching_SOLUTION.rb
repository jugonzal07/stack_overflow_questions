require 'openstudio'

# Class created for the sole purpose of making spaces comparable.
# Sorting is dependent on space bounding box boundaries
class SpaceSort

	attr_accessor :space, :min_x, :max_x, :min_y, :max_y, :min_z, :max_z

	def initialize(os_space)

		bounding_box = os_space.boundingBox
		@space = os_space
		@min_x = bounding_box.minX.to_f
		@max_x = bounding_box.maxX.to_f
		@min_y = bounding_box.minY.to_f
		@max_y = bounding_box.maxY.to_f
		@min_z = bounding_box.minZ.to_f
		@max_z = bounding_box.maxZ.to_f
		
	end

	# Sorting for SpaceSort objects follows this hierarchy (from lowest to highest)
	# -min_x, max_x, min_y, max_y, min_z, max_z
	# NOTE: -1 = less than
	#        1 = greater than
	#        0 = equal to
	def <=>(other_space_sort)

		if @min_x < other_space_sort.min_x
			return -1
		elsif @min_x > other_space_sort.min_x
			return 1
		elsif @max_x < other_space_sort.max_x
			return -1
		elsif @max_x > other_space_sort.max_x
			return 1
		elsif @min_y < other_space_sort.min_y
			return -1
		elsif @min_y > other_space_sort.min_y
			return 1
		elsif @max_y < other_space_sort.max_y
			return -1
		elsif @max_y > other_space_sort.max_y
			return 1
		elsif @min_z < other_space_sort.min_z
			return -1
		elsif @min_z > other_space_sort.min_z
			return 1
		elsif @max_z < other_space_sort.max_z
			return -1
		elsif @max_z > other_space_sort.max_z
			return 1
		else
			return 0 #bounding boxes are identical
		end
	end
end


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

	# sort outside spaces
	outside_spaces = sort_spaces(outside_spaces)

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

def sort_spaces(spaces)

	# Array of SpaceSort objects, used to sort spaces by their bounding boxes
	space_sort_list = []

	# Construct SurfaceSort objects for sorting surfaces
	spaces.each do |space|
		space_sort_list << SpaceSort.new(space)
	end

	# sort SurfaceSort objects by their bounding box boundaries
	sorted_list = space_sort_list.sort()

	sorted_spaces = []

	# Extract spaces from sorted SurfaceSort objects
	sorted_list.each do |space_sort|
		sorted_spaces << space_sort.space
	end

	return(sorted_spaces)
end




#----- Main testing starts here

osm_path = 'C:/git/stack_overflow_questions/unmet_hours/surface_matching/before_matching.osm'

model = osload(osm_path)

# Match and intersect surfaces
match_blocks(model)

File.open("after_matching_sorted.osm", 'w') {|f| f.write(model)}
