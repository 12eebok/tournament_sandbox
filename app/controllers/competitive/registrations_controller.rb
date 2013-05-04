class Competitive::RegistrationsController < ApplicationController

    def sample_registrations
      # "sample_registrations"=>{"competition_id"=>"1", "registrations"=>"20"}
      competition = Competition.find(params[:sample_registrations][:competition_id])
      unless competition.nil?
        registrations = params[:sample_registrations][:registrations].to_i
        require 'ffaker'
        if User.count < registrations
          (User.count - registrations).times do
            User.create!(:email => Faker::Internet.email, :name => Faker::Name.name, :password => "secret")
          end
        end
        users = User.limit(registrations)
        users.each do |user|
          registration = competition.registrations.create
          registration.assign_to(user)
        end
      end
      redirect_to competitive_registrations_path
    end

    # GET /registrations
    # GET /registrations.json
    def index
      @registrations = Registration.all

      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @registrations }
      end
    end

    # GET /registrations/1
    # GET /registrations/1.json
    def show
      @registration = Registration.find(params[:id])

      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @registration }
      end
    end

    # GET /registrations/new
    # GET /registrations/new.json
    def new
      @registration = Registration.new

      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @registration }
      end
    end

    # GET /registrations/1/edit
    def edit
      @registration = Registration.find(params[:id])
    end

    # POST /registrations
    # POST /registrations.json
    def create
      @registration = Registration.new(params[:registration])

      respond_to do |format|
        if @registration.save
          format.html { redirect_to [:competitive, @registration], notice: 'Registration was successfully created.' }
          format.json { render json: @registration, status: :created, location: @registration }
        else
          format.html { render action: "new" }
          format.json { render json: @registration.errors, status: :unprocessable_entity }
        end
      end
    end

    # PUT /registrations/1
    # PUT /registrations/1.json
    def update
      @registration = Registration.find(params[:id])

      respond_to do |format|
        if @registration.update_attributes(params[:registration])
          format.html { redirect_to [:competitive, @registration], notice: 'Registration was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: "edit" }
          format.json { render json: @registration.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /registrations/1
    # DELETE /registrations/1.json
    def destroy
      @registration = Registration.find(params[:id])
      @registration.destroy

      respond_to do |format|
        format.html { redirect_to competitive_registrations_url }
        format.json { head :no_content }
      end
    end
  end