use std::fs;

// Time: 32:47
// Looked up syntax for collecting and zipping

fn main() {
    let contents = fs::read_to_string("../resources/day-1-input.txt")
        .expect("Should have been able to read the file");

    let mut left_list = Vec::new();
    let mut right_list = Vec::new();

    contents.lines().for_each(|line| {
        let elements = line
            .split("   ")
            .map(|num| num.parse::<u32>())
            .collect::<Result<Vec<u32>, _>>()
            .expect("Should have been able to parse the numbers");
        left_list.push(elements[0]);
        right_list.push(elements[1]);
    });

    left_list.sort();
    right_list.sort();

    let mut total = 0;
    // Star One
    // for (left, right) in left_list.iter().zip(right_list.iter()) {
    //     println!("{:?} {:?}", left, right);
    //     total += left.abs_diff(*right);
    // }

    // Star Two
    for left in left_list.iter() {
        let right_count = right_list.iter().filter(|x| *x == left).count();
        total += left * right_count as u32;
    }

    println!("Total: {}", total);
}
