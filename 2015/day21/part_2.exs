player = %{hp: 100, damage: 0, armor: 0, spent: 0}
boss = %{hp: 109, damage: 8, armor: 2, spent: 0}

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
  
  def fight(%{hp: php, damage: _, armor: _, spent: pspent}, %{hp: _, damage: _, armor: _, spent: _}, _) when php <= 0 do
    pspent
  end
  def fight(%{hp: _, damage: _, armor: _, spent: _}, %{hp: bhp, damage: _, armor: _, spent: bspent}, _) when bhp <= 0 do
    bspent
  end
  def fight(%{hp: php, damage: pdamage, armor: parmor, spent: _} = player, %{hp: bhp, damage: bdamage, armor: barmor, spent: _} = boss, turn) do
    if mod(turn, 2) == 0 do
      damage = max(bdamage - parmor, 1)
      updated_player = Map.put(player, :hp, php - damage)
      LOTR.fight(updated_player, boss, turn + 1)
    else
      damage = max(pdamage - barmor, 1)
      updated_boss = Map.put(boss, :hp, bhp - damage)
      LOTR.fight(player, updated_boss, turn + 1)
    end
  end
end

# 2 Rings
option_null = weapons
  |> Enum.map(fn(weapon) ->
    rings
      |> Enum.with_index
      |> Enum.map(fn({left_ring, index}) ->
        List.delete_at(rings, index)
          |> Enum.map(fn(right_ring) ->
            Map.put(player, :damage, weapon.damage + left_ring.damage + right_ring.damage)
              |> Map.put(:armor, left_ring.armor + right_ring.armor)
              |> Map.put(:spent, weapon.cost + left_ring.cost + right_ring.cost)
              |> LOTR.fight(boss, 1)
          end)
      end)
  end)
  |> List.flatten 
  |> Enum.max

# 2 Rings
option_one = weapons
  |> Enum.map(fn(weapon) ->
    armors
      |> Enum.map(fn(armor) ->
        rings
          |> Enum.with_index
          |> Enum.map(fn({left_ring, index}) ->
            List.delete_at(rings, index)
              |> Enum.map(fn(right_ring) ->
                Map.put(player, :damage, weapon.damage + left_ring.damage + right_ring.damage)
                  |> Map.put(:armor, armor.armor + left_ring.armor + right_ring.armor)
                  |> Map.put(:spent, armor.cost + weapon.cost + left_ring.cost + right_ring.cost)
                  |> LOTR.fight(boss, 1)
              end)
          end)
      end)
  end)
  |> List.flatten 
  |> Enum.max

# 1 Ring
option_two = weapons
  |> Enum.map(fn(weapon) ->
    armors
      |> Enum.map(fn(armor) ->
        rings
          |> Enum.map(fn(ring) ->
            Map.put(player, :damage, weapon.damage + ring.damage)
              |> Map.put(:armor, armor.armor + ring.armor)
              |> Map.put(:spent, armor.cost + weapon.cost + ring.cost)
              |> LOTR.fight(boss, 1)
          end)
      end)
  end)
  |> List.flatten
  |> Enum.max

# 0 Rings
option_three = weapons
  |> Enum.map(fn(weapon) ->
    armors
      |> Enum.map(fn(armor) ->
        Map.put(player, :damage, weapon.damage)
          |> Map.put(:armor, armor.armor)
          |> Map.put(:spent, armor.cost + weapon.cost)
          |> LOTR.fight(boss, 1)
      end)
  end)
  |> List.flatten
  |> Enum.max

[option_null, option_one, option_two, option_three]
  |> Enum.max
  |> IO.inspect
