import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public final class Main {
  static final class Forest {
    private final int goats;
    private final int wolves;
    private final int lions;

    private Forest(int goats, int wolves, int lions) {
      this.goats = goats;
      this.wolves = wolves;
      this.lions = lions;
    }
    public boolean isStable() {
      return (this.goats == 0 && (this.wolves == 0 || this.lions == 0)) ||
             (this.wolves == 0 && this.lions == 0);
    }
    public boolean isValid() {
      return this.goats >= 0 && this.wolves >= 0 && this.lions >= 0;
    }

    @Override
    public int hashCode() {
      final int magic = 0x9e3779b9;
      int seed = 0;
      seed ^= this.goats + magic + (seed << 6) + (seed >> 2);
      seed ^= this.lions + magic + (seed << 6) + (seed >> 2);
      seed ^= this.wolves + magic + (seed << 6) + (seed >> 2);
      return seed;
    }

    @Override
    public boolean equals(Object obj) {
      Forest rhs = (Forest) obj;
      return this.goats == rhs.goats &&
             this.lions == rhs.lions &&
             this.wolves == rhs.wolves;
    }

    @Override
    public String toString() {
      return "Forest { goats: " + this.goats + ", wolves: " + this.wolves +
        ", lions: " + this.lions + " }";
    }
  }

  static List<Forest> mutate(List<Forest> forests) {
    List<Forest> next = new ArrayList<>(3*forests.size());
    for (Forest f : forests) {
      next.add(new Forest(f.goats - 1, f.wolves - 1, f.lions + 1));
      next.add(new Forest(f.goats - 1, f.wolves + 1, f.lions - 1));
      next.add(new Forest(f.goats + 1, f.wolves - 1, f.lions - 1));
    };
    return next.stream().filter(Forest::isValid).distinct().collect(Collectors.toList());
  }

  static public List<Forest> solve(Forest f) {
    List<Forest> forests = Collections.singletonList(f);
    while (!forests.isEmpty() && !forests.stream().anyMatch(Forest::isStable)) {
      forests = mutate(forests);
    }
    return forests.stream().filter(Forest::isStable).collect(Collectors.toList());
  }

  public static void main(String[] args) {
    Forest initial = new Forest(
      Integer.parseInt(args[0]),
      Integer.parseInt(args[1]),
      Integer.parseInt(args[2])
    );
    System.out.println("Initial: " + initial);
    solve(initial).forEach(s -> System.out.println("Solution: " + s));
  }
}
