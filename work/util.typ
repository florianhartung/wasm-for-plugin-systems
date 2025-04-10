#let in-outline = state("in-outline", false)

#let setup(contents) = {
  show outline: it => {
    in-outline.update(true)
    it
    in-outline.update(false)
  }
  contents
}

#let flex-caption(long, short) = context if in-outline.get() { short } else { long }