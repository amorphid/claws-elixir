defmodule CLAWS.Lexxer.HelpTest do
  use ExUnit.Case, async: true

  setup_all do
    help =
      """
      AWS()                                   AWS()

      S\bSE\bEC\bCT\bTI\bIO\bON\bN O\bON\bNE\bE
             Row 1

      S\bSE\bEC\bCT\bTI\bIO\bON\bN T\bTW\bWO\bO
             Row 2

             Row 3


                                              AWS()
      """

    {:ok, tokens, _} = to_charlist(help) |> CLAWS.Lexxer.Help.string()
    context = [tokens: tokens]
    {:ok, context}
  end

  def bold?({:bold,_}), do: true
  def bold?(_), do: false

  def new_line?(:new_line), do: true
  def new_line?(_), do: false

  def utf8_charlist?([]), do: true
  def utf8_charlist?([h|t]) do
    <<_::utf8()>> = <<h>>
    utf8_charlist?(t)
  rescue
    _ -> false
  end
  def utf8_charlist?(_), do: false

  def whitespace?({:whitespace,_}), do: true
  def whitespace?(_), do: false

  test "trim leading text", c do
    assert c.tokens |> List.first() == {:bold, 'SECTION'}
  end

  test "trim trailing text", c do
    assert c.tokens |> List.last() == '3'
  end

  test "bold count", c do
    assert Enum.filter(c.tokens, &bold?/1) |> length() == 4
  end

  test "charlist count", c do
    assert Enum.filter(c.tokens, &utf8_charlist?/1) |> length() == 6
  end

  test "whitespace count", c do
    assert Enum.filter(c.tokens, &whitespace?/1) |> length() == 8
  end

  test "expected tokens", c do
    expected = [
      {:bold, 'SECTION'},
      {:whitespace, ' '},
      {:bold, 'ONE'},
      {:line_breaks, '\n'},
      {:whitespace, '       '},
      'Row',
      {:whitespace, ' '},
      '1',
      {:line_breaks, '\n\n'},
      {:bold, 'SECTION'},
      {:whitespace, ' '},
      {:bold,'TWO'},
      {:line_breaks, '\n'},
      {:whitespace, '       '},
      'Row',
      {:whitespace, ' '},
      '2',
      {:line_breaks, '\n\n'},
      {:whitespace, '       '},
      'Row',
      {:whitespace, ' '},
      '3'
    ]
    assert c.tokens == expected
  end
end
