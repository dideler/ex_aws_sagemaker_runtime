# ExAws.SageMakerRuntime

[![Hex.pm](https://img.shields.io/hexpm/v/ex_aws_sagemaker_runtime.svg)](https://hex.pm/packages/ex_aws_sagemaker_runtime)
[![Build Docs](https://img.shields.io/badge/hexdocs-release-blue.svg)](https://hexdocs.pm/ex_aws_sagemaker_runtime/ExAws.html)


[ExAws](https://github.com/ex-aws/ex_aws) service for [AWS SageMaker Runtime](https://docs.aws.amazon.com/sagemaker/latest/dg/API_Operations_Amazon_SageMaker_Runtime.html).

Use it for inference with models deployed on SageMaker.

## API Coverage

- [InvokeEndpoint](https://docs.aws.amazon.com/sagemaker/latest/dg/API_runtime_InvokeEndpoint.html)

## Installation

Add the `ex_aws_sagemaker_runtime` service package to your list of dependencies in `mix.exs`.  
It depends on the `ex_aws` core package. It's recommended to make it an explicit dependency.  
You'll also need a compatible HTTP client (`ex_aws` defaults to `hackney`).


```elixir
def deps do
  [
    {:ex_aws, "~> 2.1"},
    {:ex_aws_sagemaker_runtime, "~> 1.0"},
    {:hackney, "~> 1.15"},
  ]
end
```

## Configuration

`ExAws.SageMakerRuntime` is configured through `ExAws`. See the documentation for `ExAws`
for configuring access credentials, region, HTTP client, and so on.

Here is a basic example configuration that could go in your `config/{config,dev,test,prod}.exs`.
```elixir
config :ex_aws, :sagemaker_runtime,
  debug_requests: true,
  region: "eu-west-1",
  access_key_id: [{:system, "AWS_ACCESS_KEY_ID"}, :instance_role],
  secret_access_key: [{:system, "AWS_SECRET_ACCESS_KEY"}, :instance_role]
```

## Usage

All SageMaker Runtime API actions need to call [`ExAws.request/2`](https://hexdocs.pm/ex_aws/ExAws.html#request/2).
```elixir
DataScience.ExAws.SageMakerRuntime.invoke_endpoint("my-model", %{query: "some-query})
|> ExAws.request()
```

A more realistic example that depends on Hackney as the underlying HTTP client and Poison for JSON.  
This example uses a function callback to handle the response body, which might be handy
when your models return their data differently.

```elixir
defmodule DataScience.Client do
  @moduledoc """
  Wrapper around HTTP requests to AWS SageMaker Runtime.
  """

  def request(endpoint, payload, opts \\ []) do
    success_handler = Keyword.get(opts, :on_success, fn body -> body end)

    response =
      ExAws.SageMakerRuntime.invoke_endpoint(endpoint, payload)
      |> ExAws.request()

    case response do
      {:ok, body} ->
        success_handler.(body)

      {:error, {:http_error, _code, %{body: body, status_code: code}}} ->
        {:error, %{code: code, reason: Poison.decode!(body)}}

      error ->
        error
    end
  end
end
```

## SageMaker Runtime vs SageMaker

[Amazon SageMaker](https://aws.amazon.com/sagemaker/) is marketed as a single product, but it consists of multiple AWS APIs.

There is the [SageMaker Runtime API][] and the [SageMaker API][].

SageMaker Runtime can be used to make inference requests against models hosted with SageMaker.

For example, you've got your own inference code and want to host it on SageMaker. You'll need to
[package your inference code in a Docker image and provide an HTTP API to handle the incoming requests](https://docs.aws.amazon.com/sagemaker/latest/dg/your-algorithms-inference-code.html).
You would use SageMaker Runtime to invoke the authenticated HTTP endpoint for your model(s) hosted on SageMaker.

[SageMaker Runtime API]: https://docs.aws.amazon.com/sagemaker/latest/dg/API_Operations_Amazon_SageMaker_Runtime.html
[SageMaker API]: https://docs.aws.amazon.com/sagemaker/latest/dg/API_Operations_Amazon_SageMaker_Service.html