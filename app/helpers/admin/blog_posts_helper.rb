# app/helpers/admin/blog_posts_helper.rb

module Admin::BlogPostsHelper
  def select_content_type_tag form, post
    form.select :content_type, options_for_select_content_type
  end # method select_content_type_tag

  private

  def localize_content_type content_type, locale = I18n.locale
    I18n.t("blog_post.content_types.#{content_type}")
  end # method localize_content_type

  def options_for_select_content_type locale = I18n.locale
    BlogPost::CONTENT_TYPES.map do |content_type|
      [localize_content_type(content_type, :locale => locale), content_type]
    end # map
  end # method options_for_select_content_type
end # module
