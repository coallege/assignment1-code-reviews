// ── Theme definitions ──────────────────────────────────────────────────────────
#let themes = (
  purple: (bg: rgb("#f2e9f2"), fr: rgb("#74007b")),
  teal:   (bg: rgb("#e9f2f0"), fr: rgb("#007070")),
  brown:  (bg: rgb("#f2efe9"), fr: rgb("#7b5700")),
  red:    (bg: rgb("#f0e5e5"), fr: rgb("#af0101")),
  gray:   (bg: rgb("#f1f1f1"), fr: rgb("#7e7676")),
)

// Internal state to share theme colors with problem/solution functions
#let _theme-state = state("assignment-theme", themes.teal)

// ── Assignment template ────────────────────────────────────────────────────────
// Parameters:
//   author, email, roll   — single-author shorthand (default)
//   num-of-authors        — set > 1 to enable multi-author table layout
//   authors               — array of (name, email, roll) dicts (required when num-of-authors > 1)
//   theme                 — theme name string ("teal", "purple", …) or custom (bg: …, fr: …) dictionary
//   font-size, font-family — document-wide typography overrides
#let assignment(
  title: "Assignment",
  author: "Student Name",
  roll: "123456",
  num-of-authors: 1,
  authors: none,
  course: "Course Name",
  date: datetime.today().display(),
  theme: "teal",
  font-size: 11pt,
  font-family: "Linux Libertine",
  body
) = {
  // Resolve theme colors
  let colors = if type(theme) == str { themes.at(theme) } else { theme }
  _theme-state.update(colors)

  // Resolve author list
  let author-list = if authors != none { authors }
    else { ((name: author, roll: roll),) }

  set document(title: title, author: author-list.map(a => a.name))
  set page(paper: "a4", margin: (x: 1.5cm, y: 2cm))
  set text(font: font-family, size: font-size, lang: "en")
  set par(justify: true, first-line-indent: 0pt)

  if num-of-authors > 1 {
    // ── Multi-author table header ──────────────────────────────────────────
        align(center)[*Course:* #course]
        v(-0.5cm)
        align(center)[#text(weight: "bold", size: 14pt)[#title]]
        v(-0.4cm)
        align(center)[*Date:* #date]
        v(-0.1cm)
        line(length: 100%, stroke: 1.5pt)
        v(-0.3cm)
    table(
      columns: (1fr,) * num-of-authors,
      align: center + horizon,
      stroke: 0pt,
      inset: 3pt,
      // Author names
      ..author-list.map(a => text(weight: "bold")[#a.name]),
      // Author roll numbers
      ..author-list.map(a => text()[Roll: #a.roll]),
    )
  } else {
    // ── Single-author header ───────────────────────────────────────────────
    let a = author-list.at(0)
    grid(
      columns: (1fr, 1fr),
      gutter: 1em,
      align(left)[
        #text(size: 14pt, weight: "bold")[#a.name] \
      ],
      align(right)[
        #text(size: 14pt, weight: "bold")[#title] \
        Course: #text(size: 11pt)[#course] \
        Date: #date
      ]
    )
  }
  v(0.1cm)
  body
}

// ── Problem box ────────────────────────────────────────────────────────────────
#let problem-counter = counter("problem")
#let problem(title: none, body) = {
  context {
    let colors = _theme-state.get()
    let p-num = problem-counter.display()
    block(
      width: 100%,
      fill: colors.bg,
      stroke: (left: 2pt + colors.fr),
      radius: 5pt,
      inset: (top: 0.5em, bottom: 0.5em, left: 1em, right: 1em),
      breakable: true,
      [
        #text(fill: colors.fr, weight: "bold")[Part #p-num]
        #if title != none [#text(fill: colors.fr)[#title]]
        #parbreak()
        #body
      ]
    )
  }
}

// ── Solution block ─────────────────────────────────────────────────────────────
#let solution(body) = {
  context{
  let colors = _theme-state.get()
  block(
    width: 100%,
    breakable: true,
    inset: (top: 0.5em, bottom: 0.5em, left: 1.5em, right: 1em),
    [
      #text(style: "italic", weight: "bold")[Solution:]
      #parbreak()
      #body
    ]
  )}
  v(0.5cm)
}

#let ma(..sink) = $mat(delim: "[", align: #right, ..sink)$

#show: assignment.with(
  title: "Assignment 1",
  author: "Nicola Gannon",
  course: "CSE 242",
)

== Part 1

$
  A = ma(
    3, 4;
    2, 1
  )
  " "
  B = ma(
    1, 2;
    0, -1
  )
$

#problem-counter.step()

#problem(title: "Q1")[
  Compute $A B$, $B A$, $(A + B)^T$, $A B^T$, $"trace"(A)$, $"trace"(A B)$.
]

#solution[
  #table(columns: (auto, auto), row-gutter: 4em, stroke: none, align: bottom)[
    $
      A B_1&=1A_1+0A_2 \
            & =A_1 \
            & = ma(3;2) \
            \
      A B_2 & = 2A_1 -1A_2 \
            & = ma(6;4) - ma(4; 1) \
            & = ma(2; 3)
            \
      bold(A B &= [A B_1 " " A B_2] = ma(
        3, 2;
        2, 3
      )) \
    $
  ][
    OK now you can see that I know how to do matrix multiplication so I will do the rest in an easier to write way.
    \
    \
    \
    \
    $
      ma(
        3 ma(1; 0)+ 2 ma(2; -1) " " 4 ma(1; 0) + 1 ma(2; -1)
      ) \
      ma(
        ma(3; 0) + ma(4; -2) " " ma(4; 0) + ma(2; -1)
      ) \
      ma(
        ma(7; -2) " " ma(6; -1)
      ) \
      bold(B A = ma(
        7, 6;
        -2, -1
      ))
    $
  ][
    $
      A + B &= ma(
        4, 6;
        2, 0
      ) \
      bold(
      (A + B)^T &= ma(
        4, 2;
        6, 0
      ))
    $
  ][
    $
      B^T &= ma(
        1, 0;
        2, -1;
      )
      \
      A B^T &= ma(
        ma(3, 4) · ma(1, 2), " ", ma(3, 4) · ma(0, -1);
        ma(2, 1) · ma(1, 2), " ", ma(2, 1) · ma(0, -1)
      ) \
      &= ma(
        3 + 8, -4;
        2 + 2, -1
      ) \
      &= bold(ma(
        11, -4;
        4, -1
      ))
    $
  ]
  The trace wuz sum of the diagonals right? $bold("trace"(A)=4)$, $bold("trace"(A B)=6)$
]

#problem(title: "Q2")[
  For the following matrix: $ M = ma(2, -1; -1, 2) $
  Calculate the eigenstuff, then verify.
]

