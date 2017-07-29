#include <algorithm>
#include <functional>
#include <iostream>
#include <vector>

using namespace std;

struct Forest {
  Forest(int g, int w, int l) : goats{g}, wolves{w}, lions{l} {}
  bool operator<(const Forest& rhs) const {
    if (goats != rhs.goats) return goats < rhs.goats;
    if (wolves != rhs.wolves) return wolves < rhs.wolves;
    return lions < rhs.lions;
  }
  bool operator==(const Forest& rhs) const {
    return (goats == rhs.goats) && (wolves == rhs.wolves) && (lions == rhs.lions);
  }
  int goats;
  int wolves;
  int lions;
};

bool is_stable(const Forest &f) {
  return (!f.goats && (!f.wolves || !f.lions)) || (!f.wolves && !f.lions);
}

bool is_invalid(const Forest &f) {
  return (f.goats < 0 || f.wolves < 0 || f.lions < 0);
}

ostream &operator<<(ostream &os, const Forest &f) {
  return os << "{ goats: " << f.goats
            << ", wolves: " << f.wolves
            << ", lions: " << f.lions << " }";
}

vector<Forest> mutate(const vector<Forest> &curr) {
  vector<Forest> next;
  next.reserve(curr.size() * 3);

  for (auto f : curr) {
    next.emplace_back(f.goats - 1, f.wolves - 1, f.lions + 1);
    next.emplace_back(f.goats - 1, f.wolves + 1, f.lions - 1);
    next.emplace_back(f.goats + 1, f.wolves - 1, f.lions - 1);
  }

  // filter out invalid forests
  auto valid_end = remove_if(begin(next), end(next), is_invalid);
  // delete duplicates
  stable_sort(begin(next), valid_end);
  next.erase(unique(begin(next), valid_end), end(next));
  return next;
}

vector<Forest> solve(const Forest &x) {
  vector<Forest> xs = { x };
  while (!xs.empty() && none_of(begin(xs), end(xs), is_stable)) {
    xs = mutate(xs);
  }
  vector<Forest> stable;
  copy_if(begin(xs), end(xs), back_inserter(stable), is_stable);
  return stable;
}

int main(int argc, char *argv[]) {
  if (argc != 4) {
    cerr << "USAGE: " << argv[0] << " <goats> <wolves> <lions>" << endl;
    exit(EXIT_FAILURE);
  }
  Forest initial{stoi(argv[1]), stoi(argv[2]), stoi(argv[3])};
  for (auto f: solve(initial)) cout << "Solution: " << f << endl;
}
