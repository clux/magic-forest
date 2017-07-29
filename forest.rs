#[derive(Clone, PartialEq, Eq, PartialOrd, Ord, Debug)]
struct Forest {
    goats: i32,
    wolves: i32,
    lions: i32,
}

impl Forest {
    fn new(goats: i32, wolves: i32, lions: i32) -> Forest {
        Forest { goats, wolves, lions }
    }

    fn is_stable(&self) -> bool {
       match *self {
           Forest { goats: 0, wolves: 0, lions: _ } |
           Forest { goats: 0, wolves: _, lions: 0 } |
           Forest { goats: _, wolves: 0, lions: 0 } => true,
           _ => false
       }
    }

    fn is_valid(&self) -> bool {
        self.goats >= 0 && self.wolves >= 0 && self.lions >= 0
    }
}

fn mutate(forests: Vec<Forest>) -> Vec<Forest> {
    let mut next = Vec::with_capacity(forests.len() * 3);
    for x in forests.into_iter() {
        next.push(Forest::new(x.goats - 1, x.wolves - 1, x.lions + 1));
        next.push(Forest::new(x.goats - 1, x.wolves + 1, x.lions - 1));
        next.push(Forest::new(x.goats + 1, x.wolves - 1, x.lions - 1));
    }
    next.retain(|x| x.is_valid());
    next.sort();
    next.dedup();
    next
}

fn solve(forest: Forest) -> Vec<Forest> {
    let mut xs = vec![forest];
    while !xs.is_empty() && !xs.iter().any(|x| x.is_stable()) {
        xs = mutate(xs)
    }
    xs.retain(|f| f.is_stable());
    xs
}

fn main() {
    let args: Vec<String> = std::env::args().collect();
    if args.len() != 4 {
        println!("USAGE: forest <goats> <wolves> <lions>");
        std::process::exit(1);
    }
    let initial = Forest {
        goats: args[1].parse().unwrap(),
        wolves: args[2].parse().unwrap(),
        lions: args[3].parse().unwrap(),
    };
    println!("Initial: {:?}", initial);
    for f in solve(initial) {
        println!("Solution: {:?}", f);
    }
}
