# Access an environment variable or raise a runtime error
# if it can't be found.
$env = ->(name) {
  ENV.fetch(name) do
    raise(sprintf("Missing ENV[\"%s\"]", name))
  end
}