*I admittedly looked up how to solve for eigenvectors:*

The steps seem to be:
1. Solve $"det"(M-λ I)=0$ to get eigenvalues
  - I remember there was a nice way to get the determinant of a 2x2 matrix.\
    Something like $a d-b c$. I'll verify this online.
2. Solve $(M-λ I)v = 0$ to get the eigenvectors

#solution[
  #table(columns: (auto, auto, auto), column-gutter: 4em, stroke: none)[
    $
      "det"(M-λ I)&="det"(ma(2-λ, -1; -1, 2-λ)) \
      &=(2-λ)^2-1 \
      &=λ^2-4λ+3 \
      \
      λ&=frac(4 ± sqrt((-4)^2 -4(1)(3)), 2(1)) \
        &=frac(4 ± sqrt(16 -12), 2) \
        &=frac(4 ± 2, 2) \
      bold(λ&=2 ± 1 = {1, 3})
    $
  ][
    Case 1:
    $
      ma(2-1, -1; -1, 2-1)v₁&=0 \
      ma(1, -1; -1, 1)v₁&=0\
      v₁₁-v₁₂ & = 0 \
      v₁₁&=v₁₂\
      bold(v₁ &= ma(1; 1))
    $
  ][
    Case 2:
    $
      ma(2-3, -1; -1, 2-3)v₂&=0 \
      ma(-1, -1; -1, -1)v₂&=0 \
      -v₂₁-v₂₂&=0 \
      -v₂₁&=v₂₂ \
      bold(v₂ &= ma(-1; 1))
    $
  ]
]

#problem(title: "Q3")[
  Prove that $∀A B, "trace"(A B) = "trace"(B A)$
]

#import "@preview/mannot:0.3.1": markrect

