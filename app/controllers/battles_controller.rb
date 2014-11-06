class BattlesController < ApplicationController
  before_action :set_battle, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!
  #before_action :find_user
  # GET /battles
  # GET /battles.json
  def attack_enemy
    amount = params[:amount]
    @battle = Battle.find(params[:battle_id])
    @user = User.find(@battle.user_id)
    @aenemy = @battle.aenemies.first
    @aenemy.take_damage(Integer(amount))
    redirect_to @battle, notice: @user.email + " attacks " + " for " + amount + " damage"
  end
  
  def spawn_aenemy
    @battle = Battle.find(params[:battle_id])
    @aenemy = @battle.aenemies.new
    redirect_to @battle
  end
  
  def index
    @battles = Battle.all
  end

  # GET /battles/1
  # GET /battles/1.json
  def show
    @battle = Battle.find(params[:id])
    @user = User.find(@battle.user_id)
   # @enemy = Pet.find(@battle.enemy_id)
   # @aenemies = @battle.aenemies
    @battle_logs = @battle.battle_logs
    #if (@battle.aenemies.any?)
    #  @aenemy = Aenemy.find(@battle.aenemy_id)
   # end
  end

  # GET /battles/new
  def new
    @battle = Battle.new
  end

  # GET /battles/1/edit
  def edit
  end

  # POST /battles
  # POST /battles.json
  def create
    @ghost_archetype = Pet.order("RANDOM()").first
    @battle = Battle.new(battle_params)
    @ghost = Ghost.new
    @battle.update_attribute(:ghost_id, @ghost.id)
    @ghost.update_attribute(:name, @ghost_archetype.name)
    @ghost.update_attribute(:imageurl, @ghost_archetype.imageurl)
    @ghost.update_attribute(:element, @ghost_archetype.element)
    @ghost.update_attribute(:user_id, @ghost_archetype.user_id)
    @pet = Pet.find(@battle.pet_id)
    @pet.update_attribute(:health, 100)
    @pet.update_attribute(:magic, 100)
    @ghost.update_attribute(:health, 100)
    @ghost.update_attribute(:magic, 100)
    @ghost.save
    @battle.ghost = @ghost
    respond_to do |format|
      if @battle.save
        Pet.find(@battle.pet_id).update_attribute(:battle_id, @battle.id)
        format.html { redirect_to @battle, notice: 'Battle was successfully created.' }
        format.json { render :show, status: :created, location: @battle }
      else
        format.html { render :new }
        format.json { render json: @battle.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /battles/1
  # PATCH/PUT /battles/1.json
  def update
    respond_to do |format|
      if @battle.update(battle_params)
        format.html { redirect_to @battle, notice: 'Battle was successfully updated.' }
        format.json { render :show, status: :ok, location: @battle }
      else
        format.html { render :edit }
        format.json { render json: @battle.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /battles/1
  # DELETE /battles/1.json
  def destroy
    @battle.destroy
    respond_to do |format|
      format.html { redirect_to battles_url, notice: 'Battle was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def find_user
      @user = User.find(params[:user_id])
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_battle
      @battle = Battle.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def battle_params
      params.require(:battle).permit(:user_id, :enemy_id, :pet_id, :b_pet_turn, :battle_state, :b_pet_winner)
    end
end
