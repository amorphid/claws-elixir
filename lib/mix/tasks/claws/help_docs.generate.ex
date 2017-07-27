defmodule Mix.Tasks.Claws.HelpDocs.Generate do
  @shortdoc "Generate help docs"

  use Mix.Task

  #######
  # API #
  #######

  @doc """
  TODO: Creating all help docs
  """
  def run(_) do
    {doc,0} = System.cmd("aws", ["help"])
    :ok = File.mkdir_p!(dir_path())
    file_path = file_path("aws_help.bin")
    contents = :erlang.term_to_binary(doc)
    :ok = File.write!(file_path, contents)
  end

  ###########
  # Private #
  ###########

  defp dir_path() do
    Path.join(["_build", Atom.to_string(Mix.env()), "lib", "claws", "helpdocs"])
  end

  defp file_path(file) do
    Path.join(dir_path(), file)
  end
end
