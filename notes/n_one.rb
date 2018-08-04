# any method can take a block but it may or may not be executed. You must provide the CORRECT number of arguments for any method call, depending on how many parameters it has. But you can call any method with a block regardless of whether or not it takes a block. 

#eg
def hello
  'hello'
end

hello {puts 'hi'}
#=> 'hello'

def hello(str)
  str
end

hello {puts 'hi'}
# ErrorMessage wrong number of arguments exp 1 gvn 0

hello('hi') {puts 'this wont show up'}
#=> 'hi'

# We can use the - yield - key word to define a method to take a block. The same rules above will apply but the block will be executed.
#eg

def hello(str)
  yield
  str
end

hello{puts 'hey there'}
#ErrorMessage ''

hello('world') do
  puts 'Hello'
end
#> Hello
#=> "world"

# If method implamentaion includes a - yield - with no conditions, you must call the method with a block, otherwise you will get a LocalJumpError: no block given (yield)

#eg with above method
hello('string')
#=>LocalJumpError: no block given (yield)
hello('string'){}
#=> "string"
hello('string'){puts 'see above, that even empty blocks pacify the LocalJumpError'}
#> see above, that even empty blocks pacify the LocalJumpError
#=> "string"

#we can keep the LocalJumpError from being raise with a conditional
def hello(str)
  yield if block_given?
  str
end   #here the yield keyword will hold for a block IF Kernel#block_given? evaluates to true

hello('no block')
#=> "no block"
hello('string') {puts 'or with a block'}
#> or with a block
#=> "string"
####################Key though!! Remember that when a developer (you) is writing a method, that is method implementaion. When a user is calling a method, that is method invocation.

# We can write a method whose block takes an argument.
# here is a simple `times` method

def times(num)
  counter = 0
  loop do
    break if counter == num
    if block_given?
      yield(counter)
    end
    coutner += 1
  end
  num
end

# a `select` method
def select(arr)
  counter = 0
  while counter < arr.size
    if !yield(arr[counter])
      arr.delete_at(counter)
    else
      counter += 1
    end
  end
  arr
end

# above on line 70, our method implamentaion will yield for the block and it will call the block with 'counter' as an argument. So in the block, we will have access to the local var 'counter'

def test
  yield(1)
end

test('hello')

# writing methods that take blocks is very useful when we want to differ some of the method implementation to the method caller. Like in the times method, the implementor doesnt know WHAT you want to do x number of times, so he provides a block wherein the invocator can edit the implementation of the method.

# another time we want to write a block taking method is when we want to time how long it takes to do something
# another is when we want the method to perform some sort of last functionality. We can use a block for the implementaion and then write the ending functionality into our method.

# as we discussed earlier, all methods will implicitly take a block. You can call a block on any method regardless of whether or not it will execute the block. However, if we want a block to EXPLICITLY require a block, we can do that too, via `&block` syntax.
#eg

def test(&block)
  puts "&block is, #{block}"
end 
#> &block is, #<Proc:0x007fde0b021368@(irb):164>
#=>nil

# `&block` is a special parameter that converts the argument into whats called a 'simple Proc' (&block could be &bop or &anything. all thats important is the `&` prefix) You drop the & syntax when referencing the simple Proc from within the block.

# this explicit requiring of a block allows us to set the block to a certain variable. That is, whenever we call this method and implement it's block, the block is not executed. Rather, it is stored in and converted to a `simple Proc`. That Proc (procedure) will be saved to whatever we write the &parameter as. We can then throw that Proc (thus that block of code) to another method!!!!!

def test(&block)
  puts 'Test 1'
  test2(block)
  puts 'Back to Test 1'
end

def test2(block)
  puts 'running test in test2'
  block.call
  puts 'back to test 1'
  sleep 3
end
#> Test 1
#> running test in test2
#> THIS IS THE BLOCK THIS IS THE PROC
#> back to test 1
#> Back to Test 1
#=> nil

# see above. In the implementation of `test` we pass the Proc to test2 without the & sign. At that point block has already been converted to a Proc via the &parameter. Then in `test2`, we recieve the block via a normal parameter because it has already been converted to a Proc via `test`. See on line 111 that we have to use Proc#call to execute the block instead of merely `yield`ing as we would to a normal block of code. Note that if we wanted to execute the simple Proc within the implementation of test, we would have to use Proc#call there as well; because as we stated earlier, the block of code has already been converted to a `simple Proc` by the time we get to the body of the `test` method.

