#
# Ring selection should happen in code instead of manually changing the loop!
#
player = %{hp: 100, damage: 0, armor: 0, spent: 0}
boss = %{hp: 109, damage: 8, armor: 2, spent: 999999999}

weapons = [
  %{cost: 8, damage: 4, armor: 0},
  %{cost: 10, damage: 5, armor: 0},
  %{cost: 25, damage: 6, armor: 0},
  %{cost: 40, damage: 7, armor: 0},
  %{cost: 74, damage: 8, armor: 0},
]

armors = [
  %{cost: 13, damage: 0, armor: 1},
  %{cost: 31, damage: 0, armor: 2},
  %{cost: 53, damage: 0, armor: 3},
  %{cost: 75, damage: 0, armor: 4},
  %{cost: 102, damage: 0, armor: 5},
]

rings = [
  %{cost: 25, damage: 1, armor: 0},
  %{cost: 50, damage: 2, armor: 0},
  %{cost: 100, damage: 3, armor: 0},
  %{cost: 20, damage: 0, armor: 1},
  %{cost: 40, damage: 0, armor: 2},
  %{cost: 80, damage: 0, armor: 3},
]

defmodule LOTR do
  defp mod(x,y) when x > 0, do: rem(x, y);
  defp mod(x,y) when x < 0, do: rem(x, y) + y;
  defp mod(0,_y), do: 0
  
  def fight(%{hp: php, damage: _, armor: _, spent: _}, %{hp: bhp, damage: _, armor: _, spent: bspent}, turn) when php <= 0 do
    IO.inspect "player: #{php}, boss: #{bhp}, turn: #{turn}"
    bspent
  end
  def fight(%{hp: php, damage: _, armor: _, spent: pspent}, %{hp: bhp, damage: _, armor: _, spent: _}, turn) when bhp <= 0 do
    IO.inspect "player: #{php}, boss: #{bhp}, turn: #{turn}"
    pspent
  end
  def fight(%{hp: php, damage: pdamage, armor: parmor, spent: _} = player, %{hp: bhp, damage: bdamage, armor: barmor, spent: _} = boss, turn) do
    IO.inspect "player: #{php}, boss: #{bhp}, turn: #{turn}"
    if mod(turn, 2) == 0 do
      damage = bdamage - parmor
      updated_player = Map.put(player, :hp, player.hp - damage)
      LOTR.fight(updated_player, boss, turn + 1)
    else
      damage = max(pdamage - barmor, 1)
      updated_boss = Map.put(boss, :hp, boss.hp - damage)
      LOTR.fight(player, updated_boss, turn + 1)
    end
  end
end

weapons
  |> Enum.map(fn(weapon) ->
    armors
      |> Enum.map(fn(armor) ->
        rings
          |> Enum.map(fn(ring) ->
            equipped_player = Map.put(player, :damage, weapon.damage + ring.damage)
            fully_equipped_player = Map.put(equipped_player, :armor, armor.armor + ring.armor)
            fully_equipped_player_and_charged = Map.put(fully_equipped_player, :spent, armor.cost + weapon.cost + ring.cost)
            IO.inspect fully_equipped_player_and_charged
            IO.puts "--"
            LOTR.fight(fully_equipped_player_and_charged, boss, 1)
          end)
      end)
  end)
  |> List.flatten
  |> IO.inspect
  |> Enum.min
  |> IO.inspect
