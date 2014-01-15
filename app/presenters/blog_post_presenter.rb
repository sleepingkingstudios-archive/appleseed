# app/presenters/blog_post_presenter.rb

class BlogPostPresenter < Struct.new(:blog_post)
  delegate :author, :blog, :content, :content_type, :title, :to => :blog_post

  def localized_content_type locale = I18n.locale
    I18n.t(content_type, :scope => 'blog_post.content_types', :locale => locale)
  end # method localized_content_type

  def raw_content
    RawContentFormatter.new(content).format
  end # method raw_content

  class ContentFormatter < Struct.new(:content)
    def format
      content
    end # method format
  end # class

  class RawContentFormatter < ContentFormatter
    include ERB::Util

    def format
      html_escape(content).gsub(/\r\n|\n|\r/, '<br />').html_safe
    end # method format
  end # class
end # class
