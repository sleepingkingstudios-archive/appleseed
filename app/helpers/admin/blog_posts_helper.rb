# app/helpers/admin/blog_posts_helper.rb

module Admin::BlogPostsHelper
  def select_content_type_tag form, post
    form.select :content_type, localized_content_types
  end # method select_content_type_tag

  private

  def localized_content_types locale = I18n.locale
    BlogPost::CONTENT_TYPES.map do |type|
      [I18n.t("blog_post.content_types.#{type}", :locale => locale), type]
    end # map
  end # method localized_content_types
end # module
