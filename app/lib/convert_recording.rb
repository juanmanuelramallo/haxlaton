class ConvertRecording
  def initialize(match)
    @match = match
  end

  # Calls the puppeteer/record.js script with the necessary arguments to convert the +match+ recording HBR2 file
  #   into an mp4 video file and stores it into the +mp4_recording+ attachment from the +match+ object.
  def convert
    if !system("which node")
      Rails.logger.error("node not present in system")
      return false
    end

    Tempfile.create(["record", ".mp4"], "tmp") do |f|
      system("node #{script_path} #{@match.replay_uri} #{f.path} #{@match.duration_secs}")

      @match.mp4_recording.attach(io: f, filename: "recording-#{@match.id}.mp4", content_type: "video/mp4")
    end
  end

  private

  def script_path
    Rails.root.join("app", "lib", "puppeteer", "record.js")
  end
end
