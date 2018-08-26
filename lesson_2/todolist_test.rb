require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require "minitest/reporters"
Minitest::Reporters.use!

require_relative 'todo_list'

class TodoListTest < Minitest::Test

  def setup
    @todo1 = Todo.new("Buy milk")
    @todo2 = Todo.new("Clean room")
    @todo3 = Todo.new("Go to gym")
    @todos = [@todo1, @todo2, @todo3]

    @list = TodoList.new("Today's Todos")
    @list.add(@todo1)
    @list.add(@todo2)
    @list.add(@todo3)
  end

  def test_to_a
    assert_equal(@todos, @list.to_a)
  end

  def test_size
    assert_equal(3, @list.size)
    assert_equal(@todos.size, @list.size)
  end

  def test_first
    assert_equal(@todo1, @list.first)
  end

  def test_last
    assert_equal(@todo3, @list.last)
  end

  def test_shift
    assert_equal(@todo1, @list.shift)
    assert_equal(2, @list.size)
  end

  def test_pop
    assert_equal(@todo3, @list.pop)
    assert_equal(2, @list.size)
  end

  def test_done?
    assert_equal(false, @list.done?)
  end

  def test_add_type_error
    assert_raises(TypeError) { @list.add('Pump Iron')}
    assert_raises(TypeError) { @list << 1 }
  end

  def test_shovel_method
    task = Todo.new('Practice Code')
    @list << task
    assert_includes(@list.to_a, task)
  end

  def test_add_method
    task = Todo.new('Practice Code')
    @list.add(task)
    assert_includes(@list.to_a, task)
  end

  def test_item_at
    assert_raises(IndexError){ @list.item_at(3)}
    assert_equal(@list.item_at(1), @todo2)
  end

  def test_mark_done_at
    assert_raises(IndexError) {@list.mark_done_at(3)}
    @list.mark_done_at(1)
    assert_equal(false, @todo1.done?)
    assert_equal(true, @todo2.done?)
    assert_equal(false, @todo3.done?)
  end

  def test_mark_undone_at
    assert_raises(IndexError) {@list.mark_undone_at(3)}

    @list.mark_done_at(1)

    assert_equal(true, @todo2.done?)
    @list.mark_undone_at(1)
    assert_equal(false, @todo2.done?)
  end

  def test_done!
    @list.done!

    assert(@todo1.done?)
    assert(@todo2.done?)
    assert(@todo3.done?)
  end

  def test_remove_at
    assert_raises(IndexError) {@list.remove_at(3)}
    @list.remove_at(1)
    assert([@todo1, @todo3] == @list.to_a)
  end

  def test_to_s
    string = <<~HEREDOC.chomp
    ---- Today's Todos ----
    [ ] Buy milk
    [ ] Clean room
    [ ] Go to gym
    HEREDOC
    assert_equal(@list.to_s, string)
    @list.mark_done_at(1)
    string = <<~HEREDOC.chomp
    ---- Today's Todos ----
    [ ] Buy milk
    [X] Clean room
    [ ] Go to gym
    HEREDOC
    assert_equal(@list.to_s, string)
    @list.done!
    string = <<~HEREDOC.chomp
    ---- Today's Todos ----
    [X] Buy milk
    [X] Clean room
    [X] Go to gym
    HEREDOC
    assert_equal(@list.to_s, string)
  end

  def test_each
    a = []
    @list.each { |task| a << task }
    assert_equal(a, @todos)
  end

  def test_each_return
    a = @list.each { |task| task}
    assert_equal(@list, a)
  end

  def test_select
    @list.mark_done_at(1)
    assert_equal(@list.select { |task| task.done? }.to_a, [@todo2])
  end

  def test_find_all_done
    @list.mark_done_at(1)
    @list.mark_done_at(2)
    result = @list.find_all_done
    assert_equal(result.to_a, [@todo2, @todo3])
  end

  def test_find_all_not_done
    @list.mark_done_at(1)
    result = @list.find_all_not_done
    assert_equal(result.to_a, [@todo1, @todo3])
  end

  def test_find_by_title
    result = @list.find_by_title('Clean room')
    assert_equal(result, @todo2)
  end

  def test_mark_done
    @list.mark_done('Clean room')
    assert(@list.item_at(1).done?)
  end

  def test_initialize
    assert_raises(ArgumentError){TodoList.new}
  end

  def test_mark_all_undone
    @list.mark_all_undone
    assert(!@list.item_at(0).done?)
    assert(!@list.item_at(1).done?)
    assert(!@list.item_at(2).done?)
  end
end
