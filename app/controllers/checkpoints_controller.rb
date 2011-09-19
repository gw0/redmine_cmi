class CheckpointsController < ApplicationController
  unloadable

  menu_item :metrics
  before_filter :find_project_by_project_id, :authorize
  before_filter :get_roles, :only => [:new, :edit, :show]
  before_filter :find_checkpoint, :only => [:show, :edit, :update, :destroy]

  helper :cmi

  def index
    @limit = per_page_option
    @count = CmiCheckpoint.count
    @pages = Paginator.new self, @count, @limit, params['page']
    @offset ||= @pages.current.offset
    @sort = sort_column
    @order = sort_direction
    @checkpoints = CmiCheckpoint.all(:conditions => ['project_id = ?', @project],
                                     :order => [@sort, @order].join(' '),
                                     :offset => @offset,
                                     :limit => @limit)
  end

  def new
    @checkpoint = CmiCheckpoint.new
  end

  def create
    @checkpoint = CmiCheckpoint.new params[:checkpoint]
    @checkpoint.project = @project
    @checkpoint.author = User.current
    if @checkpoint.save
      flash[:notice] = l(:notice_successful_update)
      redirect_to :action => :index
    else
      get_roles
      render :action => 'new'
    end
  end

  def show
    @journals = @checkpoint.journals.find(:all, :include => [:user, :details], :order => "#{Journal.table_name}.created_on ASC")
    @journals.each_with_index {|j,i| j.indice = i+1}
    @journals.reverse! if User.current.wants_comments_in_reverse_order?
  end

  def edit
    @journal = @checkpoint.current_journal
  end

  def update
    @checkpoint.init_journal(User.current, params[:notes])
    @checkpoint.attributes = params[:checkpoint]
    if @checkpoint.save
      flash[:notice] = l(:notice_successful_update)
      redirect_back_or_default({:action => 'show', :id => @checkpoint})
    else
      get_roles
      @journal = @checkpoint.current_journal
      render :action => 'edit'
    end
  end

  def destroy
    @checkpoint.destroy
    redirect_back_or_default(:action => 'index', :project_id => @project)
  end

  private

  def find_checkpoint
    @checkpoint = CmiCheckpoint.find params[:id]
    unless @checkpoint.project_id == @project.id
      deny_access
      return
    end
  end

  def sort_column
    CmiCheckpoint.column_names.include?(params[:sort]) ? params[:sort] : "checkpoint_date"
  end

  def sort_direction
    %w[asc desc].include?(params[:order]) ? params[:order] : "desc"
  end

  def get_roles
    @roles = User.roles
  end
end
