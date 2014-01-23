# app/presenters/admin/blog_post_presenter.rb

class Admin::BlogPostPresenter < ::BlogPostPresenter
  def published_mark
    content_tag :i, nil, :class => published? ? 'fi-check success' : 'fi-x alert'
  end # method published_mark
end # class
