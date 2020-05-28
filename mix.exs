defmodule ExAws.SageMakerRuntime.MixProject do
  use Mix.Project

  @name __MODULE__ |> Module.split() |> Enum.take(2) |> Enum.join(".")
  @version "1.0.1"
  @url "https://github.com/dideler/ex_aws_sagemaker_runtime"
  @ex_aws_services_hex_url "https://hex.pm/packages?search=ex_aws&sort=total_downloads"
  @ex_aws_services_github_url "https://github.com/search?l=Elixir&q=%22ex_aws%22+in%3Aname&type=Repositories"

  def project do
    [
      app: :ex_aws_sagemaker_runtime,
      version: @version,
      elixir: "~> 1.6",
      package: package(),
      docs: [main: @name, source_ref: "v#{@version}", source_url: @url],
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  defp package do
    [
      description: "#{@name} service package",
      files: ["lib", "mix.exs", "README*", "LICENSE", "CHANGELOG.md"],
      maintainers: ["Dennis Ideler"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => @url,
        "Other ExAws services on Hex" => @ex_aws_services_hex_url,
        "Other ExAws services on GitHub" => @ex_aws_services_github_url
      }
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.20", only: :dev, runtime: false},
      {:ex_aws, "~> 2.1.1"}
    ]
  end
end
