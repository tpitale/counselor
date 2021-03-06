class Client < ActiveRecord::Base
  validates :phone, presence: true, uniqueness: true

  has_many :interactions

  def self.with_phone(search)
    normalized_phone = search.to_s.length == 10 ? "+1"+search : search

    where(phone: normalized_phone).first || new(phone: search.to_s)
  end

  def male?
    ["man", "male", "guy", "dude"].include? gender.to_s.downcase
  end

  def female?
    ["woman", "female", "lady"].include? gender.to_s.downcase
  end

  def ssn?
    ssn.present?
  end

  def family?
    kid_count.to_i > 0
  end

  def name
    "#{first_name} #{last_name}"
  end

  def formatted_birthdate
    birthdate && birthdate.strftime("%B %e, %Y")
  end

  def contact_types
    types = interactions.map(&:type).uniq.compact
    types.any? ? types.join(", ") : "No contact types"
  end

  def last_contacted_event
    events = Event.where(interaction: interactions)
    if events.any?
      events.max_by(&:created_at)
    end
  end

  def last_contacted
    if last_contacted_event
      last_contacted_event.created_at.strftime("%m/%d/%Y %l:%M %p")
    end
  end
end
