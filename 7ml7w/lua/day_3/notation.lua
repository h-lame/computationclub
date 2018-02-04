local function note(letter, octave)
  local notes = {
    C = 0, Cs = 1, D = 2, Ds = 3, E = 4,
    F = 5, Fs = 6, G = 7, Gs = 8, A = 9,
    As = 10, B = 11
  }

  local notes_per_octave = 12

  return (octave + 1) * notes_per_octave + notes[letter]
end

local tempo = 100

local function duration(value)
  local quarter = 60 / tempo
  local durations = {
    h = 2.0,
    q = 1.0,
    ed = 0.75,
    e = 0.5,
    s = 0.25
  }

  return durations[value] * quarter
end

local function volume(value)
  if (not value) or (value == "") then
    return 0x40
  end

  return 0x7f * ((value + 1) / 10)
end

local function parse_note(s)
  local letter, octave, value = string.match(s, "([A-Gs]+)(%d+)(%a+)")

  if not (letter and octave and value) then
    return nil
  end

  return {
    note = note(letter, octave),
    duration = duration(value)
  }
end

local function do_medium_parse_note(s)
  local letter, octave, duration_value, volume_value = string.match(s, "([A-Gs]+)(%d+)(%a+)(%d?)")

  if not (letter and octave and duration_value) then
    print("No value!")
    return nil
  end

  return {
    note = note(letter, octave),
    duration = duration(duration_value),
    volume = volume(volume_value)
  }
end

local scheduler = require 'scheduler'

local NOTE_DOWN = 0x90
local NOTE_UP = 0x80
local VELOCITY = 0x7f

local function play(note, duration)
  midi_send(NOTE_DOWN, note, VELOCITY)
  scheduler.wait(duration)
  midi_send(NOTE_UP, note, VELOCITY)
end

local function do_medium_play(note)
  midi_send(NOTE_DOWN, note.note, note.volume)
  scheduler.wait(note.duration)
  midi_send(NOTE_UP, note, note.volume)
end

local function part(t)
  local function play_part()
    for i = 1, #t do
      play(t[i].note, t[i].duration)
    end
  end

  scheduler.schedule(0.0, coroutine.create(play_part))
end

local function do_medium_part(t)
  local function play_part()
    for i = 1, #t do
      do_medium_play(t[i])
    end
  end

  scheduler.schedule(0.0, coroutine.create(play_part))
end

local function set_tempo(bpm)
  tempo = bpm
end

local function go()
  scheduler.run()
end

local mt = {
  __index = function(t, s)
    local result = parse_note(s)
    return result or rawget(t, s)
  end
}

local do_medium_mt = {
  __index = function(t, s)
    local result = do_medium_parse_note(s)
    return result or rawget(t, s)
  end
}

setmetatable(_G, do_medium_mt)

return {
  parse_note = do_medium_parse_note,
  play = do_medium_play,
  part = do_medium_part,
  set_tempo = set_tempo,
  go = go
}
