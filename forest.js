#!/usr/bin/env node

function Forest(goats, wolves, lions) {
  this.goats = goats;
  this.wolves = wolves;
  this.lions = lions;
}

var isStable = function (f) {
  return (!f.goats && (!f.wolves || !f.lions)) || (!f.wolves && !f.lions);
};

var isValid = function (f) {
  return (f.goats >= 0 && f.wolves >= 0 && f.lions >= 0);
};

var order = function (x, y) {
  return (x.goats - y.goats) || (x.wolves - y.wolves) || (x.lions - y.lions);
};

var notFirstOrPrevious = function (f, i, ary) {
  return (i === 0 || order(f, ary[i - 1]) !== 0);
};
 
var mutate = function (forests) {
  return forests.reduce(function (acc, f) {
    acc.push(new Forest(f.goats - 1, f.wolves - 1, f.lions + 1));
    acc.push(new Forest(f.goats - 1, f.wolves + 1, f.lions - 1));
    acc.push(new Forest(f.goats + 1, f.wolves - 1, f.lions - 1));
    return acc;
  }, []).filter(isValid).sort(order).filter(notFirstOrPrevious);
};

var findStableForests = function (forest) {
  var forests = [forest];
  while (forests.length && !forests.some(isStable)) {
    forests = mutate(forests);
  }
  return forests.filter(isStable);
};

if (module === require.main) {
  var args = process.argv.slice(2);
  if (args.length !== 3 || args.some(isNaN)) {
    return console.log('USAGE: node magicForest.js <goats> <wolves> <lions>');
  }
  console.time('Time');
  var initial = new Forest(args[0] | 0, args[1] | 0, args[2] | 0);
  findStableForests(initial).forEach(function (f) {
    console.log('Solution:', f);
  });
  console.timeEnd('Time');
}
