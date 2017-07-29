use std::fmt;
use std::process;

#[derive(Clone, PartialEq, Eq, PartialOrd, Ord)]
struct Forest {
    goats : i32,
    wolves : i32,
    lions : i32,
}

impl Forest {
    fn new(goats: i32, wolves: i32, lions: i32) -> Forest {
        Forest { goats, wolves, lions }
    }
    fn is_stable(&self) -> bool {
        match *self {
            Forest { goats: 0, wolves: 0, lions: _ } |
            Forest { goats: 0, wolves: _, lions: 0 } |
            Forest { goats: _, wolves: 0, lions: 0 }
              => true,
            _ => false
        }
    }

    fn is_valid(&self) -> bool {
        self.goats >= 0 && self.wolves >= 0 && self.lions >= 0
    }
}

impl fmt::Display for Forest {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "{{ goats: {}, wolves: {}, lions: {} }}", self.goats, self.wolves, self.lions)
    }
}

fn mutate(forests: Vec<Forest>) -> Vec<Forest> {
    let mut next: Vec<Forest> = Vec::with_capacity(forests.len()*3);
    for x in forests.into_iter() {
        next.push(Forest::new(x.goats - 1, x.wolves - 1, x.lions + 1));
        next.push(Forest::new(x.goats - 1, x.wolves + 1, x.lions - 1));
        next.push(Forest::new(x.goats + 1, x.wolves - 1, x.lions - 1));
    }
    // filter out invalid forests
    next.retain(|x| x.is_valid());
    // delete duplicates
    next.sort();
    next.dedup();
    next
}

fn solve(forest: Forest) -> Vec<Forest> {
    let mut xs: Vec<Forest> = Vec::with_capacity(1);
    xs.push(forest);
    while !xs.is_empty() && !xs.iter().any(|x| x.is_stable()) {
        xs = mutate(xs)
    }
    xs.retain(|f| f.is_stable());
    xs
}

fn main(){
    let mut args = std::env::args();
    if args.len() != 4 {
        println!("USAGE: forest <goats> <wolves> <lions>");
        process::exit(1);
    }
    // don't want a proper arg parser right now:
    args.next();
    let goats : i32 = args.next().unwrap().parse().unwrap();
    let wolves : i32 = args.next().unwrap().parse().unwrap();
    let lions : i32 = args.next().unwrap().parse().unwrap();

    let initial = Forest { goats, wolves, lions};
    println!("Initial {}", initial);

    for f in solve(initial) {
        println!("Solution: {}", f);
    }
}
