class ArtInfosController < ApplicationController

  def new
    @art_info = ArtInfo.new
  end

  def create
    @art_info = ArtInfo.create(art_info_params)
    GithubPainter.new(@art_info).call
  end

  private

  def art_info_params
    params.require(:art_info).permit(:author_email, :key, :image, :random, :recurring, :random, :repo_path, :degrade)
  end
end
