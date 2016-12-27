require File.expand_path('../../../test_helper', __FILE__)

class TelegramCommon::BotTest < ActiveSupport::TestCase
  fixtures :users, :email_addresses, :roles

  let(:bot_token) { 'token' }

  context '/start' do
    setup do
      @telegram_message = ActionController::Parameters.new(
        from: { id:         123,
                username:   'dhh',
                first_name: 'David',
                last_name:  'Haselman' },
        chat: { id: 123,
                type: 'private' },
        text: '/start'
      )

      @bot_service = TelegramCommon::Bot.new(bot_token, @telegram_message)
    end

    context 'without user' do
      setup do
        TelegramCommon::Bot::MessageSender
            .expects(:call)
            .with(
              chat_id: 123,
              message: I18n.t('telegram_common.bot.start.instruction_html'),
              bot_token: bot_token
            )
      end

      should 'create telegram account' do
        assert_difference('TelegramCommon::Account.count') do
          @bot_service.call
        end

        telegram_account = TelegramCommon::Account.last
        assert_equal 123, telegram_account.telegram_id
        assert_equal 'dhh', telegram_account.username
        assert_equal 'David', telegram_account.first_name
        assert_equal 'Haselman', telegram_account.last_name
        assert telegram_account.active
      end

      should 'update telegram account' do
        telegram_account = TelegramCommon::Account.create(telegram_id: 123, username: 'test', first_name: 'f', last_name: 'l')

        assert_no_difference('TelegramCommon::Account.count') do
          @bot_service.call
        end

        telegram_account.reload

        assert_equal 'dhh', telegram_account.username
        assert_equal 'David', telegram_account.first_name
        assert_equal 'Haselman', telegram_account.last_name
      end

      should 'activate telegram account' do
        actual = TelegramCommon::Account.create(telegram_id: 123, active: false)

        assert_no_difference('TelegramCommon::Account.count') do
          @bot_service.call
        end

        actual.reload

        assert actual.active
      end
    end

    context 'group' do
      setup do
        @telegram_message = ActionController::Parameters.new(
          from: { id:         123,
                  username:   'abc',
                  first_name: 'Antony',
                  last_name:  'Brown' },
          chat: { id: -123,
                  type: 'group' },
          text: '/start'
        )

        @bot_service = TelegramCommon::Bot.new(bot_token, @telegram_message)
      end

      should 'send message about private command' do
        TelegramCommon::Bot::MessageSender
          .expects(:call)
          .with(
            chat_id: -123,
            message: I18n.t('telegram_common.bot.group.private_command'),
            bot_token: bot_token
          )
        @bot_service.call
      end
    end
  end

  context '/connect e@mail.com' do
    setup do
      @user = User.find(2)

      @telegram_account = TelegramCommon::Account.create(telegram_id: 123)
    end

    context 'new connection' do
      setup do
        @telegram_message = ActionController::Parameters.new(
          from: { id:         123,
                  username:   'dhh',
                  first_name: 'David',
                  last_name:  'Haselman' },
          chat: { id: 123,
                  type: 'private' },
          text: "/connect #{@user.mail}"
        )

        @bot_service = TelegramCommon::Bot.new(bot_token, @telegram_message)

        TelegramCommon::Bot::MessageSender
          .expects(:call)
          .with(
            chat_id: 123,
            message: I18n.t('telegram_common.bot.connect.wait_for_email', email: @user.mail),
            bot_token: bot_token
          )
      end

      should 'send connect instruction by email' do
        TelegramCommon::Mailer.any_instance
          .expects(:telegram_connect)
          .with(@user, @telegram_account)

        @bot_service.call
      end

      should 'unblock telegram account after one hour' do
        TelegramCommon::Mailer.any_instance
          .expects(:telegram_connect)
          .with(@user, @telegram_account)

        @telegram_account.blocked_at = DateTime.now - 2.hour
        @telegram_account.save!

        @bot_service.call

        assert !@telegram_account.reload.blocked?
      end
    end

    context 'already connected' do
      setup do
        @user.telegram_account = @telegram_account
        @user.save!

        @telegram_message = ActionController::Parameters.new(
          from: { id:         123,
                  username:   'dhh',
                  first_name: 'David',
                  last_name:  'Haselman' },
          chat: { id: 123,
                  type: 'private' },
          text: "/connect #{@user.mail}"
        )

        @bot_service = TelegramCommon::Bot.new(bot_token, @telegram_message)
      end

      should 'send telegram notification about already connected' do
        TelegramCommon::Bot::MessageSender
          .expects(:call)
          .with(
            chat_id: 123,
            message: I18n.t('telegram_common.bot.connect.already_connected'),
            bot_token: bot_token
          )

        @bot_service.call
      end
    end

    context 'user not found' do
      setup do
        @telegram_message = ActionController::Parameters.new(
          from: { id:         123,
                  username:   'dhh',
                  first_name: 'David',
                  last_name:  'Haselman' },
          chat: { id: 123,
                  type: 'private' },
          text: '/connect wrong@email.com'
        )

        @bot_service = TelegramCommon::Bot.new(bot_token, @telegram_message)
      end

      should 'increment connect trials count' do
        message = I18n.t('telegram_common.bot.connect.wrong_email')
        TelegramCommon::Bot::MessageSender
          .expects(:call)
          .with(
            chat_id: 123,
            message: message,
            bot_token: bot_token
          )

        assert_equal 0, @telegram_account.connect_trials_count
        @bot_service.connect
        assert_equal 1, @telegram_account.reload.connect_trials_count
      end

      should 'block telegram account after 3 wrong trials' do
        message = I18n.t('telegram_common.bot.connect.blocked')
        TelegramCommon::Bot::MessageSender
          .expects(:call)
          .with(
            chat_id: 123,
            message: message,
            bot_token: bot_token
          )

        assert !@telegram_account.blocked?

        @telegram_account.connect_trials_count = 2
        @telegram_account.save!

        @bot_service.call

        assert @telegram_account.reload.blocked?
        assert_equal 0, @telegram_account.connect_trials_count
      end
    end
  end

  context '/help' do
    context 'private' do
      setup do
        @telegram_message = ActionController::Parameters.new(
          from: { id:         123,
                  username:   'abc',
                  first_name: 'Antony',
                  last_name:  'Brown' },
          chat: { id: 123,
                  type: 'private' },
          text: '/help'
        )

        @bot_service = TelegramCommon::Bot.new(bot_token, @telegram_message)
      end

      should 'send help for private chat' do
        text = <<~TEXT
          /start - #{I18n.t('telegram_common.bot.private.help.start')}
          /connect - #{I18n.t('telegram_common.bot.private.help.connect')}
          /help - #{I18n.t('telegram_common.bot.private.help.help')}
        TEXT

        message = text.chomp
        TelegramCommon::Bot::MessageSender
          .expects(:call)
          .with(
            chat_id: 123,
            message: message,
            bot_token: bot_token
          )

        @bot_service.call
      end
    end

    context 'group' do
      setup do
        @telegram_message = ActionController::Parameters.new(
          from: { id:         123,
                  username:   'abc',
                  first_name: 'Antony',
                  last_name:  'Brown' },
          chat: { id: -123,
                  type: 'group' },
          text: '/help'
        )

        @bot_service = TelegramCommon::Bot.new(bot_token, @telegram_message)
      end

      should 'send help for private chat' do
        text = <<~TEXT
          #{I18n.t('telegram_common.bot.group.no_commands')}
          /start - #{I18n.t('telegram_common.bot.private.help.start')}
          /connect - #{I18n.t('telegram_common.bot.private.help.connect')}
          /help - #{I18n.t('telegram_common.bot.private.help.help')}
        TEXT

        message = text.chomp
        TelegramCommon::Bot::MessageSender
          .expects(:call)
          .with(
            chat_id: -123,
            message: message,
            bot_token: bot_token
          )

        @bot_service.call
      end
    end
  end
end
