class Admin::ResourceController < Admin::BaseController
  helper_method :new_object_url, :edit_object_url, :object_url, :collection_url
  load_and_authorize_resource
  respond_to :html
  
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

  def new_object_url(options = {})
    new_polymorphic_url([:admin, model_class], options)
  end
  
  def edit_object_url(object, options = {})
    edit_polymorphic_url([:admin, object], options)
  end
  
  def object_url(object = nil, options = {})
    if object
      polymorphic_url([:admin, object], options)
    else
      [:admin, @object]
    end
  end
  
  def collection_url(options = {})
    polymorphic_url([:admin, model_class], options)
  end
end
