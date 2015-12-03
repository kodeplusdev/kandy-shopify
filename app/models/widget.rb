class Widget < ActiveRecord::Base
  belongs_to :shop
  serialize :json_string, JSON
  validates_presence_of :name
  validates_length_of :color, minimum: 7, maximum: 7

  def json_string_open_struct
    unless @json_string_open_struct
      @json_string_open_struct = OpenStruct.new(json_string)
    end
    @json_string_open_struct
  end

  def self.DEFAULT
    {
        chat_close: {
            ask_for_rating: true,
            downloadable: false,
            button_text: 'Sign Up Free!',
            chat_closed: 'Thanks for chatting. Please rate how you feel about the chat session',
            custom_link_button: false,
            download: 'Download chat transcript',
            rating_thanks: 'Thanks for your rating!',
            title: 'Chat Closed',
            url: 'https://www.kandy.io/'
        },
        collapse: {
            custom_image_id: '',
            custom_image_url: '',
            horizontal: 40,
            image: 2,
            image_in_front_of_tabtofTab: false,
            is_custom: true,
            page_load: 'bounceIn',
            position: 'br',
            scale: 100,
            show_widget_hide_button: true,
            title: 'Chat with us!',
            type: 'ti',
            vertical: 50
        },
        color: '#5cb85c',
        enable: true,
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
            ask_for_email: true,
            ask_for_email_text: 'Enter your email here',
            ask_for_name: true,
            ask_for_name_text: 'Enter your name here',
            ask_for_question: false,
            ask_for_question_text: 'Enter your question here',
            ask_for_department: false,
            intro_text: 'Enter your info below to begin.',
            popout_automatically: false,
            request_button: 'Start Chat',
            title: 'Chat with us!'
        },
        style: 'Minimal',
        name: 'Default'
    }
  end
end
