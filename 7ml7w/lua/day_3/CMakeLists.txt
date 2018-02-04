cmake_minimum_required (VERSION 2.8)
project (play)
add_executable (play do_easy_play.cpp)
target_link_libraries (play lua RtMidi)
