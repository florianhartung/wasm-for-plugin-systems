#let todo(c) = {
  if c.fields().len() == 0 {
    c = [TODO]
  } else {
    c = [TODO: ] + c
  }
  text(red, weight: "bold", style: "italic", c)
};
