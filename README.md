# data-lens
## Simple JavaScript implementation of data-lens

### Usage

```javascript
Lens = require('data-lens');

// Basic use
lens = new Lens(getter, setter);

lens.get(data); // === getter(data)
lens.set(val, data); // === setter(val, data)

// Chaining
lens1.then(lens2).get(data);
lens1.then(lens2).set(val, data);
lens1.key(key1).key(key2).index(index1).index(index2)...;

// Convenience methods
Lens.index(0).get([1,2,3]); // 1
Lens.index(0).set(3, [1,2,3]); // [3, 2, 3]

Lens.key('a').get({a: 1}); // 1
Lens.key('a').set(3, {a: 1}); // {a: 3}

Lens.path('a.b').get({a: {b: 1}}); // 1
Lens.path('a.b').set(3, {a: {b: 1}}); // {a: {b: 3}}

Lens.compose(lens1, lens2); // Equivalent to lens1.then(lens2)
```