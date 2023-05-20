class ServersController < ApplicationController
  before_action :set_server, only: %i[ show update destroy logs advanced ]

  # GET /servers or /servers.json
  def index
    @servers = current_user.servers.all
  end

  # GET /servers/1 or /servers/1.json
  def show
  end

  # GET /servers/new
  def new
    @server = current_user.servers.new
    @server.rcon_password = Devise.friendly_token[0, 10]
  end

  # POST /servers or /servers.json
  def create
    @server = current_user.servers.new(server_params)

    respond_to do |format|
      Server.transaction do
        if @server.save
          @server.create_kubernetes_resource
          format.html { redirect_to server_url(@server), notice: "Server was successfully created." }
          format.json { render :show, status: :created, location: @server }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @server.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /servers/1 or /servers/1.json
  def update
    respond_to do |format|
      if @server.update(server_params)
        @server.update_kubernetes_resource
        format.html { redirect_to server_url(@server), notice: "Server was successfully updated." }
        format.json { render :show, status: :ok, location: @server }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @server.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /servers/1 or /servers/1.json
  def destroy
    @server.delete_kubernetes_resource
    @server.destroy

    respond_to do |format|
      format.html { redirect_to servers_url, notice: "Server was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def logs
  end

  def advanced
  end

  def start
    head :ok
  end

  def stop
    head :ok
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_server
    @server = current_user.servers.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def server_params
    params.require(:server).permit(:name, :gslt, :map, :password, :rcon_password, :tickrate, :game_type, :game_mode, :disable_bots, :server_configs, :picture)
  end
end
