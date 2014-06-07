#include <algorithm>
#include <functional>
#include <iostream>
#include <time.h>

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

bool isStable(const Forest &f) {
  return (!f.goats && (!f.wolves || !f.lions)) || (!f.wolves && !f.lions);
}

bool isInvalid(const Forest &f) {
  return (f.goats < 0 || f.wolves < 0 || f.lions < 0);
}

ostream &operator<<(ostream &os, const Forest &f) {
  return os << "{ goats: " << f.goats
            << ", wolves: " << f.wolves
            << ", lions: " << f.lions << " }";
}

vector<Forest> mutate(const vector<Forest>& xs) {
  vector<Forest> next;
  next.reserve(xs.size() * 3);
  
  for (auto f : xs) {
    next.emplace_back(f.goats - 1, f.wolves - 1, f.lions + 1); // wolfDevoursGoat
    next.emplace_back(f.goats - 1, f.wolves + 1, f.lions - 1); // lionDevoursGoat
    next.emplace_back(f.goats + 1, f.wolves - 1, f.lions - 1); // lionDevoursWolf
  }   
  
  // filter out invalid forests
  auto valid_end = remove_if(begin(next), end(next), isInvalid);    
  // delete duplicates
  stable_sort(begin(next), valid_end);
  next.erase(unique(begin(next), valid_end), end(next));
  return next;
}

vector<Forest> stable_forests(const vector<Forest>& forests) {
  vector<Forest> xs;
  copy_if(begin(forests), end(forests), back_inserter(xs), isStable);
  return xs;
}

vector<Forest> find_stable_forests(const Forest& forest) {
  vector<Forest> forests = { forest };
  while (!forests.empty() && none_of(begin(forests), end(forests), isStable)) {
    forests = mutate(forests);
  }
  return stable_forests(forests);
}

int main(int argc, char* argv[]) {
  if (argc != 4) {
    cerr << "USAGE: " << argv[0] << " <goats> <wolves> <lions>" << endl;
    exit(EXIT_FAILURE);
  }
  clock_t t = clock();
  Forest initial{stoi(argv[1]), stoi(argv[2]), stoi(argv[3])};
  for (auto f: find_stable_forests(initial)) cout << "Solution: " << f << endl;
  cout << (static_cast<double>(clock() - t))*1000/CLOCKS_PER_SEC << "ms" << endl;
}
