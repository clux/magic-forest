#[derive(Clone, PartialEq, Eq, PartialOrd, Ord, Debug)]
struct Forest {
    goats: i32,
    wolves: i32,
    lions: i32,
}

fn is_valid(f: &Forest) -> bool {
    f.goats >= 0 && f.wolves >= 0 && f.lions >= 0
}

fn is_stable(f: &Forest) -> bool {
    (f.goats == 0 && (f.wolves == 0 || f.lions == 0)) || (f.wolves == 0 && f.lions == 0)
}

fn mutate(forests: Vec<Forest>) -> Vec<Forest> {
    let mut next = Vec::with_capacity(forests.len() * 3);
    for f in forests.into_iter() {
        next.extend_from_slice(&[
            Forest { goats: f.goats - 1, wolves: f.wolves - 1, lions: f.lions + 1 },
            Forest { goats: f.goats - 1, wolves: f.wolves + 1, lions: f.lions - 1 },
            Forest { goats: f.goats + 1, wolves: f.wolves - 1, lions: f.lions - 1 },
        ]);
    }
    next.retain(is_valid);
    next.sort();
    next.dedup();
    next
}

fn solve(forest: Forest) -> Vec<Forest> {
    let mut res = vec![forest];
    while !res.is_empty() && !res.iter().any(is_stable) {
        res = mutate(res)
    }
    res.retain(is_stable);
    res
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
