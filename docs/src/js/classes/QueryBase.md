[**@lancedb/lancedb**](../README.md) • **Docs**

***

[@lancedb/lancedb](../globals.md) / QueryBase

# Class: QueryBase&lt;NativeQueryType&gt;

Common methods supported by all query types

## Extended by

- [`Query`](Query.md)
- [`VectorQuery`](VectorQuery.md)

## Type Parameters

• **NativeQueryType** *extends* `NativeQuery` \| `NativeVectorQuery`

## Implements

- `AsyncIterable`&lt;`RecordBatch`&gt;

## Constructors

### new QueryBase()

```ts
protected new QueryBase<NativeQueryType>(inner): QueryBase<NativeQueryType>
```

#### Parameters

* **inner**: `NativeQueryType` \| `Promise`&lt;`NativeQueryType`&gt;

#### Returns

[`QueryBase`](QueryBase.md)&lt;`NativeQueryType`&gt;

## Properties

### inner

```ts
protected inner: NativeQueryType | Promise<NativeQueryType>;
```

## Methods

### \[asyncIterator\]()

```ts
asyncIterator: AsyncIterator<RecordBatch<any>, any, undefined>
```

#### Returns

`AsyncIterator`&lt;`RecordBatch`&lt;`any`&gt;, `any`, `undefined`&gt;

#### Implementation of

`AsyncIterable.[asyncIterator]`

***

### doCall()

```ts
protected doCall(fn): void
```

#### Parameters

* **fn**

#### Returns

`void`

***

### execute()

```ts
protected execute(options?): RecordBatchIterator
```

Execute the query and return the results as an

#### Parameters

* **options?**: `Partial`&lt;`QueryExecutionOptions`&gt;

#### Returns

[`RecordBatchIterator`](RecordBatchIterator.md)

#### See

 - AsyncIterator
of
 - RecordBatch.

By default, LanceDb will use many threads to calculate results and, when
the result set is large, multiple batches will be processed at one time.
This readahead is limited however and backpressure will be applied if this
stream is consumed slowly (this constrains the maximum memory used by a
single query)

***

### explainPlan()

```ts
explainPlan(verbose): Promise<string>
```

Generates an explanation of the query execution plan.

#### Parameters

* **verbose**: `boolean` = `false`
    If true, provides a more detailed explanation. Defaults to false.

#### Returns

`Promise`&lt;`string`&gt;

A Promise that resolves to a string containing the query execution plan explanation.

#### Example

```ts
import * as lancedb from "@lancedb/lancedb"
const db = await lancedb.connect("./.lancedb");
const table = await db.createTable("my_table", [
  { vector: [1.1, 0.9], id: "1" },
]);
const plan = await table.query().nearestTo([0.5, 0.2]).explainPlan();
```

***

### fastSearch()

```ts
fastSearch(): this
```

Skip searching un-indexed data. This can make search faster, but will miss
any data that is not yet indexed.

Use lancedb.Table#optimize to index all un-indexed data.

#### Returns

`this`

***

### ~~filter()~~

```ts
filter(predicate): this
```

A filter statement to be applied to this query.

#### Parameters

* **predicate**: `string`

#### Returns

`this`

#### Alias

where

#### Deprecated

Use `where` instead

***

### fullTextSearch()

```ts
fullTextSearch(query, options?): this
```

#### Parameters

* **query**: `string`

* **options?**: `Partial`&lt;`FullTextSearchOptions`&gt;

#### Returns

`this`

***

### limit()

```ts
limit(limit): this
```

Set the maximum number of results to return.

By default, a plain search has no limit.  If this method is not
called then every valid row from the table will be returned.

#### Parameters

* **limit**: `number`

#### Returns

`this`

***

### nativeExecute()

```ts
protected nativeExecute(options?): Promise<RecordBatchIterator>
```

#### Parameters

* **options?**: `Partial`&lt;`QueryExecutionOptions`&gt;

#### Returns

`Promise`&lt;`RecordBatchIterator`&gt;

***

### offset()

```ts
offset(offset): this
```

#### Parameters

* **offset**: `number`

#### Returns

`this`

***

### select()

```ts
select(columns): this
```

Return only the specified columns.

By default a query will return all columns from the table.  However, this can have
a very significant impact on latency.  LanceDb stores data in a columnar fashion.  This
means we can finely tune our I/O to select exactly the columns we need.

As a best practice you should always limit queries to the columns that you need.  If you
pass in an array of column names then only those columns will be returned.

You can also use this method to create new "dynamic" columns based on your existing columns.
For example, you may not care about "a" or "b" but instead simply want "a + b".  This is often
seen in the SELECT clause of an SQL query (e.g. `SELECT a+b FROM my_table`).

To create dynamic columns you can pass in a Map<string, string>.  A column will be returned
for each entry in the map.  The key provides the name of the column.  The value is
an SQL string used to specify how the column is calculated.

For example, an SQL query might state `SELECT a + b AS combined, c`.  The equivalent
input to this method would be:

#### Parameters

* **columns**: `string` \| `string`[] \| `Record`&lt;`string`, `string`&gt; \| `Map`&lt;`string`, `string`&gt;

#### Returns

`this`

#### Example

```ts
new Map([["combined", "a + b"], ["c", "c"]])

Columns will always be returned in the order given, even if that order is different than
the order used when adding the data.

Note that you can pass in a `Record<string, string>` (e.g. an object literal). This method
uses `Object.entries` which should preserve the insertion order of the object.  However,
object insertion order is easy to get wrong and `Map` is more foolproof.
```

***

### toArray()

```ts
toArray(options?): Promise<any[]>
```

Collect the results as an array of objects.

#### Parameters

* **options?**: `Partial`&lt;`QueryExecutionOptions`&gt;

#### Returns

`Promise`&lt;`any`[]&gt;

***

### toArrow()

```ts
toArrow(options?): Promise<Table<any>>
```

Collect the results as an Arrow

#### Parameters

* **options?**: `Partial`&lt;`QueryExecutionOptions`&gt;

#### Returns

`Promise`&lt;`Table`&lt;`any`&gt;&gt;

#### See

ArrowTable.

***

### where()

```ts
where(predicate): this
```

A filter statement to be applied to this query.

The filter should be supplied as an SQL query string.  For example:

#### Parameters

* **predicate**: `string`

#### Returns

`this`

#### Example

```ts
x > 10
y > 0 AND y < 100
x > 5 OR y = 'test'

Filtering performance can often be improved by creating a scalar index
on the filter column(s).
```

***

### withRowId()

```ts
withRowId(): this
```

Whether to return the row id in the results.

This column can be used to match results between different queries. For
example, to match results from a full text search and a vector search in
order to perform hybrid search.

#### Returns

`this`
