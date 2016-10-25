module UsersHelper

  # Returns the Gravatar for the given user.
  def gravatar_for(user, size: 80)
    avatar_url = user.avatar.url || 'avatar.jpg'
    image_tag(avatar_url, alt: user.name, class: "gravatar", size: size)
  end
end
