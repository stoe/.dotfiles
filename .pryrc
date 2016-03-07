Pry.config.pager = true
Pry.config.color = true
Pry.config.history.should_save = true

Pry.config.prompt = [ proc { "ruby> "},
                      proc { "    | "}]
