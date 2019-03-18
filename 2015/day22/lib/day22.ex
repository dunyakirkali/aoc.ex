defmodule RC do
  use Bitwise
  def powerset1(list) do
    n = length(list)
    max = round(:math.pow(2,n))
    for i <- 0..max-1, do: (for pos <- 0..n-1, band(i, bsl(1, pos)) != 0, do: Enum.at(list, pos) )
  end
 
  def powerset2([]), do: [[]]
  def powerset2([h|t]) do
    pt = powerset2(t)
    (for x <- pt, do: [h|x]) ++ pt
  end
 
  def powerset3([]), do: [[]]
  def powerset3([h|t]) do
    pt = powerset3(t)
    powerset3(h, pt, pt)
  end
 
  defp powerset3(_, [], acc), do: acc
  defp powerset3(x, [h|t], acc), do: powerset3(x, t, [[x|h] | acc])
end

defmodule Player do
  def new(player_stats) do
    player_stats
    |> Map.put(:armor, 0)
    |> Map.put(:shield, 0)
    |> Map.put(:recharge, 0)
  end
  
  def print(player) do
    # IO.puts("- Player has #{player.hp} hit points, #{player.armor} armor, #{player.mana} mana")
  end
  
  def attack(player, damage) do
    # if player.armor > 0 do
    #   IO.puts("Boss attacks for #{damage} - #{player.armor} = #{damage - player.armor} damage!")
    # else
    #   IO.puts("Boss attacks for #{damage} damage!")
    # end
    
    Map.update!(player, :hp, &(&1 - (damage - player.armor)))
  end
  
  def spend(player, mana) do
    Map.update!(player, :mana, &(&1 - mana))
  end
  
  def heal(player, hp) do
    Map.update!(player, :hp, &(&1 + hp))
  end
end

defmodule Boss do
  def new(boss_stats) do
    boss_stats
    |> Map.put(:poison, 0)
  end
  
  def print(boss) do
    # IO.puts("- Boss has #{boss.hp} hit points")
  end
  
  def attack(boss, damage) do
    Map.update!(boss, :hp, &(&1 - damage))
  end
  
  def poison(boss) do
    Map.update!(boss, :poison, &(&1 + 6))
  end
end

