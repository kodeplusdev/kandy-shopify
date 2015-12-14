class Widget < ActiveRecord::Base
  belongs_to :shop
  serialize :json_string, JSON
  validates_presence_of :name
  validates_uniqueness_of :shop_id
  validates_length_of :color, minimum: 7, maximum: 7
  before_validation :set_default

  def json_string_open_struct
    unless @json_string_open_struct
      @json_string_open_struct = OpenStruct.new(json_string)
    end
    @json_string_open_struct
  end

  def set_default
    puts 'set_default'
    self.name ||= 'Live Chat'
    self.color ||= '#000000'
    self.enabled ||= true
    self.json_string ||= {
        chat_close: {
            ask_for_rating: '1',
            downloadable: '0',
            button_text: 'Sign Up Free!',
            chat_closed: 'Thanks for chatting. Please rate how you feel about the chat session',
            custom_link_button: '0',
            download: 'Download chat transcript',
            rating_thanks: 'Thanks for your rating!',
            title: 'Chat Closed',
            url: 'https://www.kandy.io/'
        },
        collapse: {
            custom_image_id: '',
            custom_image_url: '',
            horizontal: '40',
            image: '2',
            image_in_front_of_tabtofTab: '0',
            is_custom: '1',
            page_load: 'bounceIn',
            position: 'br',
            scale: '100',
            show_widget_hide_button: '1',
            title: 'Chat with us!',
            type: 'ti',
            vertical: '50'
        },
        error_messages: {
            email_valid: 'Please enter valid email.',
            name_required: 'Please enter name.',
            no_operator_required: 'Please enter name, email and question.'
        },
        in_chat: {
            connecting: 'Connecting you to the chat now...',
            greeting: 'Hello,',
            joined_chat: 'has joined the chat!',
            left_chat: 'has left the chat',
            closed_chat: 'has closed the chat',
            message: 'An operator will be right with you!',
            no_operators: 'An operator has not yet connected. Don\'t worry, an operator will be by shortly! When they connect, they\'ll see all the messages you\'ve sent so far.',
            send_message: 'Type your message here and press <enter> to send.',
            title: 'Chatting with',
            typing: 'is typing',
            start_message: 'Hi! Can we answer a question for you?'
        },
        no_operators: {
            action: 'e',
            central_email: 'info@kandy.io',
            email_intro: 'There are currently no operators available, but feel free to send us an email!',
            email_sent_text: 'Email is sent and should go back to the initial page waiting for new chat sessions.',
            message: 'Sorry, no operators are currently available',
            send_button: 'Send',
            title: 'No Operators Available',
            email: 'Enter your email here',
            name: 'Enter your name here',
            question: 'what can we help with?'
        },
        start_chat: {
            ask_for_email: '1',
            ask_for_email_text: 'Enter your email here',
            ask_for_name: '1',
            ask_for_name_text: 'Enter your name here',
            ask_for_question: '0',
            ask_for_question_text: 'Enter your question here',
            ask_for_department: '0',
            intro_text: 'Enter your info below to begin.',
            popout_automatically: '0',
            request_button: 'Start Chat',
            title: 'Chat with us!'
        }
    }
  end
end
