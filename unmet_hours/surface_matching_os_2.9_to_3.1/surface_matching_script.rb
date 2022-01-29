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

def match_spaces(spaces)

	# Sort spaces for consistency between models
	spaces = sort_spaces(spaces)

	n = spaces.size

	boundingBoxes = []
	(0...n).each do |i|
		boundingBoxes[i] = spaces[i].transformation * spaces[i].boundingBox
	end

	(0...n).each do |i|
		(i+1...n).each do |j|
			next unless boundingBoxes[i].intersects(boundingBoxes[j])
			puts "#{spaces[i].name.to_s} intersects #{spaces[j].name.to_s}"
			spaces[i].intersectSurfaces(spaces[j])
			spaces[i].matchSurfaces(spaces[j])
		end #j
	end #i
end


file_name = 'before_matching_3.1.osm'

model = osload(file_name)

match_spaces(model.getSpaces)

# spaces = OpenStudio::Model::SpaceVector.new
# model.getSpaces.each do |space|
# 	spaces << space
# end

#OpenStudio::Model.intersectSurfaces(spaces)
#OpenStudio::Model.matchSurfaces(spaces)

