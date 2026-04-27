class ProfileController < ApplicationController
  DEFAULTS = { name: "Napassawan korsinprasert", university: "ศิลปากร CS" }.freeze

  def show
    @profile = Profile.first_or_create(DEFAULTS)
    @total   = Task.count
    @done    = Task.where(completed: true).count
    @left    = @total - @done
  end

  def edit
    @profile = Profile.first_or_create(DEFAULTS)
  end

  def update
    @profile = Profile.first_or_create(DEFAULTS)
    if @profile.update(profile_params)
      redirect_to profile_path, notice: "Profile updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def profile_params
    params.expect(profile: [ :name, :university ])
  end
end
