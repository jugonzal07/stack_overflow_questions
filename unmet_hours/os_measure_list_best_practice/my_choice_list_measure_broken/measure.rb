# insert your copyright here

# see the URL below for information on how to write OpenStudio measures
# http://nrel.github.io/OpenStudio-user-documentation/reference/measure_writing_guide/

require_relative "./my_choice_constants"

# start the measure
class MyChoiceListMeasure < OpenStudio::Measure::ModelMeasure
  # human readable name
  def name
    # Measure name should be the title case of the class name.
    return 'My Choice List Measure'
  end

  # human readable description
  def description
    return 'Created for https://unmethours.com/question/97597/openstudio-measure-with-long-list-of-inputs-best-practice/'
  end

  # human readable description of modeling approach
  def modeler_description
    return 'Created for https://unmethours.com/question/97597/openstudio-measure-with-long-list-of-inputs-best-practice/'
  end

  # define the arguments that the user will input
  def arguments(model)
    args = OpenStudio::Measure::OSArgumentVector.new

    #--------- Assign enumerations for inputs from constants
    choices_os_vector = OpenStudio::StringVector.new
    option_list = MyConstants::CHOICE_LIST
    option_list.each do |option|
      choices_os_vector << option
    end

   # Populate choices
	choice_input = OpenStudio::Measure::OSArgument::makeChoiceArgument('my_choice_input', choices_os_vector, true)
    choice_input.setDisplayName("My Building Input")
    choice_input.setDefaultValue("Choice 1")
    args << choice_input

    return args

    return args
  end

  # define what happens when the measure is run
  def run(model, runner, user_arguments)
    super(model, runner, user_arguments)  # Do **NOT** remove this line

    # use the built-in error checking
    if !runner.validateUserArguments(arguments(model), user_arguments)
      return false
    end

    # assign the user inputs to variables
    choice_input = runner.getStringArgumentValue('my_choice_input', user_arguments)

    # report final condition of model
    runner.registerFinalCondition("Complete")

    return true
  end
  
end

# register the measure to be used by the application
MyChoiceListMeasure.new.registerWithApplication
