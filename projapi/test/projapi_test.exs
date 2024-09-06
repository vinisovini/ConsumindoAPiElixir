defmodule ProjapiTest do
  use ExUnit.Case
  doctest Projapi

  test "greets the world" do
    assert Projapi.hello() == :world
  end
end
