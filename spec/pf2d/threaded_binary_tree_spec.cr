require "../spec_helper"

include PF2d

describe ThreadedBinaryTree do
  #   5   │        1   │           4   │               2   │                3
  #  .─.  │       .─.  │          .─.  │              .─.  │               .─.
  # ( 5 ) │  ┌───( 5 ) │  ┌──────( 5 ) │   ┌─────────( 5 ) │      ┌───────( 5 )
  #  `─'  │  │    `─'  │  │       `─'  │   │          `─'  │      │        `─'
  #       │  │     ▲   │  │        ▲   │   │           ▲   │      │         ▲
  #       │  ▼         │  ▼            │   ▼               │      ▼
  #       │ .─.    │   │ .─.       │   │  .─.          │   │     .─.        │
  #       │( 1 )─ ─    │( 1 )──┐       │ ( 1 )─────┐       │    ( 1 )───┐
  #       │ `─'        │ `─'   │   │   │  `─'      │   │   │     `─'    │   │
  #       │            │  │    ▼       │   │       ▼       │      │     ▼
  #       │            │      .─.  │   │  ─       .─.  │   │ ┌ ─ ─     .─.  │
  #       │            │  └ ▶( 4 )─    │ │    ┌──( 4 )─    │      ┌───( 4 )─
  #       │            │      `─'      │      │   `─'      │ │    │    `─'
  #       │            │               │ │    ▼    ▲       │      ▼     ▲
  #       │            │               │     .─.           │ │   .─.     ─ ─ ┐
  #       │            │               │ └ ▶( 2 )─ ┘       │  ─▶( 2 )───┐
  #       │            │               │     `─'           │     `─'    │    │
  #       │            │               │                   │      │     │
  #       │            │               │                   │            ▼    │
  #       │            │               │                   │      │    .─.
  #       │            │               │                   │       ─ ▶( 3 )─ ┘
  #       │            │               │                   │           `─'
  #       │            │               │                   │
  it "maintains order of inserted nodes" do
    tree = ThreadedBinaryTree(Int32).new { |a, b| a <=> b }
    tree << 5
    tree << 1
    tree << 4
    tree << 2
    tree << 3

    tree.to_a.should eq([1, 2, 3, 4, 5])
  end

  it "handles lopsided trees" do
    tree = ThreadedBinaryTree(Int32).new { |a, b| a <=> b }
    tree << 5
    tree << 6
    tree << 10
    tree << 8
    tree << 7

    tree.to_a.should eq([5, 6, 7, 8, 10])
  end

  it "prevents duplicates" do
    tree = ThreadedBinaryTree(Int32).new { |a, b| a <=> b }
    tree << 5
    tree << 4
    tree << 5
    tree << 6
    tree << 3
    tree << 3

    tree.to_a.should eq([3, 4, 5, 6])
  end

  it "optionally handles duplicates" do
    tree = ThreadedBinaryTree(Int32).new { |a, b| a >= b ? 1 : -1 }
    tree << 5
    tree << 4
    tree << 5
    tree << 6
    tree << 3
    tree << 3

    tree.to_a.should eq([3, 3, 4, 5, 5, 6])
  end
end
