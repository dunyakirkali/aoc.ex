defmodule Day7 do
  @moduledoc """
  Documentation for Day7.
  """
  
  def part_2(ips) do
    ips
    |> Enum.filter(&(support_ssl?(&1)))
    |> Enum.count
  end
  
  def part_1(ips) do
    ips
    |> Enum.filter(&(support_tls?(&1)))
    |> Enum.count
  end
  
  @doc """
      iex> Day7.support_ssl?("aba[bab]xyz")
      true
      
      iex> Day7.support_ssl?("xyx[xyx]xyx")
      false
      
      iex> Day7.support_ssl?("aaa[kek]eke")
      true
      
      iex> Day7.support_ssl?("zazbz[bzb]cdb")
      true
  """
  def support_ssl?(ip) do
    [external, internal] =
      ip
      |> split()
      |> Enum.map(fn list ->
        list
        |> Enum.map(fn sublist ->
          expand(sublist, 3)
        end)
        |> List.flatten
      end)
        
    external = Enum.filter(external, &(is_aba?(&1)))
    internal =
      internal
      |> Enum.filter(&(is_aba?(&1)))
      |> Enum.map(&(revert(&1)))
    
    
    diff = external -- internal
    Enum.count(external -- diff) > 0
  end

  @doc """
      iex> Day7.support_tls?("abba[mnop]qrst")
      true
      
      iex> Day7.support_tls?("abcd[bddb]xyyx")
      false
      
      iex> Day7.support_tls?("aaaa[qwer]tyui")
      false
      
      iex> Day7.support_tls?("ioxxoj[asdfgh]zxcvbn")
      true
  """
  def support_tls?(ip) do
    [external, internal] =
      ip
      |> split()
      |> Enum.map(fn list ->
        list
        |> Enum.map(fn sublist ->
          expand(sublist)
        end)
        |> List.flatten
      end)
    
    has_ext = 
      external
      |> Enum.map(fn str ->
        is_palidrome?(str)
      end)
      |> Enum.any?
    
    has_int = 
      internal
      |> Enum.map(fn str ->
        is_palidrome?(str)
      end)
      |> Enum.any?
    
    has_ext and not has_int
  end
  
  @doc """
      iex> Day7.is_palidrome?("abba")
      true
      
      iex> Day7.is_palidrome?("aaaa")
      false
      
      iex> Day7.is_palidrome?("abcd")
      false
  """
  def is_palidrome?(str) do
    if String.at(str, 0) == String.at(str, 1) do
      false
    else
      String.at(str, 0) == String.at(str, 3) && String.at(str, 1) == String.at(str, 2)
    end
  end

  @doc """
      iex> Day7.is_aba?("aba")
      true
      
      iex> Day7.is_aba?("aaa")
      false
      
      iex> Day7.is_aba?("abd")
      false
  """  
  def is_aba?(str) do
    if String.at(str, 0) == String.at(str, 1) do
      false
    else
      String.at(str, 0) == String.at(str, 2)
    end
  end
  
  @doc """
      iex> Day7.revert("aba")
      "bab"
  """
  def revert(str) do
    String.at(str, 1) <> String.at(str, 0) <> String.at(str, 1)
  end

  @doc """
      iex> Day7.expand("abbaqrst")
      ["abba", "bbaq", "baqr", "aqrs", "qrst"]
  """
  def expand(str, length \\ 4) do
    str
    |> String.graphemes
    |> Enum.chunk_every(length, 1, :discard)
    |> Enum.map(&Enum.join/1)
  end
  
  @doc """
      iex> Day7.split("abba[mnop]qrst")
      [["abba", "qrst"], ["mnop"]]
      
      iex> Day7.split("abba[mnop]qrst[asdf]")
      [["abba", "qrst"], ["mnop", "asdf"]]
  """
  def split(ip) do
    res = Regex.scan(~r/\[([a-zA-Z]*)\]/, ip) |> Enum.map(fn list -> List.last(list) end)
    rests =
      res
      |> Enum.reduce({[], ip}, fn substr, {acc, str} ->
        splits = String.split(str, "[#{substr}]")
        {[List.first(splits) | acc], List.last(splits)}
      end)
      
    all_rest = Enum.reverse([elem(rests, 1) | elem(rests, 0)])
    |> Enum.filter(fn str ->
      str != ""
    end)
    [all_rest, res]
  end
end
