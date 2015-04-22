should = require('chai').should()

Lens = require('../index')

describe('#array', () ->
  it('Lens.index(0).get([1, 2 ,3])', () ->
    Lens.index(0).get([1, 2 ,3]).should.equal(1)
  )
  it('Lens.index(0).set(3, [1, 2, 3])', () ->
    Lens.index(0).set(3, [1, 2, 3]).should.deep.equal([3, 2, 3])
  )
  it('Lens.index(2).get([1, 2 ,3])', () ->
    Lens.index(2).get([1, 2 ,3]).should.equal(3)
  )
  it('Lens.index(2).set(0, [1, 2, 3])', () ->
    Lens.index(2).set(0, [1, 2, 3]).should.deep.equal([1, 2, 0])
  )
)

describe('#obj', () ->
  it('Lens.key("a").get({a: 1, b: 2})', () ->
    Lens.key("a").get({a: 1, b: 2}).should.equal(1)
  )
  it('Lens.key("a").set(3, {a: 1, b: 2})', () ->
    Lens.key("a").set(3, {a: 1, b: 2}).should.deep.equal({a: 3, b: 2})
  )
)

describe('#key.key', () ->
  it('Lens.key("a").key("b").get({a: {b: 2}})', () ->
    Lens.key("a").key("b").get({a: {b: 2}}).should.equal(2)
  )
  it('Lens.key("a").key("b").set(1, {a: {b: 2}})', () ->
    Lens.key("a").key("b").set(1, {a: {b: 2}}).should.deep.equal({a: {b: 1}})
  )
)

describe('#then', () ->
  it('Lens.key("a").then(Lens.key("b")).get({a: {b: 1}})', () ->
    Lens.key("a").then(Lens.key("b")).get({a: {b: 1}}).should.equal(1)
  )
  it('Lens.key("a").then(Lens.key("b")).set(3, {a: {b: 1}})', () ->
    Lens.key("a").then(Lens.key("b")).set(3, {a: {b: 1}}).should.deep.equal(
      {a: {b: 3}}
    )
  )
)

describe('#compose', () ->
  it('Lens.compose(Lens.key("a"), Lens.key("b")).get({a: {b: 1}})', () ->
    Lens.compose(Lens.key("a"), Lens.key("b")).get({a: {b: 1}}).should.equal(1)
  )
  it('Lens.compose(Lens.key("a"), Lens.key("b")).set(3, {a: {b: 1}})', () ->
    Lens.compose(Lens.key("a"), Lens.key("b")).set(3, {a: {b: 1}}).should.deep
      .equal(
        {a: {b: 3}}
      )
  )
)

describe('#path', () ->
  it('Lens.path("a.b").get({a: {b: 1}})', () ->
    Lens.path("a.b").get({a: {b: 1}}).should.equal(1)
  )
  it('Lens.path("a.b").set(3, {a: {b: 1}})', () ->
    Lens.path("a.b").set(3, {a: {b: 1}}).should.deep
      .equal(
        {a: {b: 3}}
      )
  )
  it('Lens.path("a.b").set(3, {})', () ->
    Lens.path("a.b").set(3, {}).should.deep
      .equal(
        {a: {b: 3}}
      )
  )
  it('Lens.path("a.b").get({})', () ->
    should.not.exist(Lens.path("a.b").get({}))
  )
)