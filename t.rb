def divisors(num)
  (1..num).select { |n| num % n == 0}
end