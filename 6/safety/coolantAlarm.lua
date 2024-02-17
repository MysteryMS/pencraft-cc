local function playDamageSound ()
    local speaker = peripheral.wrap("speaker_1")
    local dfpwm = require("cc.audio.dfpwm")
    local decoder = dfpwm.make_decoder()

    for chunk in io.lines("safety/sounds/low_coolant.dfpwm", 16 * 1024) do
        local buffer = decoder(chunk)

        while not speaker.playAudio(buffer, 100) do
            os.pullEvent("speaker_audio_event")
        end
    end
end

return playDamageSound
