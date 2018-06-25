Pry.config.pager = true
Pry.config.color = true
Pry.config.history.should_save = true

# Pry.config.prompt = [ proc { "ruby> "},
#                       proc { "    | "}]

# === CUSTOM PROMPT ===
# This prompt shows the ruby version (useful for RVM)
prompt_proc = lambda do |obj, nest_level, _|
  ruby_info = ""
  ruby_info << "#{Rails.version}@" if defined?(Rails)
  ruby_info << RUBY_VERSION
  ruby_info = "\e[32m#{ruby_info}\e[0m"
  "ruby [#{ruby_info}] > "
end

Pry.prompt = [prompt_proc, prompt_proc]
