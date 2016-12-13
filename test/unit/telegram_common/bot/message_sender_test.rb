require File.expand_path('../../../../test_helper', __FILE__)

class TelegramCommon::Bot::MessageSenderTest < ActiveSupport::TestCase
  let(:chat_id) { 123 }
  let(:text) { 'text' }
  let(:bot_token) { 'token' }

  subject do
    TelegramCommon::Bot::MessageSender.new(
      chat_id: chat_id,
      message: text,
      bot_token: bot_token
    )
  end

  before do
    Telegrammer::Bot.any_instance.stubs(:get_me)
  end

  it 'inits telegrammer bot with passed token' do
    expect(subject.bot_token).must_equal bot_token
  end

  it 'sends message via telegrammer' do
    Telegrammer::Bot.any_instance
      .expects(:send_message)
      .with(chat_id: chat_id, text: text, parse_mode: 'HTML')

    subject.call
  end
end
