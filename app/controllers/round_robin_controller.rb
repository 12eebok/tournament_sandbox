class RoundRobinController < ApplicationController

  # GET /elimination
  # GET /elimination.json
  def index
    @competitions = Competition.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @eliminations }
    end
  end

  # GET /elimination/1
  # GET /elimination/1.json
  def show
    @elimination = Elimination.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @elimination }
    end
  end

  # GET /elimination/new
  # GET /elimination/new.json
  def new
    @elimination = Elimination.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @elimination }
    end
  end

  # GET /elimination/1/edit
  def edit
    @elimination = Elimination.find(params[:id])
  end

  # POST /elimination
  # POST /elimination.json
  def create
    @elimination = Elimination.new(params[:elimination])

    respond_to do |format|
      if @elimination.save
        format.html { redirect_to @elimination, notice: 'Match was successfully created.' }
        format.json { render json: @elimination, status: :created, location: @elimination }
      else
        format.html { render action: "new" }
        format.json { render json: @elimination.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /elimination/1
  # PUT /elimination/1.json
  def update
    @elimination = Elimination.find(params[:id])

    respond_to do |format|
      if @elimination.update_attributes(params[:elimination])
        format.html { redirect_to results_competition_path(@elimination.competition), notice: 'Match was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @elimination.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /elimination/1
  # DELETE /elimination/1.json
  def destroy
    @elimination = Elimination.find(params[:id])
    @elimination.destroy

    respond_to do |format|
      format.html { redirect_to elimination_url }
      format.json { head :no_content }
    end
  end

end
