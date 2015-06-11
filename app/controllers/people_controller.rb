# coding: utf-8
class PeopleController < ApplicationController
  protect_from_forgery with: :null_session
  before_action :set_person, only: [:show, :edit, :update, :destroy]

  # GET /people
  # GET /people.json
  def index
    @people = Person.all
    # @people = Person.group(:name)
    # @counts = Person.group(:name).count.values
    # respond_to do |format|
    #   format.html # => 通常のURLの場合index.html.erbが返される
    #   format.json { render json: @people } # URLが.jsonの場合、@people.to_jsonが返される
    # end
  end

  # GET /people/1
  # GET /people/1.json
  def show
  end

  # GET /people/new
  def new
    @person = Person.new
  end

  # GET /people/1/edit
  def edit
    @person = Person.find(params[:id])
  end

  # POST /people
  # POST /people.json
  def create
    # json受付用と化した。 ビューからの登録は一時的に不可能に
    # 新しい名前だったら新しく作る、それ以外はカウントアップ
    # @person = Person.new(person_params) <= これはただのコメントアウト
    if Person.exists?(:name => params[:name]) then
      # count up
      @person = Person.where("name = ?", params[:name]).first
      if !@person.created_at.today? then
        @person.count = @person.count + 1
      end
    else
      # create new person
      @person = Person.new({ :name => params[:name] })
      @person.user_name = params[:name]
      @person.count = 1
    end

    respond_to do |format|
      if @person.save
        # format.html { redirect_to @person, notice: 'Person was successfully created.' }
        format.html { render :text => "ヘィ提督ゥ〜現在person#createはビューを介しての登録はしていない筈なんだけど、なんでここまでこれたのデース？" }
	# format.json { render :json => create_json(@person), :status => 201 }
        format.json { render :show, status: :created, location: @person }
      else
        # format.html { render :new }
        format.html { render :text => "日本の首都柏" }
        format.json { render json: @person.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /people/1
  # PATCH/PUT /people/1.json
  def update
    @person = Person.find(params[:id])
    if @person.update(person_params)
      redirect_to person_url(@person)
    else
      render 'edit'
    end
  end

  # DELETE /people/1
  # DELETE /people/1.json
  def destroy
    @person.destroy
    respond_to do |format|
      format.html { redirect_to people_url, notice: 'Person was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_person
      @person = Person.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def person_params
      params.require(:person).permit(:name, :user_name)
    end

    def create_json(people)
      people = [people] unless people.class == Array
      people = people.inject([]){ |arr, task|
        arr << {
          :id => person.id,
          :name => person.name,
          :created_at => person.created_at
        }; arr
      }
      { :people => people }.to_json
    end
end
