class GithubPainter

  def initialize(art_info)
    @art_info = art_info
  end

  def call
    file = File.new(Rails.root.join('tmp/ssh')+"#{@art_info.author_email}_key", 'w')
    file.write(ensure_newline(@art_info.key.gsub("\r", "")))
    File.chmod(0600, file.path)
    file.rewind
    %x( ssh-keygen -f #{file.path} -y > #{file.path}.pub ) #smells so good
    full_repository_path = Rails.root.join('tmp/repos/'+@art_info.repo_path)
    delete_dir_if_exists(full_repository_path)
    git = Git.clone(
      "git@github.com:#{@art_info.repo_path}.git",
      full_repository_path,
      :config => ["core.sshCommand=ssh -i #{file.path}", 'submodule.recurse=true']
    )
    git.config('user.email', @art_info.author_email)
    # erase_commits(git) if @art_info.recurring
    current_date = Date.today.last_week.end_of_week - 1.day
    image = Magick::ImageList.new(ActiveStorage::Blob.service.path_for(@art_info.image.key))
    image.rotate(90).flip.each_pixel do |pixel|
      if pixel.alpha != 0
        git.commit("xablau: " + current_date.to_s, date: current_date.to_s , allow_empty: true)
      end
      current_date = current_date - 1
    end

    git.push("origin", "main", {force: true})

    file.close
  end

  private

  def delete_dir_if_exists(full_repository_path)
    FileUtils.remove_dir(full_repository_path, true) if File.directory?(full_repository_path)
  end

  # this works but github don't erase contributions marks if you force push
  # branchs removing commits, very sad... I'm still trying to figure out
  # another solution for this.
  def erase_commits(git)
    git.checkout('orphane', {orphan: true})
    git.commit('empty xablau', allow_empty: true)
    git.branch.delete(@art_info.main_branch_name)
    git.branch.rename(@art_info.main_branch_name)
  end

  def ensure_newline(string)
    return string + "\n" if string[-1] != "\n"
    string
  end
end
