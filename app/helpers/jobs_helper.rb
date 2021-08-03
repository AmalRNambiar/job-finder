# frozen_string_literal: true

module JobsHelper
  require 'digest/md5'

  def job_image(title)
    color = Digest::MD5.hexdigest(title)[0..5]
    "https://dummyimage.com/300x300/#{color}/ffffff.png&text=#{title.scan(/\w+/)[0..1].join(' ').capitalize}"
  end

  def extract_text(html)
    ActionView::Base.full_sanitizer.sanitize(html)
  end

  def format_date(date)
    return 'Date not available' if date.blank?

    date.strftime('%B %d, %Y %H:%M %p')
  end
end
