/* template.cpp {{{ */
#include <cctype>
#include <climits>
#include <cmath>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <cinttypes>

#include <algorithm>
#include <bitset>
#include <complex>
#include <deque>
#include <functional>
#include <iomanip>
#include <iostream>
#include <limits>
#include <list>
#include <map>
#include <numeric>
#include <ostream>
#include <queue>
#include <set>
#include <sstream>
#include <stack>
#include <string>
#include <utility>
#include <vector>
#include <tuple>
#include <unordered_map>
#include <unordered_set>

using std::cout;
using std::endl;
using std::cin;

// clang-format off
#define GET_MACRO(_1, _2, _3, _4, NAME, ...) NAME
#define rep(...) GET_MACRO(__VA_ARGS__, rep4, rep3, rep2, rep1)(__VA_ARGS__)
#define rep1(n) rep2(_, n)
#define rep2(i, n) rep3(i, 0, n)
#define rep3(i, a, n) rep4(i, a, n, 1)
#define rep4(i, a, n, s) for (int64 i = (a); i < (int64)(n); i += (s))
#define rrep(...) GET_MACRO(__VA_ARGS__, rrep4, rrep3, rrep2, rrep1)(__VA_ARGS__)
#define rrep1(a) rrep2(_, a)
#define rrep2(i, a) rrep3(i, a, 0)
#define rrep3(i, a, n) rrep4(i, a, n, 1)
#define rrep4(i, a, n, s) for (int64 i = (a); i >= (int64)(n); i -= (s))
#define each(i, ctn) for (auto &&i : (ctn))

#define all(v) begin(v), end(v)
#define debug(x) cerr << (x) << " (L:" << __LINE__ << ")" << '\n'

using int32 = std::int_fast32_t;
using int64 = std::int_fast64_t;
using uint32 = std::uint_fast32_t;
using uint64 = std::uint_fast64_t;

template <class T> using vec = std::vector<T>;
template <class T> using heap = std::priority_queue<T>;
template <class T> using minheap = std::priority_queue<T, vec<T>, std::greater<T>>;
using vi = vec<int32>;
using vvi = vec<vi>;
using vvvi = vec<vvi>;
using pii = std::pair<int32, int32>;

int32 constexpr INF = 1001001001;
int64 constexpr LINF = 1001001001001001001ll;
int32 constexpr MOD = (int32)1e9 + 7;
double constexpr EPS = 1e-9;
double constexpr PI = M_PI;
int32 constexpr dx[] = {0, 1, 0, -1, 1, -1, 1, -1}, dy[] = {1, 0, -1, 0, 1, -1, -1, 1};

inline bool inside(int32 y, int32 x, int32 h, int32 w) { return y >= 0 && x >= 0 && y < h && x < w; }
template <class T> inline void print(T const& x) { std::cout << x << '\n'; }
template <class T> inline void print(vec<T> const& v, std::string d = "\n") { rep(i, v.size()) std::cout << v[i] << (i == (int64)(v.size() - 1) ? "\n" : d); }
template <class T, class... Args> inline void print(T const& x, Args const&... trail) {
  std::cout << x << " ";
  print(trail...);
}
template <class T = int32> inline T in() { T x; std::cin >> x; return x; }
template <class T> inline void in(T& x) { std::cin >> x; }
template <class T, class... Args> inline void in(T& x, Args&... trail) { 
  std::cin >> x;
  in(trail...);
}
template <class T = std::string> vec<T> split(std::string const& s, char d = ',') {
  vec<T> v; std::stringstream ss(s); for (std::string b; getline(ss, b, d); ) {
    std::stringstream conv(b); T t; conv >> t; v.eb(t); } return v;
}

struct pre_ { pre_() { std::cin.tie(nullptr); std::ios::sync_with_stdio(false); std::cout << std::fixed << std::setprecision(12); } } pre__;
// clang-format on
/* }}} */

signed main() {
  {{_cursor_}}
}
