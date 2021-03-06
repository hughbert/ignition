#######################################################################
# The Project model class represents an example primary resource for the
# service. This model could be substituted with any primary resource
# that makes sense for your service. A primary resource is related to
# other resources in your system, to a user that created it, and to
# a group that can access it.
#
# The concept of a primary resource allows you to grant group access to
# the primary resource and any of its related resources.
#######################################################################
class Project
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paperclip

  # Scope definitions for organizational based queries
  include Organizational

  # Add call to strip leading and trailing white spaces from all attributes
  strip_attributes  # See strip_attributes for more information

  ## ATTRIBUTES -------------------------------------------------------

  field :name, type: String
  field :description, type: String

  ## VALIDATIONS ------------------------------------------------------

  validates_presence_of :name
  validates_presence_of :description
  validates_presence_of :user_id

  ## RELATIONSHIPS ----------------------------------------------------

  belongs_to :user
  belongs_to :organization
  has_mongoid_attached_file :charter_doc
  do_not_validate_attachment_file_type :charter_doc

  ## DELEGATIONS ------------------------------------------------------

  delegate :first_name, :last_name, to: :user, prefix: true
  delegate :name, to: :organization, prefix: true

  ## PUBLIC METHODS ---------------------------------------------------

  #####################################################################
  # Create a new project and relate the user record to it.
  #####################################################################
  def self.create_with_user(project_params, user)
     project = Project.new(project_params)
     project.user = user
     project
  end

end