defmodule Game do
  def new(player_stats, boss_stats) do
    %{player: Player.new(player_stats), boss: Boss.new(boss_stats), turn: :player}
  end
  
  def play(game, spells, part_2 \\ false) do
    result =
      0..999
      |> Enum.reduce_while({game, nil, 0}, fn i, {game, winner, mana_spent} ->
        spell_index = Kernel.trunc(i / 2)
        spell =
          case game.turn do
            :boss ->
              # IO.puts("-- Boss turn --")
              nil
            :player ->
              # IO.puts("-- Player turn --")
              Enum.at(spells, spell_index)
          end
        
        Player.print(game.player)
        Boss.print(game.boss)
        
        game = 
          if part_2 and game.turn == :player do
            Game.punish(game)
          else
            game
          end
        
        if Game.ended?(game, spell) do
          {:halt, {game, Game.winner(game), mana_spent}}
        else
          game = Game.process_effects(game)
          
          if Game.ended?(game, spell) do
            {:halt, {game, Game.winner(game), mana_spent}}
          else
            {game, mana} = Game.tick(game, spell)
            
            if length(spells) <= spell_index + 1 and game.turn == :player do
              # IO.puts("--DONE--")
              {:halt, {game, Game.winner(game), mana_spent + mana}}
            else
              {:cont, {game, winner, mana_spent + mana}}
            end
          end
        end
        
      end)
      # |> IO.inspect(label: "result")
    {elem(result, 1), elem(result, 2)}
  end
  
  def process_effects(game) do
    boss = process_effects(:boss, game.boss)
    player = process_effects(:player, game.player)
    
    game
    |> Map.put(:boss, boss)
    |> Map.put(:player, player)
  end
  
  defp process_effects(side, boss) when side == :boss do
    if boss.poison > 0 do
      # IO.puts("Poison deals 3 damage; its timer is now #{boss.poison - 1}.")
      boss
      |> Map.update!(:hp, &(&1 - 3))
      |> Map.update!(:poison, &(&1 - 1))
    else
      boss
    end
  end
  
  defp process_effects(side, player) when side == :player do
    player =
      if player.shield > 0 do
        # IO.puts("Shield's timer is now #{player.shield - 1}.")
        player
        |> Map.update!(:shield, &(&1 - 1))
      else
        player
        |> Map.put(:armor, 0)
      end

    player =
      if player.recharge > 0 do
        # IO.puts("Recharge provides 101 mana; its timer is now #{player.recharge - 1}.")
        player =
          player
          |> Map.update!(:mana, &(&1 + 101))
          |> Map.update!(:recharge, &(&1 - 1))
        
        if player.recharge == 0 do
          # IO.puts("Recharge wears off.")
        end
        player
      else
        player
      end
    
    player
  end
  
  def punish(game) do
    player = game.player
    player = Map.update!(player, :hp, &(&1 - 1))
    Map.put(game, :player, player)
  end
  
  def winner(game) do
    cond do
      game.player.hp <= 0 ->
        :boss
      game.boss.hp <= 0 ->
        :player
      true ->
        nil
    end
  end
  
  def tick(game, spell) do
    {game, mana} =
      case game.turn do
        :boss ->
          
          player = game.player
          boss = game.boss
          
          player = Player.attack(player, boss.damage)
          
          game =
            game
            |> Map.put(:turn, :player)
            |> Map.put(:player, player)
            |> Map.put(:boss, boss)
          {game, 0}
        :player ->
          
          player = game.player
          boss = game.boss
          
          {player, boss, mana} =
            case spell do
              :magic_missile ->
                # IO.puts("Player casts Magic Missile, dealing 4 damage.")
                {Player.spend(player, 53), Boss.attack(boss, 4), 53}
              :poison ->
                # IO.puts("Player casts Poison.")
                {Player.spend(player, 173), Boss.poison(boss), 173}
              :drain ->
                # IO.puts("Player casts Drain, dealing 2 damage, and healing 2 hit points.")
                player = 
                  player
                  |> Player.spend(73)
                  |> Player.heal(2)
                
                boss = 
                  boss
                  |> Boss.attack(2)
                {player, boss, 73}
              :shield ->
                # IO.puts("Player casts Shield, increasing armor by 7.")
                player = 
                  player
                  |> Player.spend(113)
                  |> Map.put(:armor, 7) 
                  |> Map.update!(:shield, &(&1 + 6))
                {player, boss, 113}
              :recharge ->
                # IO.puts("Player casts Recharge.")
                player = 
                  player
                  |> Player.spend(229)
                  |> Map.update!(:recharge, &(&1 + 5))
                {player, boss, 229}
            end
          
          game =
            game
            |> Map.put(:turn, :boss)
            |> Map.put(:boss, boss)
            |> Map.put(:player, player)
          {game, mana}
      end
    # IO.puts("")
    {game, mana}
  end
  
  def ended?(game, spell) do
    player = game.player
    boss = game.boss
    if boss.hp <= 0 or player.hp <= 0 or player.mana < 0 do
      true
    else
      cond do
        boss.poison > 0 and spell == :poison -> true
        player.shield > 0 and spell == :shield -> true
        player.recharge > 0 and spell == :recharge -> true
        true -> false
      end
    end
  end
end

defmodule Day22 do
  def part_2(player_stats, boss_stats) do
    game = Game.new(player_stats, boss_stats)
    
    s = [:poison, :magic_missile, :drain, :shield, :recharge]
    
    combination(1, s)
    |> IO.inspect
    |> Stream.with_index
    |> pmap(fn {spells, index}->
      Game.play(game, spells, true)
    end)
    |> Stream.filter(fn {winner, _} ->
      winner == :player
    end)
    |> pmap(fn {_, mana} ->
      mana
    end)
    |> Enum.sort
    |> List.first
    |> IO.inspect
  end
  
  @doc """
      # iex> Day22.part_1(%{hp: 10, mana: 250}, %{hp: 13, damage: 8})
      # 226
      # 
      # iex> Day22.part_1(%{hp: 10, mana: 250}, %{hp: 14, damage: 8})
      # 641
  """
  def part_1(player_stats, boss_stats) do
    game = Game.new(player_stats, boss_stats)
    
    [:poison, :magic_missile, :drain, :shield, :recharge]
    |> selections(10)
    |> Stream.with_index
    |> pmap(fn {spells, index}->
      IO.puts("#{index} of #{9_765_625}")
      Game.play(game, spells)
    end)
    |> Stream.filter(fn {winner, _} ->
      winner == :player
    end)
    |> Stream.map(fn {_, mana} ->
      mana
    end)
    |> Enum.sort
    |> List.first
    |> IO.inspect
  end
  
  def pmap(collection, func) do
    collection
    |> Stream.map(&(Task.async(fn -> func.(&1) end)))
    |> Stream.map(&Task.await/1)
  end
  
  def combination(0, _), do: [[]]
  def combination(_, []), do: []
  def combination(n, [x|xs]) do
    (for y <- combination(n - 1, xs), do: [x|y]) ++ combination(n, xs)
  end
  
  def selections(_, 0), do: [[]]
  def selections(enum, n) do
    list = Enum.to_list(enum)
    list
    |> Stream.flat_map(fn el -> Enum.map(selections(list, n - 1), &([el | &1])) end)
  end
end
