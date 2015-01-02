class ExceptionController < ApplicationController
  respond_to :html, :xml, :json
  before_action :status
  layout :layout_status

  def show
    @details = details
    puts 'blah blahblah '+@details.inspect
    puts 'blah blahblah '+@status.inspect
    puts 'blah blahblah '+layout_status.inspect
    respond_with status: @status
  end

  protected
  def status
    @exception  = env['action_dispatch.exception']
    @status     = ActionDispatch::ExceptionWrapper.new(env, @exception).status_code
    @response   = ActionDispatch::ExceptionWrapper.rescue_responses[@exception.class.name]
  end

  def details
    @details ||= {}.tap do |h|
      I18n.with_options scope: [:exception, :show, @response], exception_name: @exception.class.name, exception_message: @exception.message do |i18n|
        h[:name]    = i18n.t "#{@exception.class.name.underscore}.title", default: i18n.t(:title, default: @exception.class.name)
        h[:message] = i18n.t "#{@exception.class.name.underscore}.description", default: i18n.t(:description, default: @exception.message)
      end
    end
  end
  helper_method :details

  private
  def layout_status
    @status.to_s == "404" ? "application" : "error"
  end

end