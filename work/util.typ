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


/// Quick and dirty binary size printing
#let format-binary-size(n) = {
  if n < 1000 {
    [#calc.round(n) B]
  } else if n < 1000000 {
    [#calc.round(n / 1000) KB]
  } else if n < 100000000 {
    [#calc.round(n / 1000000) MB]
  } else {
    [#calc.round(n / 1000000000) GB]
  }
}

/// Last category is always other. Pass the total size as the last value and the size of other will be calculated automatically.
#let stacked-bar-chart(categories, values, category_colors: i => gradient.linear(..color.map.rainbow).sample(i * 10%)) = {
  let category_colors = categories.enumerate().map(((i, _)) => category_colors(i))
  category_colors.last() = color.gray

  let values = values.pairs()
    .map(((k, v)) => {
      v.last() = 2 * v.last() - v.sum()
      (k, v)
    })
    .to-dict()

  let bars = grid(
    columns: (auto, 1fr),
    gutter: 0.5em,
    ..values.pairs().map(((k, v)) => (
      align(horizon + right, [#k (#format-binary-size(v.sum()))]), 
      grid(
        columns: v.map(x => x * 1fr),
        gutter: 0pt,
        ..v.enumerate().map(((i, x)) => rect(height: 1.4em, width: 100%, fill: category_colors.at(i))),
      )
    )).flatten()
  )

  let categories = categories.zip(category_colors)
    .map(((name, color)) => stack(dir: ltr, spacing: 0.2em, square(size: 0.8em, fill: color), name))
    .chunks(3)
    .map(chunk => stack(dir: ltr, spacing: 0.8em, ..chunk))
    .sum()

  bars + categories + v(1em)
}