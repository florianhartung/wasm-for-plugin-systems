#let show-todo = true;

#let todo(c) = {
  if show-todo {
    text(red, weight: "bold", style: "italic", [TODO: ] + c)
  }
};

#let td = if show-todo { text(red, weight: "bold", style: "italic", "TODO") }