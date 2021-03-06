# -*- encoding : utf-8 -*-
require File.join(File.dirname(__FILE__), 'helper')

class TestCell < Test::Unit::TestCase


  def test_init
    w = Workbook::Cell.new nil
    assert_equal(nil,w.value)
    w = Workbook::Cell.new "asdf"
    assert_equal("asdf",w.value)

    assert_raise(ArgumentError) { w = Workbook::Cell.new :asdf }

    t = Time.now
    w = Workbook::Cell.new t
    assert_equal(t,w.value)

  end

  def test_value
    w = Workbook::Cell.new nil
    assert_equal(nil,w.value)
    w.value = "asdf"
    assert_equal("asdf",w.value)
    w.value = Date.new
    assert_equal(Date.new,w.value)
  end

  def test_comp
    a = Workbook::Cell.new 1
    b = Workbook::Cell.new 2
    assert_equal(-1, a<=>b)
    a = Workbook::Cell.new "c"
    b = Workbook::Cell.new "bsdf"
    assert_equal(1, a<=>b)
    a = Workbook::Cell.new "c"
    b = Workbook::Cell.new "c"
    assert_equal(0, a<=>b)
    a = Workbook::Cell.new true
    b = Workbook::Cell.new false
    assert_equal(-1, a<=>b)
    a = Workbook::Cell.new "true"
    b = Workbook::Cell.new "false"
    assert_equal(1, a<=>b)
    a = Workbook::Cell.new 1
    b = Workbook::Cell.new "a"
    assert_equal(-1, a<=>b)
    a = Workbook::Cell.new nil
    b = Workbook::Cell.new "a"
    assert_equal(1, a<=>b)
    a = Workbook::Cell.new nil
    b = Workbook::Cell.new nil
    assert_equal(0, a<=>b)
  end

  def test_cloning_as_expected?
    a = Workbook::Cell.new 1
    a.format = Workbook::Format.new({:value=>1})
    b = a.clone
    b.value = 2
    b.format[:value]=2
    assert_equal(1,a.value)
    assert_equal(2,b.value)
    assert_equal(2,a.format[:value])
    assert_equal(2,b.format[:value])
  end

  def test_to_sym
    c = Workbook::Cell.new "A - B"
    assert_equal(:a_b, c.to_sym)
    c = Workbook::Cell.new "A-B"
    assert_equal(:ab, c.to_sym)
    c = Workbook::Cell.new "A - c (B123)"
    assert_equal(:a_c_b123, c.to_sym)

  end

  def test_nil
    c = Workbook::Cell.new nil
    assert_equal(true,c.nil?)
  end

  def test_colspan_rowspan
    c = Workbook::Cell.new
    c.colspan = 1
    c.rowspan = 1
    assert_equal(nil,c.colspan)
    assert_equal(nil,c.rowspan)
    c.colspan = nil
    c.rowspan = ""
    assert_equal(nil,c.colspan)
    assert_equal(nil,c.rowspan)
    c.colspan = 3
    c.rowspan = "4"
    assert_equal(3,c.colspan)
    c.rowspan = 0
    assert_equal(nil,c.rowspan)
    assert_equal(3,c.colspan)
    c.colspan = 0
    c.rowspan = 3
    assert_equal(3,c.rowspan)
    assert_equal(nil,c.colspan)
  end
end
