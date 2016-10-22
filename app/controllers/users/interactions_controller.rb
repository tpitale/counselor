module Users
  class InteractionsController < Users::BaseController

    respond_to :html

    def index
      @interactions = Interaction.includes(:events).active_for(current_user)
    end

    def show
      @interaction = Interaction.find(params[:id])
      @client = @interaction.client
      @event = Event.new(interaction: @interaction, user: current_user)
    end

    def new
      @interaction = Interaction.new
    end

    def create
      @interaction = Interaction.create_for_phone(params[:interaction][:phone])

      respond_with @interaction, location: [:users, @interaction]
    end

  end
end
