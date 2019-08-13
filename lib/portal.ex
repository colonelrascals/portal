defmodule Portal do
  @moduledoc """
  Documentation for Portal.
  """
  defstruct [:left, :right]

  def transfer(left, right, data) do
    for item <- data do
      Portal.Door.push(left, item)
    end

    %Portal{left: left, right: right}
  end

  def push_right(portal) do
    case Portal.Door.pop(portal.left) do
      :error -> :ok
      {:ok, head} -> Portal.Door.push(portal.right, head)
    end

    portal
  end

  def shoot(color) do
	  DynamicSupervisor.start_child(Portal.DoorSupervisor, {Portal.Door, color})
  end
end

defimpl Inspect, for: Portal do
  def inspect(%Portal{left: left, right: right}, _) do
    left_door = inspect(left)
    right_door = inspect(right)

    left_data = inspect(Enum.reverse(Portal.Door.get(left)))
    right_data = inspect(Portal.Door.get(right))

    max = max(String.length(left_door), String.length(left_data))

    """
    #Portal<
    #{String.pad_leading(left_door, max)} <=> #{right_door}
    #{String.pad_leading(left_data, max)} <=> #{right_data}
    >
    """
  end
end