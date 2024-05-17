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

void main() {
  auto cin = new Scanner();
  {{_cursor_}}
}
