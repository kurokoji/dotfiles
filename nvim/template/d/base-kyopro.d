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
// ModInt {{{
struct ModInt(ulong modulus) {
  import std.traits : isIntegral, isBoolean;
  import std.exception : enforce;

  private {
    ulong val;
  }

  this(const ulong n) {
    val = n % modulus;
  }

  this(const ModInt n) {
    val = n.value;
  }

  @property {
    ref inout(ulong) value() inout {
      return val;
    }
  }

  T opCast(T)() {
    static if (isIntegral!T) {
      return cast(T)(val);
    } else if (isBoolean!T) {
      return val != 0;
    } else {
      enforce(false, "cannot cast from " ~ this.stringof ~ " to " ~ T.stringof ~ ".");
    }
  }

  ModInt opAssign(const ulong n) {
    val = n % modulus;
    return this;
  }

  ModInt opOpAssign(string op)(ModInt rhs) {
    static if (op == "+") {
      val += rhs.value;
      if (val >= modulus) {
        val -= modulus;
      }
    } else if (op == "-") {
      if (val < rhs.value) {
        val += modulus;
      }
      val -= rhs.value;
    } else if (op == "*") {
      val = val * rhs.value % modulus;
    } else if (op == "/") {
      this *= rhs.inv;
    } else if (op == "^^") {
      ModInt res = 1;
      ModInt t = this;
      while (rhs.value > 0) {
        if (rhs.value % 2 != 0) {
          res *= t;
        }
        t *= t;
        rhs /= 2;
      }
      this = res;
    } else {
      enforce(false, op ~ "= is not implemented.");
    }

    return this;
  }

  ModInt opOpAssign(string op)(ulong rhs) {
    static if (op == "+") {
      val += ModInt(rhs).value;
      if (val >= modulus) {
        val -= modulus;
      }
    } else if (op == "-") {
      auto r = ModInt(rhs);
      if (val < r.value) {
        val += modulus;
      }
      val -= r.value;
    } else if (op == "*") {
      val = val * ModInt(rhs).value % modulus;
    } else if (op == "/") {
      this *= ModInt(rhs).inv;
    } else if (op == "^^") {
      ModInt res = 1;
      ModInt t = this;
      while (rhs > 0) {
        if (rhs % 2 != 0) {
          res *= t;
        }
        t *= t;
        rhs /= 2;
      }
      this = res;
    } else {
      enforce(false, op ~ "= is not implemented.");
    }

    return this;
  }

  ModInt opUnary(string op)() {
    static if (op == "++") {
      this += 1;
    } else if (op == "--") {
      this -= 1;
    } else {
      enforce(false, op ~ " is not implemented.");
    }
    return this;
  }

  ModInt opBinary(string op)(const ulong rhs) const {
    mixin("return ModInt(this) " ~ op ~ "= rhs;");
  }

  ModInt opBinary(string op)(ref const ModInt rhs) const {
    mixin("return ModInt(this) " ~ op ~ "= rhs;");
  }

  ModInt opBinary(string op)(const ModInt rhs) const {
    mixin("return ModInt(this) " ~ op ~ "= rhs;");
  }

  ModInt opBinaryRight(string op)(const ulong lhs) const {
    mixin("return ModInt(this) " ~ op ~ "= lhs;");
  }

  long opCmp(ref const ModInt rhs) const {
    return cast(long)value - cast(long)rhs.value;
  }

  bool opEquals(const ulong rhs) const {
    return value == ModInt(rhs).value;
  }

  ModInt inv() const {
    ModInt ret = this;
    ret ^^= modulus - 2;
    return ret;
  }

  string toString() const {
    import std.format : format;

    return format("%s", val);
  }
}
// }}}
// alias {{{
alias Heap(T, alias less = "a < b") = BinaryHeap!(Array!T, less);
alias MinHeap(T) = Heap!(T, "a > b");

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
  auto cin = new Scanner;
  {{_cursor_}}
}
