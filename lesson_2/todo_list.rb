class Todo
  DONE_MARKER = 'X'
  UNDONE_MARK = ' '

  attr_accessor :title, :description, :done

  def initialize(title, description='')
    @title = title
    @description = description
    @done = false
  end

  def done!
    self.done = true
  end

  def done?
    done
  end

  def undone!
    self.done = false
  end

  def to_s
    "[#{done? ? DONE_MARKER : UNDONE_MARK}] #{title}"
  end
end





class TodoList
  attr_accessor :title

  def initialize(title)
    @title = title
    @todos = []
  end
  
  def <<(todo)
    raise TypeError, "Can only add Todo objects" unless todo.class == Todo
    @todos << todo
  end

  alias_method :add, :<<

  def size
    @todos.size
  end

  def first
    @todos.first
  end

  def last
    @todos.last
  end

  def item_at(indx)
    @todos.fetch(indx)
  end

  def find_by_title(title)
    each { |task| return task if task.title == title }
    nil
  end

  def mark_done_at(indx)
    item_at(indx).done!
  end

  def mark_done(title)
    each do |task|
      if task.title == title
        task.done!
        return task
      end
    end
    return nil
  end

  def done!
    each { |task| task.done!}
  end

  def mark_undone_at(indx)
    raise IndexError if indx > (@todos.size - 1)
    @todos[indx].undone!
  end

  def mark_all_undone
    each { |task| task.undone!}
  end

  def find_all_done
    select { |task| task.done? }
  end

  def find_all_not_done
    select { |task| !task.done? }
  end

  def shift
    @todos.shift
  end

  def pop
    @todos.pop
  end

  def remove_at(indx)
    @todos.delete(item_at(indx))
  end

  def done?
    @todos.all? {|task| task.done?}
  end

  def each
    @todos.each { |task| yield(task)}
    self
  end

  def select
    new_list = TodoList.new('New List')
    each { |task| new_list << task if yield(task) }
    new_list
  end

  def to_s
    text = "---- #{title} ----\n"
    text << @todos.map(&:to_s).join("\n")
    text
  end

  def to_a
    @todos
  end
end
