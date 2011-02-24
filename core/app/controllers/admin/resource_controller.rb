class Admin::ResourceController < Admin::BaseController
  helper_method :new_object_url, :edit_object_url, :object_url, :collection_url
  load_and_authorize_resource
  respond_to :html

  def index  
    respond_with(collection)
  end
  
  def update
    if object.update_attributes(params[object_name])
      flash[:notice] = I18n.t(:successfully_updated, :scope => object_name)
      respond_with(object, :location => collection_url)
    else
      render :edit
    end
  end

  def create
    if object.save
      flash[:notice] = I18n.t(:successfully_created, :scope => object_name)
      respond_with(object, :location => collection_url)
    else
      render :edit
    end
  end
  
  def destroy
    if object.destroy
      flash[:notice] = I18n.t(:successfully_removed, :scope => object_name)
    end
    respond_to do |format|
      format.html { redirect_to collection_url }
      format.js   { render_js_for_destroy }
    end
  end
 
  protected

  def render_js_for_destroy
    render :partial => "/admin/shared/destroy"
    flash.notice = nil
  end
  
  def model_class
    object_name.classify.constantize
  end
  
  def object_name
    controller_name.singularize
  end
  
  def collection
    @collection = model_class.all
    instance_variable_set "@#{controller_name}", @collection  
  end
  
  def object
    @object ||= instance_variable_get "@#{object_name}"
  end

  def new_object_url(*params)
    eval "new_admin_#{object_name}_url(#{params})"
  end
  
  def edit_object_url(object, *params)
    send "edit_admin_#{object_name}_url", object, params
  end
  
  def object_url(object = nil)
    if object
      send "admin_#{object_name}_url", object
    else
      @object
    end
  end
  
  def collection_url
    send "admin_#{controller_name}_url"
  end
end
