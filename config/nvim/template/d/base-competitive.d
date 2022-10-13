// import chie template :) {{{
static if (__VERSION__ < 2090) {
  import std.stdio, std.algorithm, std.array, std.string, std.math, std.conv,
  std.range, std.container, std.bigint, std.ascii, std.typecons, std.format,
  std.bitmanip, std.numeric;
} else {
  import std;
}

// }}}
// nep.scanner {{{
class Scanner {
  import std.stdio : File, stdin;
  import std.conv : to;
  import std.array : split;
  import std.string;
  import std.traits : isSomeString;

  private File file;
  private char[][] str;
  private size_t idx;

  this(File file = stdin) {
    this.file = file;
    this.idx = 0;
  }

  this(StrType)(StrType s, File file = stdin) if (isSomeString!(StrType)) {
    this.file = file;
    this.idx = 0;
    fromString(s);
  }

  private char[] next() {
    if (idx < str.length) {
      return str[idx++];
    }

    char[] s;
    while (s.length == 0) {
      s = file.readln.strip.to!(char[]);
    }

    str = s.split;
    idx = 0;

    return str[idx++];
  }

  T next(T)() {
    return next.to!(T);
  }

  T[] nextArray(T)(size_t len) {
    T[] ret = new T[len];

    foreach (ref c; ret) {
      c = next!(T);
    }

    return ret;
  }

  void scan(T...)(ref T args) {
    foreach (ref arg; args) {
      arg = next!(typeof(arg));
    }
  }

  void fromString(StrType)(StrType s) if (isSomeString!(StrType)) {
    str ~= s.to!(char[]).strip.split;
  }
}
// }}}
// alias {{{
alias Heap(T, alias less = "a < b") = BinaryHeap!(Array!T, less);
alias MinHeap(T) = Heap!(T, "a > b");
alias Deque(T) = DList!T;
alias Queue(T) = DList!T;

// }}}
// memo {{{
/*

  - ある値が見つかるかどうか
    <https://dlang.org/phobos/std_algorithm_searching.html#canFind>

    canFind(r, value); -> bool

  - 条件に一致するやつだけ残す
    <https://dlang.org/phobos/std_algorithm_iteration.html#filter>

    // 2で割り切れるやつ
    filter!"a % 2 == 0"(r); -> Range

  - 合計
    <https://dlang.org/phobos/std_algorithm_iteration.html#sum>

    sum(r);

  - 累積和
    <https://dlang.org/phobos/std_algorithm_iteration.html#cumulativeFold>

    // 今の要素に前の要素を足すタイプの一般的な累積和
    // 累積和のrangeが帰ってくる(破壊的変更は行われない)
    cumulativeFold!"a + b"(r, 0); -> Range

  - rangeをarrayにしたいとき

    array(r); -> Array

  - 各要素に同じ処理をする
    <https://dlang.org/phobos/std_algorithm_iteration.html#map>

    // 各要素を2乗
    map!"a * a"(r) -> Range

  - ユニークなやつだけ残す
    <https://dlang.org/phobos/std_algorithm_iteration.html#uniq>

    uniq(r) -> Range

  - 順列を列挙する
    <https://dlang.org/phobos/std_algorithm_iteration.html#permutations>

    permutation(r) -> Range

  - ある値で埋める
    <https://dlang.org/phobos/std_algorithm_mutation.html#fill>

    fill(r, val); -> void

  - バイナリヒープ
    <https://dlang.org/phobos/std_container_binaryheap.html#.BinaryHeap>

    // 昇順にするならこう(デフォは降順)
    BinaryHeap!(Array!T,  "a > b") heap;
    heap.insert(val);
    heap.front;
    heap.removeFront();


  - 浮動小数点の少数部の桁数設定

    // 12桁
    writefln("%.12f", val);

  - 浮動小数点の誤差を考慮した比較
    <https://dlang.org/phobos/std_math.html#.approxEqual>

    approxEqual(1.0, 1.0099); -> true

  - 小数点切り上げ
    <https://dlang.org/phobos/std_math.html#.ceil>

    ceil(123.4); -> 124

  - 小数点切り捨て
    <https://dlang.org/phobos/std_math.html#.floor>

    floor(123.4) -> 123

  - 小数点四捨五入
    <https://dlang.org/phobos/std_math.html#.round>

    round(4.5) -> 5
    round(5.4) -> 5

*/
// }}}

void main() {
  auto cin = new Scanner();
  {{_cursor_}}
}
