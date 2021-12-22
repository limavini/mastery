defmodule Mastery.Core.Question do
  @moduledoc """
  asked (String.t)
  The question text for a user. For example, "1 + 2".

  template (Template.t)
  The template that created the question.

  substitutions (%{ substitution: any})
  The values chosen for each substitution field in a template.
  For example, for a template <%= left %> + <%= right %>, the substitutions might be %{ "left" => 1, "right" => 2}.”
  """

  alias Mastery.Core.Template
  defstruct ~w[asked substitutions template]a

  def new(%Template{} = template) do
    template.generators
    |> Enum.map(&build_substituion/1)
    |> evaluate(template)
  end

  defp evaluate(substitutions, template) do
    %__MODULE__{
      asked: compile(template, substitutions),
      substitutions: substitutions,
      template: template
    }
  end

  defp compile(template, substitutions) do
    template.compiled
    |> Code.eval_quoted(assigns: substitutions)
    |> elem(0)
  end

  def build_substituion({name, choices_or_generator}) do
    {name, choose(choices_or_generator)}
  end

  defp choose(choices) when is_list(choices) do
    Enum.random(choices)
  end

  defp choose(generator) when is_function(generator) do
    generator.()
  end
end
