extern "C"
{
#include "lua.h"
#include "lauxlib.h"
#include "lualib.h"
}

#include "RtMidi.h"
static RtMidiOut midi;

int midi_send(lua_State* L)
{
  double status = lua_tonumber(L, -3);
  double data1 = lua_tonumber(L, -2);
  double data2 = lua_tonumber(L, -1);

  std::vector<unsigned char> message(3);
  message[0] = static_cast<unsigned char>(status);
  message[1] = static_cast<unsigned char>(data1);
  message[2] = static_cast<unsigned char>(data2);

  midi.sendMessage(&message);

  return 0;
}

int main(int argc, const char* argv[])
{
  if (argc < 1) { return -1; }

  unsigned int ports = midi.getPortCount();
  if (ports < 1) { return -1; }
  midi.openPort(0);

  lua_State *L = luaL_newstate();
  luaL_openlibs(L);

  lua_getglobal(L, "require");
  lua_pushstring(L, "notation");
  // numbers to pcall are the number of args, number of results, and a handler
  // for errors, in our case null
  if (lua_pcall(L, 1, 1, 0)) {
    printf("%s\n", lua_tostring(L, -1));
    lua_close(L);
    return -1;
  }

  lua_setglobal(L, "song");

  lua_pushcfunction(L, midi_send);
  lua_setglobal(L, "midi_send");

  if (luaL_dofile(L, argv[1]))
  {
    printf("%s\n", lua_tostring(L, -1));
    lua_close(L);
    return -1;
  }

  lua_getglobal(L, "song");
  // -1 apparently means actually use the key, not the index
  lua_getfield(L, -1, "go");
  lua_call(L, 0, 0);

  lua_close(L);
  return 0;
}
