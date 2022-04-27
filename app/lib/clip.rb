class Clip
  GO_BACK_SECONDS = 5

  # @param match [Match]
  # @param from_secs [Integer] Amount of seconds where to start the clip
  # @param to_secs [Integer] Amount of seconds where to end the clip
  def initialize(match, from_secs: nil, to_secs:)
    @match = match
    @from_secs = (from_secs || (to_secs - GO_BACK_SECONDS)).clamp(0, @match.duration_secs)
    @to_secs = to_secs.clamp(0, @match.duration_secs)
  end

  def clip
    if !system("which ffmpeg")
      Rails.logger.error("ffmpeg not present in system")
      return false
    end

    if !@match.mp4_recording.attached?
      Rails.logger.error("No mp4 recording for match #{@match.id}")
      return false
    end

    Tempfile.create(["output-#{SecureRandom.uuid}", ".mp4"], "tmp") do |f|
      Tempfile.create(["recording-#{SecureRandom.uuid}", ".mp4"], "tmp", binmode: true) do |mp4_file|
        mp4_file.puts @match.mp4_recording.download
        mp4_file.rewind

        # -i  input file
        # -ss seek to position where to start the clip HH:MM:SS
        # -t  duration of the clip HH:MM:SS
        # -y  overwrite output file if exists
        system("ffmpeg -i #{mp4_file.path} -ss #{from_secs_stamp} -t #{duration_stamp} -y #{f.path}")
      end

      @match.clips.attach(io: f, filename: "clip-#{@match.id}.mp4", content_type: "video/mp4")
    end

    true
  end

  private

  def duration_stamp
    Time.at(@to_secs - @from_secs).utc.strftime("%H:%M:%S")
  end

  def from_secs_stamp
    Time.at(@from_secs).utc.strftime("%H:%M:%S")
  end
end