#solution[
  $A$ and $B$ must be square matrices by premise. Let $A B = C$ and $B A = C'$.
  Generally, matrix multiplication for an arbitrary A and B of size $n^2$ is $ C_(i j) = sum_(k=1)^n A_(i k)B_(k j) $
  We recall the definition of a trace of a matrix $A$ of size $n^2$:
  $
    "trace"(A) = ∑_(i = 1)^n A_(i i)
  $
  Unfold the definitions of trace and matrix multiplication in our goal.
  $
    ⊢ ∑_(i=1)^n∑_(k=1)^n A_(i k) B_(k i) = ∑_(i=1)^n∑_(k=1)^n B_(i k) A_(k i) \
  $
  Rewrite by add commutativity, swapping the order of the sums on the RHS:
  $
    ⊢ ∑_(i=1)^n∑_(k=1)^n A_(i k) B_(k i) = ∑_(k=1)^n∑_(i=1)^n B_(i k) A_(k i) \
  $
  We recognize that $i$ and $k$ are bound and are local to their respective $∑$s.
  $
    ⊢ markrect(∑_markrect(i=1)^n markrect(∑_markrect(k=1)^n A_(i k) B_(k i) ))= markrect(∑_markrect(k=1)^n markrect(∑_markrect(i=1)^n B_(i k) A_(k i))) \
  $
  Therefore their names are relevant only within their boxes. Our ultimate goal is to show α-equivalence and so I will:
  - On the left, rewrite $i → ⋆, k → ⋄$
  - On the right, rewrite $i → ⋄, k → ⋆$
  $
    ⊢ markrect(∑_markrect(⋆=1)^n markrect(∑_markrect(⋄=1)^n A_(⋆ ⋄) B_(⋄ ⋆) ))= markrect(∑_markrect(⋆=1)^n markrect(∑_markrect(⋄=1)^n B_(⋄ ⋆) A_(⋆ ⋄))) \
  $
  Scalar multiplication has commutativity, and so rewrite $B_(⋄ ⋆) A_(⋆ ⋄) → A_(⋆ ⋄) B_(⋄ ⋆)$
  $
    ⊢ ∑_(⋆=1)^n ∑_(⋄=1)^n A_(⋆ ⋄) B_(⋄ ⋆)= ∑_(⋆=1)^n ∑_(⋄=1)^n A_(⋆ ⋄) B_(⋄ ⋆) \
  $
  Reflexivity. QED.
]

#problem(title: "Q4")[
  Compute the inverse of $ C = ma(4, 7; 2, 6) $
]

#solution[
  $
    ma(4, 7, 1, 0; 2, 6, 0, 1) & " " & (r₂)/2 -> & ma(4, 7, 1, 0; 2/2, 6/2, 0/2, 1/2)\
    ma(4, 7, 1, 0; 1, 3, 0, 1/2) &  & r₁-4r₂ -> & ma(4 - 4*1, 7 - 4*3, 1-4*0, 0-4*1/2; 1, 3, 0, 1/2) \
    & & = & ma(0, 7-12, 1, -2; 1, 3, 0, 1/2) & &\
    ma(0, -5, 1, -2; 1, 3, 0, 1/2) & & (r₁)/ (-5) -> & ma(0, (-5)/(-5), 1/(-5), (-2)/(-5); 1, 3, 0, 1/2) \
    ma(0, 1, -1/5, 2/5; 1, 3, 0, 1/2) & & r₂ -3r₁ -> & ma(0, 1, -1/5, 2/5; 1, 0, 3/5, 1/2-6/5 = 5/10-12/10) \
    ma(0, 1, -1/5, 2/5; 1, 0, 3/5, -7/10) & & r₁ <->r₂ -> & bold(ma(3/5, -7/10; -1/5, 2/5))\
  $
]

#problem-counter.step()

== Part 2

#problem(title: "Q1")[
Suppose a random variable $X$ follows a discrete distribution:

$
P(X=k)=c · (3^k)/(k!), k=0,1,2, …
$

(a) Find the normalization constant $c$.

(b) Compute the expectation $E[X]$ and variance $"Var"(X)$.
]

#solution[
  $
  1&=∑_(k=0)^∞ c (3^k)/k! \
  1&=c ∑_(k=0)^∞ (3^k)/k!
$

We recall that the taylor series of $e^x = ∑_(k=0)^∞ (x^k)/k!$ and so the above product must be $c e^3$ and $bold(c≔e^(-3))$.

Just to restate it:

$
  P(X=k)=e^(-3) (3^k)/(k!)
$

Expectation in this case would be:

