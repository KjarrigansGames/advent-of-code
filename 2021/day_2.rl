"// Last Updated: 2021.12.02"
"// RocketLang Version: 0.9.7"
"------------------------------------"

let x = 0;
let depth = 0;

let each = fn(enumerable, yield, idx) {
  if (idx == len(enumerable)) {
    return len(enumerable);
  }
  yield(enumerable[idx]);
  each(enumerable, yield, idx + 1);
};

"Does not work because you have to do push with let a = push(a, b)"
"which makes a a 'local' variable and thus breaks everything -.-"
let split = fn(string, separator) {
  let list = [];
  let current_word = "";

  each(string, fn(char) {
    puts(char == separator);
    if (char == separator) {
      puts "Split found!"
      let list = push(list, current_word);
      let current_word = "";
    } else {
      puts(current_word);
      puts("Another letter to the word: " + char);
      let current_word = current_word + char;
      puts(current_word);
    }
  }, 0);
  let list = push(list, current_word);

  return list;
};

split("Hello World", " ");

"Simplified sample of split. super sad that this does not work :-("
let char_array = [];
let counter = 0;
each("Hello World", fn(c) {
  let char_array = push(char_array, c);
  let counter = counter + 1;
}, 0);
puts(char_array);
puts(counter);
