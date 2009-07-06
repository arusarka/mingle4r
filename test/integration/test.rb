require '../../lib/mingle4r'


class Mingle4r::Project
  class << self
    attr_reader :resource_class
  end
end

m_c = Mingle4r::MingleClient.new('http://localhost:9090', 'testuser', 'testuser', 'api_test')

cards = m_c.cards
card = cards[2]
puts card.number
puts card.description
# card.description = 'test'
# card.save
attachment = card.attachments[0]
puts attachment.url

# delete attachments
Mingle4r::Card::Attachment.site = 'http://localhost:9090/projects/api_test/cards/18'
Mingle4r::Card::Attachment.user = 'testuser'
Mingle4r::Card::Attachment.password = 'testuser'

attachment = Mingle4r::Card::Attachment.find(:all)[0]
attachment.delete