class GithubPainter

  def initialize(art_info)
    @art_info = art_info
  end

  def call
    file = File.new("/home/#{ENV['USER']}/.ssh/#{@art_info.author_email}_key", 'w')
    file.write(@art_info.key.gsub("\r", ""))
    File.chmod(0600, file.path)
    file.rewind
    %x( ssh-keygen -f #{file.path} -y > #{file.path}.pub ) #smells so good

    git = Git.clone(
      "git@github.com:#{@art_info.repo_path}.git",
      Rails.root.join('tmp/repos/'+@art_info. repo_path),
      :config => ["core.sshCommand=ssh -i #{file.path}", 'submodule.recurse=true']
    )
    git.config('user.email', @art_info.author_email)
    current_date = Date.today.last_week.end_of_week - 1.day
    image = Magick::ImageList.new(ActiveStorage::Blob.service.path_for(@art_info.image.key))
    image.rotate(90).flip.each_pixel do |pixel|
      if pixel.alpha != 0
        git.commit("xablau: " + current_date.to_s, date: current_date.to_s , allow_empty: true)
      end
      current_date = current_date - 1
    end

    git.push

    file.close
  end

  private

end
