require_dependency 'radiant'

class ApplicationController < ActionController::Base
  include LoginSystem
  
  filter_parameter_logging :password, :password_confirmation
  
  protect_from_forgery :secret => "sweet-harmonious-biscuits"
  
  before_filter :set_current_user
  before_filter :set_javascripts_and_stylesheets
  
  attr_accessor :config
  
  def initialize
    super
    @config = Radiant::Config
  end
  
  # helpers to include additional assets from actions or views
  helper_method :include_stylesheet, :include_javascript
  
  def include_stylesheet(sheet)
    @stylesheets << sheet
  end
  
  def include_javascript(script)
    @javascripts << script
  end
  
  def rescue_action_in_public(exception)
    case exception
      when ActiveRecord::RecordNotFound, ActionController::UnknownController, ActionController::UnknownAction, ActionController::RoutingError
        render :template => "site/not_found", :status => 404
      else
        super
    end
  end
  
  private
  
    def set_current_user
      UserActionObserver.current_user = current_user
    end
  
    def set_javascripts_and_stylesheets
      @stylesheets = %w(admin/main)
      @javascripts = %w(prototype string effects admin/tabcontrol admin/ruledtable admin/admin)
    end
end
