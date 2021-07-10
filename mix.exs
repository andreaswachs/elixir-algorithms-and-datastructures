defmodule EADS.MixProject do
  use Mix.Project

  def project do
    [
      app: :eads,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      package: package(),
      deps: deps(),

      description: description(),
      # Docs
      name: "Elixir Algorithms and Data Structures (eads)",
      source_url: "https://github.com/andreaswachs/elixir-algorithms-and-datastructures",
      homepage_url: "https://andreaswachs.github.io/project/eads",
      docs: [
        extras: ["README.md"]
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp description() do
    "This is a library where algorithms and data structures will be implemented. "
    <> "The university course in algorithms and data structures will be my main "
    <> "source of ideas for stuff to implement."
  end

  defp package() do
    [
      # This option is only needed when you don't want to use the OTP application name
      name: "eads",
      # These are the default files included in the package
      files: ~w(lib mix.exs README* LICENSE* CHANGELOG*),
      licenses: ["MIT License"],
      links: %{"GitHub" => "https://github.com/andreaswachs/elixir-algorithms-and-datastructures"}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
      {:credo, "~> 1.5"},
      {:ex_doc, "~> 0.24", only: :dev, runtime: false}
    ]
  end
end
