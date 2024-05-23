class ArtInfosController < ApplicationController

  def new
    @art_info = ArtInfo.new
  end

  def create
    ArtInfo.create(art_info_params)
  end

  private

  def art_info_params
    params.require(:art_info).permit(:key, :image, :random, :recurring, :random, :repo_path, :degrade)
  end
end