#align(center)[
#table(columns: (auto, auto), column-gutter: 7em, stroke: none)[
  $
    E[X]=& ∑_(k=0)^∞ k e^(-3) (3^k)/k! \
    =& cancel(0 e^(-3) (3^0)/0!) + ∑_(k=1) k e^(-3) (3^k)/k! \
    =& ∑_(k=1)^∞ e^(-3) (3^k)/(k-1)! \
    =& e^(-3) ∑_(k=1)^∞ (3^k)/(k-1)! \
  $
][
  $
  =& e^(-3) ∑_(k=1)^∞ 3 * 3^(k-1)/(k-1)! \
  =& 3e^(-3) ∑_(k=1)^∞ 3^(k-1)/(k-1)! \
  =& 3e^(-3) ∑_(k=0)^∞ 3^k/k! \
  =& 3e^(-3)e^3 \
  bold(=& 3)
  $
]
]
]

#solution[
  I have no idea how to solve this.
]

#problem(title: "Q2")[
  Given two events $A$ and $B$ with $P(A)=0.5$, $P(B)=0.3$, and $P(A ∣ B)=0.6$, compute the following:

  (a) $P(A ∩ B)$,

  (b) $P(B ∣ A)$,

  (c) $P(A ∪ B)$.
]

#solution[
  #table(columns: (auto, auto, auto), column-gutter: 2em, stroke: none)[
    $
      P(A | B) &= P(A ∩ B)/P(B) \
      0.6 &= P(A ∩ B)/0.3 \
      bold(0.6 * 0.3 = 0.18 &= P(A ∩ B))
    $
  ][
    $
      P(B|A) &= P(A ∩ B)/P(A) \
      bold(&= 0.18/0.5 = 0.36) \
    $
  ][
    $
      P(&A ∪ B) \
        & = P(A) + P(B) - P(A ∩ B) \
        & = 0.5 + 0.3 - 0.18 \
        bold(& = 0.62)
    $
  ]
]

#problem(title: "Q3")[
  Suppose you have a biased coin with unknown probability of heads $θ=P(H)$. You flip this coin 5 times and observe the sequence: H, H, T, H, T.

  (a) Derive the Maximum Likelihood Estimate (MLE) for $θ$, showing each step from the likelihood function.

  (b) Compute the Maximum a Posteriori (MAP) estimate for $θ$, assuming a prior distribution:

  $
  P(θ) = cases(
    2θ & "," 0 ≤ θ ≤ 1,
    0 & "," "otherwise"
  )
  $
]

#solution[
  $
    L(θ) &= θ^3*(1-θ)^2 = θ^5-2θ^4+θ^3 \
    L'(θ) &= 5θ^4 - 8θ^3 - 3θ^2 = θ^2(5θ^2-8θ+3)
  $
  Ok and now we cheat a little bit because obviously $θ=0$ is a solution to $L'(θ)=0$ but that would mean the probability of heads is zero, so that's crazy. So we know that the right product must be zero:
  $
    0 = (5θ^2-8θ+3) \
  $
  And this is a quadratic equation so now we just use the quadratic equation formula. I don't wanna write it up. The first result is 1, which is also crazy, so we will use $b-$, which is $bold(θ=0.6)$.
]

#solution[
  Unsolved. I have no idea what this is.
]

#problem(title: "Q4")[
  Consider a Gaussian distribution with parameters $μ$ (mean) and $σ^2$ (variance). Given the dataset $X={1,3,5,7}$, derive the Maximum Likelihood Estimates (MLE) for both $μ$ and $σ^2$. Show each mathematical step clearly.
]

#problem(title: "Q5")[
  You observe samples drawn from a Gaussian distribution with unknown mean $μ$ and known variance $σ^2=4$. Given a Gaussian prior for the mean $μ$:
]


#problem(title: "Q6")[
  Prove the variance expansion identity:

  $
  "Var"(X)=E(X^2)-[E(X)]^2
  $
]

#solution[
  We recall that in all cases, expectation is a sum, and so the usual rules apply.
  $
    "Var"(X)&=E[(X-E[X])^2] \
    &=E[X^2-2X E[X] +E[X]^2]
  $
  Expectation of a constant is a constant soooo
  $
    &=E[X^2] -2E[X]E[X] +E[X]^2 \
    &=E[X^2] +E[X]^2 -2E[X]^2 \
    bold(&=E[X^2] - E[X]^2)
  $
]

#problem-counter.step()

#problem(title: "Q1")[
  Given a dataset represented by a random vector $X$, derive the mathematical expression for the variance of the projection onto a unit vector $u$:

  $
  "Var"(u^T X)=u^T Σ u
  $
]
