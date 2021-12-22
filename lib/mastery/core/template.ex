defmodule Mastery.Core.Template do
  @moduledoc """
  name (atom)
  The name of this template.

  category (atom)
  A grouping for questions of the same name.

  instructions (string)
  A string telling the user how to answer questions of this type.

  raw (string)
  The template code before compilation.

  compiled (macro)
  The compiled version of the template for execution.

  generators (%{ substitution: list or function})
  The generator for each substitution in a template. Each generator is a list of elements or a function.
  Generating a template substitution will either fire the function or pick a random item from the list.

  checker (function(substitutions, string) -> boolean)
  Given the substitutions strings and an answer, the function returns true if the answer is correct.
  For example, fn subs, answer -> to_string(subs.left + subs.right) == String.trim(answer) end).

  """
  defstruct ~w[name category instructions raw compiled generators checker]a

  def new(fields) do
    raw = Keyword.fetch!(fields, :raw)
    struct!(__MODULE__, Keyword.put(fields, :compiled, EEx.compile_string(raw)))
  end
end
