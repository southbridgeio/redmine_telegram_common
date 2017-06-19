# deep-property


Enables deep property manipulation and inspection without worrying about
exceptions.


## Usage

```
npm install deep-property
```

```
var props = require('deep-property'),
    sample = { };

props.set(sample, 'name.first', 'John');
props.set(sample, 'name.middle', 'C');
props.set(sample, 'name.last', 'Reilly');
props.set(sample, 'job.title', 'Actor');

props.get(sample, 'name.first');     // John
props.get(sample, 'name.middle');    // C
props.get(sample, 'name.last');      // Reilly
props.get(sample, 'job.title');      // Actor

props.remove(sample, 'name.middle'); // True

props.has(sample, 'name.first');     // True
props.has(sample, 'name.title');     // False
props.has(sample, 'job.title');      // True
props.has(sample, 'job.salary');     // False
```

```
// Resulting object
{
  name: {
    first:  'John',
    last:   'Reilly'
  },
  job: {
    title:  'Actor'
  }
}
```


## Paths

The `path` parameter of each function is dot-delimited string.  Everything
between the dots is considered a property name.  Paths can be as long and
complex as necessary, with the following constraints and assumptions:

- Paths will not recognize array indexes.  Using a path like
  'path.to.items[4].type' will include a lookup for an element
  named `items[4]` (string) instead of an array element.
- Calls using invalid paths will result in the following:
    - `get`: `undefined`
    - `set`: No values (including intermediates) set
    - `has`: `false`
    - `remove`: `false`
- Paths with blank sections (`path.to..nothing` or `path.to.nothing.`)
  will be considered invalid.
