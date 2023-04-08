class RoomNotification < ApplicationNotification
  deliver_by :slack, format: :to_slack, debug: true

  DEFAULT_CHANNEL = Rails.env.production? ? "#long-elite" : "#hax-dev"

  def room
    @room ||= Room.find_by(id: params[:room_id])
  end

  def channel
    params[:channel] || DEFAULT_CHANNEL
  end

  def to_slack
    {
      channel: channel,
      blocks: [
        {
          type: "section",
          text: {
            type: "mrkdwn",
            text: "Nueva sala <!channel>\nCreada por <#{player_url(room.created_by, host: ENV.fetch("HOST_NAME"))}|#{room.created_by.name}>",
          },
          accessory: {
            type: "button",
            text: {
              type: "plain_text",
              text: "Entrar :peeporun:",
              emoji: true
            },
            value: "entrar",
            url: room_url(room, redirect: true, host: ENV.fetch("HOST_NAME")),
            action_id: "entrar"
          }
        }
      ]
    }
  end
end
