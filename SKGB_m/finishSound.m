%% Play a WAV sound
function finishSound()
[y, fs] = audioread('Noti_Sound.wav');
sound(y, fs);
end